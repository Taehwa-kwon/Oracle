-------6/19�� 
--1.����ó�� - ����ó���� ������ ���ؼ� ����ó��
--    ���ܿ��� 2���� ���� 1.������ ����(��Ÿ,����)
--                      2.��Ÿ�� ���� (2-1 ������ ��Ű�ٰ� �߰��� �߻��ϴ� ����- ������ ���� �ʾҴµ� ������� ������ �����)
--                                   (2-2 ������ ������ ���ٰ� �˸��� �ؾ��Ѵ�. )
--��Ÿ�� �������� ������ �����ʰ� TRY ~ CATCH�Ѵ�. 
                      
                      
------------------------------------------------------------------------------------
------------���̵� �Է¹޾Ƽ� �̸��� ã�� ���ν���
CREATE OR REPLACE PROCEDURE EXCEPT_TST
(
    IN_SID  IN VARCHAR2,
    O_CUR OUT SYS_REFCURSOR
)
AS
    V_SNAME VARCHAR2(20);
BEGIN
    SELECT SNAME INTO V_SNAME
    FROM STUDENTS2
    WHERE SID = IN_SID; --ROW���� ã�´�. 

END 
EXCEPT_TST;
/

-----���� ���´�� �ϰ� ���ν������� SNAME �� �ٸ��� �����ϸ� no data found�� ���. 
------------------------------------------------------------------------------------
---------------------------------����ó��---------------------------------
CREATE OR REPLACE PROCEDURE EXCEPT_TST
(
    IN_SID  IN VARCHAR2,
    O_ERR_CD OUT VARCHAR2,
    O_ERR_MSG OUT VARCHAR2,
    O_CUR OUT SYS_REFCURSOR
)
AS
    V_SNAME VARCHAR2(20);
BEGIN
    SELECT SNAME INTO V_SNAME
    FROM STUDENTS2
    WHERE SID = IN_SID; --ROW���� ã�´�. 
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            O_ERR_CD := SQLCODE;--SQL�� ������ ������ �ִ� ����
            O_ERR_MSG := SQLERRM;
            WHEN OTHERS THEN --NA_DATA_FOUND�� ������ ��� �����ڵ� 
            
            DBMS_OUTPUT.PUT_LINE('�����Ͱ� �����ϴ�');

END 
EXCEPT_TST;
/

--------------------------------------------------------------
---------------------------------���� ���ܷ� �Ѱܼ� ó��---------------------------------
CREATE OR REPLACE PROCEDURE PROC_EXCEPT_TST
(
    IN_SID IN VARCHAR2,
    O_ERR_CD OUT VARCHAR2,
    O_ERR_MSG OUT VARCHAR2,
    O_CUR OUT SYS_REFCURSOR  
)
AS 
    V_SNAME VARCHAR2(20);
   
    --����� ���� ���� --SELECT���� �ڷᰡ ������ �츮�� ����ó���Ϸ� ������. 
    NO_DATA_ROWS EXCEPTION;
    V_ROW_CNT NUMBER:= 0; --NUMBER�� ������ ���൵ �ȴ�. 
    
BEGIN 
    SELECT COUNT(*) INTO V_ROW_CNT -- ������ 0�̸� 
    FROM STUDENTS2
    WHERE SID = IN_SID 
    ;
    
    IF V_ROW_CNT = 0 THEN 
        RAISE NO_DATA_ROWS; --���⼭ ������ �߻� ��Ų��.
    ELSE 
    
    OPEN O_CUR FOR
    SELECT * FROM STUDENTS2
    WHERE SID = IN_SID
    ;
    END IF;
    
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
            O_ERR_CD := SQLCODE;
            O_ERR_MSG := SQLERRM;
          
           WHEN NO_DATA_ROWS THEN
            O_ERR_CD := 'E0001';
            O_ERR_MSG := '�˻��� �ڷᰡ �����ϴ�.';
            
            WHEN OTHERS THEN --NA_DATA_FOUND�� ������ ��� �����ڵ� 
             O_ERR_CD := SQLCODE;--SQL�� ������ ������ �ִ� ����
            O_ERR_MSG := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('�����Ͱ� �����ϴ�');
END
PROC_EXCEPT_TST
;
/


------------------------------������Ÿ��---------------------------------
CREATE OR REPLACE PROCEDURE TYPE_EX01
(
    IN_SID IN STUDENTS2.SID%TYPE, --DATABASE������ �����ϴ� ��� STUDENTS2.SID%TYPE
    O_CUR OUT SYS_REFCURSOR  
)
AS

BEGIN
    NULL;
END
TYPE_EX01
;
/



------------------------------DB�� �迭 ---------------------------------
CREATE OR REPLACE PROCEDURE TYPE_EX01
(
    IN_SID IN STUDENTS2.SID%TYPE, --DATABASE������ ������ 
    O_CUR OUT SYS_REFCURSOR  -- �̷��� �������� ���ø����̼ǿ��� ������ �ִ�. --������ Ŀ��(MS SQL�� �� ������ ����) || �Ͻ��� Ŀ�� 
)
AS
--�� �̰��� �� �÷����� ����� ���̺��� �����ϴ°��̴�. http://www.gurubee.net/lecture/1047
    TYPE ARR_TYPE IS TABLE OF VARCHAR2(20)  --ARR_TYPE���̺�Ÿ������ ARR_SNAME������ �����ؼ� ���
    INDEX BY BINARY_INTEGER;  
    
    ARR_SNAME ARR_TYPE;
    
    I NUMBER:= 1;
    ROW_CNT NUMBER;
--���̺�Ÿ������ ������ �����ؼ� ���

BEGIN
    --�л����̺��� �� ROW���� 
    SELECT COUNT(*) INTO ROW_CNT FROM STUDENTS2;
    
    
    FOR V_CUR IN --FROM STUDENTS2 �� 13�� ���Ƽ� SID,SNAME�� 
    (
         SELECT SID,SNAME  FROM  STUDENTS2
    )
    LOOP 
        DBMS_OUTPUT.PUT_LINE(V_CUR.SNAME);
        ARR_SNAME(I) := V_CUR.SNAME; --�����ִ� V_CUR�� SNAME�� ARR_SNAME�� �ִ´�. 
        I := I+1;
        
    END LOOP
    ;
    
    FOR A IN 1.. ROW_CNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(ARR_SNAME(A));
    
    END LOOP;
END
TYPE_EX01
;
/


------------------------------------------------------------------------------------------------------
--���࿡ �÷��� ���� ������ IS�ؿ��ٰ� SELECT INTO �Ϸ��� �ҋ� SELECT �� �ϳ��ϳ� ����,Ÿ���� �� ����� �Ѵ�. �װ��� �����ϱ� ���ؼ� 
CREATE OR REPLACE PROCEDURE TYPE_EX02
    (
        IN_SID IN VARCHAR2
    )
IS
/*
    V_SID VARCHAR2(10);
    V_SNAME VARCHAR2(20);
    V_DID VARCHAR2(10);
 */
 
    V_ST  STUDENTS2%ROWTYPE; --STUDENTS2 Ÿ���� ROW�ϱ� ������ Ÿ���� �����´�  ---STUDENTS2���̺����� ������ Ÿ���� �������°Ű� ������ �� �÷�(����)�� ���� �������°��� 
BEGIN
    SELECT SID, SNAME,DID
    INTO V_ST.SID,V_ST.SNAME,V_ST.DID
    --INTO V_SID,V_SNAME,V_DID �̰� ����ؼ� ���������� ��밡�� 
    FROM STUDENTS2
    WHERE TRIM(SID)= IN_SID
    ;
    DBMS_OUTPUT.PUT_LINE(V_ST.SID);
    DBMS_OUTPUT.PUT_LINE(V_ST.SNAME);
    DBMS_OUTPUT.PUT_LINE(V_ST.DID);
END 
TYPE_EX02
;
/

------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE TYPE_EX02
(
    IN_SID IN VARCHAR2
)
AS
  ST_ROW STUDENTS2%ROWTYPE;
    

BEGIN
    SELECT SID, SNAME, DID 
    INTO ST_ROW.SID,ST_ROW.SNAME,ST_ROW.DID
    FROM STUDENTS2
    WHERE SID = IN_SID
    ;

END 
TYPE_EX02
;





---------------------------�̺�Ʈ-----------------------------------------
--�԰����̺��� WAREHOSING  INSERT��� �̺�Ʈ�� �߻��ϸ� -> PRODUCT �� QTY���� �������� �հ谡 ������ �Ѵ� .-> Ʈ����

Ʈ���ſ��� 2���� ������ �ִ�. Ư�����̺��� �̺�Ʈ(INSERT, DELETE,UPDATE)�� �߻��ϸ� �ڵ����� ����
1.AFTER TRIGGER    �̺�Ʈ�� �߻��ϸ� ���� INSERT,UPDATE, DELETE�� ����� �Ŀ� �ش� ���ν����� ����ȴ�.
2.BEFORE TRIGGER   �̺�Ʈ�� �߻��ϸ� ���� INSERT,UPDATE, DELETE�� ����Ǳ� ���� �ش� ���ν����� ����ǰ� INSERT,UPDATE, DELETE�� ���� 

CREATE OR REPLACE PROCEDURE PROC_WARE
(
    IN_PID IN VARCHAR2,
    IN_PRICE IN NUMBER, --�԰�����
    IN_PPRICE IN NUMBER, --�ǸŰ���
    IN_QTY IN NUMBER
    
)
AS

BEGIN

    INSERT INTO WAREHOUSING VALUES('W002', IN_PID, IN_PRICE, IN_QTY, SYSDATE);
    -- �԰� -> ������� 610���� 30���� �԰�
    
    --��ǰ���̺��� �ǸŰ��ݰ� ����� ������Ʈ
    UPDATE PRODUCTS
    SET PR_QTY = PR_QTY + IN_QTY
    WHERE PR_ID = IN_PID;
    
  
END 
PROC_WARE
;


--------------------------�԰���� ------------------------------------
CREATE OR REPLACE TRIGGER TRG_CANCEL
AFTER DELETE ON WAREHOUSING
REFERENCING NEW AS NEW OLD AS OLD 
FOR EACH ROW        --�̰� �־�� ���ٿ� ���ؼ� ������ �Ѵ�. 
BEGIN

    UPDATE PRODUCTS
    SET PR_QTY = PR_QTY - :OLD.QTY
    WHERE PR_ID = :OLD.PID
    ;
    
END TRG_CANCEL;
/

-------------------------������Ʈ----------------------------
CREATE OR REPLACE TRIGGER PRG_CHG_PRICE
AFTER UPDATE ON PRODUCTS
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
    --������ ������ �� OLD ������  NEW    
    INSERT INTO CHG_PRICE(PID,SEQ,PRICE)
    VALUES(:OLD.PID, 2,:NEW.PPRICE );
    
    
END TRG_CHG_PRICE
;

    