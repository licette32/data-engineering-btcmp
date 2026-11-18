-- 1. TABLA: CONSULTORIOS

CREATE TABLE consultorios (
    consultorio_id      SERIAL PRIMARY KEY,
    numero              VARCHAR(20) NOT NULL UNIQUE,
    piso                INTEGER NOT NULL,
    ala                 VARCHAR(10) DEFAULT 'Norte',
    servicio            VARCHAR(100) NOT NULL,

    CONSTRAINT chk_piso
        CHECK (piso BETWEEN 0 AND 30),

    CONSTRAINT chk_ala
        CHECK (ala IN ('Norte', 'Sur', 'Este', 'Oeste'))
);


-- 2. TABLA: MEDICOS

CREATE TABLE medicos (
    medico_id           SERIAL PRIMARY KEY,
    nombre              VARCHAR(100) NOT NULL,
    apellido            VARCHAR(100) NOT NULL,
    matricula           VARCHAR(30) NOT NULL UNIQUE,
    especialidad        VARCHAR(100) NOT NULL,
    consultorio_id      INTEGER NOT NULL UNIQUE,

    -- Relación 1:1: Cada médico tiene un solo consultorio.
    -- UNIQUE impide que dos médicos compartan consultorio.

    CONSTRAINT fk_medico_consultorio
        FOREIGN KEY (consultorio_id)
        REFERENCES consultorios(consultorio_id)
);


-- 3. TABLA: PACIENTES

CREATE TABLE pacientes (
    paciente_id         SERIAL PRIMARY KEY,
    nombre              VARCHAR(100) NOT NULL,
    apellido            VARCHAR(100) NOT NULL,
    dni                 VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento    DATE NOT NULL,
    grupo_sanguineo     VARCHAR(2) NOT NULL,
    factor_rh           CHAR(1) NOT NULL,
    telefono            VARCHAR(30),
    activo              BOOLEAN DEFAULT TRUE,

    CONSTRAINT chk_fecha_nacimiento
        CHECK (fecha_nacimiento < CURRENT_DATE),

    CONSTRAINT chk_grupo_sanguineo
        CHECK (grupo_sanguineo IN ('A', 'B', 'AB', 'O')),

    CONSTRAINT chk_factor_rh
        CHECK (factor_rh IN ('+', '-'))
);


-- 4. TABLA: CITAS

CREATE TABLE citas (
    cita_id           SERIAL PRIMARY KEY,
    paciente_id       INTEGER NOT NULL,
    medico_id         INTEGER NOT NULL,
    fecha_hora        TIMESTAMP NOT NULL,
    motivo            VARCHAR(200) NOT NULL,
    duracion_minutos  INTEGER DEFAULT 30,
    estado            VARCHAR(20) DEFAULT 'Programada',

    -- Relación 1:N (Un paciente puede tener muchas citas).
    CONSTRAINT fk_cita_paciente
        FOREIGN KEY (paciente_id)
        REFERENCES pacientes(paciente_id),

    -- Relación 1:N (Un médico puede atender muchas citas).
    CONSTRAINT fk_cita_medico
        FOREIGN KEY (medico_id)
        REFERENCES medicos(medico_id),

    CONSTRAINT chk_duracion
        CHECK (duracion_minutos BETWEEN 10 AND 240),

    CONSTRAINT chk_estado_cita
        CHECK (estado IN (
            'Programada',
            'Atendida',
            'Cancelada'
        )),

    -- Un médico no puede tener dos citascon el mismo horario de inicio.
    CONSTRAINT uq_medico_horario
        UNIQUE (medico_id, fecha_hora)
);


-- 5. TABLA: ENFERMEDADES

CREATE TABLE enfermedades (
    enfermedad_id   SERIAL PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL UNIQUE,
    categoria       VARCHAR(100) NOT NULL,
    descripcion     TEXT
);


-- 6. TABLA: PACIENTE_ENFERMEDAD

CREATE TABLE paciente_enfermedad (
    paciente_id         INTEGER NOT NULL,
    enfermedad_id       INTEGER NOT NULL,
    fecha_diagnostico   DATE DEFAULT CURRENT_DATE,
    gravedad            VARCHAR(20) NOT NULL,
    observaciones       TEXT,

    -- Clave primaria compuesta.
    -- Evita duplicar la misma asociación
    -- entre paciente y enfermedad.

    CONSTRAINT pk_paciente_enfermedad
        PRIMARY KEY (paciente_id, enfermedad_id),

    -- Relación 1:N (con pacientes).
    CONSTRAINT fk_pe_paciente
        FOREIGN KEY (paciente_id)
        REFERENCES pacientes(paciente_id),

    -- Relación 1:N (con enfermedades).
    CONSTRAINT fk_pe_enfermedad
        FOREIGN KEY (enfermedad_id)
        REFERENCES enfermedades(enfermedad_id),

    CONSTRAINT chk_gravedad
        CHECK (gravedad IN ('Leve', 'Moderada', 'Grave', 'Critica')),

    CONSTRAINT chk_fecha_diagnostico
        CHECK (fecha_diagnostico <= CURRENT_DATE)
);

