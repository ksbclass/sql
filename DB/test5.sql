-- 1. 학년의 평균 몸무게가 70보다 큰 학년의 학년와 평균 몸무게 출력하기

SELECT s.grade ,avg(height)
FROM student s
GROUP BY grade
HAVING AVG(height) > 70;

-- 2. 학년별로 평균체중이 가장 적은 학년의  학년과 평균 체중을 출력하기

SELECT * FROM 
(SELECT grade,AVG(weight) avg FROM student GROUP BY grade) a
WHERE AVG = (SELECT MIN(AVG) 
		FROM (SELECT grade,AVG(weight)avg FROM student GROUP BY grade) a);
		
SELECT grade,AVG(weight) FROM student GROUP BY grade
HAVING AVG(weight) <=ALL
(SELECT AVG(weight) FROM student GROUP BY grade);

-- 3. 전공테이블(major)에서 공과대학(deptno=10)에 소속된  학과이름을 출력하기

SELECT code,NAME,part
FROM major 
WHERE part IN 
(SELECT m1.code FROM  major m1,major m2  WHERE m1.part = m2.code AND m2.`name` = '공과대학');

-- 4. 자신의 학과 학생들의 평균 몸무게 보다 몸무게가 적은   학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
 
SELECT s.studno, s.`name`, s.major1, s.weight
FROM student s
WHERE s.weight < (SELECT AVG(weight) FROM student WHERE major1 = s.major1);
 
-- 5. 학번이 220212학생과 학년이 같고 키는  210115학생보다  큰 학생의 이름, 학년, 키를 출력하기
 
SELECT s.`name`,s.grade,s.height
FROM  student s
WHERE s.grade =(SELECT grade FROM student WHERE studno= 220212) 
  AND height > (SELECT height FROM student WHERE studno = 210115);

-- 6. 컴퓨터정보학부에 소속된 모든 학생의 학번,이름, 학과번호, 학과명 출력하기

SELECT s.studno,s.`name`,s.major1,m.`name`
FROM student s , major m
WHERE s.major1 = m.code
 AND m.part IN (SELECT CODE FROM major WHERE NAME = '컴퓨터정보학부');

-- 7. 4학년학생 중 키가 제일 작은 학생보다  키가 큰 학생의 학번,이름,키를 출력하기

SELECT s.studno,s.`name`,s.height
FROM student s
WHERE height > (SELECT MIN(height) FROM student WHERE grade =4 );

-- 8. 학생 중에서 생년월일이 가장 빠른 학생의  학번, 이름, 생년월일을 출력하기

SELECT s.studno,s.`name`,s.birthday
FROM student s
WHERE s.birthday = (SELECT MIN(birthday) FROM student);

-- 9. 학년별  생년월일이 가장 빠른 학생의 학번, 이름, 생년월일,학과명을 출력하기

SELECT s.studno,s.`name`,s.birthday, m.`name`
FROM student s , major m
WHERE s.major1 = m.code AND (s.grade,s.birthday) in (SELECT grade , MIN(birthday) FROM student GROUP BY grade);


-- 10. 학과별 입사일 가장 오래된 교수의 교수번호,이름,입사일,학과명 조회하기

SELECT p.no, p.`name`,p.hiredate,m.`name`
FROM professor p , major m
WHERE p.deptno = m.code 
AND (p.deptno,p.hiredate) in (SELECT deptno, MIN(hiredate) FROM professor GROUP by deptno);


-- 11. 4학년학생 중 키가 제일 작은 학생보다  키가 큰 학생의 학번,이름,키를 출력하기

SELECT s.studno,s.`name`,s.height
FROM student s
WHERE height > (SELECT min(height) FROM student WHERE grade=4 )
ORDER BY studno;

-- 12. 학년별로 평균키가 가장 적은 학년의 학년과 평균키 출력하기

SELECT grade, avg(height)
FROM student s
GROUP BY grade
having avg(height) <= all
(SELECT avg(height) FROM student GROUP BY grade);

-- 13. 학생의 학번,이름,학년,키,몸무게, 학년의 최대키,최대 몸무게 조회하기

SELECT s.studno,s.`name`,s.grade,s.height,s.weight, (SELECT MAX(height) FROM student WHERE grade=s.grade)  최대키,
(SELECT MAX(weight) FROM student where grade=s.grade) 최대몸무게
FROM student s

-- 14. 교수번호,이름,부서코드,부서명,자기부서의 평균급여,평균보너스 조회하기
-- 보너스가 없으면 0 으로 처리한다.

SELECT p.no,p.`name`,p.deptno,
(SELECT NAME FROM major m WHERE m.code = p.deptno ) 부서명,
(SELECT AVG(salary) FROM professor WHERE p.deptno = deptno) 평균급여,
(SELECT AVG(ifnull(bonus,0)) FROM professor WHERE p.deptno = deptno) 평균보너스
FROM professor p 

-- 15. test6 테이블 생성하기
-- 컬럼 :seq : 숫자, 기본키, 자동증가
-- 		name : 문자형 20문자
--			birthday : 날짜만

CREATE TABLE test6(
	seq INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(20),
	birthday DATE
)

DESC test6


 