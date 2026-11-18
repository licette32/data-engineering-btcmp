-- Semana 6 · Clase 12 — Tarea: JOINs sobre el minimercado
-- Base de datos: minimercado


-- E1 — INNER JOIN
-- Solo aparecen proveedores que tienen productos.

SELECT
    pr.nombre AS proveedor,
    p.nombre AS producto
FROM proveedores pr
INNER JOIN productos p
    ON pr.id = p.proveedor_id
ORDER BY pr.nombre, p.nombre;


-- E2 — LEFT JOIN
-- Todos los proveedores y cuántos productos tiene cada uno, se incluyen los proveedores que no tienen productos.

SELECT
    pr.id,
    pr.nombre AS proveedor,
    COUNT(p.id) AS cantidad_productos
FROM proveedores pr
LEFT JOIN productos p
    ON pr.id = p.proveedor_id
GROUP BY pr.id, pr.nombre
ORDER BY cantidad_productos DESC, pr.nombre;



-- E3 — LEFT JOIN
-- Ventas que no tienen productos cargados.

SELECT
    v.id AS venta_id,
    v.fecha,
    v.cliente_id,
    v.total
FROM ventas v
LEFT JOIN venta_productos vp
    ON v.id = vp.venta_id
WHERE vp.venta_id IS NULL
ORDER BY v.fecha, v.id;



-- E4 — RIGHT JOIN
-- Todos los métodos de pago y cuántas ventas se realizaron con c/u, incluso los que nunca se usaron.

SELECT
    mp.id,
    mp.nombre AS metodo_pago,
    COUNT(v.id) AS cantidad_ventas
FROM ventas v
RIGHT JOIN metodos_pago mp
    ON v.metodo_pago_id = mp.id
GROUP BY mp.id, mp.nombre
ORDER BY cantidad_ventas DESC, mp.nombre;



-- E5 — FULL OUTER JOIN
-- Productos que nunca se vendieron.


SELECT
    p.id AS producto_id,
    p.nombre AS producto
FROM productos p
FULL OUTER JOIN venta_productos vp
    ON p.id = vp.producto_id
WHERE vp.producto_id IS NULL
ORDER BY p.id;



-- E6 — CROSS JOIN
-- Todas las combinaciones posibles entre productos y métodos de pago.


SELECT
    p.nombre AS producto,
    p.precio,
    mp.nombre AS metodo_pago
FROM productos p
CROSS JOIN metodos_pago mp
ORDER BY p.nombre, mp.nombre;



-- E7 — JOIN MÚLTIPLE
-- Cliente, fecha de venta y cantidad total de unidades de c/venta.
-- LEFT JOIN: conservar las ventas que no tienen productos cargados.


SELECT
    v.id AS venta_id,
    c.nombre AS cliente,
    v.fecha,
    COALESCE(SUM(vp.cantidad), 0) AS total_unidades
FROM ventas v
INNER JOIN clientes c
    ON v.cliente_id = c.id
LEFT JOIN venta_productos vp
    ON v.id = vp.venta_id
GROUP BY v.id, c.nombre, v.fecha
ORDER BY v.fecha, v.id;



-- E8 — JOIN MÚLTIPLE
-- Total facturado por proveedor.
-- Fórmula: cantidad * precio_unitario.

SELECT
    pr.id,
    pr.nombre AS proveedor,
    COALESCE(
        SUM(vp.cantidad * vp.precio_unitario),
        0
    ) AS total_facturado
FROM proveedores pr
LEFT JOIN productos p
    ON pr.id = p.proveedor_id
LEFT JOIN venta_productos vp
    ON p.id = vp.producto_id
GROUP BY pr.id, pr.nombre
ORDER BY total_facturado DESC, pr.nombre;



-- E9 — JOIN MÚLTIPLE: INNER + LEFT
-- productos, su proveedor y la cantidad total de unidades vendidas.

SELECT
    p.id AS producto_id,
    p.nombre AS producto,
    pr.nombre AS proveedor,
    COALESCE(SUM(vp.cantidad), 0) AS unidades_vendidas
FROM productos p
INNER JOIN proveedores pr
    ON p.proveedor_id = pr.id
LEFT JOIN venta_productos vp
    ON p.id = vp.producto_id
GROUP BY p.id, p.nombre, pr.nombre
ORDER BY unidades_vendidas DESC, p.nombre;


-- E10 — JOIN MÚLTIPLE: INNER + LEFT
-- Ventas, cliente, método de pago y cantidad de productos distintos de cada venta.

SELECT
    v.id AS venta_id,
    v.fecha,
    c.nombre AS cliente,
    mp.nombre AS metodo_pago,
    COUNT(DISTINCT vp.producto_id) AS productos_distintos
FROM ventas v
INNER JOIN clientes c
    ON v.cliente_id = c.id
INNER JOIN metodos_pago mp
    ON v.metodo_pago_id = mp.id
LEFT JOIN venta_productos vp
    ON v.id = vp.venta_id
GROUP BY
    v.id,
    v.fecha,
    c.nombre,
    mp.nombre
ORDER BY v.fecha, v.id;



-- E11 — JOIN MÚLTIPLE: LEFT + LEFT
-- Proveedores y cuántas ventas distintas se vendio algún producto de cada proveedor.


SELECT
    pr.id,
    pr.nombre AS proveedor,
    COUNT(DISTINCT vp.venta_id) AS ventas_distintas
FROM proveedores pr
LEFT JOIN productos p
    ON pr.id = p.proveedor_id
LEFT JOIN venta_productos vp
    ON p.id = vp.producto_id
GROUP BY pr.id, pr.nombre
ORDER BY ventas_distintas DESC, pr.nombre;

--

--FROM proveedores pr
--LEFT JOIN productos p
--    ON pr.id = p.proveedor_id
--INNER JOIN venta_productos vp
--    ON p.id = vp.producto_id
-- Desaparecen los proveedores que no tienen productos. También, desaparecen los proveedores cuyos productos nunca se vendieron.
-- Se conservan los proveedores que tienen al menos un producto asociado a una venta.
-- La razón es que INNER JOIN exige encontrar coincidencias en venta_productos.