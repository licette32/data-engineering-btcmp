-- Semana 6 · Clase 11 — Tarea: Diseñar una base de datos transaccional
-- Base de datos: hospital_db


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
        CHECK (estado IN ('Programada', 'Atendida', 'Cancelada')),

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




-- INSERTS: CONSULTORIOS


INSERT INTO consultorios
(numero, piso, ala, servicio)
VALUES
('N-101', 3, 'Norte', 'Neurocirugía'),
('E-202', 4, 'Este', 'Electrofisiología cardíaca'),
('H-303', 5, 'Oeste', 'Hematología y trasplante');


-- INSERTS: MEDICOS

INSERT INTO medicos
(nombre, apellido, matricula, especialidad, consultorio_id)
VALUES
('Valentina', 'Méndez', 'MP-45821', 'Neurocirugía', 1),
('Santiago', 'Ferraro', 'MP-37642', 'Electrofisiología cardíaca', 2),
('Lucía', 'Herrera', 'MP-51289', 'Hematología y trasplante de médula ósea', 3);


-- INSERTS: PACIENTES

INSERT INTO pacientes
(nombre, apellido, dni, fecha_nacimiento, grupo_sanguineo, factor_rh, telefono)
VALUES
('Martín', 'Quiroga', '30111222', '1975-04-12', 'A', '+', '3492001101'),
('Camila', 'Benítez', '32555666', '1988-08-20', 'O', '-', '3492001102'),
('Federico', 'Suárez', '28999888', '1969-11-05', 'B', '+', '3492001103');


-- INSERTS: CITAS

INSERT INTO citas
(paciente_id, medico_id, fecha_hora, motivo, duracion_minutos, estado)
VALUES
(1, 1, '2026-11-18 09:00:00', 'Evaluación prequirúrgica de tumor cerebral', 60, 'Programada'),
(1, 2, '2026-11-19 10:30:00', 'Evaluación electrofisiológica por arritmia', 45, 'Programada'),
(2, 1, '2026-11-20 11:00:00', 'Seguimiento de lesión intracraneal', 45, 'Programada'),
(3, 3, '2026-11-21 08:30:00', 'Evaluación hematológica por alteración medular', 60, 'Programada');


-- INSERTS: ENFERMEDADES

INSERT INTO enfermedades
(nombre, categoria, descripcion)
VALUES
('Hipertensión arterial', 'Cardiovascular', 'Elevación persistente de la presión arterial.'),
('Fibrilación auricular', 'Cardiovascular', 'Arritmia cardíaca caracterizada por una actividad auricular desorganizada.'),
('Glioblastoma', 'Oncológica', 'Tumor cerebral maligno de alto grado.'),
('Leucemia mieloide aguda', 'Hematológica', 'Neoplasia hematológica caracterizada por proliferación de células mieloides inmaduras.');


-- INSERTS: PACIENTE_ENFERMEDAD

INSERT INTO paciente_enfermedad
(paciente_id, enfermedad_id, fecha_diagnostico, gravedad, observaciones)
VALUES
-- Martín: hipertensión y fibrilación auricular.
(1, 1, '2024-03-10', 'Moderada', 'Diagnóstico en seguimiento.'),
(1, 2, '2025-06-15', 'Grave', 'Requiere evaluación electrofisiológica.'),

-- Camila: hipertensión y glioblastoma.
(2, 1, '2023-09-12', 'Leve', 'Control periódico de presión arterial.'),
(2, 3, '2026-02-20', 'Grave', 'En seguimiento por neurocirugía.'),

-- Federico: enfermedad hematológica.
(3, 4, '2026-01-15', 'Grave', 'En evaluación para tratamiento especializado.');




-- Consultas para verificar las relaciones

-- A. Médicos y consultorios (1:1)

SELECT
    m.medico_id,
    m.nombre,
    m.apellido,
    m.especialidad,
    c.numero AS consultorio,
    c.piso,
    c.ala
FROM medicos m
INNER JOIN consultorios c
    ON m.consultorio_id = c.consultorio_id;


-- B. Pacientes, citas y médicos (1:N)

SELECT
    p.nombre,
    p.apellido,
    c.fecha_hora,
    c.motivo,
    m.apellido AS medico,
    m.especialidad,
    c.estado
FROM pacientes p
INNER JOIN citas c
    ON p.paciente_id = c.paciente_id
INNER JOIN medicos m
    ON c.medico_id = m.medico_id
ORDER BY c.fecha_hora;


-- C. Pacientes y enfermedades (N:N)

SELECT
    p.nombre,
    p.apellido,
    e.nombre AS enfermedad,
    e.categoria,
    pe.fecha_diagnostico,
    pe.gravedad
FROM pacientes p
INNER JOIN paciente_enfermedad pe
    ON p.paciente_id = pe.paciente_id
INNER JOIN enfermedades e
    ON pe.enfermedad_id = e.enfermedad_id
ORDER BY p.apellido;


-- D. Cantidad de citas por médico

SELECT
    m.nombre,
    m.apellido,
    m.especialidad,
    COUNT(c.cita_id) AS total_citas
FROM medicos m
LEFT JOIN citas c
    ON m.medico_id = c.medico_id
GROUP BY
    m.medico_id,
    m.nombre,
    m.apellido,
    m.especialidad;
