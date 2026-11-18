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
