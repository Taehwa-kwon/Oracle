--1����

SELECT * FROM RESULT
WHERE RDATE BETWEEN TO_DATE('2020-06-13') AND TO_DATE('2020-06-15');

SELECT * FROM RESULT
WHERE RDATE <= TO_DATE('2020-06-15')
AND RDATE >= TO_DATE('2020-06-13');
--�̷��� �ϸ� S004�� ���ڿ������� ��µȴ�.
SELECT * FROM STUDENTS2
WHERE SID>= 'S004';
--��� �ϸ� �� �˻��ϸ� ���� ���� ���ڰ� �� �������� 
SELECT * FROM STUDENTS2 WHERE SNAME LIKE '%��%';
SELECT * FROM STUDENTS2 WHERE SNAME >='��' AND  SNAME <='��';


SELECT * FROM STUDENTS2
WHERE SID IN('S001','S003','S006');
--���� IN�����ھȿ��� �ζ��������� ��ħ

--1:N ���迡���� ������ �Ǹ��ϰ� �۵���

----------------------------------------------------------------------------
--�ߺ����Ŵ� DISTINCT ���� GROUP BY �� ���� ���, ������ DISTINCT�� NULL���� 
SELECT SID FROM RESULT
GROUP BY SID;



--N:M���迡�� ���� ���. 
--����ģ �л��� ã�´�. �̷��� �ؼ� �ߺ��� �����Ѵ�.
SELECT * FROM STUDENTS2
WHERE SID IN
(
    SELECT SID FROM RESULT GROUP BY SID
)
;

--����ġ�� �ʴ� �л��� ã�´�.
SELECT * FROM STUDENTS2
WHERE SID NOT IN
(
    SELECT SID FROM RESULT GROUP BY SID
)
;
----------------------------------------------------------------------------

--ROWNUM
--�ǹ������� UPDATE�� INSERT�� ����ϰ� �ϰ� SELECT JOIN�� �Դٰ����ϸ鼭 �������� Ŀ���� ��� �ٲ��. �׷��ٰ� INSERT�ϸ� 
--������ ������â�� �ȴ�. �׷��� ���� ����ϴ� ������ �ƴϴ�. 
SELECT SID, SNAME, ROWNUM FROM STUDENTS2;
----------------------------------------------------------------------------

----������ ���� ��� 1.�׳� ���������� �ٷ� ���콺�����ʴ����� �����Ѵ�. 


SELECT SEQ1.NEXTVAL FROM DUAL; --�̷��� �����ϴµ� ���� ���� �پ������
ALTER SEQUENCE SEQ1. INCREMENT BY 1; --1�� ����
INSERT INTO ���̺��� VALUES(SEQ1.NEXTVAL,'�÷� ��')

----------------------------
���ν���
��ü�� �����ϴ� ���ɾ�� CREATE �� .
;
------------------------------------------------------------INSERT ���ν��� ����
CREATE OR REPLACE PROCEDURE PROC_TEST
(
    --PARAMENTS ����
    --�Ű����������� NUMBER�� �����ʴ´�. ��¥�� DB�� ���� ���ڵ� �ƴϵ� ������ ���ϴϱ� �˰� �ֱ⸦
    IN_SID IN CHAR,
    IN_SNAME IN VARCHAR,
    IN_DID IN CHAR,
    IN_DAGE IN NUMBER,
    IN_DGEN IN CHAR
 )   
AS
--  ���̺�Ÿ������ ������ �����ؼ� ��� 
--  empno_tab  empno_table ;
BEGIN
    INSERT INTO STUDENTS2
    (
        SID,SNAME,DID,SAGE,SGEN --�̷��� ����־� ��. �ƴϸ� STUDENTS2 ���̺��� �÷��� �߰������� VALUES�� ������ ������ ��
        --������ ��ٴ°��� ������ ������ �����. ������ �����ϴ�.
        --�׷��� ���⿡�� �÷����� �����༭ ����� ���� ������ �ְ� ���ش�.
    )
    VALUES (IN_SID, IN_SNAME,IN_DID,IN_DAGE,IN_DGEN)
    ;

END
PROC_TEST
;


------------------------------------------------------------------INSERT ���ν��� ����
DECLARE
    --���� ���� �κ�
BEGIN 
    PROC_TEST('S014','�����','D004',25,'F');
END;

SELECT * FROM STUDENTS2;

------------------------------------------------------------------ SELECT ���ν��� ����
CREATE OR REPLACE PROCEDURE PROC_SELECT_STUDENTS2
(
    IN_SNAME IN VARCHAR2,
    O_CUR OUT SYS_REFCURSOR --Ŀ�� OUT���ְ� 
)
AS
    V_SID  CHAR(4);

BEGIN
    --OPEN O_CUR FOR
    --SELECT * FROM STUDENTS2
    --WHERE SID = IN_SID;
    SELECT SID INTO V_SID
    FROM STUDENTS2
    WHERE SNAME = IN_SNAME
    ;
    
    OPEN O_CUR FOR
    SELECT V_SID AS V_SID FROM DUAL;
    
END PROC_SELECT_STUDENTS2;

------------------------------------------------------------------ SELECT ���ν��� ����

DECLARE
BEGIN 
    PROC_SELECT_STUDENTS2('�ڰ���');
END
;

----------------Ŀ���� �����ΰ�? ��Ȱ�ڵ� ���� �� ����

----12:00���� ~
��Ű����... ���ν����� �����ϱ� ���Ѱ� 




SET SERVEROUTPUT ON;
DECLARE
    V_SID VARCHAR2(20);
    V_MAX_SID VARCHAR2(20);
    V_MAX_STR VARCHAR2(3);
    V_MAX_NUM NUMBER(5);
    V_NEW_SID VARCHAR2(20);
BEGIN
    SELECT MAX(SID) INTO V_MAX_SID --MAX(SID)���� S014�� ���� 
    FROM STUDENTS2;
    
    DBMS_OUTPUT.PUT_LINE(' V_MAX_SID : '||V_MAX_SID);
    
    V_MAX_STR := SUBSTR(TRIM(V_MAX_SID),2,3);
    DBMS_OUTPUT.PUT_LINE('V_MAX_STR : ' ||V_MAX_STR);
    
    V_MAX_NUM := TO_NUMBER(V_MAX_STR)+1;
    DBMS_OUTPUT.PUT_LINE('V_MAX_NUM : ' || V_MAX_NUM); --15�� ��
    
    V_NEW_SID := 'S' || TRIM(TO_CHAR(V_MAX_NUM, '000'));
    DBMS_OUTPUT.PUT_LINE('V_NEW_SID : ' || V_NEW_SID);
    
    SELECT 'S' || TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(SID), 2, 3))+1,'000'))
    INTO V_NEW_SID
    FROM STUDENTS2
    ;
    DBMS_OUTPUT.PUT_LINE('���2 : ');
    DBMS_OUTPUT.PUT_LINE('V_NEW_SID : ' || V_NEW_SID)
    ;
END;

DECLARE
    V_LEN NUMBER(4):= 5;
    V_STR VARCHAR2(20);
    V_INIT VARCHAR2(20) := '00000000000000000000';
BEGIN
    FOR I IN 1..V_LEN
    LOOP
        V_STR := V_STR || '0';
        
    END LOOP;
    V_STR := SUBSTR(V_INIT,1,6); --SUBSTR�� ���ڿ�Ÿ�Ը� �����ϳ� 
    DBMS_OUTPUT.PUT_LINE(V_STR);

END;
;


SELECT * FROM STUDENTS2;

------------------------------------------------------�����ڵ���� ��Ű��
CREATE OR REPLACE PACKAGE PKG_EXAM_RESULT
AS
    --������ ����ϴ� ���ν���
    PROCEDURE PROC_RESULT_INSERT
    (
         IN_PID  IN VARCHAR2
        ,IN_SUID IN VARCHAR2
        ,IN_SEQ IN VARCHAR2 --RSEQ�� �ʿ����..
        
        ,IN_SID IN VARCHAR2
        ,IN_SCORE IN NUMBER
        ,IN_DATE IN VARCHAR2    
    
    );
END
;

---------------------------------����ó�� �����ϴ� ���ν���


CREATE OR REPLACE PROCEDURE PROC_EXCEPT
(
    IN_SID IN VARCHAR2--�̷��� �ص� IN
  --  ,ERP_CD OUT VARCHAR2 --�̰Ÿ� ���̰�
 --   ,ERR_MSG OUT VARCHAR2 --�̰Ÿ� �ٿ��� �� �ΰ��� ������ ������ �ڵ尪�� ��� ó���Ұ��̳�,? 
    
    ,O_CUR OUT SYS_REFCURSOR

)
AS 
    V_SNAME VARCHAR2(20);
BEGIN
    SELECT SNAME INTO V_SNAME
    FROM STUDENTS2
    WHERE SID = IN_SID
    ;
    
    OPEN O_CUR FOR 
    SELECT V_SNAME FROM DUAL;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         --   ERR_MSG :='�ش� �л��� �����ϴ�.'; 
            DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�.');
            --ERR_CD := 'ERRCD01'; --NODATEPAOUND ERR 
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('����� 2���̻� �Դϴ�.');
    
END;
------------------------------------------------------------------------
1.IN_SID�� �ùٸ����ְ� IN_SNAME�� �ùٸ��� ������ �ùٸ��� ����Ǵµ�
2.���� IN_SID�� Ʋ������ ������ ������ �����߻�, �Ʒ��� DEPARTS���� �ùٸ� ���� ���γ����� �׷��� COMMIT�� �ϼ�
3.������IN_SID�� �ùٸ��� �ְ� IN_SNAME�� Ʋ������ ������ �ý����� ������ �߻��ؼ�,�Ʒ��� DEPARTS�� �������  ����ó���� ���� ROLLBACK�� �ȴ�.
4.

CREATE OR REPLACE PROCEDURE PROC_EXCEPT2
(
    IN_SID IN VARCHAR2
    ,IN_DID IN VARCHAR2
    ,IN_SNAME IN VARCHAR2
    ,IN_DNAME IN VARCHAR2
    
)
AS

BEGIN
    UPDATE STUDENTS2 SET SNAME = IN_SNAME
    WHERE SID = IN_SID;
    
    UPDATE DEPARTS SET DNAME = IN_DNAME
    WHERE DID = IN_DID;
    COMMIT;
    
    EXCEPTION 
        WHEN OTHERS THEN ROLLBACK;
END;


