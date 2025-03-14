CREATE OR REPLACE PACKAGE func_package IS
    PROCEDURE roll_back(date_time TIMESTAMP);
    PROCEDURE roll_back(date_time NUMBER);
    PROCEDURE report(t_begin IN TIMESTAMP, t_end IN TIMESTAMP);
    PROCEDURE report;
END func_package;
/
CREATE OR REPLACE PACKAGE BODY func_package IS
    PROCEDURE roll_back(date_time TIMESTAMP) IS
    BEGIN
        -- Обновленный вызов для работы с заказами и клиентами
        rollback_by_date(date_time);
    END roll_back;

    PROCEDURE roll_back(date_time NUMBER) IS
    BEGIN
        DECLARE
            current_time TIMESTAMP := SYSTIMESTAMP;
        BEGIN
            current_time := current_time - NUMTODSINTERVAL(date_time/1000, 'SECOND');
            -- Откат для истории заказов и клиентов
            rollback_by_date(current_time);
        END;
    END roll_back;

    PROCEDURE report(t_begin IN TIMESTAMP, t_end IN TIMESTAMP) IS
        v_cur TIMESTAMP;
    BEGIN
        SELECT CAST(SYSDATE AS TIMESTAMP) INTO v_cur FROM DUAL;

        IF t_end > v_cur THEN
            -- Генерация отчета по продажам и клиентам
            create_report(t_begin, v_cur);
            INSERT INTO reports_history(report_date) VALUES (v_cur);
        ELSE
            -- Отчет за указанный период по заказам
            create_report(t_begin, t_end);
            INSERT INTO reports_history(report_date) VALUES (t_end);
        END IF;
    END report;

    PROCEDURE report IS
        v_begin TIMESTAMP;
        v_cur   TIMESTAMP;
    BEGIN
        SELECT CAST(SYSDATE AS TIMESTAMP) INTO v_cur FROM DUAL;

        -- Получение последнего отчета из истории продаж
        SELECT REPORT_DATE
        INTO v_begin
        FROM REPORTS_HISTORY
        WHERE id = (SELECT MAX(id) FROM REPORTS_HISTORY);

        -- Генерация отчета по последним транзакциям
        create_report(v_begin, v_cur);

        INSERT INTO reports_history(report_date) VALUES (v_cur);
    END report;

END func_package;