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
