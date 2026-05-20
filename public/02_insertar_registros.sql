-- =============================================
-- SISTEMA DE GESTIÓN PARA GIMNASIO
-- Universidad El Bosque — Bases de Datos 1
-- Santiago Muñoz, Felipe Acosta, Gabriela Poveda
-- Script de inserción de registros
-- =============================================

-- Inserción EMPLEADO
INSERT INTO empleado (id_empleado, documento, nombre_completo, correo, password, telefono, cargo, estado, fecha_creacion) VALUES
(1, '123456789',  'Administrador Principal', 'admin@gimnasio.com',      '$2a$10$JGPEHJIK1TCbYr/sHW.vL.nbAoP9TS0p/XeQP5nLmwvNjDmWvT.s6', '3001234567', 'administrador',         'activo',   '2026-05-14'),
(3, '111111111',  'Recepcionista Demo',      'recepcion@gimnasio.com',  '$2a$10$JGPEHJIK1TCbYr/sHW.vL.nbAoP9TS0p/XeQP5nLmwvNjDmWvT.s6', '3001111111', 'recepcionista',         'activo',   '2026-05-14'),
(4, '222222222',  'Instructor Demo',         'instructor@gimnasio.com', '$2a$10$JGPEHJIK1TCbYr/sHW.vL.nbAoP9TS0p/XeQP5nLmwvNjDmWvT.s6', '3002222222', 'instructor',            'retirado', '2026-05-14'),
(5, '333333333',  'Tecnico Demo',            'tecnico@gimnasio.com',    '$2a$10$JGPEHJIK1TCbYr/sHW.vL.nbAoP9TS0p/XeQP5nLmwvNjDmWvT.s6', '3003333333', 'tecnico_mantenimiento', 'activo',   '2026-05-14'),
(6, '2365456',    'Santi',                   'instructor@gmail.com',    '$2a$10$Dbag2DBvTPDv8uwOvvsmVO8aBDAMRfotSTN/GD/1rYiBsNHD8Hm56',   NULL,         'instructor',            'activo',   '2026-05-14');

-- Reiniciar secuencia de empleado
SELECT setval('empleado_id_empleado_seq', (SELECT MAX(id_empleado) FROM empleado));

-- Inserción SALA
INSERT INTO sala (id_sala, nombre_sala, tipo, capacidad_max, estado, fecha_creacion) VALUES
(1, 'Sala  Crossfit', 'funcional', 10, 'disponible', '2026-05-13'),
(2, 'Sala Principal', 'Cardio',    20, 'disponible', '2026-05-15');

SELECT setval('sala_id_sala_seq', (SELECT MAX(id_sala) FROM sala));

-- Inserción EQUIPO
INSERT INTO equipo (id_equipo, nombre, marca, modelo, estado, fecha_creacion, sala_id_sala) VALUES
(1, 'Bicicleta', 'Temu', '2026', 'operativo', '2026-05-14', 1);

SELECT setval('equipo_id_equipo_seq', (SELECT MAX(id_equipo) FROM equipo));

-- Inserción CLASE
INSERT INTO clase (id_clase, nombre_clase, disciplina, duracion_minutos, nivel_dificultad, capacidad_max, dia_semana, hora_inicio, estado, fecha_creacion, instructor_id_empleado, sala_id_sala) VALUES
(1, 'Yoga Matutino', 'Yoga',    60, 'basico', 15, 'lunes', '07:00', 'activo', '2026-05-15', 4, 1),
(2, 'Spining',       'Spining', 60, 'basico', 10, 'lunes', '8:00',  'activo', '2026-05-14', 6, 2);

SELECT setval('clase_id_clase_seq', (SELECT MAX(id_clase) FROM clase));

-- Inserción MIEMBRO
INSERT INTO miembro (documento, nombre_completo, correo_electronico, telefono, fecha_nacimiento, estado, fecha_creacion, password) VALUES
('1069725875', 'Santiago Muñoz Villate', 'santiagomunozv123@gmail.com', '3142980438', '2006-11-30', 'activo', '2026-05-13', '$2a$10$4LIZxp8WjC2oo9dgap64U.iUVGd6hn8q24gkMEKbhfJTjuwS3ytCm'),
('107046585',  'Daniel Felipe Acosta',  'dfacosr@unbosque.edu.co',     '31231',      '2007-02-28', 'activo', '2026-05-14', NULL),
('1069745684', 'Daniel Perez',          'hola@gmail.com',              '3151455123', '2000-02-11', 'activo', '2026-05-14', NULL),
('1069745685', 'Pepito Ramirez',        'correo@gmail.com',            NULL,         '2000-11-11', 'activo', '2026-05-14', '$2a$10$DfSPqvXtmFRqY7sEifqY/u/AC27/3e5z/zzzdW0YMRKzvCILgpbJS'),
('123456789',  'Florentino Vargas',     'correoo@gmail.com',           NULL,         '2010-02-11', 'activo', '2026-05-17', '$2a$10$NeY9YFtF.sdoEy4JE5.IuuYEQ6v9KeHXx7wejZjhFnfdhIpHIx7uC'),
('1234567891', 'Florentino Vargas',     'correoom@gmail.com',          NULL,         '2010-02-11', 'activo', '2026-05-17', '$2a$10$9wwL.agzjoHMmecpiQLOjOQztDdVIrDEhPsgVlf1v8McdT06sFySC');

-- Inserción PLAN
INSERT INTO plan (id_plan, nombre, precio_cop, duracion_dias, estado, fecha_creacion) VALUES
(1, 'Plan Mensual', 80000.00, 30, 'activo', '2026-05-15');

SELECT setval('plan_id_plan_seq', (SELECT MAX(id_plan) FROM plan));

-- Inserción MEMBRESIA
INSERT INTO membresia (id_membresia, fecha_inicio, fecha_fin, precio_inscrito, estado, fecha_creacion, miembro_documento, plan_id_plan) VALUES
(1, '2026-05-01', '2026-05-31', 80000.00, 'activa',  '2026-05-15', '1069725875', 1),
(2, '2026-05-14', '2026-06-13', 80000.00, 'activa',  '2026-05-14', '107046585',  1),
(3, '2026-05-15', '2026-06-14', 80000.00, 'activa',  '2026-05-15', '1069745684', 1),
(4, '2026-04-14', '2026-05-14', 80000.00, 'vencida', '2026-05-15', '1069745685', 1),
(5, '2026-05-17', '2026-06-16', 80000.00, 'activa',  '2026-05-17', '1234567891', 1);

SELECT setval('membresia_id_membresia_seq', (SELECT MAX(id_membresia) FROM membresia));

-- Inserción PAGO
INSERT INTO pago (num_pago, membresia_id_membresia, fecha_pago, monto_cop, metodo_pago, fecha_creacion) VALUES
(1, 3, '2026-05-15', 80000.00, 'efectivo', '2026-05-15'),
(1, 4, '2026-04-14', 80000.00, 'efectivo', '2026-05-15'),
(1, 5, '2026-05-17', 40000.00, 'efectivo', '2026-05-17');

-- Inserción RESERVA
INSERT INTO reserva (id_reserva, miembro_documento, clase_id_clase, fecha_reserva, estado, fecha_creacion) VALUES
(1, '1069725875', 1, '2026-05-14', 'confirmada', '2026-05-14');

SELECT setval('reserva_id_reserva_seq', (SELECT MAX(id_reserva) FROM reserva));

-- Inserción MANTENIMIENTO
INSERT INTO mantenimiento (id_mantenimiento, equipo_id_equipo, fecha_mantenimiento, costo_cop, descripcion, fecha_creacion, tecnico_id_empleado, administrador_id_empleado) VALUES
(1, 1, '2026-05-14', 10000.00, NULL, '2026-05-14', 5, NULL);