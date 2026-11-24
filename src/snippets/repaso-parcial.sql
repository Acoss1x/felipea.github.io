CREATE OR REPLACE FUNCTION FN_NOMINA_DEPARTAMENTO(
p_department_id IN EMPLEADO.department_id%TYPE)
RETURN NUMBER
IS
vn_suma NUMBER;
BEGIN
SELECT NVL(SUM(salary * (1 + NVL(commission_pct, 0)) ), 0)
INTO vn_suma
FROM EMPLEADO
WHERE department_id = p_department_id;
RETURN vn_suma;
END FN_NOMINA_DEPARTAMENTO;
