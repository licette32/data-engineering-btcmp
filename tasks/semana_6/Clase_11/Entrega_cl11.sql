-- Consultas para verificar las relaciones

-- A. Autores y libros (1:N)

SELECT
    a.nombre,
    a.apellido,
    l.titulo,
    l.area,
    l.anio_publicacion
FROM autores a
INNER JOIN libros l
    ON a.autor_id = l.autor_id;


-- B. Socios y carnets (1:1)

SELECT
    s.nombre,
    s.apellido,
    s.categoria,
    c.numero_carnet,
    c.fecha_emision,
    c.fecha_vencimiento,
    c.estado
FROM socios s
INNER JOIN carnets c
    ON s.socio_id = c.socio_id;


-- C. Socios, préstamos y libros (N:N)

SELECT
    s.nombre,
    s.apellido,
    p.fecha_prestamo,
    p.fecha_devolucion_prevista,
    l.titulo,
    pl.estado_ejemplar
FROM socios s
INNER JOIN prestamos p
    ON s.socio_id = p.socio_id
INNER JOIN prestamo_libros pl
    ON p.prestamo_id = pl.prestamo_id
INNER JOIN libros l
    ON pl.libro_id = l.libro_id
ORDER BY p.fecha_prestamo;

-- D. Cantidad de préstamos por socio

SELECT
    s.nombre,
    s.apellido,
    s.categoria,
    COUNT(p.prestamo_id) AS total_prestamos
FROM socios s
LEFT JOIN prestamos p
    ON s.socio_id = p.socio_id
GROUP BY
    s.socio_id,
    s.nombre,
    s.apellido,
    s.categoria;


-- E. Libros más solicitados

SELECT
    l.titulo,
    l.area,
    COUNT(pl.libro_id) AS veces_prestado
FROM libros l
LEFT JOIN prestamo_libros pl
    ON l.libro_id = pl.libro_id
GROUP BY
    l.libro_id,
    l.titulo,
    l.area
ORDER BY veces_prestado DESC;