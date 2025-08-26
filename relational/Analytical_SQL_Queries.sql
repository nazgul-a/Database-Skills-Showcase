
-- a
/*
A query that will list the faculty members (along with the building code and
room number) who are (located) in the (BUS)iness building.
*/

SELECT (f.F_FIRST || ' ' || f.F_MI || ' ' || f.F_LAST) F_FULL_NAME,
    l.BLDG_CODE,
    l.ROOM
FROM FACULTY f
JOIN LOCATION l
ON f.LOC_ID = l.LOC_ID
WHERE l.BLDG_CODE = 'BUS'
;
/


--------------------------------------------------------------------------------
-- b
/*
A query that will list students who are enrolled in the courses offered in the 
Fall term of 2024 or 2025 or Spring term of 2025. No duplicate student
names in the output. 
*/

SELECT DISTINCT 
    (s.S_FIRST || ' ' || s.S_MI || ' ' || s.S_LAST) S_FULL_NAME
    -- t.TERM_DESC
FROM STUDENT s
JOIN ENROLLMENT e
ON s.S_ID = e.S_ID
JOIN COURSE_SECTION cs
ON e.C_SEC_ID = cs.C_SEC_ID
JOIN TERM t
ON cs.TERM_ID = t.TERM_ID
WHERE t.TERM_DESC IN ('Fall 2024', 'Fall 2025', 'Spring 2025')
;
/


--------------------------------------------------------------------------------
-- c
/*
A query that will list the total building capacity of various buildings. The rooms
with a capacity of less than five are excluded when generating building�s total
capacity. Result lists the buildings with a total building capacity
of 150 or over, in the increasing order of the total capacity.
*/

SELECT l1.BLDG_CODE,
    SUM(l2.CAPACITY) BLDG_CAPACITY
FROM LOCATION l1
LEFT JOIN LOCATION l2
ON l1.BLDG_CODE = l2.BLDG_CODE
WHERE l1.CAPACITY >= 5
GROUP BY l1.BLDG_CODE
HAVING SUM(l2.CAPACITY) > 150
ORDER BY SUM(l2.CAPACITY)
;
/


--------------------------------------------------------------------------------
-- d
/*
A query that will list faculty supervisors and their respective students. Each
supervisor�s students appears in a single row, in the order of faculty supervisor's
id and include only those results where the number of students against a supervisor is
more than 1. */

SELECT (f.F_FIRST || ' ' || f.F_MI || ' ' || f.F_LAST) SUPERVISOR,
    LISTAGG(s.S_FIRST || ' ' || s.S_MI || ' ' || s.S_LAST, ', ') STUDENTS
FROM FACULTY f
JOIN STUDENT s
ON s.F_ID = f.F_ID
GROUP BY f.F_ID, f.F_FIRST, f.F_MI, f.F_LAST
HAVING COUNT(s.S_ID) > 1
ORDER BY f.F_ID
;
/


--------------------------------------------------------------------------------
-- e
/*
A query that will list students enrolled with a total of 12 or more course credit
points, in decreasing order of total credit points. */

SELECT (s.S_FIRST || ' ' || s.S_MI || ' ' || s.S_LAST) S_FULL_NAME,
    SUM(c.CREDITS) TOTAL_CREDITS
FROM STUDENT s
JOIN ENROLLMENT e
ON s.S_ID = e.S_ID
JOIN COURSE_SECTION cs
ON e.C_SEC_ID = cs.C_SEC_ID
JOIN COURSE c
ON cs.COURSE_NO = c.COURSE_NO
GROUP BY s.S_FIRST, s.S_MI, s.S_LAST, s.S_ID
HAVING SUM(c.CREDITS) >= 12
ORDER BY SUM(c.CREDITS) DESC
;
/


--------------------------------------------------------------------------------
-- f
/*
A query that lists the courses (with their course names) and the course sections
that are offered either on all the three days (M)onday, (W)ednesday and (F)riday or at
least four times a week. The course section days, the course
section time, number of the days that the courses are offered are also displayed, 
in the increasing order of number of days.
*/

SELECT c.COURSE_NO,
    c.COURSE_NAME,
    cs.SEC_NUM,
    cs.C_SEC_DAY,
    TO_CHAR(cs.C_SEC_TIME, 'HH AM') AS SECTION_TIME,
    LENGTH(cs.C_SEC_DAY) NUMBER_OF_DAYS

FROM COURSE c
JOIN COURSE_SECTION cs
ON c.COURSE_NO = cs.COURSE_NO
WHERE (C_SEC_DAY = 'MWF')
    OR (LENGTH(cs.C_SEC_DAY) >= 4)
ORDER BY LENGTH(cs.C_SEC_DAY)
;
/


--------------------------------------------------------------------------------
-- g
/*
A query listing the details of the faculty member(s) who supervise(s) the highest
number of students, and the number of students. The query also works in situations 
when more than one supervisor has the highest number of students
(e.g., 2 supervisors each having 5 students and 5 being highest number).*/

WITH MAX_STUDENTS AS (
    SELECT f.F_ID, 
        COUNT(s.S_ID) STUDENT_COUNT
    FROM FACULTY f
    JOIN STUDENT s
    ON f.F_ID = s.F_ID
    GROUP BY f.F_ID)

SELECT (f.F_FIRST || ' ' || f.F_MI || ' ' || f.F_LAST) SUPERVISOR,
    LISTAGG(s.S_FIRST || ' ' || s.S_MI || ' ' || s.S_LAST, ', ') STUDENTS,
    ms.STUDENT_COUNT MAX_STUDENTS
FROM FACULTY f
JOIN STUDENT s
ON s.F_ID = f.F_ID
JOIN MAX_STUDENTS ms
ON f.F_ID = ms.F_ID
WHERE ms.STUDENT_COUNT = (
    SELECT MAX(STUDENT_COUNT)
    FROM MAX_STUDENTS)
GROUP BY f.F_ID, f.F_FIRST, f.F_MI, f.F_LAST, ms.STUDENT_COUNT
ORDER BY f.F_ID
;
/ 

--adding students to other supervisor to check if the query works for supervisors 
--with the same number of students

INSERT INTO student VALUES
('JO103', 'Jones', 'Tom', 'R', '1817 Eagleridge Circle', 'Tallahassee', 
'FL', '32811', '7155559876', 'SR', TO_DATE('07/14/1998', 'MM/DD/YYYY'), 8891, 2, TO_YMINTERVAL('3-2'));
INSERT INTO student VALUES
('JO104', 'Jones', 'Kevin', 'R', '1817 Eagleridge Circle', 'Tallahassee', 
'FL', '32811', '7155559876', 'SR', TO_DATE('07/14/1998', 'MM/DD/YYYY'), 8891, 2, TO_YMINTERVAL('3-2'));
INSERT INTO student VALUES
('JO105', 'Jones', 'Ryan', 'R', '1817 Eagleridge Circle', 'Tallahassee', 
'FL', '32811', '7155559876', 'SR', TO_DATE('07/14/1998', 'MM/DD/YYYY'), 8891, 2, TO_YMINTERVAL('3-2'));
/

ROLLBACK;
/

--------------------------------------------------------------------------------
-- h
/*
A query that will list student(s) enrolled with the highest total course credit
points, the number of courses that a student is enrolled for, the average credit points, 
the highest credit points along with the total credit points. */

WITH MAX_CREDITS AS (
    SELECT s.S_ID,
        SUM(c.CREDITS) TOTAL_CREDITS,
        AVG(c.CREDITS) AVG_CREDITS,
        MAX(c.CREDITS) HIGHEST_CREDIT,
        COUNT(e.C_SEC_ID) NUMBER_OF_COURSE
    FROM STUDENT s
    JOIN ENROLLMENT e
    ON s.S_ID = e.S_ID
    JOIN COURSE_SECTION cs
    ON e.C_SEC_ID = cs.C_SEC_ID
    JOIN COURSE c
    ON cs.COURSE_NO = c.COURSE_NO
    GROUP BY s.S_ID)

SELECT (s.S_FIRST || ' ' || s.S_MI || ' ' || s.S_LAST) S_FULL_NAME,
    mc.TOTAL_CREDITS,
    mc.NUMBER_OF_COURSE,
    mc.AVG_CREDITS,
    mc.HIGHEST_CREDIT
    
FROM STUDENT s
JOIN MAX_CREDITS mc
ON s.S_ID = mc.S_ID
WHERE mc.TOTAL_CREDITS = (
    SELECT MAX(TOTAL_CREDITS)
    FROM MAX_CREDITS)
GROUP BY s.S_FIRST, s.S_MI, s.S_LAST, s.S_ID, 
    mc.NUMBER_OF_COURSE,
    mc.TOTAL_CREDITS,
    mc.AVG_CREDITS,
    mc.HIGHEST_CREDIT
ORDER BY s.S_ID
;
/ 


















