# Tarea Semana 4 · Clase 8 — Docker + PostgreSQL + pgAdmin

## 1. Verificación del Entorno
- Se levantaron los contenedores `postgres-db` y `pgAdmin` mediante Docker Compose (`docker compose up -d`).
- Conexión exitosa desde la interfaz web de pgAdmin hacia el servidor PostgreSQL.

## 2. Diseño Entidad-Relación (dbdiagram.io)

![Diagrama Relacional](<Clase 8.png>)

## 3. Modelado y Creación de Tablas (DDL)
Se ejecutó el siguiente script SQL en el *Query Tool* de pgAdmin para implementar los tres tipos de relaciones relacionales:

```sql
-- Relación 1:1 
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    bio TEXT,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Relación 1:N 
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- Relación N:N 
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE student_courses (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
```

![Resultado en pgAdmin](<resultado_pgadmin.png>)


