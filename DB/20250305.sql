/*
	desc : 테이블의 구조(스키마)
	
	select : * => 모든컬럼
				컬럼명들
	from 테이블명
	[where 조건문] => 구현이 안된경우 : 모든행 선택
							구현이 된 경우 : 조건문의 결과가 참인 레코드만 선택
	
	컬럼 부분
		* : 모든컬럼
		컬럼명 목록 : 구현된 컬럼만 조회
		컬럼에 리터널 컬럼 : 상수 컬럼
		컬럼에 연산자 사용 가능 : +,-,*,/
		별명(alias) 사용 가능
		distinct : 중복없이 조회. 컬럼명 앞에 한번만 사용 가능
		
	where 조건문에서 사용되는 연산자
		관계 연산자 : =,>,<,>=,<=, <>(같지 않다.),!=
		논리 연산자 : and,or
		between : 컬럼명 between A and B => 컬럼의 값이 A 이상 B이하
		in : 컬럼명 in (A,B,...) => 컬럼의 값이 A 또는 B 인 경우
			not in
		like : 부분적으로 일치하는 문자열 찾기
			not like
			% : 0개 이상의 임의의 문자
			_ : 1개 임의의 문자
			binary : 대소문자 구분.MariaDB에서만 사용
		is null : null 값은 값이 없으므로, 연산, 비교 대상이 안됨.
		is not null 
	
	order by : 정렬. select 구문의 마지막에 기술되어야 함
			asc : 오름차순 정렬. 기본 값이므로 생략가능
			desc : 내림차순 정렬.
	order by 컬럼1,컬럼2 => 컬럼1로 1차 정렬후에 컬럼2로 2차 정렬
			컬럼명,조회된컬럼의 순서, 컬럼의 별명
*/

-- 집합연산(두개의 select문 연결)
-- 교수테이블에서 교수이름,학과코드,급여,연봉 조회하기
-- 보너스가 있는경우 : 급여*12+보너스
-- 보너스가 없는경우 : 급여*12
/*
	합집합 : union, union all
	union : 합집합.중복을 제거하여 조회.
	union all : 두개의 쿼리 문장의 결과를 합하요 조회.중복제거 안됨.
*/

SELECT NAME,deptno,salary,bonus,salary*12+bonus FROM professor
WHERE bonus IS NOT NULL
union
SELECT NAME,deptno,salary,bonus,salary*12 FROM professor
WHERE bonus IS NULL

