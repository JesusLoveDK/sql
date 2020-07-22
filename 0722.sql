오라클 계층쿼리 : 하나의 테이블(혹은 인라인 뷰)에서
                특정 행을 기준으로 다른 행을 찾아가는 문법
조인 : 테이블 - 테이블
계층쿼리 : 행 - 행

1. 시작점(행)을 설정
2. 시작점(행)과 다른행을 연결시킬 조건을 기술

1. 시작점 : mgr 정보가 없는 KING
2. 연결 조건 : KING을 MGR컬럼으로 하는 사원

SELECT LPAD(' ', (LEVEL - 1)*4) || ename, LEVEL
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

SELECT LPAD('기준문자열', 15, '*')
FROM dual;

SELECT LPAD(' ', (LEVEL - 1)*4) || ename, LEVEL
FROM emp
START WITH ename = 'BLAKE'
CONNECT BY PRIOR empno = mgr;

최하단 노드에서 상위 노드로 연결하는 상향식 연결방법
시작점 : SMITH

**PRIOR 키워드는 CONNECT BY 키워드와 떨어져서 사용해도 무관
**PRIOR 키워드는 현재 읽고 있는 행을 지칭하는 키워드
SELECT LPAD(' ', (LEVEL - 1) * 4) || ename, LEVEL
FROM emp
START WITH ename = 'SMITH'
CONNECT BY empno = PRIOR mgr AND deptno = 20;

SELECT LPAD(' ', (LEVEL - 1) * 4) || ename, LEVEL
FROM emp
START WITH ename = 'SMITH'
CONNECT BY empno = PRIOR mgr AND PRIOR hiredate < hiredate;

SELECT *
FROM dept_h;

--XX회사 부서부터 시작하는 하향식 계층쿼리 작성, 부서이름과 LEVEL 컬럼을 이용하여 들어쓰기 표현
SELECT (LPAD(' ', (LEVEL - 1) * 4) || deptnm) deptnm, dept_h.*, LEVEL
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;