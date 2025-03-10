-- 1. Тест для SELECT с джойнами и вложенным подзапросом
DECLARE
    v_xml VARCHAR2(3000) := '
    <Operation>
        <Type>SELECT</Type>
        <Tables>
            <Table>XMLTEST1</Table>
            <Table>XMLTEST2</Table>
        </Tables>
        <Joins>
            <Join>
                <Type>LEFT JOIN</Type>
                <Condition>XMLTEST1.ID = XMLTEST2.ID</Condition>
            </Join>
        </Joins>
        <Columns>
            <Column>XMLTEST1.ID</Column>
            <Column>XMLTEST2.ID</Column>
        </Columns>
        <Where>
            <Conditions>
                <Condition>
                    <Body>XMLTEST1.ID = 1</Body>
                    <Operator>AND</Operator>
                </Condition>
                <Condition>
                    <Body>EXISTS</Body>
                    <Operation>
                        <Type>SELECT</Type>
                        <Tables>
                            <Table>XMLTEST1</Table>
                        </Tables>
                        <Columns>
                            <Column>ID</Column>
                        </Columns>
                        <Where>
                            <Conditions>
                                <Condition>
                                    <Body>ID = 1</Body>
                                </Condition>
                            </Conditions>
                        </Where>
                    </Operation>
                </Condition>
            </Conditions>
        </Where>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_OPERATOR(v_xml));
END;
/

-- 2. Тест для CREATE TABLE с ограничениями
DECLARE
    v_xml VARCHAR2(3000) := '
    <Operation>
        <Type>CREATE</Type>
        <Table>SOME_TABLE</Table>
        <Columns>
            <Column>
                <Name>COL1</Name>
                <Type>NUMBER</Type>
                <Constraints>
                    <Constraint>NOT NULL</Constraint>
                </Constraints>
            </Column>
            <Column>
                <Name>COL2</Name>
                <Type>VARCHAR2(100)</Type>
                <Constraints>
                    <Constraint>NOT NULL</Constraint>
                </Constraints>
            </Column>
        </Columns>
        <TableConstraints>
            <Primary>
                <Columns>
                    <Column>COL2</Column>
                </Columns>
            </Primary>
            <ForeignKey>
                <ChildColumns>
                    <Column>COL1</Column>
                </ChildColumns>
                <Parent>SOME_TABLE2</Parent>
                <ParentColumns>
                    <Column>ID</Column>
                </ParentColumns>
            </ForeignKey>
        </TableConstraints>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_CREATE(v_xml));
END;
/

-- 3. Тест для DELETE с подзапросом
DECLARE
    v_xml VARCHAR2(3000) := '
    <Operation>
        <Type>DELETE</Type>
        <Table>XMLTEST1</Table>
        <Where>
            <Conditions>
                <Condition>
                    <Body>XMLTEST1.ID = 1</Body>
                    <Operator>AND</Operator>
                </Condition>
                <Condition>
                    <Body>EXISTS</Body>
                    <Operation>
                        <Type>SELECT</Type>
                        <Tables>
                            <Table>XMLTEST1</Table>
                        </Tables>
                        <Columns>
                            <Column>ID</Column>
                        </Columns>
                        <Where>
                            <Conditions>
                                <Condition>
                                    <Body>ID = 1</Body>
                                </Condition>
                            </Conditions>
                        </Where>
                    </Operation>
                </Condition>
            </Conditions>
        </Where>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_DELETE(v_xml));
END;
/

-- 4. Тест для DROP TABLE
DECLARE
    v_xml VARCHAR2(3000) := '
    <Operation>
        <Type>DROP</Type>
        <Table>XMLTEST1</Table>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_DROP(v_xml));
END;
/

-- 5. Тест для INSERT из подзапроса
DECLARE
    v_xml VARCHAR2(3000) := '
    <Operation>
        <Type>INSERT</Type>
        <Table>Table1</Table>
        <Columns>
            <Column>XMLTEST2.ID</Column>
        </Columns>
        <Operation>
            <Type>SELECT</Type>
            <Tables>
                <Table>XMLTEST1</Table>
            </Tables>
            <Columns>
                <Column>ID</Column>
            </Columns>
            <Where>
                <Conditions>
                    <Condition>
                        <Body>ID = 1</Body>
                    </Condition>
                </Conditions>
            </Where>
        </Operation>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_INSERT(v_xml));
END;
/

-- 6. Тест для UPDATE с подзапросом
DECLARE
    v_xml VARCHAR2(3000) := '
    <Operation>
        <Type>UPDATE</Type>
        <Table>XMLTEST1</Table>
        <SetOperations>
            <Set>col1 = 1</Set>
        </SetOperations>
        <Where>
            <Conditions>
                <Condition>
                    <Body>XMLTEST1.ID = 1</Body>
                    <Operator>AND</Operator>
                </Condition>
                <Condition>
                    <Body>EXISTS</Body>
                    <Operation>
                        <Type>SELECT</Type>
                        <Tables>
                            <Table>XMLTEST1</Table>
                        </Tables>
                        <Columns>
                            <Column>ID</Column>
                        </Columns>
                        <Where>
                            <Conditions>
                                <Condition>
                                    <Body>ID = 1</Body>
                                </Condition>
                            </Conditions>
                        </Where>
                    </Operation>
                </Condition>
            </Conditions>
        </Where>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_UPDATE(v_xml));
END;
/

-- 7. Тест для SELECT с IN и сложными условиями
DECLARE
    v_xml VARCHAR2(3000) := '
    <Operation>
        <Type>SELECT</Type>
        <Tables>
            <Table>T1</Table>
        </Tables>
        <Columns>
            <Column>*</Column>
        </Columns>
        <Where>
            <Conditions>
                <Condition>
                    <Body>T1.ID IN</Body>
                    <Operation>
                        <Type>SELECT</Type>
                        <Tables>
                            <Table>T2</Table>
                        </Tables>
                        <Columns>
                            <Column>ID</Column>
                        </Columns>
                        <Where>
                            <Conditions>
                                <Condition>
                                    <Body>VAL LIKE ''%a%''</Body>
                                    <Operator>AND</Operator>
                                </Condition>
                                <Condition>
                                    <Body>T2.NUMB BETWEEN 2 AND 4</Body>
                                </Condition>
                            </Conditions>
                        </Where>
                    </Operation>
                </Condition>
            </Conditions>
        </Where>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_OPERATOR(v_xml));
END;
/


DECLARE
    v_xml_create VARCHAR2(3000) := '
    <Operation>
        <Type>CREATE</Type>
        <Table>t_name1</Table>
        <Columns>
            <Column>
                <Name>ID</Name>
                <Type>NUMBER</Type>
                <Constraints>
                    <Constraint>PRIMARY KEY</Constraint>
                </Constraints>
            </Column>
            <Column>
                <Name>name</Name>
                <Type>VARCHAR2(100)</Type>
            </Column>
        </Columns>
        <TableConstraints>
            <PrimaryKey>
                <Columns>
                    <Column>ID</Column>
                </Columns>
            </PrimaryKey>
        </TableConstraints>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_CREATE(v_xml_create));
END;
/

DECLARE
    v_xml_create VARCHAR2(3000) := '
    <Operation>
        <Type>CREATE</Type>
        <Table>t_name2</Table>
        <Columns>
            <Column>
                <Name>ID</Name>
                <Type>NUMBER</Type>
            </Column>
            <Column>
                <Name>name</Name>
                <Type>VARCHAR2(100)</Type>
            </Column>
        </Columns>
        <TableConstraints>
            <ForeignKey>
                <Parent>t_name1</Parent>
                <ChildColumns>
                    <Column>ID</Column> 
                </ChildColumns>
                <ParentColumns>
                    <Column>ID</Column> 
                </ParentColumns>
            </ForeignKey>
        </TableConstraints>
    </Operation>';
BEGIN
    DBMS_OUTPUT.PUT_LINE(XML_PARSING.HANDLER_CREATE(v_xml_create));
END;
/