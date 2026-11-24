CREATE OR REPLACE FUNCTION trg_fn_reserva_transicion() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    IF NOT (
        (OLD.estado_reserva = 'PENDIENTE'  AND NEW.estado_reserva IN ('CONFIRMADA', 'CANCELADA')) OR
        (OLD.estado_reserva = 'CONFIRMADA' AND NEW.estado_reserva IN ('EN_CURSO', 'CANCELADA'))  OR
        (OLD.estado_reserva = 'EN_CURSO'   AND NEW.estado_reserva = 'FINALIZADA')
    ) THEN
        RAISE EXCEPTION 'Transición de reserva no permitida: % -> %', OLD.estado_reserva, NEW.estado_reserva;
END IF;
RETURN NEW;
END;
$$;

CREATE TRIGGER trg_reserva_transicion
    BEFORE UPDATE OF estado_reserva ON reserva
    FOR EACH ROW
    WHEN (OLD.estado_reserva IS DISTINCT FROM NEW.estado_reserva)
    EXECUTE FUNCTION trg_fn_reserva_transicion();
