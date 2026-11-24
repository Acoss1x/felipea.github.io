DECLARE
    v_id NUMBER;
BEGIN
    SP_REGISTRAR_PRODUCTO('PRU-0001', 'Producto de prueba', 1, 50000, 30000, 5, v_id);
    DBMS_OUTPUT.PUT_LINE('OK: producto registrado con ID ' || v_id);

    BEGIN   
        SP_REGISTRAR_PRODUCTO('PRU-0001', 'Otro', 1, 50000, 30000, 5, v_id);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Duplicado (esperado -20003): ' || SQLERRM);
    END;
    BEGIN   
        SP_REGISTRAR_PRODUCTO('PRU-0002', 'Precio malo', 1, 10000, 20000, 5, v_id);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Precio (esperado -20001): ' || SQLERRM);
    END;
    BEGIN   
        SP_REGISTRAR_PRODUCTO('PRU-0003', 'Categoria mala', 99999, 50000, 30000, 5, v_id);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Categoria (esperado -20002): ' || SQLERRM);
    END;
    ROLLBACK;
END;
/
