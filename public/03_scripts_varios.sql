-- =============================================
-- SISTEMA DE GESTIÓN PARA GIMNASIO
-- Universidad El Bosque — Bases de Datos 1
-- Santiago Muñoz, Felipe Acosta, Gabriela Poveda
-- Scripts Varios
-- =============================================


-- =============================================
-- 1. VISTAS
-- =============================================

-- Vista: Miembros con membresía activa y su plan
CREATE OR REPLACE VIEW v_miembros_activos AS
SELECT 
    m.documento,
    m.nombre_completo,
    m.correo_electronico,
    m.telefono,
    mb.fecha_inicio,
    mb.fecha_fin,
    mb.precio_inscrito,
    mb.estado AS estado_membresia,
    p.nombre AS nombre_plan,
    p.duracion_dias,
    (mb.fecha_fin - CURRENT_DATE) AS dias_restantes
FROM miembro m
JOIN membresia mb ON m.documento = mb.miembro_documento
JOIN plan p ON mb.plan_id_plan = p.id_plan
WHERE mb.estado = 'activa';

-- Vista: Agenda de clases con instructor y sala
CREATE OR REPLACE VIEW v_agenda_clases AS
SELECT
    c.id_clase,
    c.nombre_clase,
    c.disciplina,
    c.dia_semana,
    c.hora_inicio,
    c.duracion_minutos,
    c.nivel_dificultad,
    c.capacidad_max,
    c.estado,
    e.nombre_completo AS instructor,
    s.nombre_sala AS sala,
    s.tipo AS tipo_sala
FROM clase c
JOIN empleado e ON c.instructor_id_empleado = e.id_empleado
JOIN sala s ON c.sala_id_sala = s.id_sala;

-- Vista: Equipos con su sala y estado de mantenimiento
CREATE OR REPLACE VIEW v_equipos_estado AS
SELECT
    eq.id_equipo,
    eq.nombre,
    eq.marca,
    eq.modelo,
    eq.estado,
    s.nombre_sala,
    COUNT(mn.id_mantenimiento) AS total_mantenimientos,
    MAX(mn.fecha_mantenimiento) AS ultimo_mantenimiento
FROM equipo eq
JOIN sala s ON eq.sala_id_sala = s.id_sala
LEFT JOIN mantenimiento mn ON eq.id_equipo = mn.equipo_id_equipo
GROUP BY eq.id_equipo, eq.nombre, eq.marca, eq.modelo, eq.estado, s.nombre_sala;

-- Vista: Ingresos por membresía
CREATE OR REPLACE VIEW v_ingresos AS
SELECT
    mb.id_membresia,
    m.nombre_completo AS miembro,
    p.nombre AS plan,
    mb.fecha_inicio,
    mb.fecha_fin,
    mb.precio_inscrito,
    SUM(pg.monto_cop) AS total_pagado,
    (mb.precio_inscrito - COALESCE(SUM(pg.monto_cop), 0)) AS saldo_pendiente
FROM membresia mb
JOIN miembro m ON mb.miembro_documento = m.documento
JOIN plan p ON mb.plan_id_plan = p.id_plan
LEFT JOIN pago pg ON mb.id_membresia = pg.membresia_id_membresia
GROUP BY mb.id_membresia, m.nombre_completo, p.nombre, mb.fecha_inicio, mb.fecha_fin, mb.precio_inscrito;


-- =============================================
-- 2. FUNCIONES
-- =============================================

-- Función: Días restantes de membresía de un miembro
CREATE OR REPLACE FUNCTION f_dias_restantes_membresia(p_documento VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    dias INTEGER;
BEGIN
    SELECT (mb.fecha_fin - CURRENT_DATE)
    INTO dias
    FROM membresia mb
    WHERE mb.miembro_documento = p_documento
      AND mb.estado = 'activa'
    ORDER BY mb.fecha_fin DESC
    LIMIT 1;
    RETURN COALESCE(dias, 0);
END;
$$ LANGUAGE plpgsql;

-- Función: Total pagado por una membresía
CREATE OR REPLACE FUNCTION f_total_pagado(p_id_membresia BIGINT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(monto_cop), 0)
    INTO total
    FROM pago
    WHERE membresia_id_membresia = p_id_membresia;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Función: Cupos disponibles en una clase
CREATE OR REPLACE FUNCTION f_cupos_disponibles(p_id_clase BIGINT)
RETURNS INTEGER AS $$
DECLARE
    capacidad INTEGER;
    reservas  INTEGER;
BEGIN
    SELECT capacidad_max INTO capacidad FROM clase WHERE id_clase = p_id_clase;
    SELECT COUNT(*) INTO reservas FROM reserva 
    WHERE clase_id_clase = p_id_clase AND estado = 'confirmada';
    RETURN capacidad - reservas;
END;
$$ LANGUAGE plpgsql;


-- =============================================
-- 3. PROCEDIMIENTOS ALMACENADOS
-- =============================================

-- Procedimiento: Vencer membresías expiradas automáticamente
CREATE OR REPLACE PROCEDURE p_vencer_membresias()
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE membresia
    SET estado = 'vencida'
    WHERE estado = 'activa'
      AND fecha_fin < CURRENT_DATE;
    RAISE NOTICE 'Membresías vencidas actualizadas correctamente.';
END;
$$;

-- Procedimiento: Cambiar estado de un equipo
CREATE OR REPLACE PROCEDURE p_cambiar_estado_equipo(
    p_id_equipo BIGINT,
    p_nuevo_estado VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE equipo
    SET estado = p_nuevo_estado
    WHERE id_equipo = p_id_equipo;
    RAISE NOTICE 'Estado del equipo % actualizado a %.', p_id_equipo, p_nuevo_estado;
END;
$$;


-- =============================================
-- 4. CONSULTAS COMPLEJAS
-- =============================================

-- Consulta 1: Miembros con membresía activa y días restantes
SELECT 
    m.documento,
    m.nombre_completo,
    p.nombre AS plan,
    mb.fecha_fin,
    (mb.fecha_fin - CURRENT_DATE) AS dias_restantes
FROM miembro m
JOIN membresia mb ON m.documento = mb.miembro_documento
JOIN plan p ON mb.plan_id_plan = p.id_plan
WHERE mb.estado = 'activa'
ORDER BY dias_restantes ASC;

-- Consulta 2: Membresías próximas a vencer en los próximos 7 días
SELECT
    m.nombre_completo,
    m.correo_electronico,
    m.telefono,
    p.nombre AS plan,
    mb.fecha_fin,
    (mb.fecha_fin - CURRENT_DATE) AS dias_restantes
FROM membresia mb
JOIN miembro m ON mb.miembro_documento = m.documento
JOIN plan p ON mb.plan_id_plan = p.id_plan
WHERE mb.estado = 'activa'
  AND mb.fecha_fin BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
ORDER BY mb.fecha_fin ASC;

-- Consulta 3: Ingresos totales por mes
SELECT
    TO_CHAR(fecha_pago, 'YYYY-MM') AS mes,
    COUNT(*) AS total_pagos,
    SUM(monto_cop) AS ingresos_totales
FROM pago
GROUP BY TO_CHAR(fecha_pago, 'YYYY-MM')
ORDER BY mes DESC;

-- Consulta 4: Clases con número de reservas confirmadas
SELECT
    c.nombre_clase,
    c.dia_semana,
    c.hora_inicio,
    c.capacidad_max,
    COUNT(r.id_reserva) AS reservas_confirmadas,
    (c.capacidad_max - COUNT(r.id_reserva)) AS cupos_disponibles
FROM clase c
LEFT JOIN reserva r ON c.id_clase = r.clase_id_clase AND r.estado = 'confirmada'
GROUP BY c.id_clase, c.nombre_clase, c.dia_semana, c.hora_inicio, c.capacidad_max
ORDER BY c.dia_semana, c.hora_inicio;

-- Consulta 5: Empleados por cargo y estado
SELECT
    cargo,
    estado,
    COUNT(*) AS total
FROM empleado
GROUP BY cargo, estado
ORDER BY cargo, estado;

-- Consulta 6: Historial de mantenimientos con técnico y equipo
SELECT
    mn.id_mantenimiento,
    eq.nombre AS equipo,
    eq.marca,
    s.nombre_sala,
    mn.fecha_mantenimiento,
    mn.costo_cop,
    mn.descripcion,
    e_tec.nombre_completo AS tecnico,
    e_adm.nombre_completo AS administrador
FROM mantenimiento mn
JOIN equipo eq ON mn.equipo_id_equipo = eq.id_equipo
JOIN sala s ON eq.sala_id_sala = s.id_sala
LEFT JOIN empleado e_tec ON mn.tecnico_id_empleado = e_tec.id_empleado
LEFT JOIN empleado e_adm ON mn.administrador_id_empleado = e_adm.id_empleado
ORDER BY mn.fecha_mantenimiento DESC;

-- Consulta 7: Miembros sin membresía activa
SELECT
    m.documento,
    m.nombre_completo,
    m.correo_electronico,
    m.estado
FROM miembro m
WHERE NOT EXISTS (
    SELECT 1 FROM membresia mb
    WHERE mb.miembro_documento = m.documento
      AND mb.estado = 'activa'
);

-- Consulta 8: Total de ingresos por plan
SELECT
    p.nombre AS plan,
    COUNT(mb.id_membresia) AS total_membresias,
    SUM(pg.monto_cop) AS ingresos_totales
FROM plan p
JOIN membresia mb ON p.id_plan = mb.plan_id_plan
LEFT JOIN pago pg ON mb.id_membresia = pg.membresia_id_membresia
GROUP BY p.id_plan, p.nombre
ORDER BY ingresos_totales DESC;


-- =============================================
-- 5. EJEMPLOS DE USO DE FUNCIONES Y PROCEDIMIENTOS
-- =============================================

-- Ver días restantes de membresía de un miembro
SELECT f_dias_restantes_membresia('1069725875');

-- Ver total pagado por una membresía
SELECT f_total_pagado(1);

-- Ver cupos disponibles en una clase
SELECT f_cupos_disponibles(1);

-- Ejecutar vencimiento automático de membresías
CALL p_vencer_membresias();

-- Cambiar estado de un equipo a mantenimiento
CALL p_cambiar_estado_equipo(1, 'en_mantenimiento');

-- Consultar las vistas
SELECT * FROM v_miembros_activos;
SELECT * FROM v_agenda_clases;
SELECT * FROM v_equipos_estado;
SELECT * FROM v_ingresos;