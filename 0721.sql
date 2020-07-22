확장된 GROUP BY
==> 서브그룹을 자동으로 생성
    만약 이런 구문이 없다면 개발자가 직접 SELECT 쿼리를 여러개 작성해서
    UNION ALL을 시행 ==> 동일한 테이블을 여러번 조회 ==> 성능 저하

1. ROLLUP
    1-1 ROLLUP절에 기술한 컬럼을 오른쪽에서부터 지워나가며 서브그룹을 생성
    1-2 생성되는 서브 그룹 : ROLLUP절에 기술한 컬럼 개수 + 1
    1-3 ROLLUP절에 기술한 컬럼의 순서가 결과에 영향을 미친다
    
2. GROUPING SETS
    2-1 사용자가 원하는 서브그룹을 직접 지정하는 형태
    2-2 컬럼 기술의 순서는 결과 집합에 영향을 미치지 않음(집합)
    
3. CUBE
    3-1 CUBE절에 기술한 컬럼의 가능한 모든 조합으로 서브그룹을 생성
    3-2 잘 안쓴다. 서브그루이 너무 많이 생성됨
        2^CUBE절에 기술한 컬럼개수
        
sub_a2
SELECT *
FROM dept_test;

1. dept_test 테이블의 empcnt 컬럼 삭제;

ALTER TABLE dept_test DROP COLUMN empcnt;

2. 2개의 신규 데이터 입력
INSERT INtO dept_test VALUES (40, 'OPERATIONS', 'BOSTON');
INSERT INtO dept_test VALUES (99, 'ddit1', 'daejeon');
INSERT INtO dept_test VALUES (98, 'ddit2', 'daejeon');

3. 부서(dept_test)중에 직원이 속하지 않은 부서를 삭제
    서브쿼리를 사용하여
    1. 비상호연관;
        DELETE dept_test
        WHERE deptno NOT IN (SELECT deptno
                             FROM emp);
    
    2. 상호연관
    
    DELETE dept_test
    WHERE NOT EXISTS (SELECT 'X'
                      FROM emp
                      WHERE emp.deptno = dept_test.deptno);
                      
    3. 상호연관 NOT IN으로 풀어보기
    DELETE dept_test
    WHERE deptno NOT IN (SELECT deptno
                         FROM emp
                         WHERE emp.deptno = dept_test.deptno);
                  
    
    삭제 대상 : 40, 98, 99
    
    SELECT *
    FROM emp_test;
    
    UPDATE emp_test a SET sal = sal + 200
    WHERE sal < (SELECT AVG(sal)
                 FROM emp_test b
                 WHERE b.deptno = a.deptno);
                             
    sub_3
    SELECT *
    FROM emp_test;
    
WITH : 쿼리 블럭을 생성하고
       같이 실행되는 SQL에서 해당 쿼리 블럭을 반복적으로 사용할 때 성능 향상 효과를 기대할 수 있다
       WITH 절에 기술된 쿼리 블럭은 메모리에 한번만 올리기 때문에
       쿼리에서 반복적으로 사용하더라도 실제 데이터를 가져오는 작업은 한번만 발생
       
       하지만 하나의 쿼리에서 동일한 서브쿼리가 반복적으로 사용된다는 것은 쿼리를 잘못 작성한
       가능성이 높다는 뜻이므로, WITH절로 해결하기보다는 쿼리를 다른 방식으로 작성할 수 없는지 먼저 고려해볼 것
       
       회사의 DB를 다른 외부인에게 오픈할 수 없기 때문에, 외부인에게 도움을 구하고자 할 때 테이블을 대신할 목적으로 많이 사용
       
사용방법 : 쿼리 블럭은 콤마(,)를 통해 여러개를 동시에 선언하는 것도 가능
WITH 쿼리블럭이름 AS(
        SELECT 쿼리
)
SELECT *
FROM 쿼리블럭이름;



1. 2020년 7월의 일수 구하기

SELECT DECODE(d, 1, iw +1, iw), MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue, 
       MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
       TO_CHAR((TO_DATE(:yyyymm, 'YYYYMM')) + (LEVEL - 1), 'D') d,
       TO_CHAR((TO_DATE(:yyyymm, 'YYYYMM')) + (LEVEL - 1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'dd'))
GROUP BY DECODE(d, 1, iw +1, iw)
ORDER BY DECODE(d, 1, iw +1, iw);



SELECT dual.*, level
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')), 'dd');

SELECT *
FROM 
(SELECT TO_CHAR(dt, 'MM') mm
 FROM sales)
 CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(dt), 'dd')
 ;
 
 SELECT TO_CHAR(LAST_DAY(dt), 'dd')
 FROM sales;
 
 
 SELECT *
 FROM sales;
 
 SELECT
 FROM
 (SELECT TO_CHAR(dt, 'MM') mm, SUM(sales)
 FROM sales
 GROUP BY TO_CHAR(dt, 'MM')
 ORDER BY mm)
 CONNECT BY LEVEL
 
 1. dt컬럼을 이용하여 월 정보를 추출
 2. 1번에서 추출된 월정보가 같은 컬럼끼리 sales 행의 합을 계산
 3. 2번에서 계산된 결과를;
 
SELECT NVL(SUM(DECODE(mm, '01', sales)), 0) jan, NVL(SUM(DECODE(mm, '02', sales)), 0) feb, NVL(SUM(DECODE(mm, '03', sales)), 0) mar,
       NVL(SUM(DECODE(mm, '04', sales)), 0) apr, NVL(SUM(DECODE(mm, '05', sales)), 0) may, NVL(SUM(DECODE(mm, '06', sales)), 0) jun
 FROM
 (SELECT TO_CHAR(dt, 'MM') mm, SUM(sales) sales
    FROM sales
    GROUP BY TO_CHAR(dt, 'MM')
    ORDER BY TO_CHAR(dt, 'MM'));
    
SELECT NVL(SUM(DECODE( TO_CHAR(dt, 'MM'), '01', sales)) ,0) jan,
       NVL(SUM(DECODE( TO_CHAR(dt, 'MM'), '02', sales)) ,0) feb,
       NVL(SUM(DECODE( TO_CHAR(dt, 'MM'), '03', sales)) ,0) mar,
       NVL(SUM(DECODE( TO_CHAR(dt, 'MM'), '04', sales)) ,0) apr,
       NVL(SUM(DECODE( TO_CHAR(dt, 'MM'), '05', sales)) ,0) may,
       NVL(SUM(DECODE( TO_CHAR(dt, 'MM'), '06', sales)) ,0) jun
FROM sales;

미리 정의된 포트
http: 80
https : 443
ftp : 21

ORACLE : 1521
TOMCAT : 8080
MYSQL : 3306

과제

SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
       TO_CHAR((TO_DATE(:yyyymm, 'YYYYMM')) + (LEVEL - 1), 'D') d,
       TO_CHAR((TO_DATE(:yyyymm, 'YYYYMM')) + (LEVEL - 1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'dd')

1. 시작날짜를 해당 월의 첫번째 일요일로 설정
2. ;

SELECT MAX(DECODE(TO_CHAR(dt, 'd'), 1, dt, null)) sun,
       MAX(DECODE(TO_CHAR(dt, 'd'), 2, dt, null)) mon,
       MAX(DECODE(TO_CHAR(dt, 'd'), 3, dt, null)) tue,
       MAX(DECODE(TO_CHAR(dt, 'd'), 4, dt, null)) wed,
       MAX(DECODE(TO_CHAR(dt, 'd'), 5, dt, null)) thu,
       MAX(DECODE(TO_CHAR(dt, 'd'), 6, dt, null)) fri,
       MAX(DECODE(TO_CHAR(dt, 'd'), 7, dt, null)) sat
FROM(SELECT TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'd')) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'd')), 'd') d,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'd')), 'iw') iw
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'dd') 
                         + (7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'd')
                         + TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'd')) - 1)
GROUP BY DECODE(d, 1, iw + 1, iw)
ORDER BY DECODE(d, 1, iw + 1, iw);
                         


WITH dt AS(
    SELECT TO_DATE('2019/12/01', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/02', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/03', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/04', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/05', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/06', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/07', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/08', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/09', 'YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_DATE('2019/12/10', 'YYYY/MM/DD') dt FROM dual)
SELECT dt, dt - (TO_CHAR(dt, 'd')-1)
FROM dt;

mybatis
SELECT : 결과가 1건이냐, 복수거나
    1건 : sqlSession.selectOne("네임스페이스.sqlid", [인자]) ==> overloading
          리턴타입 : resultType
    복수 : sqlSession.selectList("네임스페이스.sqlid", [인자]) ==> overloading
          리턴타입 List<resultType>