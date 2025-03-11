/*
	join 구문 : 여러개의 테이블을 연결하여 데이터를 조회.
		cross join : m*n 개수로 레코드 생성. 사용시 주의요함
		등가 조안(euqi join) : 조인컬럼을 이용하여 조건의 맞는 레코드만 선택.조인컬럼의 조건문이 = 인경우
		비 등가 조안(euqi join) : 조인컬럼을 이용하여 조건의 맞는 레코드만 선택.조인컬럼의 조건문이 = 아닌경우
		self join (자기 조인) : 같은테이블을 join하는경우
										테이블의 별명 설정, 컬럼 조회시 별명 설정
										
		inner join : 조인컬럼을 이용하여 조건의 맞는 레코드만 선택.
		outer join : 조인컬럼을 이용하여 조건의 맞는 레코드만 선택.
						 한쪽 또는 양쪽테이블에서 조건 맞지 않아도 선택.
			left outer join : 왼쪽테이블의 내용은 전부 조회
									left join 예약어
			right outer join : 오른쪽테이블의 내용은 전부 조회
									right join 예약어
			full outer join : 양쪽테이블의 내용은 전부 조회
									union 사용하여 구현
*/
/*
	subquery : select 구문 내부에 select 구문이 존재함
				  where 조건문에서 사용되는 select 구문
	subquery 가능 부분
		where 조건문 : subquery
		from			 : inline 뷰
		컬럼부분		:  스칼라 subquery
		having
*/

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

*/

-- emp 테이블에서 김지애 사원보다 많은 급여를 받는 직원의 정보 조회하기

-- 1. 김지애 직원의 급여 조회하기

SELECT salary FROM emp WHERE ename='김지애';

-- 2. 550 보다 많은 급여를 받는 직원의 정보 조회하기

SELECT * FROM emp WHERE salary > 550;

-- 1,2 동시에 가능

SELECT * FROM emp 
WHERE  salary > (SELECT salary FROM emp WHERE ename='김지애');

-- 문제
-- 김종연 학생보다 윗학년의 이름과, 학년,전공번호1 ,학과명 출력하기

SELECT s.`name`,s.grade,s.major1,m.`name`
FROM student s , major m
WHERE s.major1 = m.code AND s.grade > (SELECT grade FROM student where NAME = '김종연');

-- 문제
-- 사원테이블에서 사원직급의 평균급여보다 적게 받는 직원의 사원번호, 이름, 직급,급여를 출력하기

SELECT e.empno,e.ename,e.salary,e.job
FROM emp e
WHERE e.salary < (SELECT avg(salary) FROM emp WHERE job ='사원');

/*
	복수행 서브쿼리
*/

-- emp, dept 테이블을 이용하여 근무지역인 서울인 사원의 사원번호,이름,부서코드,부서명을 조회하기

SELECT * FROM dept;

SELECT e.empno, e.ename,e.deptno,d.dname 
FROM emp e , dept d
WHERE e.deptno = d.deptno AND e.deptno IN (10,20,30,40);

SELECT e.empno, e.ename,e.deptno,d.dname 
FROM emp e , dept d
WHERE e.deptno = d.deptno AND e.deptno IN (SELECT deptno FROM dept WHERE loc = "서울");

-- 문제
-- 1학년 학생과 같은키를 가지고 있는 2학년학생의 이름,키, 학년 조회하기

SELECT s.`name`,s.height,s.grade
FROM student s
WHERE s.grade =2 AND height IN (SELECT height FROM student WHERE grade=1 );

-- 사원직급의 최대 급여보다 급여가 높은 직원의 이름, 직급,급여 조회하기

SELECT e.ename,e.job,e.salary
FROM emp e
WHERE e.salary > (SELECT max(salary)FROM emp WHERE job="사원");

-- >all : 복수결과값 모든값보다 큰 경우 . 그룹함수 사용
-- <all : 복수결과값 모든값보다 작은 경우
-- >any : 복수결과값 중 한개보다 큰 경우 . 그룹함수 사용
-- <any : 복수결과값 중 한개보다 작은 경우

SELECT salary FROM emp WHERE job = '사원';

SELECT e.ename,e.job,e.salary
FROM emp e
WHERE e.salary >all (SELECT (salary)FROM emp WHERE job="사원");

SELECT e.ename,e.job,e.salary
FROM emp e
WHERE e.salary <all (SELECT (salary)FROM emp WHERE job="사원");

-- 문제 
-- major 테이블에서 컴퓨터 정보학부에 소속된 학생의 학번,이름,학과번호, 학과명을 출력하기

SELECT s.studno,s.`name`,s.major1,m.`name`
FROM student s, major m
WHERE s.major1 = m.code
AND m.part IN (SELECT code FROM major  WHERE NAME = '컴퓨터정보학부' );

SELECT s.studno,s.`name`,s.major1,m.`name`
FROM student s, major m
WHERE s.major1 = m.code
AND m.part =100;

SELECT s.studno,s.`name`,s.major1,m.`name`
FROM student s, major m
WHERE s.major1 = m.code
AND s.major1 IN
(SELECT CODE FROM major WHERE part = 
(SELECT code FROM major  WHERE NAME = '컴퓨터정보학부' ));

/*
	다중컬럼 서브 쿼리 : 비교대상 컬럼이 2개인 경우
*/

-- 학년별로 최대키를 가진 학생의 학년,이름,키 조회하기

SELECT grade,MAX(height)
FROM student 
GROUP BY grade;

SELECT grade,name,height , MAX(height)
FROM student
GROUP BY grade;

SELECT grade,NAME,height
FROM student
WHERE grade =1 AND height = (SELECT MAX(height) FROM student WHERE grade =1)
union
SELECT grade,NAME,height
FROM student
WHERE grade =2 AND height = (SELECT MAX(height) FROM student WHERE grade =2)
union
SELECT grade,NAME,height
FROM student
WHERE grade =3 AND height = (SELECT MAX(height) FROM student WHERE grade =3)
union
SELECT grade,NAME,height
FROM student
WHERE grade =4 AND height = (SELECT MAX(height) FROM student WHERE grade =4);

SELECT grade,NAME,height
FROM student
WHERE (grade,height) IN  -- 다중컬럼 서브쿼리
(SELECT grade, MAX(height) FROM student GROUP BY grade);

-- emp 테이블에서 직급별 해당 직급의 최대 급여를 받는 직원의 정보조회하기

SELECT * FROM emp
WHERE (job,salary) IN (SELECT job,MAX(salary)FROM emp GROUP BY job);

-- 문제 
-- 학과별 입사일 가장 오랜된 교수의 교수번호,이름,입사일,학과명 조회하기

SELECT p.no,p.`name`,p.hiredate,m.`name`
FROM professor p , major m
WHERE p.deptno = m.code AND (p.deptno,p.hiredate) IN 
(SELECT deptno,MIN(hiredate) FROM professor GROUP BY deptno);

/*
	상호 연관 서브 쿼리 : 외부query 의 컬럼이 subquery에 영향을 주는 query
								 성능이 안좋다. 
*/

-- 직원의 현재 직급의 평균 급여 이상의 급여를 받는 직원의 정보를 조회하기

SELECT * FROM emp e1
WHERE salary >= (SELECT AVG(salary) FROM emp e2 WHERE e2.job = e1.job);

-- 문제
-- 교수 본인 직급의 평균 급여 이상을 받는 교수의 이름,직급,급여  조회하기

SELECT p1.`name`,p1.`position`,p1.salary
FROM professor p1
WHERE salary >= (SELECT AVG (salary) FROM professor p2 WHERE p2.position = p1.`position`);

-- 사원이름, 직급, 부서코드,부서명 조회하기

SELECT e.ename,e.job,e.deptno,d.dname
FROM emp e , dept d
WHERE e.deptno = d.deptno;

-- join을 사용하지 않고 조회하기
-- 컬럼부분에 subquery 사용하기 => 스칼라 sub query 방식

SELECT ename,job,deptno,
(SELECT d.dname FROM dept d WHERE d.deptno = e.deptno)  부서명
FROM emp e;

-- 학년별 평균체중이 가장 적은 학년의 학년과 평균 체중 조회하기
-- from 구문에 사용되는 subquery => inline 뷰 sub query
-- 		inline 뷰에서 반드시 테이블의 별명을 작성해야한다. 

SELECT * FROM 
(SELECT grade,AVG(weight) avg FROM student GROUP BY grade) a
WHERE AVG = (SELECT MIN(AVG) 
		FROM (SELECT grade,AVG(weight)avg FROM student GROUP BY grade) a)
		
SELECT grade,MIN(AVG) FROM
(SELECT grade, AVG(weight) AVG FROM student GROUP BY grade order BY 2) a


/*
	DDL : Date Definition Language(데이터 정의어)
			객체의 구조를 생성,수정,제거하는 명령어
			create : 객체 생성 명령어
				table 생성 : create table
				user 생성 : create user
				index 생성 : create index
				...
				
		alter : 객체 수정 명령어. 컬럼 추가,컬럼제거, 컬럼의 크기 변경...
		drop : 객체 제거 명렁어 
		truncate : 데이터를 제거. 데이터랑 객체를 분리. 객체와 데이터 분리.
		
	DDL의 특징 : transaction 처리안됨. commit, rollback 관련 명령어

	transaction : 최소 업무 단위.	all or nothing
*/

/*
계좌이체

- 출금 1. 출금계좌에서 확인
		 2. 출금계좌에서 잔액차감
		 3. 출금계좌와 거래내역추가
		 4. 회계처리. 
- 입금 1. 입금계좌 확인
		 2. 입금계좌에 잔액 증가 
		 3. 입금계좌에 거래내역 추가
		 4. 회계처리. 
- 모든 거래 정상 : commit
*/

-- create : table 생성 명령어
-- no(int),name(varchar(20)),birth(datetime) 컬럼을 가진 test1 테이블 생성하기

CREATE TABLE test1(
	NO INT ,
	NAME VARCHAR(20),
	birth datetime
)

-- DESC 명령어로 스키마 조회

DESC test1

-- 기본키 : Primary Key. 각각의 레코드를 구분할 수 있는 데이터
--				학번, 주민번호....
--				기본키의 컬럼값은 중복불가. 유일한 컬럼값을 가짐. 값이 존재한다( null 불가능).

-- create : table 생성 명령어
-- no(int),name(varchar(20)),birth(datetime) 컬럼을 가진 test2 테이블 생성하기 . 단 no 를 기본키로 설정하기

CREATE TABLE test2(
	NO INT PRIMARY KEY AUTO_INCREMENT, -- 제약조건
	NAME VARCHAR(20),
	birth datetime
);

DESC test2;

-- create : table 생성 명령어
-- no(int),name(varchar(20)),birth(datetime) 컬럼을 가진 test3 테이블 생성하기 . 단 no 를 기본키로 설정하기

CREATE TABLE test3(
	NO INT ,
	NAME VARCHAR(20),
	birth DATETIME,
	PRIMARY KEY(NO)
);

DESC test3;

-- AUTO_INCREMENT : 자동으로 1 씩 증가. 숫자형 기본키에서만 사용가능
-- 오라클에서는 사용 불가능 => 시퀸스 객체를 이용함.

INSERT INTO test2 (NAME,birth) VALUES ('홍길동','1990-01-01');
SELECT * FROM test2;


-- 기본키 컬럼이 여러개로 설정하기

CREATE TABLE test4(
	NO INT,
	seq INT,
	NAME VARCHAR(20),
	PRIMARY KEY (NO,seq)
);

DESC test4;

/*
	no	  seq 
	1		1 		가능
	1		2		가능
	2		1		가능
	2		1		불가능 = 기본키가 중복됨.
	
	기본키는 테이블당 한개만 가능. 여러개 중복컬럼은 가능. unique + not null 기능
*/

/*
	컬럼에 기본값 설정하기
	default : 값이 없으면 기본값으로 설정
*/

CREATE TABLE test5 (
	NO INT PRIMARY KEY,
	NAME VARCHAR(30) DEFAULT "홍길동" -- 값이 없으면 홍길동 대입
);

DESC test5;

INSERT INTO test5 (NO) VALUES (1); -- primary 꼭 넣어야됨

SELECT * FROM test5 ;

/*
	create table 테이블명 (
		컬럼명 1 자료형 [제약조건 : 기본키, auto_increment, default],
		컬럼명 2 자료형 ...
		...
		primary key(컬럼1,컬럼2) 기본키 설정
	)
*/

/*
	기존테이블을 이용하여 새로운 테이블 생성하기
*/

-- dept 테이블의 모든 컬럼과 모든 레코드를 가진 depttes1 생성하기

CREATE TABLE depttest1 AS SELECT * FROM dept; -- 제약조건에 대해서는 복사 불가능

SELECT * FROM depttest1;

DESC dept ;

DESC depttest1 ;

-- dept 테이블의 모든 컬럼과 지역인 서울인  레코드만  가진 depttes2 생성하기

CREATE TABLE depttest2 AS 
SELECT * FROM dept
WHERE loc = '서울' ;

SELECT * FROM depttest2;

-- dept 테이블의 deptno,danme 컬럼가지고 있고, 레코드 없는 테이블 
-- depttest3 생성하기

CREATE TABLE depttest3 AS SELECT deptno,dname FROM dept WHERE 1=2 ;

SELECT * from depttest3;

-- 문제
-- 교수테이블에서 101학과 교수들만 professor_101 테이블생성하기
-- 필요한 컬럼 : 교수번호,이름,학과코드,직책,학과명

CREATE TABLE professor_101 AS 
SELECT p.no,p.`name`,p.deptno,p.`position`, m.name mname
from professor p , major m
WHERE deptno= '101' AND p.deptno = m.code;

SELECT * FROM  professor_101 ;


CREATE TABLE professor_1 AS 
SELECT p.no,p.`name`,p.deptno,p.`position`, m.name mname
from professor p , major m
WHERE deptno= '101' AND p.deptno = m.code;

SELECT * FROM  professor_1 ;

DESC professor_1;

-- 문제
-- 학생테이블에서 1학년 학생들만 student1 테이블로 생성하기
-- 필요컬럼 학번,이름,전공1학과 코드, 학과명

CREATE TABLE student1 AS 
SELECT s.studno , s.`name`, s.major1 , m.`name` mname
FROM student s , major m
WHERE s.major1 = m.code 
AND grade = 1  ;

SELECT * FROM student1;

-- datebase 의 table 들의 목록 조회

SHOW TABLES; 

CREATE sequence testseq; -- => 시퀀스 객체 생성

/*
	alter : 테이블 구조 수정.
*/

DESC depttest3;

-- depttest3 테이블에 loc 컬럼 추가하기

SELECT * FROM depttest3;

ALTER TABLE depttest3 ADD loc VARCHAR(30)

SELECT * FROM depttest3;

DESC depttest3;

-- depttest3 테이블에 int 형 컬럼 part 컬럼 추가

ALTER TABLE depttest3 ADD part INT;

SELECT * FROM depttest3;

DESC depttest3;

-- part 컬럼의 자료형을 int -> int(2) 변경

ALTER TABLE depttest3 MODIFY part INT(2);

DESC depttest3;

-- 문제
-- depttest3 테이블의 loc 컬럼 varchar(100) 크기 변경

ALTER TABLE depttest3 MODIFY loc VARCHAR(100);

DESC depttest3;

-- depttest3 테이블에 part 컬럼 제거하기

ALTER TABLE depttest3 DROP part;

DESC depttest3;

-- depttest3 테이블에 loc 컬럼의 이름을 area 이름으로 변경하기

ALTER TABLE depttest3 CHANGE loc AREA VARCHAR(30);

DESC depttest3;

ALTER TABLE depttest3 CHANGE AREA loc VARCHAR(100);

DESC depttest3;

/*
	컬럼 관련 구조 수정 
		컬럼 추가 : add 컬럼명 자료형
		컬럼 크기 변경 : modify 컬럼명 자료형
		컬럼 삭제 : drop 컬럼명
		컬럼 이름 변경(자료형 변경) : change 원래컬럼명 변경컬럼명 자료형
*/

/*
	제약조건 수정
*/

-- depttest3 테이블 deptno 기본키 설정하기

ALTER TABLE depttest3 ADD CONSTRAINT PRIMARY KEY (deptno);
DESC depttest3 ;

-- professor_1 테이블의 no 컬럼은 professor 테이블의 no 컬럼을
-- 참조 하도록 외래키로 설정

ALTER TABLE professor_1 ADD CONSTRAINT FOREIGN KEY (NO) 
REFERENCES professor(NO);

DESC professor_1 ; 

SELECT no FROM professor;
SELECT NO FROM professor_1;

-- professor_1 테이블 2000 인 교수 추가하기

INSERT INTO professor_1 (NO,NAME,POSITION,mname)
VALUE(2000,'임시','임시강사','임시학과') -- => 오류

INSERT INTO professor_1 (NO,NAME,POSITION,mname)
VALUE(5010,'임시','임시강사','임시학과')

SELECT * FROM professor_1;

-- professor_1 테이블에 deptno 컬럼은 major 테이블의 code 컬럼을 참조하도록 외래키로 설정

ALTER TABLE professor_1 ADD CONSTRAINT FOREIGN KEY (deptno)
REFERENCES major(CODE);

DESC professor_1 

-- 문제
-- professor_1 테이블 기본키 설정하기 no 컬럼으로 기본키 설정하기

ALTER TABLE professor_1 ADD CONSTRAINT PRIMARY KEY (NO);

DESC professor_1

-- 하나의 테이블에 외래키는 여러개 가능함
-- 하나의 테이블에 기본키는 한개만 가능함.

ALTER TABLE professor_1 ADD CONSTRAINT PRIMARY KEY (NAME); -- 오류 발생 기본키는 한개만 가능하기 때문에 오류

-- 제약조건  조회하기

USE information_schema -- information_schema database 선택
							  -- information_schema의 테이블/뷰를 사용하기

SELECT * FROM table_constraints
WHERE TABLE_NAME= 'professor_1' ;

USE gdjdb
SELECT * FROM student;