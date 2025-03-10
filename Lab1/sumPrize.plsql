CREATE OR REPLACE FUNCTION calculate_total_reward(p_salary NUMBER, p_bonus_percentage NUMBER) RETURN NUMBER IS
    v_total_reward NUMBER;
BEGIN
    IF p_salary < 0 OR p_bonus_percentage < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary and bonus percentage must be non-negative.');
    END IF;

    v_total_reward := (1 + (p_bonus_percentage / 100)) * 12 * p_salary;
    RETURN v_total_reward;
END;
/

DECLARE
 v_res VARCHAR2(200);
BEGIN
    v_res := calculate_total_reward(100, 20);
    DBMS_OUTPUT.PUT_LINE('Результат: ' || v_res);
END;
/