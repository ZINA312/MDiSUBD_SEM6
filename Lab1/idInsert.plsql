CREATE OR REPLACE FUNCTION generate_insert_command(p_id NUMBER) RETURN VARCHAR2 IS
    v_val NUMBER;
    v_command VARCHAR2(400);
BEGIN
    SELECT val INTO v_val FROM MyTable WHERE id = p_id;

    v_command := 'INSERT INTO MyTable (id, val) VALUES (' || p_id || ', ' || v_val || ');';
    RETURN v_command;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No record found for ID: ' || p_id;
END;
/

DECLARE
 v_res VARCHAR2(200);
BEGIN
    v_res := generate_insert_command(-5);
    DBMS_OUTPUT.PUT_LINE('Результат: ' || v_res);
END;
/