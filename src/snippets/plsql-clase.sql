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
