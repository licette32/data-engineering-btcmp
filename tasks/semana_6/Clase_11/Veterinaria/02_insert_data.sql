-- Inserción de datos

-- INSERTS: DUENOS

INSERT INTO duenos
(nombre, apellido, documento, establecimiento, localidad, telefono)
VALUES
('Roberto', 'Acosta', '25111222', 'La Esperanza', 'Rafaela', '3492001101'),
('Mariana', 'Torres', '28333444', 'El Ombú', 'Sunchales', '3492001102'),
('Federico', 'Molina', '30111555', 'Los Álamos', 'Esperanza', '3492001103');


-- INSERTS: MASCOTAS (ANIMALES)

INSERT INTO mascotas
(dueno_id, nombre, identificacion, especie, raza, sexo, fecha_nacimiento)
VALUES
(1, 'Luna', 'AR-0001', 'Bovino', 'Holando Argentino', 'Hembra', '2023-03-10'),
(2, 'Mora', 'AR-0002', 'Bovino', 'Aberdeen Angus', 'Hembra', '2022-08-15'),
(3, 'Relámpago', 'EQ-0001', 'Equino', 'Criollo', 'Macho', '2020-05-20');



-- INSERTS: HISTORIAS_CLINICAS

INSERT INTO historias_clinicas
(mascota_id, antecedentes, estado_sanitario)
VALUES
(1, 'Antecedente de mastitis clínica durante la lactancia.', 'En seguimiento'),
(2, 'Control sanitario periódico del establecimiento.', 'Estable'),
(3, 'Antecedente de lesión en miembro posterior.', 'En tratamiento');


-- INSERTS: CITAS

INSERT INTO citas
(mascota_id, fecha_hora, motivo, tipo, estado)
VALUES
(1, '2026-11-18 08:00:00', 'Evaluación de mastitis y control de glándula mamaria', 'Consulta', 'Realizada'),
(1, '2026-11-25 09:00:00', 'Control posterior al tratamiento', 'Control sanitario', 'Programada'),
(2, '2026-11-19 10:00:00', 'Evaluación reproductiva', 'Control reproductivo', 'Programada'),
(3, '2026-11-20 11:00:00', 'Evaluación de lesión en miembro posterior', 'Consulta', 'Realizada');


-- INSERTS: TRATAMIENTOS

INSERT INTO tratamientos
(nombre, categoria, descripcion, via_administracion)
VALUES
('Tratamiento de mastitis', 'Sanidad bovina', 'Tratamiento veterinario indicado para mastitis bovina.', 'Intramamaria'),
('Plan sanitario preventivo', 'Prevención', 'Intervenciones sanitarias preventivas según evaluación veterinaria.', 'Inyectable'),
('Tratamiento de lesión musculoesquelética', 'Traumatología equina', 'Manejo terapéutico de lesiones del aparato locomotor.', 'Oral'),
('Control antiparasitario', 'Sanidad animal', 'Tratamiento de control de parásitos internos o externos.', 'Oral');


-- INSERTS: CITA_TRATAMIENTO

INSERT INTO cita_tratamiento
(cita_id, tratamiento_id, dosis, observaciones)
VALUES
(1, 1, 'Según indicación veterinaria', 'Tratamiento indicado luego de la evaluación clínica.'),
(1, 4, 'Según peso y protocolo', 'Control antiparasitario complementario.'),
(2, 2, 'Según protocolo sanitario', 'Intervención preventiva programada.'),
(3, 4, 'Según peso y protocolo', 'Control antiparasitario del animal.'),
(4, 3, 'Según evaluación veterinaria', 'Tratamiento indicado para la lesión del miembro posterior.');
