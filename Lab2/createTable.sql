CREATE TABLE GROUPS (
    ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(100),
    C_VAL NUMBER DEFAULT 0
);

CREATE TABLE STUDENTS (
    ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(100),
    GROUP_ID NUMBER
);

