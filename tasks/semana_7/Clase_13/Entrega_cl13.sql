-- SEMANA 7 - CLASE 13
-- SQL AVANZADO SOBRE EL MINIMERCADO

-- E1 - VISTA vista_detalle_ventas

CREATE OR REPLACE VIEW vista_detalle_ventas AS
SELECT
    v.id AS venta_id,
    v.fecha,
    c.id AS cliente_id,
    c.nombre AS cliente,
    mp.nombre AS metodo_pago,
    p.id AS producto_id,
    p.nombre AS producto,
    pr.nombre AS proveedor,
    vp.cantidad,
    vp.precio_unitario,
    vp.cantidad * vp.precio_unitario AS subtotal
FROM ventas v
JOIN clientes c ON c.id = v.cliente_id
JOIN metodos_pago mp ON mp.id = v.metodo_pago_id
JOIN venta_productos vp ON vp.venta_id = v.id
JOIN productos p ON p.id = vp.producto_id
JOIN proveedores pr ON pr.id = p.proveedor_id;

-- COMPROBACIÓN
SELECT *
FROM vista_detalle_ventas
ORDER BY venta_id, producto_id
LIMIT 20;

-- Se muestran los datos de venta, cliente, pago, producto y proveedor.


-- E2 - CONSULTAS SOBRE vista_detalle_ventas

-- Total gastado por cliente
SELECT
    cliente_id,
    cliente,
    SUM(subtotal) AS total_gastado
FROM vista_detalle_ventas
GROUP BY cliente_id, cliente
ORDER BY total_gastado DESC;

-- Productos más vendidos
SELECT
    producto_id,
    producto,
    SUM(cantidad) AS unidades_vendidas
FROM vista_detalle_ventas
GROUP BY producto_id, producto
ORDER BY unidades_vendidas DESC;

-- Se muestran los clientes ordenados desde el que más gastó y los productos ordenados desde el que más unidades vendió.


-- E3 - VISTA vista_stock_bajo

CREATE OR REPLACE VIEW vista_stock_bajo AS
SELECT
    p.id,
    p.nombre,
    p.stock,
    pr.nombre AS proveedor,
    pr.telefono
FROM productos p
JOIN proveedores pr ON pr.id = p.proveedor_id
WHERE p.stock < 10;

-- COMPROBACIÓN
SELECT *
FROM vista_stock_bajo
ORDER BY stock ASC, id ASC;

--Se muestran productos con stock menor a 10 unidades, ordenados por stock ascendente, junto con el nombre y teléfono del proveedor.



-- E4 - VISTA MATERIALIZADA mv_ventas_por_mes

-- Eliminar versión anterior para poder repetir el ejercicio.
DROP MATERIALIZED VIEW IF EXISTS mv_ventas_por_mes;



CREATE MATERIALIZED VIEW mv_ventas_por_mes AS
SELECT
    DATE_TRUNC('month', fecha)::DATE AS mes,
    COUNT(*) AS cantidad_ventas,
    COALESCE(SUM(total), 0) AS total_vendido
FROM ventas
GROUP BY DATE_TRUNC('month', fecha)::DATE;

-- a- Consulta inicial.
SELECT *
FROM mv_ventas_por_mes
ORDER BY mes;

-- b- Insertar venta nueva.
INSERT INTO ventas (cliente_id, metodo_pago_id, fecha, total)
VALUES (1, 3, CURRENT_TIMESTAMP, 50.00)
RETURNING id, fecha, total;

-- c- Sin refrescar.
SELECT *
FROM mv_ventas_por_mes
ORDER BY mes;

-- d- Actualizo la vista materializada.
REFRESH MATERIALIZED VIEW mv_ventas_por_mes;

SELECT *
FROM mv_ventas_por_mes
ORDER BY mes;



-- E5 - ÍNDICES EXISTENTES

SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN (
      'clientes',
      'proveedores',
      'productos',
      'metodos_pago',
      'ventas',
      'venta_productos'
  )
ORDER BY tablename, indexname;

-- PRIMARY KEY y UNIQUE crean índices automáticamente.
-- venta_productos tiene índice compuesto por su PRIMARY KEY.
-- Las FOREIGN KEY no crean índices automáticamente.



-- E6 - EXPERIMENTO DE RENDIMIENTO CON EXPLAIN ANALYZE

DROP TABLE IF EXISTS prueba_indices;

CREATE TABLE prueba_indices (
    id BIGINT,
    cliente_id INTEGER,
    fecha TIMESTAMP,
    total NUMERIC(10, 2)
);

-- Genero un millón de registros.
INSERT INTO prueba_indices (id, cliente_id, fecha, total)
SELECT
    n,
    (FLOOR(RANDOM() * 10000) + 1)::INTEGER,
    CURRENT_TIMESTAMP - RANDOM() * INTERVAL '365 days',
    ROUND((RANDOM() * 500)::NUMERIC, 2)
FROM GENERATE_SERIES(1, 1000000) AS g(n);

ANALYZE prueba_indices;

-- a- Sin índice.
EXPLAIN ANALYZE
SELECT *
FROM prueba_indices
WHERE cliente_id = 42;

-- b- Creamos el índice.
CREATE INDEX idx_prueba_indices_cliente_id
ON prueba_indices (cliente_id);

ANALYZE prueba_indices;

-- c- Con índice.
EXPLAIN ANALYZE
SELECT *
FROM prueba_indices
WHERE cliente_id = 42;

-- Sin índice:
-- Tipo de scan: Parallel Seq Scan (dentro de Gather)
-- Execution Time: 220.905 ms

-- Con índice (idx_prueba_indices_cliente_id):
-- Tipo de scan: Bitmap Index Scan + Bitmap Heap Scan
-- Execution Time: 2.848 ms

-- d- Elimino la tabla auxiliar.
DROP TABLE IF EXISTS prueba_indices;



-- E7 - CREAR ÍNDICES EN EL MINIMERCADO

CREATE INDEX IF NOT EXISTS idx_ventas_cliente_id
ON ventas (cliente_id);

CREATE INDEX IF NOT EXISTS idx_venta_productos_producto_id
ON venta_productos (producto_id);

CREATE INDEX IF NOT EXISTS idx_ventas_fecha
ON ventas (fecha);

-- COMPROBACIÓN
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname IN (
      'idx_ventas_cliente_id',
      'idx_venta_productos_producto_id',
      'idx_ventas_fecha'
  )
ORDER BY tablename, indexname;



-- E8 - FUNCIÓN fn_total_gastado

CREATE OR REPLACE FUNCTION fn_total_gastado(p_cliente_id INT)
RETURNS NUMERIC(12, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC(12, 2);
BEGIN
    SELECT COALESCE(SUM(vp.cantidad * vp.precio_unitario), 0)
    INTO v_total
    FROM ventas AS v
    INNER JOIN venta_productos AS vp
        ON v.id = vp.venta_id
    WHERE v.cliente_id = p_cliente_id;

    RETURN v_total;
END;
$$;

-- a- Un cliente.
SELECT fn_total_gastado(1) AS total_cliente_1;

-- b- Listar todos los clientes.
SELECT
    c.id,
    c.nombre,
    fn_total_gastado(c.id) AS total_gastado
FROM clientes AS c
ORDER BY total_gastado DESC, c.id;

-- Se muestra cada cliente con su total gastado. Los clientes sin compras devuelven 0.


-- E9 - PROCEDIMIENTO sp_aumentar_precios

CREATE OR REPLACE PROCEDURE sp_aumentar_precios(
    p_proveedor_id INT,
    p_porcentaje NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_actualizados INT; -- se guarda cuántos productos cambian de precio
BEGIN
    UPDATE productos
    SET precio = ROUND(precio * (1 + p_porcentaje / 100.0), 2)
    WHERE proveedor_id = p_proveedor_id;

    GET DIAGNOSTICS v_actualizados = ROW_COUNT;

    RAISE NOTICE 'Productos actualizados: %', v_actualizados;
END;
$$;

-- En el dataset original "Lácteos del Valle"  tiene id = 8.

-- a- Precios antes del aumento.
SELECT id, nombre, precio
FROM productos
WHERE proveedor_id = 8
ORDER BY id;

-- b- Aplicamos aumento del 10 %.
CALL sp_aumentar_precios(8, 10);

-- c- Precios despues del aumento.
SELECT id, nombre, precio
FROM productos
WHERE proveedor_id = 8
ORDER BY id;


-- Se muestra que los precios aumentar un 10%.
-- Si repito el CALL vuelve a aumentar otro 10 %.



-- E10 - TRIGGER trg_descontar_stock

CREATE OR REPLACE FUNCTION fn_descontar_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;

    RETURN NEW;
END;
$$;

-- Se evita duplicar el trigger.
DROP TRIGGER IF EXISTS trg_descontar_stock ON venta_productos;

CREATE TRIGGER trg_descontar_stock
AFTER INSERT ON venta_productos
FOR EACH ROW
EXECUTE FUNCTION fn_descontar_stock();

-- a- Stock inicial deLeche Entera 1L (id = 1).
SELECT id, nombre, stock AS stock_antes
FROM productos
WHERE id = 1;

-- b- Guardar el ID de la venta.
DROP TABLE IF EXISTS venta_prueba;

CREATE TEMP TABLE venta_prueba (
    id INTEGER
);


WITH nueva_venta AS (
    INSERT INTO ventas (cliente_id, metodo_pago_id, fecha, total)
    VALUES (1, 3, CURRENT_TIMESTAMP, 4.50)
    RETURNING id
)
INSERT INTO venta_prueba (id)
SELECT id
FROM nueva_venta;

-- Verifico el ID generado.
SELECT id AS nueva_venta_id
FROM venta_prueba;

-- c- Se agrega 3 unidades de leche a esa venta.
INSERT INTO venta_productos (
    venta_id,
    producto_id,
    cantidad,
    precio_unitario
)
SELECT id, 1, 3, 1.50
FROM venta_prueba
RETURNING venta_id, producto_id, cantidad, precio_unitario;

-- d- Stock baja?.
SELECT id, nombre, stock AS stock_despues
FROM productos
WHERE id = 1;

-- Se muestra que el stock inicial era 100, después 97.



-- E11 - INTENTAR VENDER JAMÓN COCIDO SIN STOCK

-- En el dataset original: Jamón Cocido 200g (id = 25, stock = 0).

-- a- Verifico el stock.
SELECT id, nombre, stock
FROM productos
WHERE id = 25;

-- b- Insertar una unidad.
DO $$
BEGIN
    INSERT INTO venta_productos (
        venta_id,
        producto_id,
        cantidad,
        precio_unitario
    )
    SELECT id, 25, 1, 3.10
    FROM venta_prueba;

    RAISE NOTICE 'Se realizó la inserción. Revisa el stock.';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'Inserción rechazada: el stock no puede quedar negativo.';
END;
$$;

-- c- Verificar si se guardo la línea.
SELECT *
FROM venta_productos
WHERE venta_id = (SELECT id FROM venta_prueba)
  AND producto_id = 25;

-- No se muestran filas.

-- d- Comprobamos nuevamente el stock.
SELECT id, nombre, stock
FROM productos
WHERE id = 25;

-- Se muestra que el stock sigue siendo 0.
-- PostgreSQL revirtió la inserción y la actualización fallida.
