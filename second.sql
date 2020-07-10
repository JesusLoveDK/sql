SELECT *
FROM dept;

첫번째 사용자가 dept테이블에 데이터를 입력후 트랜잭션을 확정짓지 않은 상태
4건조회
첫번째 사용자가 commit 실행
5건조회

UPDATE dept SET dname = '대덕'
WHERE deptno = 99;
commit;

선행 트랜잭션에서 99번부서를
FOR UPDATE로 조회
후행 트랜잭션에서는 수정이 불가능

UPDATE dept SET dname = 'DDIT'
WHERE deptno = 99;
ROLLBACK;
하지만 후행 트랜잭션에서 신규 입력은 가능
락을 걸려고 해도 존재하지 않는 데이터에 대한 락은 불가능하기 때문
이러한 현상을 Phantom Read - 없던 데이터가 새로 조회되는 현상 이라고 한다.

팬텀리드
INSERT INTO dept
VALUES (98, 'ddit', 'daejeon');
commit;
ROLLBACK;

SET TRANSACTION ISOLATION LEVEL
 SERIALIZABLE;
 
INSERT INTO dept 
    VALUES(97, 'ddit', 'daejeon');
COMMIT;