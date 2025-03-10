CREATE OR REPLACE FUNCTION check_even_odd_count RETURN VARCHAR2 IS
    even_count NUMBER;
    odd_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO even_count FROM MyTable WHERE MOD(val, 2) = 0;
    SELECT COUNT(*) INTO odd_count FROM MyTable WHERE MOD(val, 2) <> 0;

    IF even_count > odd_count THEN
        RETURN 'TRUE';
    ELSIF odd_count > even_count THEN
        RETURN 'FALSE';
    ELSE
        RETURN 'EQUAL';
    END IF;
END;
/


DECLARE
 v_res VARCHAR2(20);
BEGIN
    v_res := check_even_odd_count();
    DBMS_OUTPUT.PUT_LINE('Результат: ' || v_res);
END;
/