CREATE OR REPLACE PROCEDURE insert_record(p_id NUMBER, p_val NUMBER) IS
    row_count NUMBER;
BEGIN
    SELECT COUNT(*)
        INTO row_count
        FROM MyTable
        WHERE id = p_id;
    IF row_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ID должно быть уникальным: ' || p_id);
    END IF;
    INSERT INTO MyTable (id, val) VALUES (p_id, p_val);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE update_record(p_id NUMBER, p_val NUMBER) IS
row_count NUMBER;
BEGIN
    SELECT COUNT(*)
        INTO row_count
        FROM MyTable
        WHERE id = p_id;
    IF row_count  < 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Запись не найдена: ' || p_id);
    END IF;
    UPDATE MyTable SET val = p_val WHERE id = p_id;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE delete_record(p_id NUMBER) IS
    row_count NUMBER;
BEGIN
    SELECT COUNT(*)
        INTO row_count
        FROM MyTable
        WHERE id = p_id;

    IF row_count < 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Запись не найдена: ' || p_id);
    ELSE
        DELETE FROM MyTable WHERE id = p_id;
        COMMIT;
    END IF;
END;
/

BEGIN
   
    DELETE_RECORD(11);
END;
/

SELECT * FROM MYTABLE;