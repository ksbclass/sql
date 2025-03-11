/*
	단일행 서브 쿼리 : 서브쿼리의 결과가 1개 행인 경우
			 사용가능한 연산자 : =, >, <, <=,>=
	복수행(다중행) 서브 쿼리 : 서브 퀴의 결과가 여러개 행인 경우
			 사용가능한 연산자 : in ,>all,<any, ...
			 in : 같은 경우
			 any : 결과 중 한개만 조건 만족
			 all : 모두 결과가 조건 만족

다중컬럼 서브 쿼리 : 비교대상 컬럼이 2개인 경우

상호 연관 서브 쿼리 : 외부query 의 컬럼이 subquery에 영향을 주는 query
							 성능이 안좋다.

	DDL : Date Definition Language(데이터 정의어)
			객체의 구조를 생성,수정,제거하는 명령어
			create : 객체 생성 명령어
				table 생성 : create table
				user 생성 : create user
				index 생성 : create index
				...
				
		alter : 객체 수정 명령어. 컬럼 추가,컬럼제거, 컬럼의 크기 변경...
			컬럼 추가 : alter table 테이블명 add 컬럼명 자료형
			컬럼 크기 변경 : alter table 테이블명 modify 컬럼명 자료형
			컬럼 이름 변경 : alter table 테이블명 change 원본컬럼명 새로운 컬럼명 자료형
			컬럼 제거 : alter table 테이블명 drop 컬럼명
			제약조건 추가 : alter table 테이블명 add constraint ...
			제약조건 제거 : alter table 테이블명 drop constraint 제약조건 이름
		
		제약조건 조회 
			information_schema 데이터베이스 선택
			table_constraints 테이블 조회하기
*/

USE information_schema;

SELECT * FROM table_constraints;
WHERE TABLE_NAME ="professor_1";

USE gdjdb;

-- 제약조건 제거하기
-- 외래키 제거

ALTER TABLE professor_1 DROP FOREIGN KEY professor_1_ibfk_1;
ALTER TABLE professor_1 DROP foreign KEY professor_1_ibfk_2;

-- 기본키 제거

ALTER TABLE professor_1 DROP PRIMARY KEY;

/*
	drop 명령어 : 객체 제거
*/

SHOW TABLES;

DESC test1;

-- test1 테이블을 제거

DROP TABLE test1;
DESC test1;

/*
	truncate : 테이블과 데이터 분리
*/

SELECT * FROM professor_1;

-- delete 명령문 비교 : autocommit false 설정

SEt autocommit = FALSE ;
SHOW VARIABLES LIKE 'autocommit%';
-- delete 명령어로 데이터 제거 : rollback 가능
DELETE FROM professor_1;
SELECT * FROM professor_1;
ROLLBACK -- TCL 트랜젝션 실행 취소
SELECT * FROM professor_1;

-- truncate로 데이터 제거 : rollback 불가능.
TRUNCATE TABLE professor_1;
SELECT * FROM professor_1;
ROLLBACK;
SELECT * FROM professor_1;

/*
	DML : Date Manipulation Language : 데이터 처리(조작)어
			데이터의 추가 변경,삭제 언어
		insert : 데이터 추가  - C
		update : 데이터 수정,변경 - U
		delete : 데이터 삭제 - D
		select : 데이터 조회 - R
		
		CRUD : Create,Read,Update,Delete
	Transaction 처리가능 : commit,rollback 가능
*/

/*
	insert : 데이터(레코드) 추가
	insert into 테이블명 [(컬럼명1,컬럼명2,...)] values (값1,값2.....)
	 => 컬럼명의 갯수 값의 갯수 동일해야함.
	 컬럼명1 <= 값1
	 컬럼명2 <= 값2
	 ....
	 
	 컬럼명 부분을 구현하지않으면 스키마 정의된 순서대로 값을 입력해야함.
	 
	 -- 컬럼명 구현 해야하는 경우
	 1. 모든 컬럼의 값을 입력하지 않는 경우
	 2. 스키마의 순서를 모를때
	 3.db 구조의 변경이 자주 발생시 컬럼명을 기술하는 것이 안전함.
*/

SELECT * FROM depttest1;
-- depttest1 테이블에 90번 특판팀 추가하기
INSERT INTO depttest1 (deptno,dname) VALUES (90,'특판팀');
SELECT * FROM depttest1;
ROLLBACK; -- insert 실행 취소
SELECT * FROM depttest1;
-- depttest1 테이블에 91번 특판1팀 추가하기
INSERT INTO depttest1  VALUES (91,'특판1팀'); -- 컬럼부분이 없으면 스키마 순서대로 값 입력
INSERT INTO depttest1  VALUES (91,'특판1팀',NULL);
SELECT * FROM depttest1;
COMMIT; -- 실행완성
ROLLBACK; -- commit 이후의 rollback은 의미 없다

-- depttest1 테이블에 70,총무부 레코드 추가하기 -- 컬럼명 생략하기
-- depttest1 테이블에 80,인사부 레코드 추가하기 -- 컬럼명 기술하기

INSERT INTO depttest1 VALUES (70,'총무부',NULL);
INSERT INTO depttest1 (deptno,dname) VALUES (80,'인사부');
SELECT * FROM depttest1;

-- 여러개의 레코드를 한번 추가하기
-- (91, 특판1팀), (50,운용팀,울산) ,(70,총무부,울산),(80,인사부,서울)
SELECT * FROM depttest2;
INSERT INTO depttest2 VALUES 
(91,'특판1팀',null), 
(50,'운용팀','울산'),
(70,'총무부','울산'),
(80,'인사부','서울');
SELECT * FROM depttest2;

-- 기존의 테이블을 이용하여 데이터 추가하기

SELECT * FROM depttest3 ;
INSERT INTO depttest3 SELECT * FROM depttest2;
SELECT * FROM depttest3;

-- professor_1 테이블에 내용을 추가하기

SELECT * FROM professor_1;

INSERT INTO professor_1 (NO,NAME,deptno,POSITION,mname) 
SELECT p.no,p.name,p.deptno,p.position,m.name
FROM professor p , major m
WHERE p.deptno = m.code
 AND p.deptno =101; 
 
SELECT * FROM professor_1;

/*
	컬럼부분의 갯수와 select에서 조회되는 컬럼의 갯수가 동일 해야함.
*/

INSERT INTO professor_1 -- 컬럼의 갯수가 다르므로 오류 발생
SELECT * FROM professor p , major m
WHERE p.deptno = m.code
 AND p.deptno =101; 

-- 문제 
-- test3 테이블에 3학년 학생의 정보를 저장하기

SELECT * FROM test3;

INSERT INTO test3 (NO,NAME,birth) 
SELECT s.studno,s.`name`,s.birthday
FROM student s
WHERE grade =3 ;

SELECT * FROM test3;

/*
	update : 데이터의 내용을 변경하는 명령어
	
	update 테이블명 set 컬럼1 = 값1, 컬럼2 = 값2...
	[where 조건문] => 없는 경우 모든 레코드값이 변경
							있는 경우 조건문에 참인 레코드만 변경
*/
-- emp 테이블에서 사원직급인 경우 보너스 10만원 인상하기
-- 보너스가 없는경우도 10만원 변경하기

SELECT * from emp WHERE job='사원';
UPDATE emp SET bonus  = bonus + 10 -- null 일경우 변경안됨.
WHERE job = '사원';

SELECT * from emp WHERE job='사원';

ROLLBACK;

UPDATE emp SET bonus = IFNULL(bonus,0) +10
WHERE job = '사원';

SELECT * from emp WHERE job='사원';

-- 이상미 교수와 같은 직급의 교수 중 급여가 350 미만인 교수의 급여를 10% 인상하기
SELECT * FROM professor
WHERE position = (SELECT POSITION FROM professor WHERE NAME ='이상미')
  AND salary < 350;

UPDATE professor set salary = salary * 1.1
WHERE position = (SELECT POSITION FROM professor WHERE NAME ='이상미')
  AND salary < 350;

SELECT * FROM professor
WHERE position = (SELECT POSITION FROM professor WHERE NAME ='이상미');

-- 문제
-- 보너스가 없는 시간강사의 보너스를 조교수의 평균 보너스의 50% 로 변경하기
SELECT AVG(bonus) FROM professor
WHERE POSITION = '조교수' ;
SELECT * from professor WHERE POSITION = '시간강사' AND bonus IS NULL;

UPDATE professor SET bonus = 50
WHERE POSITION = "시간강사" AND bonus IS NULL;

ROLLBACK;

UPDATE professor 
SET bonus = (SELECT AVG(bonus)*0.5 FROM professor WHERE POSITION = '조교수')
WHERE POSITION = '시간강사' AND bonus IS NULL;

SELECT * from professor WHERE POSITION = '시간강사';

-- 지도교수가 없는 학생의 지도교수를 이용학생의 지도교수로 변경하기

SELECT * FROM student where profno IS NULL;
SELECT profno FROM student WHERE NAME = '이용';

UPDATE student 
SET profno = (SELECT profno FROM student WHERE NAME = '이용')
WHERE profno IS NULL ;

SELECT * FROM student WHERE grade = 1;

ROLLBACK;

-- 교수 중 김옥남 교수와 같은 직급의 교수 급여를 101학과의 평균 급여로 변경하기
-- 소숫점이하는 반올림하여 정수로 저장하기

SELECT position FROM professor WHERE NAME ='김옥남';
SELECT round(avg(salary)) FROM professor WHERE deptno =101;

UPDATE professor SET salary =(SELECT round(avg(salary)) FROM professor WHERE deptno =101)
WHERE POSITION = (SELECT position FROM professor WHERE NAME ='김옥남');

SELECT * FROM professor WHERE POSITION = '시간강사';

ROLLBACK;

/*
	delete : 레코드 삭제
	
	delete from 테이블명
	[where 조건문] => 조건문의 결과가 참인 레코드만 삭제
*/

SELECT * FROM depttest1;

-- depttest1의 모든 레코드를 삭제하기

DELETE FROM depttest1;

SELECT * FROM depttest2;

-- depttest2 테이블에서 기획부를 삭제하기
DELETE FROM depttest2 

WHERE dname = '기획부';

DELETE FROM depttest2 

-- depttest2 테이블에서 부서명에  '기' 문자가 있는  삭제
SELECT * FROM depttest2 WHERE dname like '%기%';
DELETE FROM depttest2 WHERE dname LIKE '%기%';
SELECT * FROM depttest2;

ROLLBACK;

-- 교수 중 김옥남 교수와 같은 부서의 교수정보 제거하기
SELECT * FROM professor
WHERE deptno =(SELECT deptno FROM professor WHERE NAME = '김옥남')

DELETE FROM  professor 
WHERE deptno = (SELECT deptno FROM professor WHERE NAME = '김옥남');

SELECT * FROM professor;

ROLLBACK;

/*
	SQL 의 종류
	DDL : 데이터 정의어. Date Definition Language
			create,alter ,drop,truncate
			Transaction 처리 안됨.autocommit 임.
*/
DELETE FROM  professor 
WHERE deptno = (SELECT deptno FROM professor WHERE NAME = '김옥남');

SELECT * FROM professor
WHERE deptno =(SELECT deptno FROM professor WHERE NAME = '김옥남');

DROP TABLE test2; -- DDL 명령 실행시 자동 commit 

ROLLBACK;

/*
	DML : 데이터 조작어(처리어). Date Maupulation Language
			insert(C),select(R),update(U),delete(D)
			Transaction 처리 가능 . rollback,commit 실행가능. 
			autocommit이 아닌 환경에서 rollback,commit 가능
	TCL : Transaction Control Language : 트랜잭션 제어 언어
		commit,rollback
	DCL : 데이터 제어어. Date Control Language => db 관리자의 언어
		grant : 사용자에게 db 권한 부여
		revoke : 사용자에게 부여되었던 권한 회수.제거
*/

