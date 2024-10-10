-- * WHERE 절 GROUP BY 절 혼합하여 사용하기 *

--> WHERE 절은 각 컬럼값에 대한 조건
--> HAVING 절은 그룹에 대한 조건

-- EMPLOYEE 테이블에서 (FROM 절)
-- 부서코드가 D5, D6인 부서의 (WHERE 절 -> GROUP BY 절)
-- 부서코드, 평균급여, 인원수 조회 (SELECT 절)

SELECT DEPT_CODE, ROUND(AVG(SALARY)), COUNT(*)   
FROM EMPLOYEE  -- EMPLOYEE 테이블에서
WHERE DEPT_CODE IN('D5', 'D6') -- 부서코드가 D5, D6인
GROUP BY DEPT_CODE; -- 부서의(WHERE절에서 구한 부서코드가 D5,D6인 데이터들을 그룹으로 묶어줌)

-- EMPLOYEE 테이블에서
-- 2000년도 이후 입사자들의
-- 직급별 급여 합을 조회

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE 
-- HIRE_DATE >= TO_DATE('2000-01-01')
-- EXTRACT(YEAR FROM HIRE_DATE) >= 2000
SUBSTR( TO_CHAR(HIRE_DATE, 'YYYY'), 1, 4) >= '2000'
GROUP BY JOB_CODE;

----------------------------------------------

-- * 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹 내 그룹이 가능하다! *

-- *** GROUP BY 사용 시 주의사항 ***
--> SELECT 문에 GROUP BY절을 사용할 경우
-- SELECT 절에 명시한 조회하려는 컬럼 중
-- 그룹함수가 적용되지 않은 컬럼을
-- 모두 GROUP BY 절에 작성해야함.


-- EMPLOYEE 테이블에서
-- 부서별로 같은 직급인 사원의 인원수를 조회
-- 부서코드 오름차순, 직급코드 내림차순으로 정렬
-- 부서코드, 직급코드, 인원수

SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- DEPT_CODE러 그룹을 나누고,
							 -- 나눠진 그룹 내에서 JOB_CODE 로 그룹을 분류
ORDER BY DEPT_CODE, JOB_CODE DESC;
-- SQL Error [979] [42000]: ORA-00979: GROUP BY 표현식이 아닙니다.

-----------------------------------------------------------------

-- * HAVING 절 : 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용

-- EMPLOYEE 테이블에서
-- 부서별 평균 급여가 3백만원 이상인 부서의
-- 부서코드, 평균급여 조회
-- 부서코드 오름차순

SELECT DEPT_CODE, ROUND(AVG(SALARY)) 
FROM EMPLOYEE
-- WHERE SALARY >= 3000000 --> 한 사람의 급여가 3백만원 이상이라는 조건(요구사항 X)
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
ORDER BY DEPT_CODE;

-- EMPLOYEE 테이블에서
-- 직급별 인원수가 5명 이하인
-- 직급코드, 인원수 조회
-- (직급코드 오름차순 정렬)

SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE 
HAVING COUNT(*) <= 5 -- HAVING 절에는 그룹함수가 반드시 작성된다!
ORDER BY 1;

---------------------------------------------------------------

-- 집계 함수(ROLLUP, CUBE)
-- 그룹 별 산출 결과 값의 집계를 계산하는 함수
-- (그룹별로 중간 집계 결과를 추가)
-- GROUP BY 절에서만 사용할 수 있는 함수!

-- ROLLUP : GROUP BY 절에서 가장먼저 작성된 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- CUBE : GROUP BY 절에 작성된 모든 컬럼의 중간 집계를 처리하는 함수
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;


/* SET OPERATOR (집합 연산자)

-- 여러 SELECT의 결과(RESULT SET)를 하나의 결과로 만드는 연산자

- UNION (합집합) : 두 SELECT 결과를 하나로 합침
                  단, 중복은 한 번만 작성

- INTERSECT (교집합) : 두 SELECT 결과 중 중복되는 부분만 조회

- UNION ALL : UNION + INTERSECT
              합집합에서 중복 부분 제거 X
             
- MINUS (차집합) : A에서 A,B 교집합 부분을 제거하고 조회

*/


-- EMPLOYEE 테이블에서
-- 부서코드가 'D5'인 사원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_NO, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
-- UNION
-- INTERSECT 
-- UNION ALL
MINUS
-- 급여가 300만 초과인 사원의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_NO, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY > '3000000';


-- (주의사항!) 집합연산자를 사용하기 위한 SELECT문들은
-- 조회하는 컬럼의 타입, 개수가 모두 동일해야 한다!

SELECT EMP_NO, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION 
SELECT EMP_NO, EMP_NAME, DEPT_CODE, 1
FROM EMPLOYEE
WHERE SALARY > '3000000';
-- SQL Error [1789] [42000]: ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
-- SQL Error [1790] [42000]: ORA-01790: 대응하는 식과 같은 데이터 유형이어야 합니다

-- 서로 다른 테이블이지만
-- 컬럼의 타입, 개수만 일치하면
-- 집합 연선자 사용 가능!
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE
UNION
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;














