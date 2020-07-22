SELECT DECODE(GROUPING(job), 1, '총', 0 , job) job, 
       (CASE
        WHEN GROUPING(deptno) = 1 AND GROUPING(deptno) = 0
        THEN INTO emp (deptno) VALUES ('소계')
        WHEN GROUPING(deptno) = 1 AND GROUPING(deptno) = 0
        THEN INTO emp (deptno) VALUES ('계')) deptno
       SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT CASE 
        WHEN GROUPING(job) = 1 THEN '총'
        WHEN GROUPING(job) = 0 THEN job
        END job,
        CASE
        WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '계'
        WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN '소계'
        WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 0 THEN TO_CHAR(deptno)
        END deptno,
        GROUPING(job), GROUPING(deptno), SUM(sal) sal_sum
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT DECODE(GROUPING(job), 1, '총', 0, job) job, 
       DECODE(GROUPING(job) + GROUPING(deptno), 1 , '소계', 0, deptno, '계') deptno,
       SUM(sal) sal_sum
FROM emp
GROUP BY ROLLUP(job, deptno);

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

SELECT d.dname, job, SUM(sal + NVL(comm, 0)) sal
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

SELECT DECODE(GROUPING(d.dname), 1 , '총', 0 , d.dname) dname, 
       DECODE(GROUPING(e.job) + GROUPING(d.dname), 1, '소계', 0, job, '계') job, SUM(sal + NVL(comm, 0)) sal
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname;

확장된 GROUP BY
1. ROLLUP (O)
    컬럼 기술에 방향성이 존재
    GROUP BY ROLLUP(job, deptno) != GROUP BY ROLLUP(deptno, job)
    GROUP BY job, deptno          GROUP BY deptno, job
    GROUP BY job                  GROUP BY deptno
    GROUP BY ''                   GROUP BY ''
    단점 : 개발자가 필요가 없는 서브 그룹을 임의로 제거할 수 없다.
    
2. GROUPING SETS (O) - 필요한 서브그룹을 임의로 지정하는 형태
    ==> 복수의 GROUP BY를 하나로 합쳐서 결과를 돌려주는 형태
   GROUP BY GROUPING SETS(col1, col2)
   GROUP BY col1
   UNION ALL
   GROUP BY col2

   GROUP BY GROUPING SETS(col2, col1)
   GROUP BY col2
   UNION ALL
   GROUP BY col1
   
   GROUPING SETS의 경우 ROLLUP과는 다르게 컬럼 나열순서가 데이터자체에 영향을 미치지 않음
   
   GROUP BY col1,col2
   UNION ALL
   GROUP BY col1
   ==> GROUPING SETS ((col1, col2), col1)

3. CUBE (X)

GROUPING SETS 실습;
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
--GROUP BY ROLLUP(job, deptno);
GROUP BY GROUPING SETS(job, deptno);
위 쿼리를 UNION ALL로 풀어 쓰기

SELECT job, null, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY job

UNION ALL

SELECT null, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY deptno;

GROUP BY GROUPING SETS (job, deptno, mgr)
!=
GROUP BY GROUPING SETS ((job, deptno), mgr)

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

CUBE
GROUP BY를 확장한 구문
CUBE절에 나열한 모든 가능한 조합으로 서브그룹을 생성
GROUP BY CUBE(job, deptno);

GROUP BY job, deptno
GROUP BY job
GROUP BY      deptno
GROUP BY

SELECT job, deptno, SUM(sal + NVL(comm, 0))
FROM emp
GROUP BY cube(job, deptno);

CUBE의 경우 기술한 컬럼으로 모든 가능한 조합으로 서브그룹을 생성한다
가능한 서브그룹은 2^기술한 컬럼 갯수
기술한 컬럼이 3개만 넘어도 생성되는 서브그룹의 개수가 8개가 넘기 때문에
실제 필요하지 않은 서브 그룹이 포함될 가능성이 높다
==> ROLLUP, GROUPIng SETS 보다 활용성이 떨어진다.

GROUP BY job, ROLLUP(deptno), CUBE(mgr)
==> 내가 필요로 하는 서브그룹을 GROUPING SETS를 통해 정의하면 간단하게 작성 가능.

GROUP BY job, ROLLUP(deptno), CUBE(mgr)
ROLLUP(deptno) : GROUP BY deptno + GROUP BY ''
CUBE(mgr) : GROUP BY mgr
            GROUP BY ''
            
GROUP BY job, deptno, mgr
GROUP BY job, deptno
GROUP BY job, mgr
GROUP BY job;

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(job, deptno), cube(mgr);

1. 서브그룹
GROUP BY job, deptno, mgr
GROUP BY job, deptno
GROUP BY job, mgr
GROUP BY job

1. 서브그룹을 나열하기

2. 스프레드시트 - 구글 문서도구를 이용하여
   데이터 조회결과에 1번의 서브그룹별로 색상을 칠해보자

SELECT *
FROM emp_test;
1. emp_test 테이블 삭제
2. emp 테이블을 이용하여 emp_test 테이블을 생성 (모든 행, 모든 컬럼)
3. emp_test 테이블에 dname(VARCHAR2(14)) 컬럼을 추가

DROP TABLE emp_test;

CREATE TABLE emp_test AS
    SELECT *
    FROM emp;
    
ALTER TABLE emp_test ADD(dname VARCHAR2(14));

SELECT *
FROM emp_test;
    
SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE dept.deptno = emp_test.deptno) dname
FROM emp_test;

DESC dept;

WHERE 절이 존재하지 않음 : 모든 행에 대해서 업데이트를 실행
UPDATE emp_test SET dname = (SELECT dname 
                             FROM dept 
                             WHERE dept.deptno = emp_test.deptno);
                             
1. dept_test 테이블을 삭제
2. dept 테이블을 이용하여 dept_test 생성(모든 행, 모든 컬럼)
3. dept_test 테이블에 empcnt(number) 컬럼을 추가
4. subquery를 이용하여 dept_test 테이블의 empcnt 컬럼을 해당 부서원 수로 update

DROP TABLE dept_test;

CREATE TABLE dept_test AS
    SELECT *
    FROM dept;
    
ALTER TABLE dept_test ADD(empcnt number);

SELECT count(*)
FROM emp
GROUP BY deptno;

UPDATE dept_test SET empcnt = (SELECT count(*)
                                FROM emp
                                WHERE dept_test.deptno = emp.deptno);
                                
SELECT *
FROM dept_test;