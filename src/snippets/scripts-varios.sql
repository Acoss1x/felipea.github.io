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
