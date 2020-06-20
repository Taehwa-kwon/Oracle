-------6/19일 
--1.예외처리 - 파일처리에 에러에 관해서 예외처리
--    예외에는 2가지 종류 1.컴파일 오류(오타,문법)
--                      2.런타임 오류 (2-1 실행을 시키다가 중간에 발생하는 오류- 에러가 나지 않았는데 결과값이 문제가 생긴것)
--                                   (2-2 파일이 없으면 없다고 알림을 해야한다. )
--런타임 과정에서 오류가 나지않게 TRY ~ CATCH한다. 
                      
                      
------------------------------------------------------------------------------------
------------아이디를 입력받아서 이름을 찾는 프로시저
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
    WHERE SID = IN_SID; --ROW줄을 찾는다. 

END 
EXCEPT_TST;
/

-----위에 상태대로 하고 프로시저에서 SNAME 을 다르게 실행하면 no data found가 뜬다. 
------------------------------------------------------------------------------------
---------------------------------예외처리---------------------------------
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
    WHERE SID = IN_SID; --ROW줄을 찾는다. 
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            O_ERR_CD := SQLCODE;--SQL이 본인이 가지고 있는 에러
            O_ERR_MSG := SQLERRM;
            WHEN OTHERS THEN --NA_DATA_FOUND를 제외한 모든 에러코드 
            
            DBMS_OUTPUT.PUT_LINE('데이터가 없습니다');

END 
EXCEPT_TST;
/

--------------------------------------------------------------
---------------------------------직접 예외로 넘겨서 처리---------------------------------
CREATE OR REPLACE PROCEDURE PROC_EXCEPT_TST
(
    IN_SID IN VARCHAR2,
    O_ERR_CD OUT VARCHAR2,
    O_ERR_MSG OUT VARCHAR2,
    O_CUR OUT SYS_REFCURSOR  
)
AS 
    V_SNAME VARCHAR2(20);
   
    --사용자 정의 예외 --SELECT에서 자료가 없으면 우리가 예외처리하러 보낸다. 
    NO_DATA_ROWS EXCEPTION;
    V_ROW_CNT NUMBER:= 0; --NUMBER은 갯수를 안줘도 된다. 
    
BEGIN 
    SELECT COUNT(*) INTO V_ROW_CNT -- 개수가 0이면 
    FROM STUDENTS2
    WHERE SID = IN_SID 
    ;
    
    IF V_ROW_CNT = 0 THEN 
        RAISE NO_DATA_ROWS; --여기서 오류를 발생 시킨다.
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
            O_ERR_MSG := '검색된 자료가 없습니다.';
            
            WHEN OTHERS THEN --NA_DATA_FOUND를 제외한 모든 에러코드 
             O_ERR_CD := SQLCODE;--SQL이 본인이 가지고 있는 에러
            O_ERR_MSG := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('데이터가 없습니다');
END
PROC_EXCEPT_TST
;
/


------------------------------데이터타입---------------------------------
CREATE OR REPLACE PROCEDURE TYPE_EX01
(
    IN_SID IN STUDENTS2.SID%TYPE, --DATABASE에서만 존재하는 방식 STUDENTS2.SID%TYPE
    O_CUR OUT SYS_REFCURSOR  
)
AS

BEGIN
    NULL;
END
TYPE_EX01
;
/



------------------------------DB의 배열 ---------------------------------
CREATE OR REPLACE PROCEDURE TYPE_EX01
(
    IN_SID IN STUDENTS2.SID%TYPE, --DATABASE에서만 존재함 
    O_CUR OUT SYS_REFCURSOR  -- 이렇게 던져야지 애플리케이션에서 받을수 있다. --묵시적 커서(MS SQL은 이 내용이 없다) || 암시적 커서 
)
AS
--즉 이것은 각 컬럼에서 사용할 테이블을 선언하는것이다. http://www.gurubee.net/lecture/1047
    TYPE ARR_TYPE IS TABLE OF VARCHAR2(20)  --ARR_TYPE테이블타입으로 ARR_SNAME변수를 선언해서 사용
    INDEX BY BINARY_INTEGER;  
    
    ARR_SNAME ARR_TYPE;
    
    I NUMBER:= 1;
    ROW_CNT NUMBER;
--테이블타입으로 변수를 선언해서 사용

BEGIN
    --학생테이블의 총 ROW개수 
    SELECT COUNT(*) INTO ROW_CNT FROM STUDENTS2;
    
    
    FOR V_CUR IN --FROM STUDENTS2 를 13번 돌아서 SID,SNAME을 
    (
         SELECT SID,SNAME  FROM  STUDENTS2
    )
    LOOP 
        DBMS_OUTPUT.PUT_LINE(V_CUR.SNAME);
        ARR_SNAME(I) := V_CUR.SNAME; --여기있는 V_CUR의 SNAME을 ARR_SNAME에 넣는다. 
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
--만약에 컬럼이 존나 많으면 IS밑에다가 SELECT INTO 하려고 할떄 SELECT 에 하나하나 변수,타입을 다 적어야 한다. 그것을 방지하기 위해서 
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
 
    V_ST  STUDENTS2%ROWTYPE; --STUDENTS2 타입의 ROW니깐 한줄의 타입을 가져온다  ---STUDENTS2테이블에서 한줄의 타입을 가져오는거고 위에는 한 컬럼(세로)의 줄을 가져오는거지 
BEGIN
    SELECT SID, SNAME,DID
    INTO V_ST.SID,V_ST.SNAME,V_ST.DID
    --INTO V_SID,V_SNAME,V_DID 이걸 대신해서 위에것으로 사용가능 
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





---------------------------이벤트-----------------------------------------
--입고테이블의 WAREHOSING  INSERT라는 이벤트가 발생하면 -> PRODUCT 의 QTY에는 누적으로 합계가 만들어야 한다 .-> 트리거

트리거에는 2가지 종류가 있다. 특정테이블에 이벤트(INSERT, DELETE,UPDATE)가 발생하면 자동으로 실행
1.AFTER TRIGGER    이벤트가 발생하면 실제 INSERT,UPDATE, DELETE가 실행된 후에 해당 프로시저가 실행된다.
2.BEFORE TRIGGER   이벤트가 발생하면 실제 INSERT,UPDATE, DELETE가 실행되기 전에 해당 프로시저가 실행되고 INSERT,UPDATE, DELETE가 실행 

CREATE OR REPLACE PROCEDURE PROC_WARE
(
    IN_PID IN VARCHAR2,
    IN_PRICE IN NUMBER, --입고가격
    IN_PPRICE IN NUMBER, --판매가격
    IN_QTY IN NUMBER
    
)
AS

BEGIN

    INSERT INTO WAREHOUSING VALUES('W002', IN_PID, IN_PRICE, IN_QTY, SYSDATE);
    -- 입고 -> 새우깡이 610원에 30봉지 입고
    
    --상품테이블의 판매가격과 재고를 업데이트
    UPDATE PRODUCTS
    SET PR_QTY = PR_QTY + IN_QTY
    WHERE PR_ID = IN_PID;
    
  
END 
PROC_WARE
;


--------------------------입고취소 ------------------------------------
CREATE OR REPLACE TRIGGER TRG_CANCEL
AFTER DELETE ON WAREHOUSING
REFERENCING NEW AS NEW OLD AS OLD 
FOR EACH ROW        --이게 있어야 한줄에 대해서 명령을 한다. 
BEGIN

    UPDATE PRODUCTS
    SET PR_QTY = PR_QTY - :OLD.QTY
    WHERE PR_ID = :OLD.PID
    ;
    
END TRG_CANCEL;
/

-------------------------업데이트----------------------------
CREATE OR REPLACE TRIGGER PRG_CHG_PRICE
AFTER UPDATE ON PRODUCTS
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
    --가격이 오르기 전 OLD 오른후  NEW    
    INSERT INTO CHG_PRICE(PID,SEQ,PRICE)
    VALUES(:OLD.PID, 2,:NEW.PPRICE );
    
    
END TRG_CHG_PRICE
;

    
