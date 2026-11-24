CREATE OR REPLACE TRIGGER tgr_a_iud_labt_linea_total
FOR INSERT OR UPDATE OR DELETE ON labt_linea
COMPOUND TRIGGER

  TYPE t_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  v_ids t_ids;  

  AFTER EACH ROW IS
  BEGIN
   
    IF :NEW.id_pedido IS NOT NULL THEN v_ids(:NEW.id_pedido) := 1; END IF;
    IF :OLD.id_pedido IS NOT NULL THEN v_ids(:OLD.id_pedido) := 1; END IF;
  END AFTER EACH ROW;

  AFTER STATEMENT IS
    v_id PLS_INTEGER;
  BEGIN
    v_id := v_ids.FIRST;
    WHILE v_id IS NOT NULL LOOP
      UPDATE labt_pedido
         SET total = (SELECT NVL(SUM(cantidad * precio), 0)
                        FROM labt_linea
                       WHERE id_pedido = v_id)
       WHERE id_pedido = v_id;

      INSERT INTO labt_recalculo (id_pedido) VALUES (v_id);
      

      v_id := v_ids.NEXT(v_id);
    END LOOP;
  END AFTER STATEMENT;

END tgr_a_iud_labt_linea_total;
