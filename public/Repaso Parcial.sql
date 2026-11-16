-- Repaso Parcial
SET SERVEROUTPUT ON;

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
/
SHOW ERRORS

-- Prueba
SELECT FN_NOMINA_DEPARTAMENTO(50)  FROM DUAL;
SELECT FN_NOMINA_DEPARTAMENTO(999) FROM DUAL;

DECLARE
    CURSOR c_practica(p_depto NUMBER) IS
        SELECT e.salary, e.employee_id, j.max_salary 
        FROM EMPLEADO e JOIN JOBS j 
        ON j.job_id = e.job_id 
        WHERE e.department_id = p_depto AND 
        e.salary < j.max_salary
        FOR UPDATE OF e.salary;
        
        r_emp c_practica%ROWTYPE;
        vn_nuevo NUMBER;
BEGIN
    OPEN c_practica(50);
    LOOP
        FETCH c_practica INTO r_emp;
        EXIT WHEN c_practica%NOTFOUND;
        vn_nuevo := LEAST(ROUND(r_emp.salary * 1.10, 2), r_emp.max_salary);
        UPDATE EMPLEADO
        SET SALARY = vn_nuevo
        WHERE CURRENT OF c_practica;
        DBMS_OUTPUT.PUT_LINE(r_emp.employee_id || ' gana ' || r_emp.salary || ' ' || 'Su nuevo sueldo es : ' || vn_nuevo);
    END LOOP;
    CLOSE c_practica;
    ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE SP_AUMENTAR_SALARIO (
    p_id_empleado IN employees.employee_id%TYPE,
    p_porcentaje IN NUMBER,
    p_nuevo_salario OUT employees.salary%TYPE
) IS 
    vn_existe NUMBER;
    vn_salario_actual employees.salary%TYPE;
    vn_job_id employees.job_id%TYPE;
    vn_max_salary jobs.max_salary%TYPE;
    vn_nuevo_salario employees.salary%TYPE;

BEGIN
    SELECT COUNT()
    INTO vn_existe
    FROM
    EMPLOYEES
    WHERE employee_id = p_id_empleado;

    IF vn_existe = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('El usuario no existe');
        RETURN;
    END IF;

    SELECT SALARY, job_id
    INTO vn_salario_actual, vn_job_id
    FROM EMPLOYEES
    WHERE employee_id = p_id_empleado;

    SELECT MAX_SALARY
    INTO vn_max_salary
    FROM JOBS
    WHERE job_id = vn_job_id;

    vn_nuevo_salario := vn_salario_actual + (vn_salario_actual(p_porcentaje/100));

    IF vn_nuevo_salario > vn_max_salary THEN
        DBMS_OUTPUT.PUT_LINE('El incremento del salarios es demasiado para el cargo');
        RETURN;
    END IF; 

    UPDATE EMPLOYEES
    SET salary = vn_nuevo_salario
    WHERE employee_id = p_id_empleado;


    p_nuevo_salario := vn_nuevo_salario;



END SP_AUMENTAR_SALARIO;
/

CREATE TABLE auditoria_salario (
    employee_id      NUMBER,
    accion           VARCHAR2(10),
    salario_anterior NUMBER,
    salario_nuevo    NUMBER,
    variacion_pct    NUMBER
);

CREATE OR REPLACE TRIGGER TGR_AUSALARIO 
AFTER UPDATE OF salary ON employees
FOR EACH ROW 
WHEN (NEW.salary <> OLD.salary)
BEGIN 

    INSERT INTO auditoria_salario (employee_id, accion, salario_anterior,salario_nuevo,variacion_pct)
    VALUES (:OLD.employee_id, 'se actualizo el salario de ' || :OLD.first_name, :OLD.salary, :NEW.salary, (:NEW.salary - :OLD.salary)/ :OLD.salary);

END TGR_AUSALARIO;
/
ALTER TABLE auditoria_salario MODIFY (accion VARCHAR2(100));

SET SERVEROUTPUT ON

UPDATE employees
SET salary = salary * 1.10
WHERE employee_id = 9999;

SELECT * FROM auditoria_salario;


ROLLBACK;

CREATE OR REPLACE PACKAGE pkg_rrhh_corto IS
    FUNCTION  fn_nomina(p_department_id NUMBER) RETURN NUMBER;
    PROCEDURE sp_aumentar(p_employee_id NUMBER, p_pct NUMBER);
END pkg_rrhh_corto;
/
SHOW ERRORS PACKAGE pkg_rrhh_corto

CREATE OR REPLACE PACKAGE BODY pkg_rrhh_corto IS

    FUNCTION fn_nomina(p_department_id NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(salary * (1 + NVL(commission_pct, 0))), 0)
          INTO v_total
          FROM employees
         WHERE department_id = p_department_id;
        RETURN v_total;
    END fn_nomina;

    PROCEDURE sp_aumentar(p_employee_id NUMBER, p_pct NUMBER) IS
    BEGIN
        UPDATE employees e
           SET salary = LEAST(ROUND(salary * (1 + p_pct), 2),
                              (SELECT max_salary FROM jobs j WHERE j.job_id = e.job_id))
         WHERE employee_id = p_employee_id
           AND salary < (SELECT max_salary FROM jobs j WHERE j.job_id = e.job_id);
    END sp_aumentar;

END pkg_rrhh_corto;
/
SHOW ERRORS PACKAGE BODY pkg_rrhh_corto

