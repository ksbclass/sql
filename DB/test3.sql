1. 학생의 이름과 지도교수번호 조회하기
   지도교수가 없는 경우 지도교수배정안됨 출력하기

SELECT NAME,ifnull(profno,"지도교수 배정안됨") profno
FROM student;

 2. major 테이블에서 코드, 코드명, build 조회하기
   build 값이 없는 경우 '단독 건물 없음' 출력하기

SELECT CODE,NAME,ifnull(build,"단독 건물 없음") build
FROM major;

 3. 학생의 이름, 전화번호, 지역명 조회하기
 지역명 : 지역번호가 02 : 서울, 031:경기, 032:인천 그외 기타지역
SELECT NAME,tel,
		if(SUBSTR(tel,1,INSTR(tel,')')-1)=02,"서울",
		if(SUBSTR(tel,1,INSTR(tel,')')-1)=031,"경기",
		if(SUBSTR(tel,1,INSTR(tel,')')-1)=032,"인천","그외 기타지역"))) 지역명
FROM student;
 4. 학생의 이름, 전화번호, 지역명 조회하기
 지역명 : 지역번호가 02,031,032: 수도권, 그외 기타지역
 SELECT NAME,tel, if(SUBSTR(tel,1,INSTR(tel,')')-1) IN (02,031,032),"수도권","기타지역")
 FROM student;
5. 학생을 3개 팀으로 분류하기 위해 학번을 3으로 나누어 
   나머지가 0이면 'A팀', 
   1이면 'B팀', 
   2이면 'C팀'으로 
   분류하여 학생번호, 이름, 학과번호, 팀 이름을 출력하여라
SELECT studno,NAME,major1, if(studno%3=0,"A팀",if(studno%3=1,"B팀","C팀")) 팀
FROM student;
                     
 6. score 테이블에서 학번, 국어,영어,수학, 학점, 인정여부 을 출력하기
    학점은 세과목 평균이 95이상이면 A+,90 이상 A0
                        85이상이면 B+,80 이상 B0
                        75이상이면 C+,70 이상 C0
                        65이상이면 D+,60 이상 D0
     인정여부는 평균이 60이상이면 PASS로 미만이면 FAIL로 출력한다.                   
    으로 출력한다.

SELECT *,if(AVG(kor+math+eng)>=95,"A+",
if(AVG(kor+math+eng)>=90,"A0",
if(AVG(kor+math+eng)>=85,"B+",
if(AVG(kor+math+eng)>=80,"B0"),
if(AVG(kor+math+eng)>=75,"C+"),
if(AVG(kor+math+eng)>=70,"C0",
if(AVG(kor+math+eng)>=65,"D+",
if(AVG(kor+math+eng)>=60,"D0","F")))))),
if(AVG(kor+math+eng)>=60,"PASS","FAIL")
FROM score;

SELECT *,case when (kor+math+eng)/3 >=95 then "A+",
			when (kor+math+eng)/3 >=90 then "A0",
			when (kor+math+eng)/3 >=85 then "B+",
			when (kor+math+eng)/3 >=80 then "B0",
			when (kor+math+eng)/3 >=75 then "C+",
   
 7. 학생 테이블에서 이름, 키, 키의 범위에 따라 A, B, C ,D그룹을 출력하기
      160 미만 : A그룹
      160 ~ 169까지 : B그룹
      170 ~ 179까지 : C그룹
      180이상       : D그룹

SELECT NAME,weight,height, case when height >=180 then " D그룹"
										  when height BETWEEN 170 AND 179 then " C그룹"
										  when height BETWEEN 160 AND 169 then " B그룹"
										  when height <160 then " D그룹"
										  ELSE "그룹 없음" END 그룹
FROM student;

 8. 교수테이블에서 교수의 급여액수를 기준으로 200이하는 4급, 201~300 : 3급, 301~400:2급
     401 이상은 1급으로 표시한다. 교수의 이름, 급여, 등급을 출력하기
     단 등급의 오름차순으로 정렬하기

SELECT NAME,salary, case when salary <= 200 then"4급"
								 when salary BETWEEN 201 AND 300 then"3급"
								 when salary BETWEEN 301 AND 400 then"2급"
								 ELSE "1급" END 등급
FROM professor
ORDER BY 등급;

9 학생의 학년별 키와 몸무게 평균 출력하기.
   학년별로 정렬하기. 
   평균은 소숫점2자리 반올림하여 출력하기

SELECT grade,round(AVG(weight),2),round(AVG(height),2)
FROM student
group by grade
ORDER BY grade;
 
10. 평균키가 170이상인  전공1학과의 
    가장 키가 큰키와, 가장 작은키, 키의 평균을 구하기 

SELECT major1, MAX(height),MIN(height),AVG(height)
FROM student
GROUP BY major1
HAVING AVG(height) >= 170;
 
11.  사원의 직급(job)별로 평균 급여를 출력하고, 
     평균 급여가 1000이상이면 '우수', 작으면 '보통'을 출력하여라

SELECT job,AVG(salary) 급여,if(AVG(salary)>=1000,"우수","보통") 평균급여
FROM emp
GROUP BY job;
 
12. 학과별로 학생의 평균 몸무게와 학생수를 출력하되 
    평균 몸무게의 내림차순으로 정렬하여 출력하기

SELECT major1 학과,AVG(weight) 평균몸무게,COUNT(*) 인원수
FROM student
GROUP BY major1 
ORDER BY AVG(weight) DESC;
 
13. 학과별 교수의 수가 2명 이하인 학과번호, 인원수를 출력하기

SELECT deptno,COUNT(*)인원수
FROM professor
GROUP BY deptno
having COUNT(deptno)<=2;


14. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기

SELECT tel,
if(SUBSTR(tel,1,INSTR(tel,')')-1)=02,"서울",
if(SUBSTR(tel,1,INSTR(tel,')')-1)=031,"경기",
if(SUBSTR(tel,1,INSTR(tel,')')-1)=051,"경남","그외지역"))), COUNT(*) 인원수
FROM student
GROUP BY if(SUBSTR(tel,1,INSTR(tel,')')-1));

15. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기. 가로출력
SELECT CONCAT(COUNT(*)+"",'명') '전체'
		 count(if(SUBSTR(tel,1,INSTR(tel,')')-1)=02,1,0))"서울",
		 count(if(SUBSTR(tel,1,INSTR(tel,')')-1)=031,1,0))"경기",
		 count(if(SUBSTR(tel,1,INSTR(tel,')')-1)=051,1,0))"부산",
		 count(if(SUBSTR(tel,1,INSTR(tel,')')-1)=052,1,0))"경남"
		 	NOT IN ('02','031','051','052') 그외지역
FROM student;
16. 교수들의 번호,이름,급여,보너스, 총급여(급여+보너스)
     급여많은순위,보너스많은순위,총급여많은 순위 조회하기
     총급여순위로 정렬하여 출력하기. 보너스없는 경우 0으로 함
     
     
SELECT NO,NAME,salary,bonus,salary+IFNULL(bonus,0)총급여,
	RANK() OVER(ORDER BY salary DESC) 급여순위,
	RANK() OVER(ORDER BY bonus DESC) 보너스순위,
	RANK() OVER(ORDER BY salary+IFNULL(bonus,0) DESC) 총급여순위
FROM professor
ORDER BY 총급여순위;

17.  교수의 직급,직급별 인원수,급여합계,보너스합계,급여평균,보너스평균 출력하기
    단 보너스가 없는 교수도 평균에 포함되도록 한다.
    급여평균이 높은순으로 정렬하기

SELECT POSITION,COUNT(*),SUM(salary)
18. 1학년 학생의 인원수,키와 몸무게의 평균 출력하기

SELECT COUNT(*) 인원수, AVG(height),AVG(weight)
FROM student
WHERE grade =1;

19. 학생의 점수테이블(score)에서 수학 평균,수학표준편차,수학분산 조회하기
20. 교수의 월별 입사 인원수를 출력하기
SELECT CONCAT(MONTH(hiredate),"월")월, COUNT(*)인원수
FROM professor
group BY MONTH(hiredate);