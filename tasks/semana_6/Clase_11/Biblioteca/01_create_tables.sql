-- SEMANA 6 - CLASE 11
-- BASE DE DATOS: biblioteca_fisica_db


-- 1. TABLA AUTORES

CREATE TABLE autores (
    autor_id        SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    apellido        VARCHAR(100) NOT NULL,
    nacionalidad    VARCHAR(80) NOT NULL,
    especialidad    VARCHAR(100)
);



-- 2. TABLA LIBROS: Catálogo de publicaciones científicas.

CREATE TABLE libros (
    libro_id                SERIAL PRIMARY KEY,
    autor_id                INTEGER NOT NULL,
    titulo                  VARCHAR(200) NOT NULL,
    isbn                    VARCHAR(20) NOT NULL UNIQUE,
    area                    VARCHAR(100) NOT NULL,
    anio_publicacion        INTEGER,
    ejemplares_disponibles  INTEGER DEFAULT 1,

    -- Relación 1:N (Un autor puede escribir muchos libros).
    CONSTRAINT fk_libro_autor
        FOREIGN KEY (autor_id)
        REFERENCES autores(autor_id),

    CONSTRAINT chk_area
        CHECK (area IN (
            'Mecanica',
            'Electromagnetismo',
            'Fisica cuantica',
            'Astrofisica',
            'Cosmologia',
            'Matematica'
        )),

    CONSTRAINT chk_anio
        CHECK (
            anio_publicacion IS NULL
            OR anio_publicacion BETWEEN 1400 AND 2100
        ),

    CONSTRAINT chk_ejemplares
        CHECK (ejemplares_disponibles >= 0)
);



-- 3. TABLA SOCIOS: Estudiantes, docentes e investigadores.

CREATE TABLE socios (
    socio_id        SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    apellido        VARCHAR(100) NOT NULL,
    documento       VARCHAR(20) NOT NULL UNIQUE,
    categoria       VARCHAR(30) NOT NULL,
    carrera         VARCHAR(120),
    fecha_alta      DATE DEFAULT CURRENT_DATE,
    activo          BOOLEAN DEFAULT TRUE,

    CONSTRAINT chk_categoria
        CHECK (categoria IN ('Estudiante', 'Docente', 'Investigador', 'Graduado'))
);


-- 4. TABLA CARNETS: Cada socio tiene un único carnet.

CREATE TABLE carnets (
    carnet_id           SERIAL PRIMARY KEY,
    socio_id            INTEGER NOT NULL UNIQUE,
    numero_carnet       VARCHAR(30) NOT NULL UNIQUE,
    fecha_emision       DATE DEFAULT CURRENT_DATE,
    fecha_vencimiento   DATE NOT NULL,
    estado              VARCHAR(20) DEFAULT 'Activo',

    -- Relación 1:1:
    CONSTRAINT fk_carnet_socio
        FOREIGN KEY (socio_id)
        REFERENCES socios(socio_id),

    CONSTRAINT chk_estado_carnet
        CHECK (estado IN ('Activo', 'Vencido', 'Suspendido')),

    CONSTRAINT chk_vencimiento
        CHECK (fecha_vencimiento > fecha_emision)
);


-- 5. TABLA PRESTAMOS: Un socio puede realizar muchos préstamos.

CREATE TABLE prestamos (
    prestamo_id                 SERIAL PRIMARY KEY,
    socio_id                    INTEGER NOT NULL,
    fecha_prestamo              DATE DEFAULT CURRENT_DATE,
    fecha_devolucion_prevista   DATE NOT NULL,
    fecha_devolucion_real       DATE,
    estado                      VARCHAR(20) DEFAULT 'Activo',

    -- Relación 1:N:
    CONSTRAINT fk_prestamo_socio
        FOREIGN KEY (socio_id)
        REFERENCES socios(socio_id),

    CONSTRAINT chk_estado_prestamo
        CHECK (estado IN ('Activo', 'Devuelto', 'Atrasado')),

    CONSTRAINT chk_fecha_devolucion
        CHECK (
            fecha_devolucion_prevista >= fecha_prestamo
        ),

    CONSTRAINT chk_devolucion_real
        CHECK (
            fecha_devolucion_real IS NULL
            OR fecha_devolucion_real >= fecha_prestamo
        )
);


-- 6. TABLA PRESTAMO_LIBROS: Tabla intermedia para resolver la relación N:N.

CREATE TABLE prestamo_libros (
    prestamo_id INTEGER NOT NULL,
    libro_id INTEGER NOT NULL,
    estado_ejemplar VARCHAR(30) DEFAULT 'En prestamo',

    -- Clave primaria compuesta.
    CONSTRAINT pk_prestamo_libros
        PRIMARY KEY (prestamo_id, libro_id),

    -- Relación 1:N con préstamos.
    CONSTRAINT fk_pl_prestamo
        FOREIGN KEY (prestamo_id)
        REFERENCES prestamos(prestamo_id),

    -- Relación 1:N con libros.
    CONSTRAINT fk_pl_libro
        FOREIGN KEY (libro_id)
        REFERENCES libros(libro_id),

    CONSTRAINT chk_estado_ejemplar
        CHECK (estado_ejemplar IN ('En prestamo', 'Devuelto', 'Dañado'))
);
