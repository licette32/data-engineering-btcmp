-- Semana 5 - Clase 10 - Tema: Relaciones con Foreign Keys
-- BASE DE DATOS: relaciones_db

-- 1. UNO A UNO (1:1)
-- Un conductor tiene un vehículo asignado. C/ vehículo pertenece a un único conductor.
-- UNIQUE: en conductor_id impide asignar dos vehículos al mismo conductor.

CREATE TABLE conductores (
    id 				SERIAL PRIMARY KEY,
    nombre 			VARCHAR(100) NOT NULL,
    licencia 		VARCHAR(30) UNIQUE,
    fecha_ingreso 	DATE
);

CREATE TABLE vehiculos (
    id 				SERIAL PRIMARY KEY,
    patente 		VARCHAR(10) UNIQUE NOT NULL,
    modelo 			VARCHAR(100) NOT NULL,
    conductor_id 	INTEGER NOT NULL UNIQUE,

	CONSTRAINT fk_conductor
    	FOREIGN KEY (conductor_id) 
		REFERENCES conductores(id)
);


-- INSERT: CONDUCTORES

INSERT INTO conductores (nombre, licencia, fecha_ingreso)
VALUES
('Esteban Carrizo', 'LIC-AR-88392', '2021-04-12'),
('Marcela Roldán', 'LIC-AR-99410', '2022-09-01'),
('Héctor Maidana', 'LIC-AR-11234', '2023-02-15');


-- INSERT: VEHICULOS

INSERT INTO vehiculos (patente, modelo, conductor_id)
VALUES
('AF456ZX', 'Toyota Hilux 4x4', 1),
('AC789BB', 'Ford Ranger Cabina Simple', 2),
('AG123YY', 'Volkswagen Amarok', 3);

-- Ver conductores y sus vehículos
SELECT
    c.nombre AS conductor,
    v.patente,
    v.modelo
FROM conductores c
INNER JOIN vehiculos v
    ON c.id = v.conductor_id;


-- Prueba de constraint UNIQUE:
-- Se intenta asignar un 2do vehículo al conductor con id = 1.
-- PostgreSQL rechaza la operación porque ese conductor ya tiene un vehículo.

-- INSERT INTO vehiculos (patente, modelo, conductor_id)
-- VALUES ('AE999ZZ', 'Nissan Frontier', 1);

-- ERROR:  duplicate key value violates unique constraint "vehiculos_conductor_id_key"
-- Key (conductor_id)=(1) already exists. 
-- Estado SQL: 23505
-- Detalle: Key (conductor_id)=(1) already exists.




-- 2. UNO A MUCHOS (1:N)
-- Un profesor puede dictar muchas clases. Cada clase pertenece obligatoriamente a un profesor.
-- La FK se encuentra en la tabla del lado N.

CREATE TABLE profesores (
    id 					SERIAL PRIMARY KEY,
    nombre 				VARCHAR(100) NOT NULL,
    especialidad 		VARCHAR(50) NOT NULL,
    fecha_contratacion 	DATE NOT NULL
);

CREATE TABLE clases (
    id 			SERIAL PRIMARY KEY,
    nombre 		VARCHAR(100) NOT NULL,
    horario 	VARCHAR(50) NOT NULL,
    profesor_id INTEGER NOT NULL,
	
    CONSTRAINT fk_profesor 
		FOREIGN KEY (profesor_id) 
		REFERENCES profesores(id)
);

-- INSERT: PROFESORES

INSERT INTO profesores (nombre, especialidad, fecha_contratacion)
VALUES
('Dra. Sofía Albarracín', 'Ciencia de Datos e IA', '2020-03-01'),
('Ing. Matías Benítez', 'Arquitectura Cloud y DevOps', '2021-06-15');


-- INSERT: CLASES

INSERT INTO clases (nombre, horario, profesor_id)
VALUES
('Introducción a Python y Pandas', 'Lunes y Miércoles 18:00', 1),
('Modelado Estadístico con R', 'Martes 19:30', 1),
('Despliegue de Contenedores con Docker', 'Jueves 18:00', 2),
('Optimización de Consultas PostgreSQL', 'Viernes 17:00', 2);


SELECT
    p.nombre AS profesor,
    cl.nombre AS clase,
    cl.horario
FROM profesores p
INNER JOIN clases cl
    ON p.id = cl.profesor_id;


-- Intento fallido: Crear una clase sin asignar un profesor (viola NOT NULL)

-- INSERT INTO clases (nombre, horario, profesor_id) 
-- VALUES ('Introducción a Big Data', 'Sábados 09:00', NULL);

-- ERROR:  null value in column "profesor_id" of relation "clases" violates not-null constraint
-- Failing row contains (5, Introducción a Big Data, Sábados 09:00, null). 
-- Estado SQL: 23502
-- Detalle: Failing row contains (5, Introducción a Big Data, Sábados 09:00, null).




-- 3. MUCHOS A MUCHOS (N:N)
-- Un paciente puede tener varias enfermedades. Una enfermedad puede afectar a varios pacientes.
-- La tabla intermedia resuelve la relación.

CREATE TABLE pacientes (
    id 					SERIAL PRIMARY KEY,
    nombre 				VARCHAR(100) NOT NULL,
    fecha_nacimiento 	DATE NOT NULL,
    telefono 			VARCHAR(20)
);

CREATE TABLE enfermedades (
    id 					SERIAL PRIMARY KEY,
    nombre 				VARCHAR(100) NOT NULL,
    descripcion 		TEXT,
    nivel_gravedad 		VARCHAR(20) NOT NULL 
		CHECK (nivel_gravedad IN ('leve', 'moderada', 'grave'))
);

CREATE TABLE pacientes_enfermedades (
    paciente_id 		INTEGER NOT NULL,
    enfermedad_id 		INTEGER NOT NULL,
    fecha_diagnostico 	DATE NOT NULL,

	CONSTRAINT pk_pacientes_enfermedades
		PRIMARY KEY (paciente_id, enfermedad_id),
		
    CONSTRAINT fk_paciente 
		FOREIGN KEY (paciente_id) 
		REFERENCES pacientes(id),
		
    CONSTRAINT fk_enfermedad
		FOREIGN KEY (enfermedad_id) 
		REFERENCES enfermedades(id)
);


-- INSERT: PACIENTES

INSERT INTO pacientes (nombre, fecha_nacimiento, telefono)
VALUES
('Camila Varela', '1992-07-14', '3425554321'),
('Luciano Mansilla', '1984-12-03', '3425558765'),
('Agustina Benítez', '1999-03-22', '3425551122');


-- INSERT: ENFERMEDADES

INSERT INTO enfermedades (nombre, descripcion, nivel_gravedad)
VALUES
('Rinitis Alérgica Estacional',
 'Reacción al polen y cambios de estación', 'leve'),

('Hipertensión Arterial Esencial',
 'Presión arterial persistentemente alta', 'moderada'),

('Asma Bronquial Crónica',
 'Inflamación y obstrucción de las vías respiratorias', 'grave');


-- INSERT: PACIENTES_ENFERMEDADES

INSERT INTO pacientes_enfermedades
(paciente_id, enfermedad_id, fecha_diagnostico)
VALUES
(1, 1, '2023-09-15'),
(1, 2, '2024-01-10'),
(2, 3, '2022-05-20'),
(3, 1, '2023-10-05');


SELECT
    pa.nombre AS paciente,
    e.nombre AS enfermedad,
    e.nivel_gravedad,
    pe.fecha_diagnostico
FROM pacientes pa
INNER JOIN pacientes_enfermedades pe
    ON pa.id = pe.paciente_id
INNER JOIN enfermedades e
    ON e.id = pe.enfermedad_id;


-- Intento fallido: Registrar otra vez que el paciente 1 tiene la enfermedad 1 (viola la PK compuesta)

-- INSERT INTO pacientes_enfermedades (paciente_id, enfermedad_id, fecha_diagnostico) 
-- VALUES (1, 1, '2024-03-01');

-- ERROR:  duplicate key value violates unique constraint "pk_pacientes_enfermedades"
-- Key (paciente_id, enfermedad_id)=(1, 1) already exists. 
-- Estado SQL: 23505
-- Detalle: Key (paciente_id, enfermedad_id)=(1, 1) already exists.