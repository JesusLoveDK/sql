SELECT *
From prod;
 
SELECT prod_id, prod_name
FROM prod;

SELECT *
From prod;

SELECT buyer_id, buyer_name
From buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

expression : 컬럼값을 가공을 하거나, 존재하지 않는 새로운 상수값(정해진 값)을 표현
             연산을 통해 새로운 컬럼을 조회할 수 있다.
             연산을 하더라도 해당 SQL 조회 결과에만 나올 뿐이고 실제 테이블의 데이터에는 영향을 주지 않는다.
             SELECT 구문은 테이블의 데이터에 영향을 주지 않음.
SELECT sal, sal+500, sal - 500, sal/5, sal*5, 500
FROM emp;

SELECT *
FROM dept;

날짜의 사칙연산 : 수학적으로 정의가 되어 있지 않음.
SQL에서는 날짜데이터 +- 정수 = 정수를 일자 취급

'2020년 6월 25일' + 5 : 2020년 6월 25일부터 5일 지난 날짜
'2020년 6월 25일' -5 : 2020년 6월 25일부터 5일 이전 날짜 