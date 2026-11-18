-- SEMANA 6 - CLASE 11
-- BASE DE DATOS: veterinaria_rural_db
-- CASO: CENTRO DE SANIDAD VETERINARIA RURAL



-- 1. TABLA - DUEÑOS: Productores y responsables de los animales.

CREATE TABLE duenos (
    dueno_id            SERIAL PRIMARY KEY,
    nombre              VARCHAR(100) NOT NULL,
    apellido            VARCHAR(100) NOT NULL,
    documento           VARCHAR(20) NOT NULL UNIQUE,
    establecimiento     VARCHAR(150) NOT NULL,
    localidad           VARCHAR(100) NOT NULL,
    telefono            VARCHAR(30)
);



-- 2. TABLA - MASCOTAS: Representa animales bovinos y equinos.

CREATE TABLE mascotas (
    mascota_id          SERIAL PRIMARY KEY,
    dueno_id            INTEGER NOT NULL,
    nombre              VARCHAR(100) NOT NULL,
    identificacion      VARCHAR(50) NOT NULL UNIQUE,
    especie             VARCHAR(20) NOT NULL,
    raza                VARCHAR(100),
    sexo                VARCHAR(10) NOT NULL,
    fecha_nacimiento    DATE,

    -- Relación 1:N (Un dueño puede tener varios animales).
    CONSTRAINT fk_mascota_dueno
        FOREIGN KEY (dueno_id)
        REFERENCES duenos(dueno_id),

    CONSTRAINT chk_especie
        CHECK (especie IN ('Bovino', 'Equino')),

    CONSTRAINT chk_sexo
        CHECK (sexo IN ('Macho', 'Hembra'))
);



-- 3. TABLA - HISTORIAS_CLINICAS: Cada animal tiene una historia clínica.

CREATE TABLE historias_clinicas (
    historia_id         SERIAL PRIMARY KEY,
    mascota_id          INTEGER NOT NULL UNIQUE,
    fecha_apertura      DATE DEFAULT CURRENT_DATE,
    antecedentes        TEXT,
    estado_sanitario    VARCHAR(30) DEFAULT 'En seguimiento',

    -- Relación 1:1 (UNIQUE impide que un animal tenga dos historias).
    CONSTRAINT fk_historia_mascota
        FOREIGN KEY (mascota_id)
        REFERENCES mascotas(mascota_id),

    CONSTRAINT chk_estado_sanitario
        CHECK (estado_sanitario IN ('En seguimiento', 'Estable', 'En tratamiento', 'Recuperado'))
);



-- 4. TABLA - CITAS: Consultas y controles veterinarios.

CREATE TABLE citas (
    cita_id         SERIAL PRIMARY KEY,
    mascota_id      INTEGER NOT NULL,
    fecha_hora      TIMESTAMP NOT NULL,
    motivo          VARCHAR(200) NOT NULL,
    tipo            VARCHAR(50) NOT NULL,
    estado          VARCHAR(20) DEFAULT 'Programada',

    -- Relación 1:N (Un animal puede tener muchas citas).
    CONSTRAINT fk_cita_mascota
        FOREIGN KEY (mascota_id)
        REFERENCES mascotas(mascota_id),

    CONSTRAINT chk_tipo_cita
        CHECK (tipo IN ('Consulta', 'Control sanitario', 'Control reproductivo', 'Urgencia')),

    CONSTRAINT chk_estado_cita
        CHECK (estado IN ('Programada', 'Realizada', 'Cancelada'))
);



-- 5. TABLA - TRATAMIENTOS: Catálogo de tratamientos veterinarios.

CREATE TABLE tratamientos (
    tratamiento_id      SERIAL PRIMARY KEY,
    nombre              VARCHAR(150) NOT NULL UNIQUE,
    categoria           VARCHAR(100) NOT NULL,
    descripcion         TEXT,
    via_administracion  VARCHAR(50),

    CONSTRAINT chk_via_administracion
        CHECK (
            via_administracion IN ('Oral', 'Inyectable', 'Topica', 'Intramamaria', 'No aplica'))
);



-- 6. TABLA - CITA_TRATAMIENTO: Tabla intermedia para resolver la relación N:N.

CREATE TABLE cita_tratamiento (
    cita_id             INTEGER NOT NULL,
    tratamiento_id      INTEGER NOT NULL,
    dosis               VARCHAR(100) NOT NULL,
    observaciones       TEXT,

    -- Clave primaria compuesta.
    CONSTRAINT pk_cita_tratamiento
        PRIMARY KEY (cita_id, tratamiento_id),

    -- Relación 1:N con citas.
    CONSTRAINT fk_ct_cita
        FOREIGN KEY (cita_id)
        REFERENCES citas(cita_id),

    -- Relación 1:N con tratamientos.
    CONSTRAINT fk_ct_tratamiento
        FOREIGN KEY (tratamiento_id)
        REFERENCES tratamientos(tratamiento_id)
);