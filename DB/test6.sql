-- 1. 테이블 test11를 생성하기. 
--    컬럼은 정수형인 no 가 기본키로 
--    name 문자형 20자리
--    tel 문자형 20 자리
--   addr 문자형 100자리로 기본값을 서울시 금천구로 설정하기	
CREATE TABLE test11(
	NAME VARCHAR(20),
	tel VARCHAR(20),
	addr VARCHAR(100) DEFAULT "서울시 금천구" 
)

-- 2. 교수 테이블로 부터 102 학과 교수들의 
-- 번호, 이름, 학과코드, 급여, 보너스, 직급만을 컬럼으로
-- 가지는 professor_102 테이블을 생성하기
​
CREATE TABLE professor_102 AS SELECT p.no,p.`name`,p.deptno,p.salary,p.bonus,p.`position`
FROM professor p
WHERE p.deptno = 102;
-- 3. 사원테이블에서 사원번호 3001, 이름:홍길동, 직책:사외이사
-- 급여:100,부서:10 입사일:2025년04월01일 인 레코드 추가하기
​
INSERT INTO emp (empNO,eNAME,job,salary,deptno,hiredate) VALUES (3001,'홍길동','사외이사',100,10,'2025-04-01');
-- 4. 교수 테이블에서 이상미교수와 같은 직급의 교수를 퇴직시키기

DELETE FROM professor WHERE position = (SELECT POSITION FROM professor WHERE NAME = '이상미');  
-- 5.교수번호,교수이름,직급, 학과코드,학과명 컬럼을 가진 테이블 professor_201을 생성하여
--   201학과에 속한 교수들의 정보를 저장하기

CREATE TABLE professor_201 AS SELECT p.no,p.`name`,p.`position`,p.deptno,m.name mname
FROM professor p, major m
WHERE p.deptno = m.code
	
-- 6. 사원테이블에 사원번호:3002, 이름:홍길동, 직책:사외이사, 
--   급여:100, 부서:10, 입사일:오늘인 레코드 등록하기 -> 컬럼명 지정안함

INSERT INTO emp VALUES (3002,'홍길동','사외이사',100,10,NOW());

-- 7. student 테이블과 같은 컬럼을 가진 테이블 stud_male 테이블 생성하기.
--     student 데이터 중 남학생 정보만 stud_male 테이블에 저장하기
--    성별은 주민번호를 기준으로 한다.
CREATE table stud_male AS SELECT * FROM student
WHERE SUBSTR(jumin,7,1) IN(1,3);

-- 8.  2학년 학생의 학번,이름, 국어,영어,수학 값을 가지는 score2 테이블 생성하기

CREATE TABLE score2 AS 
SELECT s.studno,s.`name`,s1.kor,s1.eng,s1.math
FROM student s, score s1
WHERE s.studno =s1.studno AND grade =2;

-- 9. 박인숙 교수와 같은 조건으로 오늘 입사한 이몽룡 교수 추가하기
--    교수번호 : 6003,이름:이몽룡,입사일:오늘,id:monglee
--    나머지 부분은 박인숙 교수 정보와 같다.
SELECT * FROM professor WHERE NAME ='박인숙';
INSERT INTO professor  (NO,NAME,hiredate,id,POSITION,salary,bonus,deptno,email,url) 
SELECT 6003,'이몽룡',NOW(),'monglee',POSITION,salary,bonus,deptno,email,url
FROM professor
WHERE NAME = '박인숙';

INSERT INTO professor (NO,NAME,hiredate,id,POSITION,salary,bonus,deptno,email,URL)
VALUES (6003,'이몽룡',NOW(),'monglee','조교수',512,100,101,'pis@abc.net','http://www.pispage.net')

SELECT * from professor 

-- 10. major 테이블에서 code값이 200 이상인 데이터만 major2에 데이터 추가하기

CREATE TABLE major2 AS 
SELECT * FROM major WHERE CODE =200;

-- 11.  major2 테이블에 공과대학에 속한 학과 정보만 추가하기

INSERT INTO major2 
SELECT * from major 
WHERE part IN (SELECT CODE FROM major WHERE NAME = '공과대학');

-- 12. 이영국 직원과 같은 직급의 직원의 급여는 
--    박진택 직원의 같은 부서의 평균급여의 80%로 변경하고, 보너스는 현재 보너스보다 15%를 인상하여 변경하기


SELECT * FROM emp WHERE job=(SELECT job FROM emp WHERE eNAME ='이영국');
SELECT * FROM emp WHERE deptno=(SELECT deptno FROM emp WHERE eNAME ='박진택');
UPDATE emp SET salary = (SELECT AVG(salary) FROM emp WHERE ename = '박진택')*0.8, bonus = bonus*1.15 
WHERE job=(SELECT job FROM emp WHERE eNAME ='이영국');

-- 13. student 테이블과 같은 컬럼과, 학생 중 남학생의 정보만을 가지는  v_stud_male 뷰 생성하기.
--    성별은 주민번호를 기준으로 한다.

CREATE OR REPLACE VIEW v_stud_male
AS SELECT * FROM student 
WHERE SUBSTR(jumin,7,1) IN(1,3);

-- 14.  교수번호,이름,부서코드,부서명,자기부서의 최대급여,최소급여,평균급여, 최대보너스,최소보너스, 평균보너스 조회하기
--       보너스가 없으면 0으로 처리한다.

SELECT p.no,p.`name`,p.deptno,m.name,max_s 최대급여,min_s 최소급여,avg_s 평균급여,max_b 최대보너스,min_b 최소보너스,avg_b 평균보너스
FROM professor p , major m, (SELECT deptno,MAX(salary)max_s,MIN(salary)min_s,AVG(salary)avg_s,MAX(ifnull(bonus,0))max_b,
MIN(IFNULL(bonus,0))min_b,AVG(IFNULL(bonus,0))avg_b FROM professor GROUP BY deptno) a
WHERE p.deptno = m.code AND a.deptno =p.deptno;
