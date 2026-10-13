SET SERVEROUTPUT ON;
DECLARE
    CURSOR cur_munoz IS
        SELECT e.first_name AS empleado_nombre, 
        m.first_name AS manager_nombre,
        e.salary, e.commission_pct,
        e.salary + (e.salary * e.commission_pct) AS final
        FROM EMPLEADO e LEFT JOIN EMPLEADO m ON e.manager_id = m.employee_id
        WHERE e.department_id IN(80,90);
        
        r_munoz cur_munoz%ROWTYPE;

BEGIN
    OPEN cur_munoz;
    LOOP
        FETCH cur_munoz INTO r_munoz;
        EXIT WHEN cur_munoz%NOTFOUND;
        IF r_munoz.commission_pct IS NOT NULL AND r_munoz.commission_pct > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || r_munoz.empleado_nombre || 
                                 ' | Jefe: ' || r_munoz.manager_nombre || 
                                 ' | Salario: ' || r_munoz.salary || 
                                 ' | Salario con comisión: ' || r_munoz.final);         
        ELSE
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || r_munoz.empleado_nombre || 
                                 ' | Jefe: ' || r_munoz.manager_nombre || 
                                 ' | Salario: ' || r_munoz.salary || 
                                 ' | Sin comisión');
        END IF;
        END LOOP;
        CLOSE cur_munoz;
END;    


DECLARE
    CURSOR cur_munoz (paramDepto NUMBER) IS
        SELECT e.first_name AS empleado_nombre, 
        m.first_name AS manager_nombre,
        e.salary, e.commission_pct,
        e.salary + (e.salary * e.commission_pct) AS final
        FROM EMPLEADO e LEFT JOIN EMPLEADO m ON e.manager_id = m.employee_id
        WHERE e.department_id = paramDepto;
        
        r_munoz cur_munoz%ROWTYPE;

BEGIN
    OPEN cur_munoz(80);
    LOOP
        FETCH cur_munoz INTO r_munoz;
        EXIT WHEN cur_munoz%NOTFOUND;
        IF r_munoz.commission_pct IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || r_munoz.empleado_nombre || 
                                 ' | Su jefe: ' || r_munoz.manager_nombre || 
                                 ' | Salario: ' || r_munoz.salary || 
                                 ' | Salario con comisión: ' || r_munoz.final);         
        ELSE
            DBMS_OUTPUT.PUT_LINE('Empleado: ' || r_munoz.empleado_nombre || 
                                 ' | Su jefe: ' || r_munoz.manager_nombre || 
                                 ' | Salario: ' || r_munoz.salary || 
                                 ' | No tiene comisión');
        END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('El numero de filas es: ' || cur_munoz%ROWCOUNT);
        CLOSE cur_munoz;
END;    

DECLARE
  v_dept_id DEPARTAMENTO.department_id%TYPE := 999;
  v_dept_name DEPARTAMENTO.departments.department_name%TYPE;
  e_
BEGIN
  SELECT department_name INTO v_dept_name
  FROM hr.departments
  WHERE department_id = v_dept_id;

  DBMS_OUTPUT.PUT_LINE('El departamento existe' || v_dept_name);
EXCEPTION
  
END;
