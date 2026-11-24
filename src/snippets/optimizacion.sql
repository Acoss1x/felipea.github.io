EXPLAIN PLAN FOR SELECT * FROM pedido WHERE id_ruta = 12;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(NULL,NULL,'BASIC +COST +ROWS +PREDICATE'));

-- Resultado esperado (capturado en el laboratorio real):
-- Rows: 3.243   Cost: 205   Operacion: TABLE ACCESS FULL
-- Este resultado se compara contra 03b_demo1_despues.sql
