GROUP 함수의 특징
1. NULL은 그룹함수 연산에서 제외가 된다
부서번호별 사원의 sal, comm 컬럼의 총 합을 구하기

SELECT deptno, SUM(sal + comm), SUM(sal + NVL(comm, 0)), SUM(sal) + SUM(comm)
FROM emp
GROUP BY deptno;

NULL 처리의 효육
SELECT deptno, SUM(sal) + NVL(SUM(comm), .0), --이쪽이 훨씬 효율적임
               SUM(sal) + SUM(NVL(comm, 0))
FROM emp
GROUP BY deptno; 

2. GROUP BY 절에 작성된 컬럼 이외의 컬럼이 select 절에 올 수 없다.

그룹 실습 1

SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2), SUM(sal), COUNT(SAL), COUNT(mgr), COUNT(*)
FROM emp;

그룹 실습 2

SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) round_sal, 
        SUM(sal) sum_sal, COUNT(SAL) count_sal, COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

그룹 실습 3

SELECT DECODE(deptno,
                10, 'ACCOUNTING',
                20, 'RESEARCH',
                30, 'SALES',
                'DDIT') dname, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) round_sal, 
        SUM(sal) sum_sal, COUNT(SAL) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno;

실습 4

SELECT TO_CHAR(hiredate, 'YYYY/MM') hire_yyyymm, count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY/MM')
ORDER BY TO_CHAR(hiredate, 'YYYY/MM');

실습 5

SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

실습 6

SELECT *
FROM dept;

SELECT COUNT(*) cnt
FROM dept;

실습 7

SELECT *
FROM emp;

SELECT count(*)
FROM
(SELECT deptno
FROM emp
GROUP BY deptno);

SELECT count(count(deptno))
FROM emp
GROUP BY deptno;

데이터 결합
JOIN : 컬럼을 확장하는 방법(데이터를 연결함)
       다른 테이블의 컬럼을 가져온다
RDBMS가 중복을 최소화하는 구조이기 때문에
하나의 테이블에 데이터를 전부 담지 않고, 목적에 맞게 설계한 테이블에
데이터가 분산이 된다.
하지만 데이터를 조회할 때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다.

ANSI-SQL : American Standard Institute....SQL
ORACLE-SQL 문법

JOIN : ANSI-SQL
       ORACLE-SQL의 차이가 다소 발생
       
ANSI-SQL join
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로 행을 연결
               컬럼 이름 뿐만 아니라 데이터 타입도 동일해야 함.
문법 :
SELECT 컬럼...
FROM 테이블1 NATURAL JOIN 테이블2

emp, dept 두 테이블의 공통된 이름을 갖는 컬럼 : deptno
조인 조건으로 사용된 컬럼은 테이블 한정자를 붙이면 에러(ANSI-SQL)

SELECT emp.empno, emp.ename, deptno, dept.dname
FROM emp NATURAL JOIN dept;

위의 쿼리를 ORACLE 버전으로 수정
오라클에서는 조인 조건을 WHERE절에 기술
행을 제한하는 조건, 조인 조건 ==> WHERE절에 기술

SELECT emp.deptno, dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;

ANSI-SQL : JOIN WITH USING
조인 테이블간 동일한 이름의 컬럼이 복수개 인데,
이름이 같은 컬럼중 일부로만 조인 하고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING (deptno);

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANSI - SQL : JOIN WITH ON
위에서 배운 NATURAL JOIN, JOIN with USING의 경우 조인 테이블의 조인컬럼이 이름이 같아야 한다는 제약조건이 있음.
설계상 두 테이블의 컬럼 이름이 다를수도 있음. 컬럼 이름이 다를 경우
개발자가 직접 조인 조건을 기술할 수 있도록 제공해주는 문법.

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

ORACLE-SQL

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELF-JOIN : 동일한 테이블끼리 조인할 때 지칭하는 명칭
            (별도의 키워드가 아니다)

SELECT 사원번호, 사원이름, 사원의 상사 사원번호, 사원의 상사 이름
FROM emp;
KING의 경우 상사가 없기 때문에 조인에 실패함.
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

사원 중 사원의 번호가 7369 ~ 7698인 사원만 대상으로 해당 사원의
사원번호, 이름, 상사의 사원번호, 상사의 이름

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;

SELECT 
FROM (SELECT empno. ename, mgr
      FROM emp
      WHERE empno BETWEEN 7369 AND 7698;) a
WHERE empno

NON-EQUI-JOIN : 조인 조건이 = 이 아닌 조인
 != 값이 다를 때 연결
 
SELECT *
FROM salgrade;

SELECT empno, ename, sal, grade -- 급여등급
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;

NATURAL JOIN

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

JOIN 0_1
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.deptno IN(10,30);