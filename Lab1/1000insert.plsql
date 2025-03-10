BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO MyTable (id, val) VALUES (i, TRUNC(DBMS_RANDOM.VALUE(1, 1000)));
    END LOOP;
    COMMIT;
END;
/

DROP TABLE MyTable;

SELECT * FROM MyTable;