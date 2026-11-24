-- Inserción SALA
INSERT INTO sala (id_sala, nombre_sala, tipo, capacidad_max, estado, fecha_creacion) VALUES
(1, 'Sala  Crossfit', 'funcional', 10, 'disponible', '2026-05-13'),
(2, 'Sala Principal', 'Cardio',    20, 'disponible', '2026-05-15');

SELECT setval('sala_id_sala_seq', (SELECT MAX(id_sala) FROM sala));

-- Inserción EQUIPO
INSERT INTO equipo (id_equipo, nombre, marca, modelo, estado, fecha_creacion, sala_id_sala) VALUES
(1, 'Bicicleta', 'Temu', '2026', 'operativo', '2026-05-14', 1);

SELECT setval('equipo_id_equipo_seq', (SELECT MAX(id_equipo) FROM equipo));
