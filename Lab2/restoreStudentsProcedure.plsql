CREATE OR REPLACE PROCEDURE restore_students(
    p_time TIMESTAMP DEFAULT NULL,
    p_offset INTERVAL DAY TO SECOND DEFAULT NULL
) IS
    v_restore_time TIMESTAMP;
BEGIN
    IF p_time IS NOT NULL THEN
        v_restore_time := p_time;
    ELSIF p_offset IS NOT NULL THEN
        v_restore_time := SYSTIMESTAMP - p_offset;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Необходимо указать либо p_time, либо p_offset.');
    END IF;

    FOR log IN (
        SELECT * FROM STUDENTS_LOG
        WHERE ACTION_TIME >= v_restore_time
        ORDER BY ACTION_TIME DESC, LOG_ID DESC
    ) LOOP
        IF log.ACTION_TYPE = 'INSERT' THEN
            DELETE FROM STUDENTS WHERE ID = log.NEW_ID;
        ELSIF log.ACTION_TYPE = 'DELETE' THEN
            INSERT INTO STUDENTS(ID, NAME, GROUP_ID)
            VALUES(log.OLD_ID, log.OLD_NAME, log.OLD_GROUP_ID);
        ELSIF log.ACTION_TYPE = 'UPDATE' THEN
            UPDATE STUDENTS SET
                NAME = log.OLD_NAME,
                GROUP_ID = log.OLD_GROUP_ID
            WHERE ID = log.OLD_ID;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Данные восстановлены на момент: ' || v_restore_time);
END;
/