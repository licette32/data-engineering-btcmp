-- Consultas para verificar las relaciones

-- A. Productores y animales (1:N)

SELECT
    d.nombre,
    d.apellido,
    d.establecimiento,
    m.nombre AS animal,
    m.especie,
    m.raza,
    m.identificacion
FROM duenos d
INNER JOIN mascotas m
    ON d.dueno_id = m.dueno_id;


-- B. Animales e historias clínicas (1:1)

SELECT
    m.nombre AS animal,
    m.especie,
    m.raza,
    h.fecha_apertura,
    h.antecedentes,
    h.estado_sanitario
FROM mascotas m
INNER JOIN historias_clinicas h
    ON m.mascota_id = h.mascota_id;


-- C. Citas y tratamientos (N:N)

SELECT
    m.nombre AS animal,
    c.fecha_hora,
    c.motivo,
    t.nombre AS tratamiento,
    ct.dosis,
    ct.observaciones
FROM citas c
INNER JOIN mascotas m
    ON c.mascota_id = m.mascota_id
INNER JOIN cita_tratamiento ct
    ON c.cita_id = ct.cita_id
INNER JOIN tratamientos t
    ON ct.tratamiento_id = t.tratamiento_id
ORDER BY c.fecha_hora;


-- D. Cantidad de animales por productor

SELECT
    d.establecimiento,
    d.nombre,
    d.apellido,
    COUNT(m.mascota_id) AS total_animales
FROM duenos d
LEFT JOIN mascotas m
    ON d.dueno_id = m.dueno_id
GROUP BY
    d.dueno_id,
    d.establecimiento,
    d.nombre,
    d.apellido;