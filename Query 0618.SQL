--1교시

SELECT * FROM RESULT
WHERE RDATE BETWEEN TO_DATE('2020-06-13') AND TO_DATE('2020-06-15');

SELECT * FROM RESULT
WHERE RDATE <= TO_DATE('2020-06-15')
AND RDATE >= TO_DATE('2020-06-13');
--이렇게 하면 S004가 문자열이지만 출력된다.
SELECT * FROM STUDENTS2
WHERE SID>= 'S004';
--어떻게 하면 ㄱ 검색하면 ㄱ에 관한 글자가 다 나오는지 
SELECT * FROM STUDENTS2 WHERE SNAME LIKE '%ㄱ%';
SELECT * FROM STUDENTS2 WHERE SNAME >='바' AND  SNAME <='삫';


SELECT * FROM STUDENTS2
WHERE SID IN('S001','S003','S006');
--보통 IN연산자안에서 인라인쿼리를 합침

--1:N 관계에서는 조인이 훌륭하게 작동함

----------------------------------------------------------------------------
--중복제거는 DISTINCT 보다 GROUP BY 를 자주 사용, 이유는 DISTINCT는 NULL값이 
SELECT SID FROM RESULT
GROUP BY SID;



--N:M관계에서 자주 사용. 
--시험친 학생을 찾는다. 이렇게 해서 중복을 제거한다.
SELECT * FROM STUDENTS2
WHERE SID IN
(
    SELECT SID FROM RESULT GROUP BY SID
)
;

--시험치지 않는 학생을 찾는다.
SELECT * FROM STUDENTS2
WHERE SID NOT IN
(
    SELECT SID FROM RESULT GROUP BY SID
)
;
----------------------------------------------------------------------------

--ROWNUM
--실무에서는 UPDATE와 INSERT를 빈번하게 하고 SELECT JOIN이 왔다갔다하면서 데이터의 커서가 계속 바뀐다. 그러다가 INSERT하면 
--순서가 엉망진창이 된다. 그래서 자주 사용하는 문법은 아니다. 
SELECT SID, SNAME, ROWNUM FROM STUDENTS2;
----------------------------------------------------------------------------

----시퀀스 생성 방법 1.그냥 시퀀스에서 바로 마우스오른쪽눌러서 생성한다. 


SELECT SEQ1.NEXTVAL FROM DUAL; --이렇게 증가하는데 만약 값이 뛰어버리면
ALTER SEQUENCE SEQ1. INCREMENT BY 1; --1로 수정
INSERT INTO 테이블명 VALUES(SEQ1.NEXTVAL,'컬럼 값')

----------------------------
프로시저
객체를 생성하는 명령어는 CREATE 다 .
;
------------------------------------------------------------INSERT 프로시저 생성
CREATE OR REPLACE PROCEDURE PROC_TEST
(
    --PARAMENTS 정의
    --매개변수에서는 NUMBER을 쓰지않는다. 어짜피 DB로 오면 문자든 아니든 구별을 안하니깐 알고 있기를
    IN_SID IN CHAR,
    IN_SNAME IN VARCHAR,
    IN_DID IN CHAR,
    IN_DAGE IN NUMBER,
    IN_DGEN IN CHAR
 )   
AS
--  테이블타입으로 변수를 선언해서 사용 
--  empno_tab  empno_table ;
BEGIN
    INSERT INTO STUDENTS2
    (
        SID,SNAME,DID,SAGE,SGEN --이렇게 적어둬야 함. 아니면 STUDENTS2 테이블에 컬럼을 추가했을때 VALUES만 있으면 에러가 뜸
        --에러가 뜬다는것은 공장의 가동이 멈춘다. 굉장히 위험하다.
        --그래서 여기에서 컬럼명을 적어줘서 여기라도 값을 넣을수 있게 해준다.
    )
    VALUES (IN_SID, IN_SNAME,IN_DID,IN_DAGE,IN_DGEN)
    ;

END
PROC_TEST
;


------------------------------------------------------------------INSERT 프로시저 실행
DECLARE
    --변수 선언 부분
BEGIN 
    PROC_TEST('S014','몰라요','D004',25,'F');
END;

SELECT * FROM STUDENTS2;

------------------------------------------------------------------ SELECT 프로시저 생성
CREATE OR REPLACE PROCEDURE PROC_SELECT_STUDENTS2
(
    IN_SNAME IN VARCHAR2,
    O_CUR OUT SYS_REFCURSOR --커서 OUT해주고 
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

------------------------------------------------------------------ SELECT 프로시저 실행

DECLARE
BEGIN 
    PROC_SELECT_STUDENTS2('박가나');
END
;

----------------커서란 무엇인가? 생활코딩 강의 함 보자

----12:00시작 ~
패키지란... 프로시저를 관리하기 위한것 




SET SERVEROUTPUT ON;
DECLARE
    V_SID VARCHAR2(20);
    V_MAX_SID VARCHAR2(20);
    V_MAX_STR VARCHAR2(3);
    V_MAX_NUM NUMBER(5);
    V_NEW_SID VARCHAR2(20);
BEGIN
    SELECT MAX(SID) INTO V_MAX_SID --MAX(SID)에는 S014가 들어옴 
    FROM STUDENTS2;
    
    DBMS_OUTPUT.PUT_LINE(' V_MAX_SID : '||V_MAX_SID);
    
    V_MAX_STR := SUBSTR(TRIM(V_MAX_SID),2,3);
    DBMS_OUTPUT.PUT_LINE('V_MAX_STR : ' ||V_MAX_STR);
    
    V_MAX_NUM := TO_NUMBER(V_MAX_STR)+1;
    DBMS_OUTPUT.PUT_LINE('V_MAX_NUM : ' || V_MAX_NUM); --15가 됐
    
    V_NEW_SID := 'S' || TRIM(TO_CHAR(V_MAX_NUM, '000'));
    DBMS_OUTPUT.PUT_LINE('V_NEW_SID : ' || V_NEW_SID);
    
    SELECT 'S' || TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(SID), 2, 3))+1,'000'))
    INTO V_NEW_SID
    FROM STUDENTS2
    ;
    DBMS_OUTPUT.PUT_LINE('방법2 : ');
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
    V_STR := SUBSTR(V_INIT,1,6); --SUBSTR은 문자열타입만 가능하네 
    DBMS_OUTPUT.PUT_LINE(V_STR);

END;
;


SELECT * FROM STUDENTS2;

------------------------------------------------------성적자동등록 패키지
CREATE OR REPLACE PACKAGE PKG_EXAM_RESULT
AS
    --성적을 등록하는 프로시저
    PROCEDURE PROC_RESULT_INSERT
    (
         IN_PID  IN VARCHAR2
        ,IN_SUID IN VARCHAR2
        ,IN_SEQ IN VARCHAR2 --RSEQ는 필요없엉..
        
        ,IN_SID IN VARCHAR2
        ,IN_SCORE IN NUMBER
        ,IN_DATE IN VARCHAR2    
    
    );
END
;

---------------------------------예외처리 공부하는 프로시저


CREATE OR REPLACE PROCEDURE PROC_EXCEPT
(
    IN_SID IN VARCHAR2--이렇게 해도 IN
  --  ,ERP_CD OUT VARCHAR2 --이거를 붙이고
 --   ,ERR_MSG OUT VARCHAR2 --이거를 붙여서 이 두개는 에러가 났을때 코드값을 어떻게 처리할것이냐,? 
    
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
         --   ERR_MSG :='해당 학생이 없습니다.'; 
            DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다.');
            --ERR_CD := 'ERRCD01'; --NODATEPAOUND ERR 
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('사원이 2명이상 입니다.');
    
END;
------------------------------------------------------------------------
1.IN_SID에 올바른값넣고 IN_SNAME에 올바른값 넣으면 올바르게 실행되는데
2.만약 IN_SID에 틀린값을 넣으면 논리적 오류발생, 아래에 DEPARTS에는 올바른 값을 전부넣으면 그래도 COMMIT이 완성
3.하지만IN_SID에 올바른값 넣고 IN_SNAME에 틀린값을 넣으면 시스템적 오류가 발생해서,아래의 DEPARTS에 관계없이  예외처리로 가서 ROLLBACK이 된다.
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



