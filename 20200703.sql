1번문제

SELECT lprod_gu, lprod_nm, prod.prod_id, prod.PROD_NAME
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;

SELECT lprod_gu, lprod_nm, prod.prod_id, prod.prod_name
FROM lprod JOIN prod ON(lprod_gu = prod_lgu);

2번문제

SELECT buyer_id, buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id;

ANSI-SQL 조인법
FROM 테이블 1 JOIN 테이블 2 ON()

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE prod.prod_id = cart.cart_prod AND cart.cart_member = member.mem_id;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON ( member.mem_id = cart.cart_member) 
            JOIN prod ON (cart.cart_prod = prod.prod_id);
            
CUSTOMER = 고객
PRODUCT = 제품
CYCLE = 고객 제품 애음 주기

SELECT cnm
FROM customer;

4번문제
ANSI
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid)
WHERE customer.cid IN(1, 2);
ORACLE
SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid 
  AND customer.cnm IN ('brown', 'sally');

5번문제
SELECT  customer.cid, customer.cnm, product.pid, product.pnm, cycle.cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid)
              JOIN product ON(cycle.pid = product.pid)
WHERE customer.cid IN(1, 2);
ORACLE
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN ('brown', 'sally');
6번문제
SELECT customer.*, cycle.pid, product.pnm,SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;
7번문제
SELECT product.pid, product.pnm, sum(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY product.pid, product.pnm;

조인 성공 여부로 데이터 조회를 결정하는 구분방법
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인 방법
OUTER JOIN : 조인에 실패하더라도 개발자가 지정한 기준이 되는 테이블의 데이터는 나오도록 하는 조인

 - left outer join
 - right outer join
 - full outer join(left + right)
 
 복습 - 사원의 관리자 이름을 알고 싶다.
    조회 컬럼 : 사번, 사원명, 사원 관리자의 사번, 사원 관리자명
    
동일한 테이블끼리 조인되었기 때문에 : SELF-JOIN
조인 조건을 만족하는 데이터만 조회되었기 때문에 : INNER-JOIN
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

KING의 경우 PRESIDENT이기 때문에 mgr 컬럼의 값이 NULL ==> 조인에 실패
==> KING의 데이터는 조회되지 않음(총 14건 데이터중 13건의 데이터만 조인 성공)

OUTER 조인을 이용하여 조인 테이블중 기준이 되는 테이블을 선택하면
JOIN에 실패하더라도 기준 테이블의 데이터는 조회되도록 할 수 있다.
ANSI-SQL
테이블1 JOIN 테이블2 ON (.....)
테이블1 LEFT OUTER JOIN 테이블2 ON (.....)
위 쿼리는 아래와 동일
테이블2 RIGHT OUTER JOIN 테이블1 ON (.....)

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);