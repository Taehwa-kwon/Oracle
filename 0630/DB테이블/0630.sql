2�������� ��κ��� Ŭ���̾�Ʈ �������� �ڵ� �����ߴ�.

�����ͺ��̽��� �����ϴ� ��ü���� 

PM�� ���� : ��������
PL�� ���� : ������Ʈ ����,��ġ����

RFP = 1�� ��û��ü 
����, ����� ->�� 1�� ��û��ü�� RFP�� �߼��Ѵ�. RFP���� ����,��� �������� �����ϰ� ��û��ü�� �װſ� ���ؼ� ���� ���� , ���ݿ� ���Ѱ� ���Ϳ� ���ؼ� ���� ���Ǹ� �����Ѵ�.
-> �׸��� ����+���뿡 ���ؼ� ���ȼ��� �����ϰ� ��ѽ��� ���Ǹ� �����Ѵ�.

1.�����м��� �����Ѵ�.

PM�� ù��° ȸ�Ƿ� �� �����м����� �ۼ��Ѵ�.
	db���踦 �����Ѵ�. ������ ���ؼ� �м��ϰ� �� �䱸������ Ȯ���� �� �����Ѵ�. ���̺���� �ۼ�

PL���״� ������ ������ �Ѵ�. 
	�� ������ �ڹٽ�ũ��Ʈ ���̺귯���� ���ý�Ų��. 

db�� ���̺귯���� ������ ������ �����Ѵ�.

�ٽ� �����̳ʿ� �غ��ϰ�, ��������ǥ�� �ۼ��Ѵ�.(�� ����)

�������̺��� �����״µ� 6������.. ���츮�� ������ ������ ������ �����.






SELECT *
FROM GRPCOMMONS_TBL G1, STUDENTS_TBL S1, COMMONS_TBL C1
WHERE S1.STU_DEPT_GRP=G1.GRP_ID
AND S1.STU_DEPT_GRP = C1.GRP_ID
AND G1.GRP_ID = 'GRP002'
AND S1.STU_ID = 'STU001'
;

SELECT *
FROM GRPCOMMONS_TBL G1, STUDENTS_TBL S1
WHERE S1.STU_DEPT_GRP=G1.GRP_ID
AND G1.GRP_ID = 'GRP002'
AND S1.STU_ID = 'STU001';



Q.ȫ�浿01�� �̸��� �а� ���� �ּҸ� �̾Ƴ��� 

--�̸� �а� 
SELECT *
FROM STUDENTS_TBL T1, COMMONS_TBL T2, GRPCOMMONS_TBL T3
WHERE T1.STU_DEPT = T2.COM_ID
AND T1.STU_DEPT_GRP = T3.GRP_ID
AND T1.STU_ID = 'STU001'
AND T3.GRP_ID = 'GRP002'
;

--�ʵ������ ������������, ROW�� �߽����� JOIN�ɱ� 
SELECT * FROM COMMONS_TBL T1, GRPCOMMONS_TBL T2
WHERE T1.GRP_ID = T2.GRP_ID
AND T2.GRP_ID = 'GRP002';

--�̷��� �ϸ� �а��� �ϳ����� ����
SELECT * FROM COMMONS_TBL T1, GRPCOMMONS_TBL T2, STUDENTS_TBL T3
WHERE T1.GRP_ID = T2.GRP_ID
AND T1.GRP_ID = T3.STU_DEPT_GRP
AND T1.COM_ID = T3.STU_DEPT

AND T2.GRP_ID = 'GRP002'
AND T3.STU_ID = 'STU001';
--�״��� �л��� ã�� . 

SELECT * FROM COMMONS_TBL T1, GRPCOMMONS_TBL T2, STUDENTS_TBL T3, COMMONS_TBL T4
WHERE T1.GRP_ID = T2.GRP_ID
AND T1.GRP_ID = T3.STU_DEPT_GRP
AND T1.COM_ID = T3.STU_DEPT
AND T3.STU_ADDR_GRP = T4.GRP_ID
AND T3.STU_ADDR = T4.COM_ID
AND T2.GRP_ID = 'GRP002'
AND T3.STU_ID = 'STU001'
;
--�л��̸� �а� �� �ּ� �������� 

SELECT STU_ID, COUNT(*) FROM 
(
SELECT * FROM COMMONS_TBL T1,  STUDENTS_TBL T3, COMMONS_TBL T4, COMMONS_TBL T5, COMMONS_TBL T6
WHERE T1.GRP_ID = T3.STU_DEPT_GRP
AND T1.COM_ID = T3.STU_DEPT
AND T3.STU_ADDR_GRP = T4.GRP_ID
AND T3.STU_ADDR = T4.COM_ID
AND T4.PARENT_ID = T5.COM_ID AND T4.GRP_ID = T5.GRP_ID
AND T5.PARENT_ID = T6.COM_ID AND T5.GRP_ID = T6.GRP_ID
AND T1.GRP_ID = 'GRP002'
AND T3.STU_ID = 'STU001'
)
GROUP BY STU_ID
HAVING COUNT(*)>1
;




Q. �а��� �л����� ���Ͽ���  (�а��� �л��� ����Ű�� ����Ǿ��ִ�)
SELECT COM_VAL
FROM STUDENTS_TBL S1, GRPCOMMONS_TBL G1
WHERE S1.STU_DEPT_GRP = G1.GRP_ID;
AND S1.STU_DEPT = C1.COM_ID;


SELECT *
FROM GRPCOMMONS_TBL G1, STUDENTS_TBL S1
WHERE G1.GRP_ID=S1.STU_DEPT_GRP
;

--��.. T1�� T2�� ����Ű�� ����Ǿ��ִ�. T1�� 1 T2�� N ���� 
SELECT T1.COM_ID, T1.COM_VAL, COUNT(*) FROM
(
SELECT * FROM COMMONS_TBL
WHERE GRP_ID = 'GRP002'
) T1
,
STUDENTS_TBL T2 
WHERE T2.STU_DEPT_GRP(+) = T1.GRP_ID
AND T2.STU_DEPT(+) = T1.COM_ID
GROUP BY T1.COM_ID, T1.COM_VAL
; --���� ����� �̹� 23���� �Ѵ´�. 0�� �Ȼ���.


SELECT * FROM COMMONS_TBL WHERE GRP_ID = 'GRP002' AND COM_LVL = 2; --�� 23���ε� 

--��.. T1�� T2�� ����Ű�� ����Ǿ��ִ�. T1�� 1 T2�� N ���� 
SELECT * FROM
(
SELECT * FROM COMMONS_TBL
WHERE GRP_ID = 'GRP002' AND COM_LVL= 2
) T1, STUDENTS_TBL T2 
WHERE T2.STU_DEPT_GRP(+) = T1.GRP_ID
AND T2.STU_DEPT(+) = T1.COM_ID
; --4�� �а��� �л��� ����

SELECT T1.COM_ID, T1.COM_VAL, COUNT(T2.STU_ID) FROM
(
SELECT * FROM COMMONS_TBL
WHERE GRP_ID = 'GRP002' AND COM_LVL= 2
) T1, STUDENTS_TBL T2 
WHERE T2.STU_DEPT_GRP(+) = T1.GRP_ID
AND T2.STU_DEPT(+) = T1.COM_ID
GROUP BY T1.COM_ID, T1.COM_VAL
ORDER BY COUNT(T2.STU_ID) ASC
; 


--����
Q.ȫ�浿01�� �̸��� �а� ���� �ּҸ� �̾Ƴ���
SELECT T2.COM_VAL, T2.COM_ID, NVL(T1.NUMBERS, 0) AS NUMBERS
FROM
(
SELECT STU_DEPT AS DEPART, COUNT(STU_ID) AS NUMBERS
FROM STUDENTS_TBL
GROUP BY STU_DEPT
) T1,
COMMONS_TBL T2
WHERE T1.DEPART(+) = T2.COM_ID
AND T2.GRP_ID = 'GRP002'
AND T2.COM_LVL = 2
;

Q. �а��� �л����� ���Ͽ���
SELECT T1.COM_ID, T1.COM_VAL, COUNT(*) FROM
(
SELECT * FROM COMMONS_TBL
WHERE GRP_ID = 'GRP002'
) T1
,
STUDENTS_TBL T2 
WHERE T2.STU_DEPT_GRP(+) = T1.GRP_ID
AND T2.STU_DEPT(+) = T1.COM_ID
GROUP BY T1.COM_ID, T1.COM_VAL;






