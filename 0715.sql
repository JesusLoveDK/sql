오라클 객체(object)
table
 . ddl 생성, 수정, 삭제
 view - sql(쿼리다) 논리적인 데이터 정의, 실체가 없음
    view 구성하는 테이블의 데이터가 변경되면 view 결과도 달라지더라
 sequence - 중복되지 않는 정수값을 반환해주는 객체
            유일한 값이 필요할 때 사용할 수 있는 객체
            nextval, currval
 index - 테이블의 일부 컬럼을 기준으로 미리 정렬해 놓은 데이터
         == > 테이블 없이 단독적으로 생성 불가, 특정 테이블에 종속
              테이블 삭제를 하면 관련 인덱스도 함께 삭제
              
DB 구조에서 중요한 전제 조건
1. DB에서 I/O의 기준은 행단위가 아니라 block 단위
   한 건의 데이터를 조회하더라도, 해당 행이 존재하는 block 전체를 읽는다
2. extent, 공간할당 기준

데이터 접근 방식
1. table full access
   multi block io ==> 읽어야할 블록 여러개를 한번에 읽어들이는 방식
                      (일반적으로 8~16 block)
   사용자가 원하는 데이터의 결과가 table의 모든 데이터를 다 읽어야 처리가 가능한 경우
   ==> 인덱스보다 여러 블럭을 한번에 많이 조회하는 table full access 방식이 유리할 수 있다
   ex :
   전제조건은 mgr, sal, comm 컬럼으로 인덱스가 없을 때
   mgr, sal, comm 정보를 table에서만 획득이 가능할 때
   SELECT count(mgr), SUM(sal), SUM(comm), AVG(sal)
   FROM emp;
   
2. index 접근, index 접근후 table access
   single block io ==> 읽어야할 행이 있는 데이터 block만 읽어서 처리하는 방식
   소수의 몇 건 데이터를 사용자가 조회할 경우, 그리고 조건에 맞는 인덱스가 존재할 경우
   빠르게 응답을 받을 수 있다.
   
   하지만 single block io가 빈번하게 일어나면 multi block io보다 오히려 느리다
   

현재 상태
index : IDX_NU_emp_01  (empno), idx_NU_emp_02, idx_nu_emp_03;
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
  
SELECT *
FROM TABLE(dbms_xplan.display);
  
SELECT *
FROM emp
ORDER BY job;

emp 테이블의 job컬럼을 기준으로 2번째 NON-UNIQUE 인덱스 생성
CREATE INDEX idx_nu_emp_02 ON emp (job);

인덱스 추가 생성
emp 테이블의 job, ename 컬럼으로 복합 non-unique index 생성
idx_nu_emp_03
CREATE INDEX idx_nu_emp_03 ON emp (job, ename);
LIKE 'C%' ==> LIKE'%C';
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE '%C';
 
 SELECT *
 FROM emp
 ORDER BY job, ename;
 
 인덱스 추가
 emp 테이블에 ename, job 컬럼을 기준으로 non-unique 인덱스 생성(idx_nu_emp_04);
 CREATE INDEX idx_nu_emp_0 ON emp (ename, job);
 현재 상태
index : IDX_NU_emp_01(empno), 
        idx_NU_emp_02(job), 
        idx_nu_emp_03(job, ename) ==> 삭제
        idx_nu_emp_04(ename, job) : 복합 컬럼의 인덱스의 컬럼순서가 미치는 영향;
        
DROP INDEX idx_nu_emp_03;
        
SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
  
SELECT *
FROM TABLE(dbms_xplan.display);

조인에서의 인덱스 활용
emp : pk_emp, fk_emp_dept 생성;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno)
                                            REFERENCES dept (deptno);
                       
접근방식 : emp 1.table full access, 2. 인덱스 * 4 : 방법 5가지 존재
          dept 1.table full access, 2. 인덱스 * 1 : 방법 2가지;
          가능한 경우의 수가 10가지
          방향성 emp, dept를 먼저 처리할지 ==> 20
                     
EXPLAIN PLAN FOR                     
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
  
SELECT *
FROM TABLE(dbms_xplan.display);

CREATE TABLE DEPT_TEST2 AS
SELECT *
FROM dept
WHERE 1 = 1;
CREATE UNIQUE INDEX idx_u_dept_test2_001 ON dept_test2 (deptno);
CREATE INDEX idx_nu_dept_test2_001 ON dept_test2 (dname);
CREATE INDEX idx_nu_dept_test2_002 ON dept_test2 (deptno, dname);

DROP INDEX idx_u_dept_test2_001;
DROP INDEX idx_nu_dept_test2_001;
DROP INDEX idx_nu_dept_test2_002;




CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE INDEX idx_nu_emp_02 emp (ename, deptno, hiredate);
CREATE INDEX idx_nu_emp_03 emp ();


1. empno(=)
2. ename(=)
3. deptno(=), empno(LIKE)
4. deptno(=), sal(between)s
5. deptno(=)
   empno(=)
6. deptno, hiredate 컬럼으로 구성된 인덱스가 있을경우 table 접근이 필요 없음

3. deptno(=), empno(LIKE)
4. deptno(=), sal(between)s
5. deptno(=)
   empno(=)
6. deptno, hiredate 컬럼으로 구성된 인덱스가 있을경우 table 접근이 필요 없음

1] empno (=)
2] ename (=)
3] deptno, empno, sal, hiredate

emp테이블에 데이터가 5천만건
10, 20, 30 데이터는 각각 50만건씩만 존재 ==> 인덱스 유리
40번데이터 4850만건 ==> table full access