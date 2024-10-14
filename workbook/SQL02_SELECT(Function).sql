-- 1. 영어영문학과(학과코드 002) 학생들의
--    학번과 이름, 입학 년도가
--    빠른 순으로 표시하는 SQL 문장을 작상하시오.
--    (단 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, ENTRANCE_DATE 입학년도
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002'
ORDER BY STUDENT_NAME;


-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다.
--    그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자.
--    (* 이때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다
--    원인이 무엇일지 생각해볼 것)
SELECT *
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';


-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오.
--    단 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오.
--    (단, 교수 중 2000 년 이후 출생자는 없으며 출력헤더는
--    "교수이름", "나이"로 한다. 나이는 '만' 으로 계산한다.)
SELECT PROFESSOR_NAME 교수이름,
			 TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19' || SUBSTR(PROFESSOR_SSN, 0, 6), 'YYYYMMDD')) / 12 ) 나이 
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = 1
ORDER BY 나이;


-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오.
--    출력헤더는 "이름" 이 찍히도록 한다. (성이 2자인 경우는 교수는 없다고 가정하시오)
SELECT SUBSTR(PROFESSOR_NAME, 2, 3) 이름
FROM TB_PROFESSOR;


-- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때,
--    19 살에 입학하면 재수를 하지 않은 것으로 간주한다.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - CONCAT('19', SUBSTR(STUDENT_SSN, 1, 2)) >= 20;


-- 6. 2020년 크리스마스는 무슨 요일인가?
SELECT TO_CHAR(TO_DATE('20201225', 'YYYYMMDD'), 'DAY') 요일
FROM DUAL;


-- 7. TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11', 'YY/MM/DD') 
--    은 각각 몇년 몇월 몇일을 의미할까? 
--    또 TO_DATE('99/10/11', 'RR/MM/DD'), TO_DATE('49/10/11', 'RR/MM/DD')
--    은 각각 몇년 몇월 몇일을 의미할까?
SELECT TO_DATE('99/10/11', 'YY/MM/DD'), 
			 TO_DATE('49/10/11', 'YY/MM/DD'),
			 TO_DATE('99/10/11', 'RR/MM/DD'), 
			 TO_DATE('49/10/11', 'RR/MM/DD')
FROM DUAL;


-- 8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다.
--    2000년도 이전 학번을 받은 학생들의 
--    학번과 이름을 보여주는 SQL 문장을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_NO, 0, 1) != 'A'; 