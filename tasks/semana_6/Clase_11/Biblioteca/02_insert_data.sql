-- Inserción de datos

-- INSERTS AUTORES

INSERT INTO autores
(nombre, apellido, nacionalidad, especialidad)
VALUES
('John R.', 'Taylor', 'Estadounidense', 'Mecánica clásica'),
('David J.', 'Griffiths', 'Estadounidense', 'Electromagnetismo'),
('Stephen', 'Hawking', 'Británica', 'Cosmología'),
('Carl', 'Sagan', 'Estadounidense', 'Astronomía y divulgación');


-- INSERTS LIBROS: ISBN y datos editoriales ilustrativos.


INSERT INTO libros
(autor_id, titulo, isbn, area, anio_publicacion, ejemplares_disponibles)
VALUES
(1, 'Classical Mechanics', '9781891389221', 'Mecanica', 2005, 3),
(2, 'Introduction to Electrodynamics', '9781108420419', 'Electromagnetismo', 2017, 2),
(3, 'A Brief History of Time', '9780553380163', 'Cosmologia', 1988, 4),
(4, 'Cosmos', '9780345539434', 'Astrofisica', 1980, 2);



-- INSERTS: SOCIOS

INSERT INTO socios
(nombre, apellido, documento, categoria, carrera)
VALUES
('Luciana', 'Pereyra', '40111222', 'Estudiante', 'Licenciatura en Física'),
('Tomás', 'Gutiérrez', '38555666', 'Estudiante', 'Licenciatura en Astronomía'),
('Gabriela', 'Fernández', '25111999', 'Docente', 'Departamento de Física');



-- INSERTS: CARNETS

INSERT INTO carnets
(socio_id, numero_carnet, fecha_emision, fecha_vencimiento)
VALUES
(1, 'BIB-2026-001', '2026-03-01', '2027-03-01'),
(2, 'BIB-2026-002', '2026-03-01', '2027-03-01'),
(3, 'BIB-2026-003', '2026-03-01', '2027-03-01');



-- INSERTS: PRESTAMOS

INSERT INTO prestamos
(socio_id, fecha_prestamo, fecha_devolucion_prevista, fecha_devolucion_real, estado)
VALUES
(1, '2026-11-10', '2026-11-24', NULL, 'Activo'),
(2, '2026-11-11', '2026-11-25', NULL, 'Activo'),
(1, '2026-10-01', '2026-10-15', '2026-10-14', 'Devuelto'),
(3, '2026-11-12', '2026-11-26', NULL, 'Activo');



-- INSERTS: PRESTAMO_LIBROS

INSERT INTO prestamo_libros
(prestamo_id, libro_id, estado_ejemplar)
VALUES
(1, 1, 'En prestamo'),
(1, 2, 'En prestamo'),
(2, 3, 'En prestamo'),
(3, 4, 'Devuelto'),
(4, 1, 'En prestamo');
