-- =============================================
-- SISTEMA DE GESTIÓN PARA GIMNASIO
-- Universidad El Bosque — Bases de Datos 1
-- Santiago Muñoz, Felipe Acosta, Gabriela Poveda
-- Script de creación de objetos
-- =============================================

-- Tabla 1: EMPLEADO
CREATE TABLE empleado (
    id_empleado          BIGSERIAL       NOT NULL,
    documento            VARCHAR(20)     NOT NULL,
    nombre_completo      VARCHAR(100)    NOT NULL,
    correo               VARCHAR(100)    NOT NULL,
    password             VARCHAR(255)    NOT NULL,
    telefono             VARCHAR(15),
    cargo                VARCHAR(30)     NOT NULL,
    estado               VARCHAR(20)     NOT NULL DEFAULT 'activo',
    fecha_creacion       DATE                     DEFAULT CURRENT_DATE,
    nivel_acceso         VARCHAR(50),
    area_especialidad    VARCHAR(100),
    especialidad         VARCHAR(100),
    nivel_certificacion  VARCHAR(50),
    CONSTRAINT empleado_pkey            PRIMARY KEY (id_empleado),
    CONSTRAINT empleado_documento_key   UNIQUE (documento),
    CONSTRAINT empleado_correo_key      UNIQUE (correo)
);

-- Tabla 2: SALA
CREATE TABLE sala (
    id_sala         BIGSERIAL       NOT NULL,
    nombre_sala     VARCHAR(50)     NOT NULL,
    tipo            VARCHAR(30)     NOT NULL,
    capacidad_max   INTEGER         NOT NULL,
    estado          VARCHAR(20)     NOT NULL DEFAULT 'disponible',
    fecha_creacion  DATE                     DEFAULT CURRENT_DATE,
    CONSTRAINT sala_pkey PRIMARY KEY (id_sala)
);

-- Tabla 3: CLASE
CREATE TABLE clase (
    id_clase                BIGSERIAL       NOT NULL,
    nombre_clase            VARCHAR(50)     NOT NULL,
    disciplina              VARCHAR(50)     NOT NULL,
    duracion_minutos        INTEGER         NOT NULL,
    nivel_dificultad        VARCHAR(20)     NOT NULL,
    capacidad_max           INTEGER         NOT NULL,
    dia_semana              VARCHAR(15)     NOT NULL,
    hora_inicio             VARCHAR(5)      NOT NULL,
    estado                  VARCHAR(20)     NOT NULL DEFAULT 'activo',
    fecha_creacion          DATE                     DEFAULT CURRENT_DATE,
    instructor_id_empleado  BIGINT          NOT NULL,
    sala_id_sala            BIGINT          NOT NULL,
    CONSTRAINT clase_pkey                       PRIMARY KEY (id_clase),
    CONSTRAINT clase_instructor_id_empleado_fkey FOREIGN KEY (instructor_id_empleado) REFERENCES empleado(id_empleado),
    CONSTRAINT clase_sala_id_sala_fkey           FOREIGN KEY (sala_id_sala)            REFERENCES sala(id_sala)
);

-- Tabla 4: EQUIPO
CREATE TABLE equipo (
    id_equipo       BIGSERIAL       NOT NULL,
    nombre          VARCHAR(50)     NOT NULL,
    marca           VARCHAR(50),
    modelo          VARCHAR(50),
    estado          VARCHAR(20)     NOT NULL DEFAULT 'operativo',
    fecha_creacion  DATE                     DEFAULT CURRENT_DATE,
    sala_id_sala    BIGINT          NOT NULL,
    CONSTRAINT equipo_pkey              PRIMARY KEY (id_equipo),
    CONSTRAINT equipo_sala_id_sala_fkey FOREIGN KEY (sala_id_sala) REFERENCES sala(id_sala)
);

-- Tabla 5: MIEMBRO
CREATE TABLE miembro (
    documento           VARCHAR(20)     NOT NULL,
    nombre_completo     VARCHAR(100)    NOT NULL,
    correo_electronico  VARCHAR(100)    NOT NULL,
    telefono            VARCHAR(15),
    fecha_nacimiento    DATE            NOT NULL,
    estado              VARCHAR(20)     NOT NULL DEFAULT 'activo',
    fecha_creacion      DATE                     DEFAULT CURRENT_DATE,
    password            VARCHAR(255),
    CONSTRAINT miembro_pkey                     PRIMARY KEY (documento),
    CONSTRAINT miembro_correo_electronico_key   UNIQUE (correo_electronico)
);

-- Tabla 6: PLAN
CREATE TABLE plan (
    id_plan         BIGSERIAL       NOT NULL,
    nombre          VARCHAR(50)     NOT NULL,
    precio_cop      NUMERIC(12,2)   NOT NULL,
    duracion_dias   INTEGER         NOT NULL,
    estado          VARCHAR(20)     NOT NULL DEFAULT 'activo',
    fecha_creacion  DATE                     DEFAULT CURRENT_DATE,
    CONSTRAINT plan_pkey PRIMARY KEY (id_plan)
);

-- Tabla 7: MEMBRESIA
CREATE TABLE membresia (
    id_membresia        BIGSERIAL       NOT NULL,
    fecha_inicio        DATE            NOT NULL,
    fecha_fin           DATE            NOT NULL,
    precio_inscrito     NUMERIC(12,2)   NOT NULL,
    estado              VARCHAR(20)     NOT NULL DEFAULT 'activa',
    fecha_creacion      DATE                     DEFAULT CURRENT_DATE,
    miembro_documento   VARCHAR(20)     NOT NULL,
    plan_id_plan        BIGINT          NOT NULL,
    CONSTRAINT membresia_pkey                       PRIMARY KEY (id_membresia),
    CONSTRAINT membresia_miembro_documento_fkey     FOREIGN KEY (miembro_documento) REFERENCES miembro(documento),
    CONSTRAINT membresia_plan_id_plan_fkey          FOREIGN KEY (plan_id_plan)      REFERENCES plan(id_plan)
);

-- Tabla 8: PAGO
CREATE TABLE pago (
    num_pago                INTEGER         NOT NULL,
    membresia_id_membresia  BIGINT          NOT NULL,
    fecha_pago              DATE            NOT NULL,
    monto_cop               NUMERIC(12,2)   NOT NULL,
    metodo_pago             VARCHAR(20)     NOT NULL,
    fecha_creacion          DATE                     DEFAULT CURRENT_DATE,
    CONSTRAINT pago_pkey                        PRIMARY KEY (num_pago, membresia_id_membresia),
    CONSTRAINT pago_membresia_id_membresia_fkey FOREIGN KEY (membresia_id_membresia) REFERENCES membresia(id_membresia)
);

-- Tabla 9: RESERVA
CREATE TABLE reserva (
    id_reserva          BIGSERIAL       NOT NULL,
    miembro_documento   VARCHAR(20)     NOT NULL,
    clase_id_clase      BIGINT          NOT NULL,
    fecha_reserva       DATE            NOT NULL,
    estado              VARCHAR(20)     NOT NULL DEFAULT 'confirmada',
    fecha_creacion      DATE                     DEFAULT CURRENT_DATE,
    CONSTRAINT reserva_pkey                     PRIMARY KEY (id_reserva, miembro_documento),
    CONSTRAINT reserva_miembro_documento_fkey   FOREIGN KEY (miembro_documento) REFERENCES miembro(documento),
    CONSTRAINT reserva_clase_id_clase_fkey      FOREIGN KEY (clase_id_clase)    REFERENCES clase(id_clase)
);

-- Tabla 10: MANTENIMIENTO
CREATE TABLE mantenimiento (
    id_mantenimiento            BIGINT          NOT NULL,
    equipo_id_equipo            BIGINT          NOT NULL,
    fecha_mantenimiento         DATE            NOT NULL,
    costo_cop                   NUMERIC(12,2)   NOT NULL,
    descripcion                 VARCHAR(200),
    fecha_creacion              DATE                     DEFAULT CURRENT_DATE,
    tecnico_id_empleado         BIGINT,
    administrador_id_empleado   BIGINT,
    CONSTRAINT mantenimiento_pkey                               PRIMARY KEY (id_mantenimiento, equipo_id_equipo),
    CONSTRAINT mantenimiento_equipo_id_equipo_fkey              FOREIGN KEY (equipo_id_equipo)            REFERENCES equipo(id_equipo),
    CONSTRAINT mantenimiento_tecnico_id_empleado_fkey           FOREIGN KEY (tecnico_id_empleado)         REFERENCES empleado(id_empleado),
    CONSTRAINT mantenimiento_administrador_id_empleado_fkey     FOREIGN KEY (administrador_id_empleado)   REFERENCES empleado(id_empleado)
);