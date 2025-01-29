CREATE OR REPLACE PROCEDURE insert_record(p_id NUMBER, p_val NUMBER) IS
BEGIN
    INSERT INTO MyTable (id, val) VALUES (p_id, p_val);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE update_record(p_id NUMBER, p_val NUMBER) IS
BEGIN
    UPDATE MyTable SET val = p_val WHERE id = p_id;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE delete_record(p_id NUMBER) IS
BEGIN
    DELETE FROM MyTable WHERE id = p_id;
    COMMIT;
END;
/