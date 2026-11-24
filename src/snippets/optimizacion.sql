INSERT INTO pedido (id_pedido, id_ruta, id_cliente, valor, estado, fecha_compra)
SELECT
    2120000 + rn,
    MOD(rn, 37) + 1,
    MOD(rn, 40) + 1,
    ROUND(DBMS_RANDOM.VALUE(15000, 180000), -2),
    CASE MOD(rn, 20)
        WHEN 0 THEN 'CANCELADO' WHEN 1 THEN 'CANCELADO'
        WHEN 2 THEN 'CONFIRMADO' ELSE 'ENTREGADO'
    END,
    DATE '2026-01-01' + MOD(rn, 110) + DBMS_RANDOM.VALUE(0, 1)
FROM (SELECT LEVEL AS rn FROM DUAL CONNECT BY LEVEL <= 300000);
COMMIT;
