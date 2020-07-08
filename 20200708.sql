1. GROUP BY (여러개의 행을 하나의 행으로 묶는 행위)
2. JOIN
3. 서브쿼리
    1. 사용위치
    2. 반환하는 행, 컬럼의 개수
    3. 상호연관 / 비상호연관
        -> 메인쿼리의 컬럼을 서브쿼리에서 사용하는지(참조하는지) 유무에 따른 분류
        : 비상호연관 서브쿼리의 경우 단독으로 실행 가능
        : 상호연관 서브쿼리의 경우 실행하기 위해서 메인쿼리의 컬럼을 사용하기 때문에 단독으로 실행이 불가능
        
sub2 : 사원들의 급여평균보다 높은 급여를 받는 직원

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원 정보 조회

SELECT empno, ename, (SELECT * FROM emp WHERE )
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
SELECT empno, ename, deptno, 
      (SELECT dname FROM dept WHERE deptno = emp.deptno)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = emp.deptno);

SELECT empno, ename, deptno, 
      (SELECT dname FROM dept WHERE deptno = deptno) dname
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = emp.deptno);
             
--풀이
SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
             FROM emp s
             WHERE s.deptno = e.deptno);
             
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH', 'WARD'));
                 
단일 값비교는 =
복수행(단일컬럼) 비교는 IN

NULL과 IN, NULL과 NOT IN
IN ==> OR
NOT IN ==> AND

SELECT *
FROM emp
WHERE mgr IN (7902, null);
==> mgr = 7902 OR empno = null

WHERE mgr NOT IN (7902, null)
==> NOT (mgr = 7902 OR mgr = null)
==> mgr != 7902 AND mgr != null
==> 데이터 안나옴
** IN, NOT IN 이용시 NULL값의 존재 유무에 따라 원하지 않는 결과가 나올 수도 있다.
NULL 비교시 IS 라는 연산자를 써야함
(JAVA에서 String비교시 .equals 쓰는것과 비슷)

pairwise, non=pairwise
한행의 컬럼값을 하나씩 비교하는 것 : non-pairwise
한행의 복수 컬럼을 비교하는 것 : pairwise
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'CLERK');
pairwise
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
non-pairwise                
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
  AND deptno IN (SELECT deptno
                 FROM emp
                 WHERE empno IN(7499, 7782));
                 
pairwise
7698, 30
7839, 10
non-pairwise
7698, 30
7698, 10
7839, 30
7839, 10
경우의 수가 늘어남 - 지정되지 않기 때문

scalar subquery : SELECT절에 쓰인 서브쿼리
행, 절이 하나여야만 한다.

inline view : from절에 쓰인 서브쿼리

서브쿼리 : where절에서 사용된 서브쿼리
상호연관 / 비상호연관
상호연관 서브쿼리 ==> 실행순서가 정해져있음(서브쿼리에서 메인쿼리 참조하기 때문)
                    main ==> sub
비상호연관 서브쿼리 ==> 정해져있지 않음

sub4

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);
                    
SELECT *
FROM product
WHERE product.pid NOT IN (SELECT pid
                          FROM cycle
                          WHERE cid = 1);

SELECT *
FROM cycle;

SELECT *
FROM (SELECT *
      FROM cycle
      WHERE cid = 1) cy1
WHERE cy1.pid IN(SELECT pid
                 FROM cycle
                 WHERE cid = 2);