/*
	view : 가상테이블
			 물리적으로 메모리 할당이 없음. 테이블처럼 join,subquery 가능함.
*/

-- 2학년 학생의 학번,이름,키,몸무게를 가진 뷰 v_stu2 생성하기

CREATE OR REPLACE VIEW v_stu2
AS SELECT studno,NAME,height,weight FROM student WHERE grade =2;

-- v_ stu 2 뷰 내용 조회하기
SELECT * FROM v_stu2;

-- 232001,홍길동,2,160,60,hongkd 학생테이블 추가하기
-- 242001,김삿갓,1,165,65,kimsk학생테이블 추가하기

INSERT INTO student (studno,NAME,grade,height,weight,id,jumin) 
VALUES (232001,'홍길동',2,160,60,'hongkd','12345'),
		 (242001,'김삿갓',1,165,65,'kimsk','56789');

SELECT * FROM v_stu2;
ROLLBACK;

-- view 객체 조회하기

USE information_schema;
SELECT view_definition FROM views
WHERE TABLE_NAME ='v_stu2';
select `gdjdb`.`student`.`studno` AS `studno`,
	`gdjdb`.`student`.`name` AS `NAME`,
	`gdjdb`.`student`.`height` AS `height`,
	`gdjdb`.`student`.`weight` AS `weight` 
	from `gdjdb`.`student` 
	 where `gdjdb`.`student`.`grade` = 2;

-- 2학년 학생의 학번,이름,국어,영어,수학 값을 가지는 v_score2 뷰 생성하기

CREATE OR REPLACE VIEW v_score2 -- or replace 사용안해도된다. 
AS SELECT s.studno,s.NAME,s2.kor,s2.math,s2.eng
FROM student s , score s2
WHERE s.studno = s2.studno
 AND grade=2;

-- create or replace  : 생성 또는 변경 

SELECT * FROM v_score2;

-- v_stu2,v_score2 뷰를 이용하여 학번,이름,국어,영어,수학 점수들,키,몸무게 조회하기
 
SELECT v1.*, v2.height,v2.weight
FROM v_stu2 v2, v_score2 v1
WHERE v1.studno = v2.studno;

-- v_score2 뷰와 student 테이블을 이용하여 학번,이름,점수들,학년,지도교수번호 출력하기

SELECT v.* , s.grade, s.profno
FROM v_score2 v , student s
WHERE v.studno = s.studno;

-- v_score2 뷰와 student, professor 테이블을 이용하여 학번,이름,점수들,학년,지도교수번호, 지도교수이름 출력하기

SELECT v.*, s.grade, s.profno, p.`name`
FROM v_score2 v , student s , professor p
WHERE v.studno = s.studno AND s.profno = p.no;

SELECT v.studno,v.`NAME`,v.kor,v.math,v.eng, s.grade, s.profno, p.`name`
FROM v_score2 v , student s , professor p
WHERE v.studno = s.studno
 AND s.profno = p.no;

-- view 삭제하기

DROP VIEW v_stu2;

SELECT * FROM v_stu2;

/*
	inline 뷰 : 뷰의 이름이 없고,일회성으로 사용되는 뷰
					select 구문의 from 절에 사용되는 subquery
					반드시 별명을 설정해야함.
*/

-- 학생의 학번,이름,학년,키, 몸무게,학년의 평균키와 평균몸무게 조회하기

SELECT s.studno,s.`name`,s.grade,s.height,s.weight, 
 (SELECT AVG(height) FROM student s1 WHERE s1.grade = s.grade) 평균키,
 (SELECT AVG(weight) FROM student s1 WHERE s1.grade = s.grade) 평균몸무게
FROM student s ;

-- inline 뷰를 이용하기
SELECT studno,NAME,s.grade,height,weight,avg_h 평균키,avg_w 평균몸무게
FROM student s,
(SELECT grade,AVG(height) avg_h,AVG(weight) avg_w FROM student GROUP BY grade ) a
WHERE s.grade = a.grade

-- 사원테이블에서 사원번호,사원명,직급,부서코드,부서명,부서별 평균 급여,부서별 평균 보너스 출력하기 . 단 보너스가 없으면 0 으로 처리하기

SELECT e.empno,e.ename,e.job,e.deptno,d.dname,a.avg_s 평균급여, a.avg_b 평균보너스
FROM emp e,dept d,
 (SELECT deptno, AVG(salary) avg_s, AVG(ifnull(bonus,0)) avg_b 
  FROM emp GROUP BY deptno) a
WHERE e.deptno = a.deptno
 AND d.deptno = e.deptno ; 

/*
	사용자 관리
*/

-- 데이터 베이스 생성

CREATE DATABASE mariadb;

-- 데이터 베이스 목록 조회

SHOW DATABASE; 

-- 테이블 목록 조회 
SHOW TABLES;

-- 사용자 생성 

USE mariadb
CREATE USER test1 ;

-- 비밀번호 설정

SET PASSWORD FOR 'test1' = PASSWORD("pass1");

-- 권한 주기
grant select,insert,update,delete,create,drop,create VIEW 
on mariadb.* to 'test1'@'%';

GRANT ALTER ON mariadb.* TO 'test1'@'%';

-- 권한 조회

SELECT * FROM USER_PRIVILEGES WHERE grantee LIKE '%test1%';

-- 권한 회수 : revoke
revoke all PRIVILEGES on mariadb.* from 'test1'@'%'

-- test1 사용자 삭제
DROP USER 'test1'@'%';



