-- desc : 테이블의 구조(스키마) 조회
-- desc 테이블명
DESC dept;

-- SQL : Structured Query Language : 관계형 데이터 베이스(RDBMS)에서 
-- 		데이터를 처리를 위한 언어.
-- select : 데이터 조회를 위한 언어
-- emp 테이블의 모든 테이터를 조회하기
SELECT * FROM emp;
-- emp 테이블의 empno,ename,depto 컬럼의 모든 레코드틀 조회하기
SELECT empno,ename,deptno FROM emp;

-- 리터널 컬럼 사용하기 : 상수값을 사용하기
-- 학생(student)의 이름뒤에 학생 문자열을 붙여서 조회하기
SELECT NAME,'학생'
FROM student;
/*
1. 교수 테이블(professor)의 구조 조회하기
*/
DESC professor;
/*
2. 교수 테이블(professor)에서 교수번호(no), 교수이름(name),'교수'문자열을 붙여서
	조회하기
*/
/*
	문자열형 상수 : 작은따음표, 큰따음표 동일함
	오라클db에서는 작은따음표만 가능함.
*/
SELECT NO,NAME,'교수' FROM  professor;
SELECT NO,NAME,"교수" FROM  professor;

-- 컬럼에 별명(alias) 설정하기 : 조회되는 컬럼명을 변경하기
SELECT NO 교수번호,NAME 교수이름,'교수' FROM  professor;
SELECT NO '교수번호',NAME '교수이름','교수' FROM  professor;
SELECT NO '교수 번호',NAME '교수 이름','교수' FROM  professor;
SELECT NO AS  '교수 번호',NAME AS '교수 이름','교수' FROM  professor;

-- 컬럼에 연산자(+,-,*,/) 사용하기
-- emp 테이블에서 사원이름(ename), 현재급여(salary),10%인상 예상 급여 조회하기
SELECT ename,salary,salary*1.1 FROM emp;

-- distinct : 중복을 제거하고 하나만 조회
--				 	컬럼의 처음에 한번만 구현해야 함
-- 교수(professor) 테이블에서 교수가 속한 부서코드(deptno)를 조회 하기 
SELECT distinct deptno FROM professor;
-- 교수(professor) 테이블에서 교수가 속한 직급(position)를 조회 하기 
SELECT POSITION FROM professor;
SELECT DISTINCT POSITION FROM professor;
-- 교수(professor) 테이블에서 부서별교수가 속한 직급(position)를 조회 하기 
-- 여러개의 컬럼앞의 distinct 는 기술된 컬럼의 값들이 중복되지않도록 조회함
-- SELECT DISTINCT deptno,DISTINCT POSITION FROM professor ;-- 오류 발생
SELECT DISTINCT deptno,POSITION FROM professor;
/*
	select 컬럼명(컬럼,리터널 컬럼, 연산된 컬럼,*,별명,distict)
	from 	 테이블명 
	where 레코드 선택 조건
			조건문이 없는 경우 : 모든 레코드를 조회
			조건문이 있는 경우 : 조건문의 결과가 참인 레코드만 조회			
*/
--  학생테이블 (student)에서 1학년 학생의 모든 컬럼을 조회하기

SELECT * FROM student WHERE grade =1;

--  학생테이블 (student)에서 3학년 학생중 전공1코드(major1)가 101 인학생의
-- 학번(studno),이름(name),학년(grade), 전공1학과(mahor1) 컬럼 조회하기
-- 논리연산 : and,or

SELECT studno,NAME,grade,major1
FROM student
WHERE grade=3 AND major1 =101

--  학생테이블 (student)에서 3학년 학생이거나  전공1코드(major1)가 101 인학생의
-- 학번(studno),이름(name),학년(grade), 전공1학과(mahor1) 컬럼 조회하기

SELECT studno,NAME,grade,major1
FROM student
WHERE grade=3 OR major1 =101
/*
	문제
	1.emp테이블에서 부서코드가 10인 사원의 이름(ename),급여(salary), 부서코드(deptno) 를 결과와 같이 출력하기
*/

SELECT ename,salary,deptno
FROM emp
WHERE deptno=10;

/*
2.emp테이블에서 급여가 800보다 큰사람의 이름과 급여를 결과와 같이 출력하기
*/

SELECT ename,salary
FROM emp
WHERE salary>800;

/*
3.professor 테이블에서 직급이 정교수인 교수의 이름과 부서코드, 직급을 결과와 같이 출력하기
*/

SELECT NAME,deptno,POSITION
FROM professor
WHERE POSITION='정교수';

-- where 조건문에 연산처리하기
-- emp테이블에서 모든 사원의 급여를 10% 인상 예정 급여가 1000이상인
-- 사원의 이름, 현재급여,인상예정급여, 부서코드 조회하기

SELECT ename,salary,salary*1.1,deptno FROM emp
WHERE salary*1.1 >=1000;

-- where 조건문에서 사용되는 연산자--
-- between : 범위 지정 연산자
-- where 컬럼명 between A and B => 컬럼의 값이 A이상B이하인 레코드 선택
-- 학생 중 1,2 학생의 모든 컬럼을 조회하기
SELECT * FROM student WHERE grade=1 OR grade=2;
SELECT * FROM student WHERE grade>=1 AND grade<=2;
SELECT * FROM student WHERE grade BETWEEN 1 AND 2;

--문제
-- 1학년 학생 중 몸무게(weight)가 70이상 80 이하인 학생의
-- 이름(name),학년(grade),몸무게(weight),전공1학과(major1) 조회하기 
-- 관계 연산자
SELECT NAME,grade,weight,major1 FROM student 
WHERE grade=1 AND weight >=70 AND weight <= 80;
-- between 연산자 이용
SELECT NAME,grade,weight,major1 FROM student 
WHERE grade=1 AND weight BETWEEN 70 AND 80;

-- 제1 전공학과가 101번 학생 중 몸무게가 50이상 80이하인 학생의 이름(name), 몸무게(weight), 1전공학과코드(major1)를 출력하기
SELECT NAME,weight,major1 FROM student
WHERE major1 = 101 AND weight >= 50 AND weight <=80; 
SELECT NAME,weight,major1 FROM student
WHERE major1 = 101 AND weight BETWEEN 50 AND 80; 

/*
	where 조건문 의 연산자 : in
									 or 조건문으로 표현 가능
*/
-- 전공학과가 101,201 학과에 속한 학생의 모든정보 조회하기
SELECT * FROM student WHERE major1 =101 OR major1 =201;
SELECT * FROM student WHERE major1 IN (101,201);

--교수 중 학과코드가 101,201 학과에 속한 교수의 교수번호(no),
-- 교수이름(name),학과코드(deptno),입사일(hiredate) 조회하기
SELECT NO,NAME,deptno,hiredate
FROM professor
WHERE deptno IN (101,201);
-- 101,201 전공학과1 학생중 키가 170이상인 학생의
-- 학번(studno),이름(name),몸무게(weight),키(height),학과코드(major1) 조회하기
SELECT studno,NAME,weight,height,major1 
FROM student
WHERE major1 IN (101,201) AND height >=170;

-- not in 연산자 
-- 101,201 전공학과1 속한 학생이 아닌 학생중 키가 170이상인 학생의
-- 학번(studno),이름(name),몸무게(weight),키(height),학과코드(major1) 조회하기
SELECT studno,NAME,weight,height,major1 
FROM student
WHERE major1 not IN (101,201) AND height >=170;
/*
	like 연산자 : 일부분이 일치하면 
		% : 0개이상 임의의 문자
		_ : 1개의 임의의 문자
*/
-- 학생의 성이 김씨인 학생의 학번,이름,학과코드1 조회하기

SELECT studno,NAME,major1
FROM student
WHERE NAME LIKE '김%';

-- 학생의 이름중 진을 가진 학생의 학번,이름,학과코드1 조회하기

SELECT studno,NAME,major1
FROM student
WHERE NAME LIKE '%진%';

-- 학생의 이름이 2자인 학생의 학번,이름,학과코드1 조회하기

SELECT studno,NAME,major1
FROM student
WHERE NAME LIKE '__';
/*
	문제
	1.학생중 이름의 끝자가 '훈'인 학생의 학번,이름,전공코드1 출력하기
	2. 학생 중 전화번호(tel)가 서울 지역(02)인 학생의 이름,학번,전화번호 출력하기
*/
-- 1번

SELECT studno, NAME,major1
FROM student
WHERE NAME LIKE '%훈';

-- 2번

SELECT studno,NAME,tel
FROM student
WHERE tel LIKE '02%';

-- 교수 테이블에 id 내용에 k 문자를 가지고 있는 교수의 이름,id ,직급 조회하기
-- like에서 대소문자 구분 안함. 오라클은 대소문자 구분함.

SELECT name,id,POSITION
FROM professor
WHERE id LIKE '%k%';

SELECT name,id,POSITION
FROM professor
WHERE id LIKE '%K%';
-- 대소문자 구분을 위해서는 binary 예약어를 사용함.

SELECT NAME,id,POSITION
FROM professor
WHERE id LIKE BINARY '%K%';

SELECT name,id,POSITION
FROM professor
WHERE id LIKE BINARY '%k%';

-- not like 연산자 : like 반대
-- 학생 중 성이 이씨가 아닌 학생의 학번,이름,전공코드1을 조회하기

SELECT studno,NAME,major1
FROM student
WHERE NAME NOT LIKE '이%';

/*
문제
	1.학생의 이름중 성이 김씨가 아닌 학생의 이름,학년,전공1학과 조회하기
	2.교수 테이블에서 101,201 학과에 속한 교수가 아닌 경우 성이 김씨가 아닌 교수의
	이름,학과 코드,직급을 조회하기
*/
-- 1번

SELECT NAME,grade,major1
FROM student
WHERE NAME NOT LIKE '김%';

-- 2번

SELECT NAME,deptno,POSITION 
FROM professor
WHERE deptno not IN (101,201) AND name NOT LIKE '김%';

/*
	null 의미 : 값이 없다. 비교 대상이 안됨.
	is null : 컬럼의 값이 null 인 경우
	is not null : 컬럼의 값이 null 이 아닌경우
*/

-- 교수중에 보너스가 없는 교수의 이름(name),급여(salary),보너스(bonus)를 조회하자

SELECT NAME,salary,bonus
FROM professor
WHERE bonus = NULL; -- null은 비교 대상이 아님.

SELECT NAME,salary,bonus
FROM professor
WHERE bonus IS NULL;

-- 교수중에 보너스가 없는 교수의 이름(name),급여(salary),보너스(bonus)를 조회하자

SELECT NAME,salary,bonus
FROM professor
WHERE bonus IS NOT NULL;

/*
	학생 중 지도교수가 없는 학생의 학번(studno), 이름(name),전공학과1(major1)
	지도교수번호(profno)를 조회하기
*/

SELECT studno,NAME,major1,profno
FROM student
WHERE profno IS NULL;

/*
	학생 중 지도교수가 있는 학생의 학번(studno), 이름(name),전공학과1(major1)
	지도교수번호(profno)를 조회하기
*/

SELECT studno,NAME,major1,profno
FROM student
WHERE profno IS NOT NULL;

-- 교수의 교수번호(no),교수이름(name)현재급여(salary), 상여금(bonus),통상급여(salary+bonus) 조회하기

SELECT NO 교수번호,NAME 교수이름,salary 현재급여,bonus 보너스,
	salary+bonus 통상급여 FROM professor;

/*
	null은 비교연산의 대상이 아님
	null값과 연산의 결과는 null 임.
*/

-- 교수중 보너스가 있는 교수의 이름,급여,보너스, 연봉을 조회하자
-- 연봉 : 급여*12+보너스

SELECT NAME 교수이름,salary 급여,bonus 보너스, salary*12+bonus 연봉
FROM professor
WHERE bonus IS NOT NULL;

-- 교수중 보너스가 없는 교수의 이름,급여,연봉을 조회하자
-- 연봉 : 급여*12

SELECT NAME 교수이름,salary 급여,bonus 보너스 ,salary*12 연봉
FROM professor
WHERE bonus IS NULL;

/*
	select *(모든 컬럼),컬럼명1,컬럼명2,....=>컬럼을 선택	 --3
	from 테이블명														--1
	[where 조건문]														 --2
			where 조건문이 생략되면 모든 레코드를 선택
			where 조건문의 결과가 참인 레코드만 선택
	[order by 컬러명 | 조회된 컴럼순서| 별명| [asc|desc]]  --4
	asc : 오름차순 desc : 내림차순
																select 문장의 마지막에 생성
	order by : 정렬관련 구문
		오름 차순 정렬 : 작은값에서  큰값으로 asc 예약어. 기본값, 생략가능
		내림 차순 정렬 : 큰갑에서 작은값으로 desc 예약어.생략불가능
*/

-- 1학년 학생의 이름,키를 조회하기. 키가 큰수으로 출력하기\
-- (1)컬럼명으로 정렬하기

SELECT NAME,height 
FROM student
WHERE grade =1 
ORDER BY height DESC;

-- (2)조회된 컬럼순서로 정렬하기. height가 2번째 조회된 컬럼이므로 2

SELECT NAME,height 
FROM student
WHERE grade =1 
ORDER BY 2 DESC;

-- (3) 별명으로 정렬하기

SELECT NAME 이름,height 키 
FROM student
WHERE grade =1 
ORDER BY 키 DESC;

-- 학생의 이름, 학년,키 조회하기. 학년순,키가 큰순으로 출력하기

SELECT NAME, grade, height
FROM student
ORDER BY grade ASC , height DESC;

SELECT NAME, grade, height
FROM student
ORDER BY 2 ASC,3 DESC;

-- 컬럼의 순서나 별명으로 정렬시는 반드시 해당 컬럼이 조회되어야한다.
-- 컬럼명으로 정렬시는 조회된 컬럼이 아니어도 가능함.
-- 1학년 학생의 이름 조회하기.키가 큰순으로 출력하기

SELECT NAME FROM student WHERE grade=1 ORDER BY height DESC;

SELECT NAME FROM student WHERE grade=1 ORDER BY 2 DESC ;
-- 오류 발생. 키는 조회된 컬럼이 아님.

/*
문제 : 
	1.교수테이블(professor)에서
	교수번호,교수이름, 학과코드(deptno),급여,예상급여(10% 인상) 출력하기
	단학과 코드 순으로 예상 급여의 역순으로 조회하기
	
	2.학생테이블에서 지도교수(profno)가 배정되지 않은 학생의 학번, 이름, 지도교수번호, 전공1코드 출력하기 단 학과코드 순으로 정렬하기
	
	3.1학년 학생의 이름, 키, 몸무게 출력하기 단 키는 작은순으로 몸무게는 큰순으로 출력하기
*/

-- 1
SELECT no,NAME,deptno,salary,salary*1.1 예상급여
FROM professor
ORDER BY deptno ASC, salary*1.1 DESC;

SELECT no,NAME,deptno,salary,salary*1.1 예상급여
FROM professor
ORDER BY 3 ASC, 5 DESC;

-- 2
SELECT studno,NAME,profno,major1
FROM student
WHERE profno IS NULL
ORDER BY major1;

SELECT studno,NAME,profno,major1
FROM student
WHERE profno IS NULL
ORDER BY 4;

-- 3
SELECT NAME, height,weight
FROM student
WHERE grade =1
ORDER BY height asc,weight desc

SELECT NAME, height,weight
FROM student
WHERE grade =1
ORDER BY 2 ASC, 3 DESC ;

