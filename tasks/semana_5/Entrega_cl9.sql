-- Semana 5 · Clase 9 — Tarea: Crear tablas y consultar ventas
-- Base de datos: test_db

-- PARTE 1: Departamentos en venta/alquiler

DROP TABLE IF EXISTS apartments;

CREATE TABLE apartments (
    id             SERIAL PRIMARY KEY,
    name           VARCHAR(50),
    address        VARCHAR(100),
    city           VARCHAR(50),
    postal_code    VARCHAR(10),
    bedrooms       INT,
    area_m2        NUMERIC(6,2),
    price          NUMERIC(10,2),
    available      BOOLEAN,
    published_date DATE
);

INSERT INTO apartments (name, address, city, postal_code, bedrooms, area_m2, price, available, published_date) VALUES
('Palermo Soho 4B',       'Honduras 4850',                    'Buenos Aires',  'C1414', 1,  42.00,  98000, TRUE,  '2023-03-14'),
('Recoleta Plaza 7A',     'Junín 1320',                       'Buenos Aires',  'C1113', 3,  96.50, 215000, FALSE, '2023-04-02'),
('Caballito Parque 2C',   'Av. Rivadavia 5240',               'Buenos Aires',  'C1424', 2,  54.80, 105000, TRUE,  '2023-04-19'),
('Belgrano R 5D',         'Echeverría 2380',                  'Buenos Aires',  'C1428', 3,  88.00, 189000, TRUE,  '2023-05-08'),
('Almagro Centro 6A',     'Av. Corrientes 3860',              'Buenos Aires',  'C1194', 1,  36.50,  64000, TRUE,  '2023-05-23'),
('Villa Urquiza 3B',      'Triunvirato 4120',                 'Buenos Aires',  'C1431', 2,  58.20, 112000, TRUE,  '2023-06-11'),
('Núñez Río 9C',          'Av. del Libertador 7650',          'Buenos Aires',  'C1429', 4, 135.00, 340000, FALSE, '2023-06-27'),
('Flores Sur 1A',         'Av. Directorio 1870',              'Buenos Aires',  'C1406', 2,  49.50,  78000, TRUE,  '2023-07-15'),
('Nueva Córdoba 8F',      'Av. Hipólito Yrigoyen 380',        'Córdoba',       'X5000', 1,  33.00,  52000, TRUE,  '2023-03-21'),
('Cerro de las Rosas 2B', 'Av. Rafael Núñez 4260',            'Córdoba',       'X5009', 3,  92.00, 158000, TRUE,  '2023-05-02'),
('Alta Córdoba 4A',       'Av. Mons. Pablo Cabrera 2190',     'Córdoba',       'X5003', 2,  57.40,  83000, FALSE, '2023-06-06'),
('General Paz 3C',        'Av. Juan B. Justo 1540',           'Córdoba',       'X5000', 2,  61.00,  91000, TRUE,  '2023-07-03'),
('Centro Córdoba 10A',    'Obispo Trejo 745',                 'Córdoba',       'X5000', 1,  38.50,  59000, TRUE,  '2023-08-09'),
('Pichincha Loft 2A',     'Av. Francia 1280',                 'Rosario',       'S2000', 1,  44.00,  71000, TRUE,  '2023-03-30'),
('Centro Rosario 12B',    'Córdoba 1850',                     'Rosario',       'S2000', 2,  59.30,  99000, TRUE,  '2023-05-17'),
('Echesortu 5C',          'Mendoza 3150',                     'Rosario',       'S2000', 2,  63.50,  96000, FALSE, '2023-06-20'),
('Fisherton Golf 1D',     'Av. Gutiérrez 580',                'Rosario',       'S2000', 3,  98.00, 168000, TRUE,  '2023-08-22'),
('Oroño Parque 6A',       'Bv. Oroño 1180',                   'Rosario',       'S2000', 2,  55.80,  94000, TRUE,  '2023-09-12'),
('Centro Mendoza 3A',     'Av. San Martín 1020',              'Mendoza',       'M5500', 2,  56.20,  88000, TRUE,  '2023-04-10'),
('Godoy Cruz 2B',         'Bolivia 780',                      'Mendoza',       'M5501', 3,  84.00, 128000, FALSE, '2023-05-29'),
('Chacras de Coria 1A',   'Viamonte 4100',                    'Mendoza',       'M5505', 4, 118.00, 195000, TRUE,  '2023-07-24'),
('Quinta Sección 4C',     'Av. Emilio Civit 580',             'Mendoza',       'M5500', 1,  37.80,  61000, TRUE,  '2023-08-30'),
('Candioti Norte 2A',     'Bv. Gálvez 1720',                  'Santa Fe',      'S3000', 2,  58.90,  79000, TRUE,  '2023-04-25'),
('Costanera 7B',          'Av. Alte. Brown 3250',             'Santa Fe',      'S3000', 3,  91.00, 132000, TRUE,  '2023-06-14'),
('Centro Santa Fe 5D',    'San Martín 2480',                  'Santa Fe',      'S3000', 1,  34.20,  47000, FALSE, '2023-07-19'),
('Guadalupe 3A',          'Av. Aristóbulo del Valle 5600',    'Santa Fe',      'S3000', 2,  62.40,  83000, TRUE,  '2023-09-05'),
('Casco Urbano 8A',       'Calle 7 N° 1250',                  'La Plata',      'B1900', 2,  55.50,  76000, TRUE,  '2023-05-11'),
('Plaza Moreno 2C',       'Calle 12 N° 780',                  'La Plata',      'B1900', 3,  87.00, 118000, TRUE,  '2023-06-29'),
('City Bell 1A',          'Camino Centenario 1950',           'La Plata',      'B1896', 3, 102.00, 149000, FALSE, '2023-08-16'),
('Tolosa Estación 4B',    'Calle 528 N° 1800',                'La Plata',      'B1900', 1,  39.00,  51000, TRUE,  '2023-09-20'),
('Güemes Mar 3B',         'Güemes 2650',                      'Mar del Plata', 'B7600', 2,  53.00,  92000, TRUE,  '2023-04-06'),
('Playa Grande 9A',       'Av. Martínez de Hoz 3900',         'Mar del Plata', 'B7600', 4, 125.00, 245000, FALSE, '2023-07-08'),
('Centro Mar 6C',         'Av. Colón 2150',                   'Mar del Plata', 'B7600', 1,  35.00,  58000, TRUE,  '2023-08-02');

-- E1: departamentos disponibles desde el más barato al más caro
SELECT *
FROM apartments
WHERE available = TRUE
ORDER BY price ASC;

-- E2: precio promedio por ciudad
SELECT city, AVG(price) AS avg_price
FROM apartments
GROUP BY city;

-- E3: 2 o más habitaciones y menos de 60 m2
SELECT *
FROM apartments
WHERE bedrooms >= 2
  AND area_m2 < 60;



-- PARTE 2: Ventas

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product VARCHAR(50),
    category VARCHAR(30),
    price NUMERIC,
    quantity INT,
    sale_date DATE
);

INSERT INTO sales (product, category, price, quantity, sale_date) VALUES
('Mouse', 'Electronics', 15, 4, '2023-07-10'),
('Keyboard', 'Electronics', 30, 2, '2023-07-11'),
('Notebook', 'Stationery', 8, 10, '2023-07-12'),
('Pen', 'Stationery', 2, 25, '2023-07-13'),
('Headphones', 'Electronics', 40, 3, '2023-07-14'),
('Monitor', 'Electronics', 120, 1, '2023-07-15'),
('Desk Chair', 'Furniture', 85, 2, '2023-07-16'),
('Notebook Case', 'Accessories', 25, 3, '2023-07-17'),
('Printer Paper', 'Stationery', 6, 15, '2023-07-18'),
('USB Drive', 'Electronics', 12, 5, '2023-07-19'),
('Desk Lamp', 'Furniture', 35, 4, '2023-07-20'),
('Stapler', 'Stationery', 7, 6, '2023-07-21'),
('Calculator', 'Electronics', 20, 3, '2023-07-22'),
('Water Bottle', 'Accessories', 10, 8, '2023-07-23'),
('Laptop Stand', 'Accessories', 45, 2, '2023-07-24'),
('Office Desk', 'Furniture', 150, 1, '2023-07-25'),
('Whiteboard', 'Furniture', 60, 1, '2023-07-26'),
('Marker Set', 'Stationery', 5, 12, '2023-07-27'),
('Mouse Pad', 'Accessories', 8, 7, '2023-07-28'),
('Webcam', 'Electronics', 50, 2, '2023-07-29'),
('Smartphone', 'Electronics', 300, 1, '2023-07-30'),
('Notebook Pro', 'Electronics', 900, 1, '2023-07-31'),
('File Cabinet', 'Furniture', 120, 1, '2023-08-01'),
('Backpack', 'Accessories', 40, 3, '2023-08-02'),
('Binder', 'Stationery', 4, 20, '2023-08-03'),
('Headset Stand', 'Accessories', 15, 5, '2023-08-04'),
('Desk Organizer', 'Accessories', 12, 6, '2023-08-05'),
('Laptop Sleeve', 'Accessories', 30, 2, '2023-08-06'),
('Paper Clips', 'Stationery', 1, 50, '2023-08-07'),
('Surge Protector', 'Electronics', 25, 3, '2023-08-08'),
('Pen Holder', 'Accessories', 5, 10, '2023-08-09');

-- E1: todas las ventas de Electronics
SELECT *
FROM sales
WHERE category = 'Electronics';

-- E2: ingresos totales por categoría
SELECT category, SUM(price * quantity) AS total_revenue
FROM sales
GROUP BY category;

-- E3: categoría con mayor ingreso total
SELECT category, SUM(price * quantity) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 1;

-- E4: ventas con precio mayor a 20
SELECT *
FROM sales
WHERE price > 20;

-- E5: total de unidades vendidas por producto
SELECT product, SUM(quantity) AS total_units
FROM sales
GROUP BY product;

-- E6: ingreso promedio por venta, por producto
SELECT product, AVG(price * quantity) AS avg_revenue
FROM sales
GROUP BY product;

-- E7: top 3 productos con mayor cantidad total vendida
SELECT product, SUM(quantity) AS total_units
FROM sales
GROUP BY product
ORDER BY total_units DESC
LIMIT 3;

-- E8: ventas posteriores al 12 de julio de 2023
SELECT *
FROM sales
WHERE sale_date > '2023-07-12';

-- E9: categorías con ingreso total mayor a 50
SELECT category, SUM(price * quantity) AS total_revenue
FROM sales
GROUP BY category
HAVING SUM(price * quantity) > 50;

-- E10: productos cuyo nombre comienza con H
SELECT *
FROM sales
WHERE product LIKE 'H%';

-- E11: cantidad promedio vendida por categoría
SELECT category, AVG(quantity) AS avg_quantity
FROM sales
GROUP BY category;

-- E12: ingreso por fila, de mayor a menor
SELECT *, price * quantity AS revenue
FROM sales
ORDER BY revenue DESC;

-- E13: Electronics con cantidad > 2 y precio < 40
SELECT *
FROM sales
WHERE category = 'Electronics'
  AND quantity > 2
  AND price < 40;