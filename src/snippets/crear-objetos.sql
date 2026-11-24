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
