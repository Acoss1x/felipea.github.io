
SET SERVEROUTPUT ON SIZE UNLIMITED


DECLARE
    v_id NUMBER;
BEGIN
    SP_REGISTRAR_PRODUCTO('PRU-0001', 'Producto de prueba', 1, 50000, 30000, 5, v_id);
    DBMS_OUTPUT.PUT_LINE('OK: producto registrado con ID ' || v_id);

    BEGIN   
        SP_REGISTRAR_PRODUCTO('PRU-0001', 'Otro', 1, 50000, 30000, 5, v_id);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Duplicado (esperado -20003): ' || SQLERRM);
    END;
    BEGIN   
        SP_REGISTRAR_PRODUCTO('PRU-0002', 'Precio malo', 1, 10000, 20000, 5, v_id);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Precio (esperado -20001): ' || SQLERRM);
    END;
    BEGIN   
        SP_REGISTRAR_PRODUCTO('PRU-0003', 'Categoria mala', 99999, 50000, 30000, 5, v_id);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Categoria (esperado -20002): ' || SQLERRM);
    END;
    ROLLBACK;
END;
/


DECLARE
    v_saldo NUMBER;
BEGIN
    SP_AJUSTAR_STOCK(1001, 1, 'ENTRADA', 50, 'Prueba entrada', v_saldo);
    DBMS_OUTPUT.PUT_LINE('ENTRADA +50, saldo bodega 1 = ' || v_saldo || ' (esperado 170)');

    BEGIN
        SP_AJUSTAR_STOCK(1001, 1, 'SALIDA', 99999, 'Prueba fallida', v_saldo);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SALIDA enorme (esperado -20072): ' || SQLERRM);
    END;

    SP_AJUSTAR_STOCK(1001, 1, 'AJUSTE', 100, 'Prueba ajuste', v_saldo);
    DBMS_OUTPUT.PUT_LINE('AJUSTE a 100, saldo = ' || v_saldo || ' (esperado 100)');

    BEGIN   -- salida sobre combinacion que no existe (1002 no esta en bodega 2)
        SP_AJUSTAR_STOCK(1002, 2, 'SALIDA', 1, 'Sin combinacion', v_saldo);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SALIDA sin combinacion (esperado -20071): ' || SQLERRM);
    END;

    SP_AJUSTAR_STOCK(1002, 2, 'ENTRADA', 10, 'Crea combinacion', v_saldo);
    DBMS_OUTPUT.PUT_LINE('ENTRADA crea combinacion, saldo = ' || v_saldo || ' (esperado 10)');
    ROLLBACK;
END;
/


DECLARE
    v_ped NUMBER;
BEGIN
    SP_CREAR_PEDIDO(501, v_ped);
    DBMS_OUTPUT.PUT_LINE('OK: pedido creado en BORRADOR con ID ' || v_ped);
    BEGIN SP_CREAR_PEDIDO(9999, v_ped);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('No existe (esperado -20074): ' || SQLERRM); END;
    BEGIN SP_CREAR_PEDIDO(506, v_ped);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Inactivo (esperado -20075): ' || SQLERRM); END;
    BEGIN SP_CREAR_PEDIDO(505, v_ped);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Sin cupo (esperado -20076): ' || SQLERRM); END;
    ROLLBACK;
END;
/


SELECT FN_STOCK_DISPONIBLE(1001, 1) AS stock_bodega_1,
       FN_STOCK_DISPONIBLE(1001)    AS stock_consolidado,
       FN_STOCK_DISPONIBLE(99999)   AS producto_inexistente
FROM   DUAL;

SELECT FN_CUPO_DISPONIBLE(501) AS cupo_501,
       FN_CUPO_DISPONIBLE(505) AS cupo_505_agotado,
       FN_CUPO_DISPONIBLE(506) AS cupo_506_inactivo
FROM   DUAL;

SELECT FN_CALCULAR_DESCUENTO(501, 2500000) AS d_501_2500000_esp_200000,
       FN_CALCULAR_DESCUENTO(503, 2500000) AS d_503_2500000_esp_250000,
       FN_CALCULAR_DESCUENTO(501, 1000000) AS d_501_1000000_esp_50000,
       FN_CALCULAR_DESCUENTO(503, 1000000) AS d_503_1000000_esp_70000,
       FN_CALCULAR_DESCUENTO(501,  500000) AS d_501_500000_esp_0
FROM   DUAL;


DECLARE
    v NUMBER;
BEGIN
    v := FN_PRECIO_PRODUCTO('HM-0001');
    DBMS_OUTPUT.PUT_LINE('HM-0001 -> ' || v || ' (esperado 45000)');
    v := FN_PRECIO_PRODUCTO('HM-9999');
    DBMS_OUTPUT.PUT_LINE('HM-9999 -> ' || v || ' (esperado -1)');
END;
/


BEGIN
    SP_VALIDAR_DESPACHO(1001, 1, 10);      -- viable
    BEGIN
        SP_VALIDAR_DESPACHO(1001, 1, 99999); -- rechazado
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Esperado -20040: ' || SQLERRM);
    END;
END;
/


BEGIN
    BEGIN SP_ANULAR_PEDIDO(9999);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('No existe (esperado -20010): ' || SQLERRM); END;
    BEGIN SP_ANULAR_PEDIDO(7);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Ya anulado (esperado -20011): ' || SQLERRM); END;
    BEGIN SP_ANULAR_PEDIDO(5);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Mas de 30 dias (esperado -20012): ' || SQLERRM); END;

    SP_ANULAR_PEDIDO(6);  
    DBMS_OUTPUT.PUT_LINE('Pedido 6 anulado correctamente');
    ROLLBACK;
END;
/


DECLARE
    v_cupo_antes  NUMBER;
    v_cupo_despues NUMBER;
    v_x NUMBER;
BEGIN
    SELECT cupo_credito INTO v_cupo_antes FROM CLIENTE WHERE id_cliente = 501;
    UPDATE CLIENTE SET cupo_credito = cupo_credito + 1 WHERE id_cliente = 501;
    BEGIN
        v_x := 1 / 0;
    EXCEPTION WHEN OTHERS THEN
        SP_REGISTRAR_ERROR('PRUEBA_ROLLBACK', 'Division por cero de prueba');
        ROLLBACK;
    END;
    SELECT cupo_credito INTO v_cupo_despues FROM CLIENTE WHERE id_cliente = 501;
    DBMS_OUTPUT.PUT_LINE('Cupo antes = ' || v_cupo_antes || ', despues del ROLLBACK = ' || v_cupo_despues || ' (iguales)');
END;
/
SELECT id_log, origen, codigo_error, detalle, fecha_log
FROM   LOG_ERRORES
WHERE  origen = 'PRUEBA_ROLLBACK'
ORDER  BY fecha_log DESC;


INSERT INTO CLIENTE (id_cliente, documento, nombre, ciudad, cupo_credito, saldo_pendiente, activo)
VALUES (NULL, '999999777', '   carlos perez gomez   ', 'Bogota', 1000000, 0, NULL);
SELECT id_cliente, documento, '[' || nombre || ']' AS nombre, ciudad, activo
FROM   CLIENTE WHERE documento = '999999777';
ROLLBACK;


UPDATE PRODUCTO SET precio_unitario = precio_unitario + 5000 WHERE id_producto = 1001;
UPDATE PRODUCTO SET precio_unitario = precio_unitario        WHERE id_producto = 1002;  
SELECT id_producto, precio_anterior, precio_nuevo, variacion_pct
FROM   AUDITORIA_PRECIO
ORDER  BY id_auditoria DESC;
ROLLBACK;


BEGIN
    BEGIN
        INSERT INTO PRODUCTO (id_producto, codigo, nombre, id_categoria, precio_unitario, costo_unitario, stock_minimo)
        VALUES (9999, 'TST-MARGEN', 'Producto prueba margen', 1, 10500, 10000, 5);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('INSERT (esperado -20020): ' || SQLERRM);
    END;
    BEGIN
        UPDATE PRODUCTO SET precio_unitario = 30000 WHERE id_producto = 1001; 
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('UPDATE (esperado -20020): ' || SQLERRM);
    END;
    ROLLBACK;
END;
/


DECLARE
    v_antes NUMBER;
    v_despues NUMBER;
    v_mov NUMBER;
BEGIN
    v_antes := FN_STOCK_DISPONIBLE(1001, 1);
    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (6, 1, 1001, 1, 2, 45000, 90000);
    v_despues := FN_STOCK_DISPONIBLE(1001, 1);
    SELECT COUNT(*) INTO v_mov FROM MOVIMIENTO_INVENTARIO WHERE id_pedido = 6 AND tipo = 'SALIDA';
    DBMS_OUTPUT.PUT_LINE('Stock antes ' || v_antes || ', despues ' || v_despues || ' (baja 2). Movimientos SALIDA: ' || v_mov);
    BEGIN
        INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
        VALUES (6, 2, 1001, 1, 99999, 45000, 99999 * 45000);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Stock insuficiente (esperado -20030): ' || SQLERRM);
    END;
    ROLLBACK;
END;
/


CREATE OR REPLACE TRIGGER T_PRUEBA_MUTANTE
AFTER INSERT ON DETALLE_PEDIDO
FOR EACH ROW
DECLARE
    vn NUMBER;
BEGIN
    SELECT SUM(subtotal) INTO vn FROM DETALLE_PEDIDO WHERE id_pedido = :NEW.id_pedido;
END;
/
BEGIN
    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (6, 1, 1001, 1, 1, 45000, 45000);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error de tabla mutante: ' || SQLERRM);
    ROLLBACK;
END;
/
DROP TRIGGER T_PRUEBA_MUTANTE;


DECLARE
    v_total6 NUMBER;
    v_total1 NUMBER;
BEGIN
    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (6, 1, 1001, 1, 2, 45000, 90000);
    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (6, 2, 1013, 1, 4, 14500, 58000);
    SELECT total INTO v_total6 FROM PEDIDO WHERE id_pedido = 6;
    DBMS_OUTPUT.PUT_LINE('Pedido 6 (BORRADOR) total = ' || v_total6 || ' (esperado 148000)');

    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (1, 99, 1001, 1, 1, 45000, 45000);
    SELECT total INTO v_total1 FROM PEDIDO WHERE id_pedido = 1;
    DBMS_OUTPUT.PUT_LINE('Pedido 1 (CONFIRMADO) total = ' || v_total1 || ' (esperado 1286500, no cambia)');

    DELETE FROM DETALLE_PEDIDO WHERE id_pedido = 6 AND linea = 2;
    SELECT total INTO v_total6 FROM PEDIDO WHERE id_pedido = 6;
    DBMS_OUTPUT.PUT_LINE('Pedido 6 despues de borrar la linea 2 = ' || v_total6 || ' (esperado 90000)');
    ROLLBACK;
END;
/


UPDATE V_STOCK_CONSOLIDADO SET precio_unitario = 48000, stock_minimo = 25 WHERE id_producto = 1001;
SELECT id_producto, codigo, precio_unitario, stock_minimo, stock_total
FROM   V_STOCK_CONSOLIDADO WHERE id_producto = 1001;
BEGIN
    UPDATE V_STOCK_CONSOLIDADO SET stock_total = 5 WHERE id_producto = 1001;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('stock_total (esperado -20050): ' || SQLERRM);
END;
/
ROLLBACK;


DECLARE
    v_total NUMBER; v_desc NUMBER; v_ped NUMBER;
    v_estado PEDIDO.estado%TYPE; v_saldo NUMBER;
BEGIN
  
    BEGIN PCK_VENTAS.SP_FACTURAR_PEDIDO(7, v_total, v_desc);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Pedido 7 (esperado -20061): ' || SQLERRM); END;

    
    BEGIN PCK_VENTAS.SP_FACTURAR_PEDIDO(6, v_total, v_desc);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Pedido 6 sin lineas (esperado -20062): ' || SQLERRM); END;

  
    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (6, 1, 1001, 1, 2, 45000, 90000);
    PCK_VENTAS.SP_FACTURAR_PEDIDO(6, v_total, v_desc);
    SELECT estado INTO v_estado FROM PEDIDO WHERE id_pedido = 6;
    SELECT saldo_pendiente INTO v_saldo FROM CLIENTE WHERE id_cliente = 501;
    DBMS_OUTPUT.PUT_LINE('Pedido 6: total ' || v_total || ', descuento ' || v_desc ||
                         ', estado ' || v_estado || ', saldo cliente 501 = ' || v_saldo ||
                         ' (esperado 90000, 0, CONFIRMADO, 1340000)');
    ROLLBACK;

 
    SP_CREAR_PEDIDO(503, v_ped);
    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (v_ped, 1, 1006, 1, 4, 480000, 1920000);
    PCK_VENTAS.SP_FACTURAR_PEDIDO(v_ped, v_total, v_desc);
    DBMS_OUTPUT.PUT_LINE('Cliente 503: total ' || v_total || ', descuento ' || v_desc ||
                         ' (esperado 1785600 y 134400)');
    ROLLBACK;

    
    SP_CREAR_PEDIDO(502, v_ped);
    INSERT INTO DETALLE_PEDIDO (id_pedido, linea, id_producto, id_bodega, cantidad, precio_unitario, subtotal)
    VALUES (v_ped, 1, 1004, 1, 1, 320000, 320000);
    BEGIN
        PCK_VENTAS.SP_FACTURAR_PEDIDO(v_ped, v_total, v_desc);
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Cupo (esperado -20063): ' || SQLERRM);
    END;
    SELECT estado INTO v_estado FROM PEDIDO WHERE id_pedido = v_ped;
    DBMS_OUTPUT.PUT_LINE('Estado del pedido tras el fallo = ' || v_estado || ' (esperado BORRADOR)');
    ROLLBACK;
END;
/
SELECT id_log, origen, codigo_error, detalle
FROM   LOG_ERRORES
WHERE  origen = 'PCK_VENTAS.SP_FACTURAR_PEDIDO'
ORDER  BY id_log DESC;
