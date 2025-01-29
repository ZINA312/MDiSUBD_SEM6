CREATE OR REPLACE PACKAGE pkg_groups_validation IS
    TYPE t_name_table IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    g_names t_name_table;
END pkg_groups_validation;
/

CREATE OR REPLACE TRIGGER trg_groups_before
BEFORE INSERT OR UPDATE ON GROUPS
FOR EACH ROW
BEGIN
    -- Сохраняем новое значение имени в коллекции
    pkg_groups_validation.g_names(pkg_groups_validation.g_names.COUNT + 1) := :NEW.NAME;
END;
/

CREATE OR REPLACE TRIGGER trg_groups_after
AFTER INSERT OR UPDATE ON GROUPS
DECLARE
    v_count NUMBER;
BEGIN
    -- Проверяем уникальность имен из коллекции
    FOR i IN 1 .. pkg_groups_validation.g_names.COUNT LOOP
        SELECT COUNT(*)
        INTO v_count
        FROM GROUPS
        WHERE NAME = pkg_groups_validation.g_names(i);

        IF v_count > 1 THEN
            -- Если найдено больше одной записи с таким именем, выбрасываем ошибку
            RAISE_APPLICATION_ERROR(-20001, 'Имя должно быть уникальным: ' || pkg_groups_validation.g_names(i));
        END IF;
    END LOOP;

    -- Очищаем коллекцию
    pkg_groups_validation.g_names.DELETE;
END;
/