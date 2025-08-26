
/*
TRIGGER FOR COURSE AVAILABILITY IN SEMESTER and COURSE DUPLICATION

When Student intend to enroll in a new course, the trigger checks if enrollment 
for the chosen course is still open, and that Student didn't take this paper before 
to prevent duplicate enrollment.
*/

CREATE OR REPLACE TRIGGER TRG_ENROL_CHECK
BEFORE INSERT OR UPDATE OF C_SEC_ID
    ON ENROLLMENT
FOR EACH ROW
DECLARE
    T_AVAILABILITY VARCHAR2(6);
    E_DUPLICATE_CHECK NUMBER(1);
    EXC_ENROL_TERM_CLOSED EXCEPTION;
    EXC_E_DUPLICATE_CHECK EXCEPTION;
    
BEGIN
    
    SELECT t.STATUS
    INTO T_AVAILABILITY
    FROM TERM t
    JOIN COURSE_SECTION cs
    ON t.TERM_ID = cs.TERM_ID
    WHERE cs.C_SEC_ID = :NEW.C_SEC_ID
    ;
    
    IF T_AVAILABILITY = 'CLOSED'
        THEN RAISE EXC_ENROL_TERM_CLOSED;
    END IF;
    ----------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO E_DUPLICATE_CHECK
    FROM ENROLLMENT e
    JOIN COURSE_SECTION cs ON e.C_SEC_ID = cs.C_SEC_ID
    WHERE e.S_ID = :NEW.S_ID
    AND cs.COURSE_NO = (
        SELECT COURSE_NO
        FROM COURSE_SECTION 
        WHERE C_SEC_ID = :NEW.C_SEC_ID)
        ;
    
    IF E_DUPLICATE_CHECK > 0
        THEN RAISE EXC_E_DUPLICATE_CHECK;
    END IF;
        
        
EXCEPTION
    WHEN EXC_ENROL_TERM_CLOSED
        THEN RAISE_APPLICATION_ERROR(-20004, 'Term for chosen course is already closed. Please choose another course.');
    WHEN EXC_E_DUPLICATE_CHECK
        THEN RAISE_APPLICATION_ERROR(-20005, 'You already took this course. Please choose another.');
END;
/

-- adding another enrollment to check the closed term trigger
INSERT INTO enrollment VALUES
('JO100', 2, null);

-- adding another enrollment to check the duplicate course trigger
INSERT INTO enrollment VALUES
('JO100', 19, null);

ROLLBACK;

--------------------------------------------------------------------------------
-- b
/*
A trigger that does not allow more than two 'Full' ranked professors as part of the
faculty (For example, trigger should fire if a new (third) Full professor is added or the
rank of one of the existing Associate professors is promoted to Full). 
*/

CREATE OR REPLACE TRIGGER TRG_F_FULL_RANK_LIMIT
BEFORE INSERT OR UPDATE OF F_RANK
    ON FACULTY
FOR EACH ROW
DECLARE
    F_FULL_COUNT NUMBER;
    EXC_F_FULL_RANK_LIMIT EXCEPTION;
BEGIN
    SELECT COUNT(*)
    INTO F_FULL_COUNT
    FROM FACULTY
    WHERE F_RANK = 'Full'
        AND F_ID != :NEW.F_ID;
        
    IF (F_FULL_COUNT >= 2 AND :NEW.F_RANK = 'Full')
        THEN RAISE EXC_F_FULL_RANK_LIMIT;
    END IF;
    
EXCEPTION
    WHEN EXC_F_FULL_RANK_LIMIT
        THEN RAISE_APPLICATION_ERROR(-20001, 'More than two Full ranked professors are not allowed');
END;
/

-- adding another Faculty member with "Full" rank to check the trigger
INSERT INTO faculty VALUES
(6, 'Bond', 'James', 'L', 13, '4079817153', 'Full', 90000.00, 1, 6089, EMPTY_BLOB());

-- updating existing staff to "Full"
UPDATE FACULTY
SET F_RANK = 'Full'
WHERE F_ID = 1
;
/

ROLLBACK;
/

--------------------------------------------------------------------------------
-- c
/*
A trigger to check that when salary is updated for an existing faculty the raise is not
over 5.5%.*/

CREATE OR REPLACE TRIGGER TRG_F_SALARY
BEFORE UPDATE OF F_SALARY
    ON FACULTY
FOR EACH ROW
DECLARE
    --FULL_FCLT NUMBER(2);
    EXC_F_SALARY EXCEPTION;
BEGIN
    IF (:NEW.F_SALARY > :OLD.F_SALARY*1.055) 
        THEN RAISE EXC_F_SALARY;
    END IF;
EXCEPTION
    WHEN EXC_F_SALARY
        THEN RAISE_APPLICATION_ERROR(-20002, 'Current salary raise over 5.5% is not allowed');
END;
/

-- check the trigger by updating a salary with over 5.5% raise
UPDATE FACULTY
SET F_SALARY = 85000
WHERE F_ID = 1
;
/

--------------------------------------------------------------------------------
-- d

/*
A procedure to insert a new faculty record. The procedure also automatically
calculates the faculty salary value. This calculated salary should be 10% less than the
average salary of the existing faculty members. 
*/

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE PRC_F_NEW_RECORD 
    (IN_f_id NUMBER,
    IN_f_last VARCHAR2,
    IN_f_first VARCHAR2,
    IN_f_mi CHAR,
    IN_loc_id NUMBER,
    IN_f_phone VARCHAR2,
    IN_f_rank VARCHAR2,
    IN_f_manager NUMBER, 
    IN_f_pin NUMBER,
    IN_f_image BLOB)
IS
    V_f_NEW_salary number;
BEGIN
    SELECT (AVG(F_SALARY)*0.9)
    INTO V_f_NEW_salary
    FROM FACULTY
    ;
    
    INSERT INTO faculty VALUES
    (IN_f_id, IN_f_last, IN_f_first, IN_f_mi, IN_loc_id, IN_f_phone, IN_f_rank, 
    V_f_NEW_salary, IN_f_manager, IN_f_pin, IN_f_image);
    --COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('New faculty member added with salary: ' || TO_CHAR(V_f_NEW_salary, 'FM$999,999.00'));

END
;
/

EXECUTE PRC_F_NEW_RECORD(6, 'Bond', 'James', 'L', 13, '4079817153', 'Associate', 1, 6089, EMPTY_BLOB())
;
/

DELETE FROM FACULTY
WHERE F_ID = 6
;
/


--------------------------------------------------------------------------------
-- e

/*
A cursor to list course sections for all the MIS courses (along with their courses names
and credits), plus some meaningful summary statistics as part of the outcome.*/

CREATE OR REPLACE PROCEDURE PRC_MIS_COURSE IS
    CURSOR CUR_MIS_COURSE IS
    SELECT cs.C_SEC_ID,
        c.COURSE_NO,
        c.COURSE_NAME,
        c.CREDITS
    FROM COURSE c
    JOIN COURSE_SECTION cs
    ON c.COURSE_NO = cs.COURSE_NO
    WHERE c.COURSE_NO LIKE 'MIS%'
    ORDER BY cs.C_SEC_ID, c.COURSE_NO
    ;
--DECLARE
    VR_MIS_COURSE CUR_MIS_COURSE%ROWTYPE;
    TOTAL_COURSES NUMBER := 0;
    TOTAL_CREDITS NUMBER := 0;
    AVG_CREDITS NUMBER := 0;
BEGIN
    OPEN CUR_MIS_COURSE;
    LOOP
        FETCH CUR_MIS_COURSE INTO VR_MIS_COURSE;
        EXIT WHEN CUR_MIS_COURSE%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Course Section ID: ' || VR_MIS_COURSE.C_SEC_ID);
        DBMS_OUTPUT.PUT_LINE('Course No: ' || VR_MIS_COURSE.COURSE_NO);
        DBMS_OUTPUT.PUT_LINE('Course Name: ' || VR_MIS_COURSE.COURSE_NAME);
        DBMS_OUTPUT.PUT_LINE('Credits: ' || VR_MIS_COURSE.CREDITS);
        DBMS_OUTPUT.PUT_LINE('');
        
        TOTAL_COURSES := TOTAL_COURSES + 1;
        TOTAL_CREDITS := TOTAL_CREDITS + VR_MIS_COURSE.CREDITS;
        
    END LOOP;
        
    CLOSE CUR_MIS_COURSE;
    
    IF TOTAL_COURSES > 0 
        THEN AVG_CREDITS := ROUND((TOTAL_CREDITS / TOTAL_COURSES),2);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Total MIS Courses: ' || TOTAL_COURSES);
    DBMS_OUTPUT.PUT_LINE('Total Credits: ' || TOTAL_CREDITS);
    DBMS_OUTPUT.PUT_LINE('Average Credits per Course: ' || AVG_CREDITS);
    
        
END;
/

EXECUTE PRC_MIS_COURSE
;
/


--------------------------------------------------------------------------------
-- f

/*
A function, which can be used to format faculty member�s salary using appropriate
format (e.g., $80,000.00). 
*/

CREATE OR REPLACE FUNCTION FUNC_F_SALARY
    (IN_F_SALARY NUMBER)
RETURN VARCHAR2
IS
    OUT_F_SALARY VARCHAR2(20);
BEGIN
    OUT_F_SALARY := '$' || TO_CHAR(IN_F_SALARY, 'FM999,999,999.00'); 
    RETURN OUT_F_SALARY;
END;
/

-- to display a faculty member�s salary
SELECT F_ID, FUNC_F_SALARY(F_SALARY) F_SALARY_FORMATTED
FROM FACULTY
;
/











