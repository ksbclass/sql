/*
	1. 집합연산자
		union		 : 합집합.중복되지 않는다
		union all : 중복됨. 두개의 쿼리의 결과를 연결하요 조회
		=> 두개의 select 에서 조회되는 컬럼의 수가 같아야한다.
		intersect : 교집합. and 조건문으로 대부분 가능하다.
		
		
		
	2. 함수 : 단일행 함수 : 하나의 레코드에서만 처리되는 함수. where 조건문에서 사용 가능 
			    그룹함수 : 여러개의 레코드에서 처리되는 함수. where 조건문에서 사용 불가능
			    															  having 조건문에서 사용가능함
	
	
	
	3. 문자열 관련 함수
		- 대소문자 변경 : upper,lower
		- 문자열의 길이 : length(바이트수),char_length(문자열의 길이)
		- 부분문자열  	substr (문자열,시작인덱스,[갯수]),
							  left(문자열, 갯수), rigth(문자열,갯수)
		- 문자열 결함수 : concat
		- 문자의 위치 : instr(문자열,문자) => 문자열에서 문자의 위치 인덱스 리턴. 인덱스는 1부터시작
		- 문자 추가 함수 : lpad(문자열,전체자리수,채울 문자),rpad(문자열,전체자리수,채울 문자)
		- 문자 제거 함수 : trim(문자열) : 양쪽 공백을 제거
								 ltrim(문자열) : 왼쪽 공백을 제거
								 rtrim(문자열) : 오른쪽 공백을 제거
								 trim(leading|trailing|both 제거할 문자 from 문자열) : 지정한 문자 제거
										 왼쪽  | 오른쪽 | 양쪽
		- 문자 치환 : replace(문자열,문자1,문자2)-> 문자열에서 문자1을 문자2 로 치환
		- 그룹의 위치 : find_in_set(문자,문자열)=> ,를 가진 문자열에서 문자가 몇번째 위치인지 리턴 



	4. 숫자 관련함수
		- 반올림 : round(숫자, [소숫점이하 자리수]) 자리수가 생략되면 정수로 출력
		- 버림	:truncate(숫자,소숫점이하 자리수)
		- 나머지 : mod, % 연산자 가능
		- 제곱 : power(숫자1,숫자2) : 숫자1을 숫자2만큼 곱하기
		- 근사정수 : ceil : 큰근사정수
						 floor : 작은 근사정수
						 
	
	
	5. 날짜 관련함수 
		- 현재일시 : now()
		- 현재 일자 : curdate(),current_date,current_date()
		- 년,월,일 : year,month,day,weekday(0(월)),dayofweek(1(일)),last_day(해당월의 마지막 날짜)
		- 이전/ 이후 : date_add,date_sub(날짜,interval 숫자[year|month|day|hour|minute|second])
		- 날짜 변환 함수: date_format => 날짜 -> 문자열
								str_to_date => 문자열 -> 날짜
			%Y,%m,%d....
*/


/*
	기타함수 
*/

-- ifnull(컬럼, 기본값) : 컬럼의 값이 null 인경우 기본값을 치환
-- 교수의 이름, 직급, 급여,보너스,급여+보너스 컬럼을 조회하자

SELECT NAME,POSITION,salary,bonus,salary+bonus FROM professor;

SELECT NAME,POSITION,salary,bonus,salary+bonus FROM professor
WHERE bonus IS NOT NULL
UNION
SELECT NAME,POSITION,salary,bonus,salary+bonus FROM professor
WHERE bonus IS NULL;

-- ifnull 사용 : ifnull(컬럼, 기본값)
-- ifnull (bonus,0) : bonus 컬럼의 값이 null 인경우 0 으로 치환

SELECT NAME,POSITION,salary,bonus,salary+ifnull(bonus,0) FROM professor;

-- ifnull(salary+bonus,salary) : salary + bonus의 결과가 null 인경우 salary로 치환

SELECT NAME,POSITION,salary,bonus,ifnull(salary+bonus,salary) FROM professor;

-- 교수의 이름,직책,급여,보너스 출력하기
-- 보너스가 없는경우 보너스없음으로 출력하기

SELECT NAME,POSITION,salary,IFNULL(bonus,'보너스 없음') bonus FROM professor;

-- 학생의 이름(name)과 지도교수의 번호(profno) 출력하기
-- 단, 지도교수가 없는경우 9999로 출력하기

SELECT NAME,IFNULL(profno,9999) profno FROM student;

/*
	조건함수 : if,case
*/

-- if 조건함수: if(조건문,'참','거짓')

-- 1학년 학생의 경우는 신입생으로 1학년학생이 아닌경우 재학생으로 출력하기

SELECT name,grade, if(grade=1,'신입생','재학생') 신입생여부 FROM student;

-- 교수의 이름,학과번호,학과명 출력하기
-- 학과명은 학과번호가 101: 컴퓨터 공학, 나머지는 공란으로 출력

SELECT NAME,deptno,if(deptno=101,'컴퓨터 공학','') 학과명 
FROM professor;

-- 교수의 이름,학과번호,학과명 출력하기
-- 학과명은 학과번호가 101: 컴퓨터 공학, 나머지는 그외학과로 출력

SELECT NAME,deptno,if(deptno=101,'컴퓨터 공학','그외학과') 학과명 
FROM professor;

-- 학생의 주민번호 7번째 자리가 1,3인경우 남자, 2,4인경우 여자로 출력

SELECT NAME,jumin,if(SUBSTR(jumin,7,1)=1,"남자",
				if (SUBSTR(jumin,7,1)=2, "여자",
				if(SUBSTR(jumin,7,1)=3,"남자" ,
				if(SUBSTR(jumin,7,1)=4 ,"여자","주민번호 오류")))) 성별
FROM student;

SELECT NAME, jumin,if(SUBSTR(jumin,7,1) IN (1,3),"남자","여자") 성별
FROM student;

-- 학생의 주민번호 7번째 자리가 1,3인경우 남자, 2,4인경우 여자로
-- 그외는 주민번호 오류로 출력하기

SELECT NAME, jumin,
if(SUBSTR(jumin,7,1) IN (1,3),"남자",
if(SUBSTR(jumin,7,1) IN (2,4),"여자","주민번호오류")) 성별
FROM student;

-- 문제
-- 교수이름, 학과번호,학과명 출력하기
-- 학과명 : 101: 컴퓨터공학,102:멀티미디어 공학,201: 기계공학,그외:그외학과

SELECT NAME,deptno,
if(deptno=101,"컴퓨터공학과",
if(deptno=102,"멀티미이디어 공학",
if(deptno=201,"기계공학","그외학과"))) 학과명
FROM professor;

/*
case 조건문
	case 컬럼명 when 값1 then 문자열
					when 값2 then 문자열
					when 값3 then 문자열
					...
					else 문자열 end
	case when 조건문1 then 문자열
				 조건문2 then 문자열
				 ...
			else 문자열 end
*/	

SELECT NAME,deptno,
	case deptno when 101 then "컴퓨터 공학"
	ELSE "" END 학과명
FROM professor;

-- 교수이름, 학과코드,학과명 출력하기
-- 학과명 : 101 학과인경우 '컴퓨터공학',그외는 그외학과 출력

SELECT NAME,deptno,
	case deptno when 101 then "컴퓨터 공학"
	ELSE "그외 학과" END 학과명
FROM professor;

-- 문제
-- 교수이름, 학과번호,학과명 출력하기
-- 학과명 : 101: 컴퓨터공학,102:멀티미디어 공학,201: 기계공학,그외:그외학과

SELECT NAME,deptno,
	case deptno when 101 then "컴퓨터공학"
					when 102 then "멀티미디어 공학"
					when 201 then "기계공학"
	ELSE "그외학과" END 학과명
FROM professor;

-- 교수이름, 학과번호, 대학명 출력하기
-- 대학명 : 101,102,201 : 공과대학, 그외는 그외대학 출력하기

-- if 조건문

SELECT NAME, deptno,
	if(deptno IN(101,102,201),"공과대학","그외 대학") 대학명
FROM professor;

-- case 조건문 => 오류발생

-- SELECT NAME, deptno,
--	case deptno when 101,102,201 then "공과대학"
--	ELSE "그외 대학" END 대학명
-- FROM professor;

-- case 조건문 => 정상처리

SELECT NAME, deptno,
	case deptno when 101 then "공과대학"
					when 102 then "공과대학"
					when 201 then "공과대학"
	ELSE "그외 대학" END 대학명
FROM professor;

SELECT NAME, deptno,
	case when deptno IN (101,102,201) then "공과대학"
	ELSE "그외 대학" END 대학명
FROM professor;

-- 문제
-- 학생의 이름,주민번호, 출생분기를 출력하기
-- 출생분기 : 주민번호 기준 1~3: 1분기, 4~6: 2분기,7~9 : 3분기, 10~12 : 4분기

SELECT NAME, jumin,
	case when substr(jumin,3,2) IN("01","02","03") then "1분기"
		  when substr(jumin,3,2) IN("04","05","06") then "2분기"
		  when substr(jumin,3,2) IN("07","08","09") then "3분기"
		  when substr(jumin,3,2) IN("10","11","12") then "4분기"
	ELSE "" END 출생분기
FROM student;

SELECT NAME, jumin,
	case when substr(jumin,3,2) BETWEEN '01' AND '03' then "1분기"
		  when substr(jumin,3,2) BETWEEN '04' AND '06' then "2분기"
		  when substr(jumin,3,2) BETWEEN '07' AND '09' then "3분기"
		  when substr(jumin,3,2) BETWEEN '10' AND '12' then "4분기"
	ELSE "" END 출생분기
FROM student;

SELECT NAME, jumin,
	case when substr(jumin,3,2) BETWEEN 1 AND 3 then "1분기"
		  when substr(jumin,3,2) BETWEEN 4 AND 6 then "2분기"
		  when substr(jumin,3,2) BETWEEN 7 AND 9 then "3분기"
		  when substr(jumin,3,2) BETWEEN 10 AND 12 then "4분기"
	ELSE "" END 출생분기
FROM student;

SELECT NAME, jumin,
	case when substr(jumin,3,2) >=1 AND substr(jumin,3,2)<=3 then "1분기"
		  when substr(jumin,3,2) >=4 AND substr(jumin,3,2)<=6 then "2분기"
		  when substr(jumin,3,2) >=7 AND substr(jumin,3,2)<=9 then "3분기"
		  when substr(jumin,3,2) >=10 AND substr(jumin,3,2)<=12 then "4분기"
	ELSE "" END 출생분기
FROM student;

-- 문제
-- 학생의 이름,생일, 출생분기를 출력하기
-- 출생분기 : 생일 기준 1~3: 1분기, 4~6: 2분기,7~9 : 3분기, 10~12 : 4분기

SELECT NAME,birthday,
	case when month(birthday) BETWEEN 1 AND 3 then "1분기" 
		  when month(birthday) BETWEEN 4 AND 6 then "2분기"
		  when month(birthday) BETWEEN 7 AND 9 then "3분기"
		  when month(birthday) BETWEEN 10 AND 12 then "4분기"
	ELSE "분기오류" END 출생분기   
FROM student;

SELECT NAME,birthday,
	case when month(birthday) BETWEEN "01" AND "03" then "1분기" 
		  when month(birthday) BETWEEN "04" AND "06" then "2분기"
		  when month(birthday) BETWEEN "07" AND "09" then "3분기"
		  when month(birthday) BETWEEN "10" AND "12" then "4분기"
	ELSE "분기오류" END 출생분기   
FROM student;

/*
	그룹함수 : 여러개의 행의 정보를 이용하여 결과 리턴함수
	select 컬럼명|*
	from 테이블명
	[where 조건문]
	[group by 컬럼명] => 레코드를 그룹화 하기위한 기준 컬럼
							group by 구문이 없는 경우 모든 레코드가 하나의 그룹으로 처리
	[having 조건문]
	[order by 컬럼명||별명||컬럼순서[asc|desc]] 
*/

-- count() : 레코드의 건수 리턴, null 값은 건수에서 제외됨
-- 교수의 전체인원수,보너스를 받는 인원수 조회하기
-- COUNT(*) : 레코드수
-- COUNT(bonus) : bonus의 값이 null이 아닌 레코드수

SELECT COUNT(*) 전체인원수,COUNT(bonus) 보너스 FROM professor;

-- 학생의 전체인원수와 지도교수를 배정받은 학생의 인원수 조회하기

SELECT COUNT(*) 전체인원수,COUNT(profno) "지도교수를 배정받은학생의 인원수"
FROM student;

-- 학생중 전공1학과가 101인 학과에 속한 학생의 인원수 조회하기

SELECT COUNT(*) FROM student
WHERE major1=101;

-- 1학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기

SELECT COUNT(*), COUNT(profno)
FROM student
WHERE grade =1;

-- 2학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기

SELECT COUNT(*), COUNT(profno)
FROM student
WHERE grade =2;

-- 3학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기

SELECT COUNT(*), COUNT(profno)
FROM student
WHERE grade =3;

-- 4학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기

SELECT COUNT(*), COUNT(profno)
FROM student
WHERE grade =4;

-- 학년별 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기

SELECT grade,COUNT(*), COUNT(profno)
FROM student
GROUP BY grade;

-- 문제 
-- 전공1 학과별 전체 인원수와 지도교수를 배정받은 학생의 인원수 조회하기

SELECT  major1,COUNT(*),COUNT(profno)
FROM student
GROUP BY major1;

-- 지도교수가 배정되지않은 학년의 전체 인원수를 출력하자

SELECT grade,COUNT(*)
FROM student
GROUP BY grade
HAVING COUNT(profno) = 0;

-- 합계 : sum, 평균 : avg
-- null 값인 경우는 제외.
-- 교수들의 급여 합계와 보너스 합계 출력하기

SELECT SUM(salary),SUM(bonus) FROM professor;

-- 교수들의 급여 평균와 보너스 평균 출력하기
-- avg(bonus) : bonus를 받는 교수들의 평균

SELECT COUNT(*) ,SUM(salary),SUM(bonus), avg(salary),avg(bonus) FROM professor;

-- 교수들의 급여 평균와 보너스 평균 출력하기.보너스가 없는 교수도 포함하여 출력하기
-- avg(ifnull(bonus,0)) : bonus 값이 null인 경우 0 을 환산하여 평균처리

SELECT COUNT(*) ,SUM(salary),SUM(bonus), avg(salary),AVG(ifnull(bonus,0)) 
FROM professor;

-- 문제
-- 교수의 부서코드, 부서별 인원수,급여합계,보너스 합계,급여평균,보너스평균출력하기
-- 단 보너스가 없는 교수도 평균에 포함되도록한다.

SELECT deptno 부서코드,COUNT(*) "부서별 인원수" , SUM(salary) "급여합계",
SUM(ifnull(bonus,0)) "보너스 합계", avg(salary) "급여 평균",AVG(ifnull(bonus,0)) "보너스 평균"
FROM professor
GROUP BY deptno
ORDER BY deptno;

-- 문제
-- 학년별,학생의 인원수,키와 몸무게의 평균 출력하기
-- 학년순으로 정렬하기

SELECT grade, COUNT(*),avg(height),AVG(weight)
FROM student
GROUP BY grade
ORDER BY grade;

-- 문제
-- 부서별 교수의 급여합,보너스합,연봉합,급여평균,보너스평균,연봉평균 출력하기
-- 연봉 : 급여 *12 +보너스
-- 보너스가 없는 경우는 0으로 처리함
-- 평균 출력시 소숫점 이하2자리로 반올림하여 출력하기

SELECT deptno,SUM(salary),SUM(ifnull(bonus,0)),SUM(salary*12+ifnull(bonus,0)),
				  round(AVG(salary),2),
				  round(AVG(IFNULL(bonus,0)),2),
				  round(AVG((salary*12+ifnull(bonus,0))),2) 
FROM professor
GROUP BY deptno;

/*
	최소값,최대값 : min,max
*/
-- 전공 1학과별 가장키가 큰학생의 키와,작은키값, 출력하기

SELECT major1,MAX(height),MIN(height)
FROM student
GROUP BY major1;

-- 교수 중 급여를 가장 많이 받는 급여 출력

SELECT MAX(salary), MIN(salary) FROM professor;

/*
	표준편차 : stddev
	분산		: variance
*/
-- 교수들의 평균 급여,급여의 표준편차,분산 출력하기

SELECT AVG(salary),STDDEV(salary),variance(salary) FROM professor;

-- 학생의 점수테이블(score) 에서 합계 평균,합계표준편차,합계분산 조회하기

SELECT avg(kor+math+eng),STDDEV(eng+kor+math),VARIANCE(eng+kor+math) 
FROM score;

-- having : group 조건
-- 학과별 가장 키가 큰학생의 키와, 가장작은학생의 키, 학과별 평균키를 출력하기
-- 평균키가 170이상인 학과정보를 출력하기

SELECT major1,MAX(height),MIN(height),AVG(height)
FROM student
GROUP BY major1
HAVING AVG(height) >=170;

-- 교수테이블에서 학과별 평균급여가 350이상인 부서의 코드와 평균급여 출력하기

SELECT deptno,AVG(salary)
FROM professor
GROUP BY deptno
HAVING AVG(salary)>=350;

-- 주민번호 기준으로 남,여 학생의 최대키,최소키,평균키 조회하기

SELECT substr(jumin,7,1) 성별, MAX(height),MIN(height),AVG(height)
FROM student
GROUP BY substr(jumin,7,1);

SELECT if(substr(jumin,7,1) IN(1,3),"남학생","여학생") 성별, MAX(height),MIN(height),AVG(height)
FROM student
GROUP BY 성별;

SELECT if(substr(jumin,7,1) IN(1,3),"남학생","여학생") 성별, MAX(height),MIN(height),AVG(height)
FROM student
GROUP BY if(substr(jumin,7,1)IN(1,3),"남학생","여학생");

-- group by 에서 설정된 컬럼만 select 컬럼으로 사용가능

SELECT name, AVG(salary) FROM professor -- => 정상처리.name 의미 없음
GROUP BY deptno;

-- 문제 학생의 생일의월별 인원수 출력하기

SELECT concat(MONTH(birthday), "월") 월,COUNT(*) 인원수 FROM student
GROUP BY MONTH(birthday);

SELECT CONCAT(COUNT(*)+"",'명') '전체',
		 SUM(if(MONTH(birthday)=1,1,0))'1월',
		 SUM(if(MONTH(birthday)=2,1,0))'2월',
		 SUM(if(MONTH(birthday)=3,1,0))'3월',
		 SUM(if(MONTH(birthday)=4,1,0))'4월',
		 SUM(if(MONTH(birthday)=5,1,0))'5월',
		 SUM(if(MONTH(birthday)=6,1,0))'6월',
		 SUM(if(MONTH(birthday)=7,1,0))'7월',
		 SUM(if(MONTH(birthday)=8,1,0))'8월',
		 SUM(if(MONTH(birthday)=9,1,0))'9월',
		 SUM(if(MONTH(birthday)=10,1,0))'10월',
		 SUM(if(MONTH(birthday)=11,1,0))'11월',
		 SUM(if(MONTH(birthday)=12,1,0))'12월'
FROM student;

-- 그룹함수전

SELECT NAME,birthday,
		if(MONTH(birthday)=1,1,0)'1월',
		if(MONTH(birthday)=2,1,0)'2월',
		if(MONTH(birthday)=3,1,0)'3월',
		if(MONTH(birthday)=4,1,0)'4월',
		if(MONTH(birthday)=5,1,0)'5월',
		if(MONTH(birthday)=6,1,0)'6월',
		if(MONTH(birthday)=7,1,0)'7월',
		if(MONTH(birthday)=8,1,0)'8월',
		if(MONTH(birthday)=9,1,0)'9월',
		if(MONTH(birthday)=10,1,0)'10월',
		if(MONTH(birthday)=11,1,0)'11월',
		if(MONTH(birthday)=12,1,0)'12월'
FROM student;

SELECT CONCAT(COUNT(*)+"",'명') '전체',
		 count(if(MONTH(birthday)=1,1,null))'1월',
		 count(if(MONTH(birthday)=2,1,null))'2월',
		 count(if(MONTH(birthday)=3,1,null))'3월',
		 count(if(MONTH(birthday)=4,1,null))'4월',
		 count(if(MONTH(birthday)=5,1,null))'5월',
		 count(if(MONTH(birthday)=6,1,null))'6월',
		 count(if(MONTH(birthday)=7,1,null))'7월',
		 count(if(MONTH(birthday)=8,1,null))'8월',
		 count(if(MONTH(birthday)=9,1,null))'9월',
		 count(if(MONTH(birthday)=10,1,null))'10월',
		 count(if(MONTH(birthday)=11,1,null))'11월',
		 count(if(MONTH(birthday)=12,1,null))'12월'
FROM student;

/*
	순위 지정함수 : rank() over(정렬방식) : 1등부터 꼴등까지
	누계 함수 : sum() over(정렬방식) : 1등부터꼴등까지 더함
*/

-- 교수의 번호,이름,급여,급여를 많이받는순위 출력하기

SELECT NO,NAME,salary,RANK() OVER(ORDER BY salary DESC) 급여순위
FROM professor;

-- 교수의 번호,이름,급여,급여 오름차순 순위 출력하기

SELECT NO,NAME,salary,RANK() OVER(ORDER BY salary asc) 급여순위
FROM professor;

-- 문제 score 테이블에서 학번,국어,수학,영어,총점 총점기준 등수 출력하기

SELECT *,kor+math+eng 총점,RANK() OVER(ORDER BY kor+math+eng DESC) 등수
FROM score; 

-- 문제 score 테이블에서 학번,국어,수학,영어,총점 총점기준 등수,과목별 등수 출력하기

SELECT *,kor+math+eng 총점,RANK() OVER(ORDER BY kor+math+eng DESC) 등수,
RANK() OVER(ORDER BY kor DESC) 국어등수,
RANK() OVER(ORDER BY math DESC) 수학등수,
RANK() OVER(ORDER BY eng DESC) 영어등수
FROM score; 

-- 교수의 이름,급여,보너스,급여의 누계를 조회하자

SELECT NAME,salary,bonus,SUM(salary) OVER(ORDER BY salary desc ) "급여의 누계"
FROM professor;

-- score 테이블에서 학번,국어,수학,영어,총점,총점누계,총점등수 조회하기

SELECT *,kor+math+eng 총점,
		SUM(kor+math+eng)OVER(ORDER BY kor+math+eng desc) 총점누계,
		RANK() OVER(ORDER BY kor+math+eng DESC) 총점등수
FROM score; 

-- 부분합 : rollup
-- 국어,수학의 합계 합을 구하기

SELECT kor,math, SUM(kor+math)
FROM score
GROUP by kor,math WITH ROLLUP;

-- 학년별 , 지역별, 몸무게평균, 키평균 조회하기

SELECT grade, SUBSTR(tel,1,INSTR(tel,')')-1) 지역,AVG(weight) 몸무게평균,
	AVG(height) 키평균
FROM student
GROUP BY grade,SUBSTR(tel,1,INSTR(tel,')')-1) ;

SELECT grade, SUBSTR(tel,1,INSTR(tel,')')-1) 지역,AVG(weight) 몸무게평균,
	AVG(height) 키평균
FROM student
GROUP BY grade,SUBSTR(tel,1,INSTR(tel,')')-1) WITH ROLLUP;

SELECT grade,AVG(weight) 몸무게평균,AVG(height) 키평균
FROM student
GROUP BY grade;

-- 학년별,성별 몸무게 평균, 키평균 조회하기. 학년별로도 평균하기

SELECT grade,if(substr(jumin,7,1) IN(1,3),"남학생","여학생") 성별,
		AVG(weight) 몸무게평균,AVG(height) 키평균
FROM student
GROUP BY grade,if(substr(jumin,7,1) IN(1,3),"남학생","여학생") WITH ROLLUP;

-- mariadb에서는 실행 안됨.

SELECT grade,if(substr(jumin,7,1) IN(1,3),"남학생","여학생") 성별,
		AVG(weight) 몸무게평균,AVG(height) 키평균
FROM student
GROUP BY grade,if(substr(jumin,7,1) IN(1,3),"남학생","여학생") WITH CUBE;
