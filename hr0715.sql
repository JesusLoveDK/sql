SELECT *
FROM JesusLoveDK.v_emp;

sem.v_emp ==> v_emp 시노님을 생성

CREATE SYNONYM v_emp FOR JesusLoveDK.v_emp;

SELECT *
FROM v_emp;

SYNONYM : 오라클 객체 별칭을 생성
JesusLoveDK.v_emp => v_emp

생성방법
CREATE SYNONYM 시노님이름 FOR 원본객체이름;
PUBLIC : 모든 사용자가 사용할 수 있는 시노님
         권한이 있어야 생성가능
PRIVATE [DEFAULT] : 해당 사용자만 사용할 수 있는 시노님

삭제방법
DROP SYNONYM 시노님이름;