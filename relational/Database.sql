
DROP TABLE enrollment CASCADE CONSTRAINTS;
DROP TABLE course_section CASCADE CONSTRAINTS;
DROP TABLE term CASCADE CONSTRAINTS;
DROP TABLE course CASCADE CONSTRAINTS;
DROP TABLE student CASCADE CONSTRAINTS;
DROP TABLE faculty CASCADE CONSTRAINTS;
DROP TABLE location CASCADE CONSTRAINTS;

CREATE TABLE LOCATION
(loc_id NUMBER(3),
bldg_code VARCHAR2(5),
room VARCHAR2(4),
capacity NUMBER(3), 
CONSTRAINT location_loc_id_pk PRIMARY KEY (loc_id));

CREATE TABLE faculty
(f_id NUMBER(3),
f_last VARCHAR2(15),
f_first VARCHAR2(15),
f_mi CHAR(1),
loc_id NUMBER(3) not null,
f_phone VARCHAR2(10),
f_rank VARCHAR2(9),
f_salary number(9,2), 
f_manager NUMBER(3), 
f_pin NUMBER(4),
f_image BLOB, 
CONSTRAINT faculty_f_id_pk PRIMARY KEY(f_id),
CONSTRAINT faculty_loc_id_fk FOREIGN KEY (loc_id) REFERENCES location(loc_id));

CREATE TABLE student
(s_id VARCHAR2(6),
s_last VARCHAR2(15),
s_first VARCHAR2(15),
s_mi CHAR(1),
s_address VARCHAR2(25),
s_city VARCHAR2(20),
s_state CHAR(2),
s_zip VARCHAR2(10),
s_phone VARCHAR2(10),
s_class CHAR(2),
s_dob DATE,
s_pin NUMBER(4),
f_id NUMBER(3) not null,
time_enrolled INTERVAL YEAR TO MONTH,
CONSTRAINT student_s_id_pk PRIMARY KEY (s_id),
CONSTRAINT student_f_id_fk FOREIGN KEY (f_id) REFERENCES faculty(f_id));

CREATE TABLE TERM
(term_id NUMBER(6),
term_desc VARCHAR2(20),
status VARCHAR2(6),
start_date DATE,
CONSTRAINT term_term_id_pk PRIMARY KEY (term_id),
CONSTRAINT term_status_cc CHECK ((status = 'OPEN') OR (status = 'CLOSED')));

CREATE TABLE COURSE
(course_no VARCHAR2(7),
course_name VARCHAR2(50),
credits NUMBER(2),
CONSTRAINT course_course_id_pk PRIMARY KEY(course_no));

CREATE TABLE COURSE_SECTION
(c_sec_id NUMBER(6),
course_no VARCHAR2(7) CONSTRAINT course_section_courseid_nn NOT NULL,
term_id NUMBER(6) CONSTRAINT course_section_termid_nn NOT NULL,
sec_num NUMBER(2) CONSTRAINT course_section_secnum_nn NOT NULL,
f_id NUMBER(3),
c_sec_day VARCHAR2(10),
c_sec_time DATE,
c_sec_duration INTERVAL DAY TO SECOND,
loc_id NUMBER(3),
max_enrl NUMBER(4) CONSTRAINT course_section_maxenrl_nn NOT NULL,
CONSTRAINT course_section_csec_id_pk PRIMARY KEY (c_sec_id),
CONSTRAINT course_section_cid_fk FOREIGN KEY (course_no) REFERENCES course(course_no), 	
CONSTRAINT course_section_loc_id_fk FOREIGN KEY (loc_id) REFERENCES location(loc_id),
CONSTRAINT course_section_termid_fk FOREIGN KEY (term_id) REFERENCES term(term_id),
CONSTRAINT course_section_fid_fk FOREIGN KEY (f_id) REFERENCES faculty(f_id));

CREATE TABLE ENROLLMENT
(s_id VARCHAR2(6),
c_sec_id NUMBER(6),
grade CHAR(1),
CONSTRAINT enrollment_pk PRIMARY KEY (s_id, c_sec_id),
CONSTRAINT enrollment_sid_fk FOREIGN KEY (s_id) REFERENCES student(s_id),
CONSTRAINT enrollment_csecid_fk FOREIGN KEY (c_sec_id) REFERENCES course_section (c_sec_id));


---- inserting into LOCATION table
INSERT INTO location VALUES
(1, 'CR', '101', 150);

INSERT INTO location VALUES
(2, 'CR', '202', 40);

INSERT INTO location VALUES
(3, 'CR', '103', 35);

INSERT INTO location VALUES
(4, 'CR', '105', 35);

INSERT INTO location VALUES
(5, 'BUS', '105', 42);

INSERT INTO location VALUES
(6, 'BUS', '404', 35);

INSERT INTO location VALUES
(7, 'BUS', '421', 35);

INSERT INTO location VALUES
(8, 'BUS', '211', 55);

INSERT INTO location VALUES
(9, 'BUS', '424', 1);

INSERT INTO location VALUES
(10, 'BUS', '402', 1);

INSERT INTO location VALUES
(11, 'BUS', '433', 1);

INSERT INTO location VALUES
(12, 'LIB', '217', 2);

INSERT INTO location VALUES
(13, 'LIB', '222', 1);


--- inserting records into FACULTY
INSERT INTO faculty VALUES
(1, 'Smith', 'Teresa', 'J', 9, '4075921695', 'Associate', 80000.00, 4, 6338, EMPTY_BLOB());

INSERT INTO faculty VALUES
(2, 'Zhulin', 'Mark', 'M', 10, '4073875682', 'Full', 108000.00, NULL, 1121, EMPTY_BLOB());

INSERT INTO faculty VALUES
(3, 'Langley', 'Colin', 'A', 12, '4075928719', 'Assistant', 70000.00, 4, 9871, EMPTY_BLOB());

INSERT INTO faculty VALUES
(4, 'Brown', 'Rita', 'D', 11, '4078101155', 'Full', 112000.00, NULL, 8297, EMPTY_BLOB());

INSERT INTO faculty VALUES
(5, 'Patel', 'James', 'L', 13, '4079817153', 'Associate', 90000.00, 1, 6089, EMPTY_BLOB());

--- inserting records into STUDENT
INSERT INTO student VALUES
('JO100', 'Jones', 'Sammy', 'R', '1817 Eagleridge Circle', 'Tallahassee', 
'FL', '32811', '7155559876', 'SR', TO_DATE('07/14/1998', 'MM/DD/YYYY'), 8891, 1, TO_YMINTERVAL('3-2'));

INSERT INTO student VALUES
('PE100', 'Zhu', 'George', 'C', '951 Rainbow Dr', 'Clermont', 
'FL', '34711', '7155552345', 'SR', TO_DATE('08/19/1989', 'MM/DD/YYYY'), 1230, 1, TO_YMINTERVAL('4-2'));

INSERT INTO student VALUES
('MA100', 'Marsh', 'Johnny', 'A', '1275 West Main St', 'Carrabelle', 
'FL', '32320', '7155553907', 'JR', TO_DATE('10/10/2001', 'MM/DD/YYYY'), 1613, 1, TO_YMINTERVAL('3-0'));

INSERT INTO student VALUES
('SM100', 'Tyson', 'Mike', NULL, '428 Markson Ave', 'Eastpoint', 
'FL', '32328', '7155556902', 'SO', TO_DATE('09/24/2004', 'MM/DD/YYYY'), 1841, 2, TO_YMINTERVAL('2-2'));

INSERT INTO student VALUES
('JO101', 'Johnson', 'Lisa', 'M', '764 Johnson Place', 'Leesburg', 
'FL', '34751', '7155558899', 'SO', TO_DATE('11/20/2003', 'MM/DD/YYYY'), 4420, 4, TO_YMINTERVAL('1-11'));

INSERT INTO student VALUES
('NG100', 'Nguyen', 'Ni', 'M', '688 4th Street', 'Orlando', 
'FL', '31458', '7155554944', 'FR', TO_DATE('12/4/2004', 'MM/DD/YYYY'), 9188, 3, TO_YMINTERVAL('0-4'));

INSERT INTO student VALUES
('TI100', 'Tindall', 'Lisa', 'O', '900 5th Street', 'Tallahassee', 
'FL', '32811', '7155554990', 'FR', TO_DATE('12/5/2002', 'MM/DD/YYYY'), 8894, 2, TO_YMINTERVAL('0-4'));

INSERT INTO student VALUES
('LA100', 'Lam', 'Mary', NULL, '909 4th Street', 'Orlando', 
'FL', '31458', '7156664990', 'SO', TO_DATE('12/6/2001', 'MM/DD/YYYY'), 8899, 3, TO_YMINTERVAL('0-4'));

INSERT INTO student VALUES
('PA100', 'Patel', 'Mona', NULL, '764 Kanuka Place', 'Westpoint', 
'FL', '34752', '7155238890', 'JR', TO_DATE('11/20/2004', 'MM/DD/YYYY'), 4424, 1, TO_YMINTERVAL('1-11'));

INSERT INTO student VALUES
('JO102', 'Jonhson', 'Katy', 'A', '18 Eaglepoint Place', 'Tallahassee', 
'FL', '32811', '7159099876', 'SR', TO_DATE('05/19/1999', 'MM/DD/YYYY'), 8898, 1, TO_YMINTERVAL('3-2'));



--- inserting records into TERM
INSERT INTO term (term_id, term_desc, status, start_date) VALUES 
(1, 'Fall 2022', 'CLOSED', '29-AUG-2022');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(2, 'Spring 2023', 'CLOSED', '09-JAN-2023');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(3, 'Summer 2023', 'CLOSED', '15-MAY-2023');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(4, 'Fall 2023', 'CLOSED', '28-AUG-2023');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(5, 'Spring 2024', 'CLOSED', '08-JAN-2024');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(6, 'Summer 2024', 'CLOSED', '18-MAY-2024');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(7, 'Fall 2024', 'CLOSED', '26-AUG-2024');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(8, 'Spring 2025', 'OPEN', '09-JAN-2025');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(9, 'Summer 2025', 'OPEN', '17-MAY-2025');

INSERT INTO term (term_id, term_desc, status, start_date) VALUES
(10, 'Fall 2025', 'OPEN', '28-AUG-2025');

--- inserting records into COURSE
INSERT INTO course VALUES
('MIS 101', 'Intro. to Info. Systems', 3);

INSERT INTO course VALUES
('MIS 301', 'Systems Analysis', 3);

INSERT INTO course VALUES
('MIS 441', 'Database Management', 3);

INSERT INTO course VALUES
('CS 155', 'Programming in C++', 3);

INSERT INTO course VALUES
('MIS 451', 'Web-Based Systems', 3);

INSERT INTO course VALUES
('MIS 240', 'Social Media Networks for Business', 3);

INSERT INTO course VALUES
('MIS 241', 'Technology Trends for Organisations', 3);

INSERT INTO course VALUES
('MIS 340', 'Organisational Knowledgement Management', 3);

INSERT INTO course VALUES
('MIS 500', 'Information Systems Project', 6);

INSERT INTO course VALUES
('MIS 600', 'Data Wrangling and Machine Learning', 3);

INSERT INTO course VALUES
('MIS 601', 'Artificial Intelligence Research', 6);


--- inserting records into COURSE_SECTION


INSERT INTO course_section VALUES
(1, 'MIS 101', 4, 1, 2, 'MWF', TO_DATE('10:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:00:50.00'), 1, 140);

INSERT INTO course_section VALUES
(2, 'MIS 101', 4, 2, 3, 'TR', TO_DATE('09:30 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:15.00'), 7, 35);

INSERT INTO course_section VALUES
(3, 'MIS 101', 4, 3, 3, 'MWF', TO_DATE('08:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:00:50.00'), 2, 35);

INSERT INTO course_section VALUES
(4, 'MIS 301', 4, 1, 4, 'TR', TO_DATE('11:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:15.00'), 6, 35);

INSERT INTO course_section VALUES
(5, 'MIS 301', 5, 2, 4, 'TR', TO_DATE('02:00 PM', 'HH:MI PM'), TO_DSINTERVAL('0 00:01:15.00'), 6, 35);

INSERT INTO course_section VALUES
(6, 'MIS 441', 5, 1, 1, 'MWF', TO_DATE('09:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:00:50.00'), 5, 30);

INSERT INTO course_section VALUES
(7, 'MIS 441', 5, 2, 1, 'MWF', TO_DATE('10:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:00:50.00'), 5, 30);

INSERT INTO course_section VALUES
(8, 'CS 155', 5, 1, 5, 'TR', TO_DATE('08:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:15.00'), 3, 35);

INSERT INTO course_section VALUES
(9, 'MIS 451', 5, 1, 2, 'MWF', TO_DATE('02:00 PM', 'HH:MI PM'), TO_DSINTERVAL('0 00:00:50.00'), 5, 35);

INSERT INTO course_section VALUES
(10, 'MIS 451', 5, 2, 2, 'MWRF', TO_DATE('03:00 PM', 'HH:MI PM'), TO_DSINTERVAL('0 00:00:50.00'), 5, 35);

INSERT INTO course_section VALUES
(11, 'MIS 101', 6, 4, 1, 'MTWRF', TO_DATE('08:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:30.00'), 1, 50);

INSERT INTO course_section VALUES
(12, 'MIS 301', 6, 3, 2, 'TWRF', TO_DATE('08:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:30.00'), 6, 35);

INSERT INTO course_section VALUES
(13, 'MIS 441', 6, 3, 3, 'TWRF', TO_DATE('09:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:30.00'), 5, 35);

INSERT INTO course_section VALUES
(14, 'MIS 240', 7, 1, 5, 'TWRF', TO_DATE('11:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:30.00'), 11, 55);

INSERT INTO course_section VALUES
(15, 'MIS 241', 8, 1, 3, 'WRF', TO_DATE('09:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:30.00'), 7, 60);

INSERT INTO course_section VALUES
(16, 'MIS 340', 8, 1, 3, 'WRF', TO_DATE('10:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:01:30.00'), 8, 65);

INSERT INTO course_section VALUES
(17, 'MIS 500', 4, 1, 3, 'WRF', TO_DATE('10:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:02:50.00'), 8, 25);

INSERT INTO course_section VALUES
(18, 'MIS 600', 8, 1, 3, 'MTWF', TO_DATE('11:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:02:50.00'), 1, 25);

INSERT INTO course_section VALUES
(19, 'MIS 101', 9, 5, 4, 'TWF', TO_DATE('09:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:02:50.00'), 11, 35);

INSERT INTO course_section VALUES
(20, 'MIS 601', 10, 1, 5, 'TWRF', TO_DATE('10:00 AM', 'HH:MI AM'), TO_DSINTERVAL('0 00:02:50.00'), 9, 50);


--- inserting records into ENROLLMENT
INSERT INTO enrollment VALUES
('JO100', 1, 'A');

INSERT INTO enrollment VALUES
('JO100', 4, 'A');

INSERT INTO enrollment VALUES
('JO100', 6, 'B');

INSERT INTO enrollment VALUES
('JO100', 9, 'B');

INSERT INTO enrollment VALUES
('JO100', 17, 'A');

INSERT INTO enrollment VALUES
('JO100', 11, 'A');

INSERT INTO enrollment VALUES
('PE100', 1, 'C');

INSERT INTO enrollment VALUES
('PE100', 5, 'B');

INSERT INTO enrollment VALUES
('PE100', 6, 'A');

INSERT INTO enrollment VALUES
('PE100', 9, 'B');

INSERT INTO enrollment VALUES
('PE100', 16, NULL);

INSERT INTO enrollment VALUES
('MA100', 1, 'C');

INSERT INTO enrollment VALUES
('MA100', 12, 'C');

INSERT INTO enrollment VALUES
('MA100', 13, 'B');

INSERT INTO enrollment VALUES
('MA100', 14, 'B');

INSERT INTO enrollment VALUES
('MA100', 15, NULL);

INSERT INTO enrollment VALUES
('SM100', 11, 'C');

INSERT INTO enrollment VALUES
('SM100', 12, 'B');

INSERT INTO enrollment VALUES
('JO101', 1, 'B');

INSERT INTO enrollment VALUES
('JO101', 5, 'C');

INSERT INTO enrollment VALUES
('JO101', 9, 'C');

INSERT INTO enrollment VALUES
('JO101', 11, 'A');

INSERT INTO enrollment VALUES
('JO101', 13, 'B');

INSERT INTO enrollment VALUES
('NG100', 9, 'B');

INSERT INTO enrollment VALUES
('NG100', 11, 'C');

INSERT INTO enrollment VALUES
('NG100', 12, 'B');

INSERT INTO enrollment VALUES
('NG100', 16, NULL);

INSERT INTO enrollment VALUES
('TI100', 9, 'A');

INSERT INTO enrollment VALUES
('TI100', 11, 'A');

INSERT INTO enrollment VALUES
('TI100', 12, 'A');

INSERT INTO enrollment VALUES
('TI100', 13, 'B');

INSERT INTO enrollment VALUES
('TI100', 20, NULL);

INSERT INTO enrollment VALUES
('TI100', 8, 'B');

INSERT INTO enrollment VALUES
('LA100', 17, NULL);

INSERT INTO enrollment VALUES
('LA100', 16, NULL);

INSERT INTO enrollment VALUES
('LA100', 18, NULL);

INSERT INTO enrollment VALUES
('LA100', 19, NULL);

INSERT INTO enrollment VALUES
('LA100', 20, NULL);

INSERT INTO enrollment VALUES
('PA100', 18, NULL);

INSERT INTO enrollment VALUES
('PA100', 19, NULL);

INSERT INTO enrollment VALUES
('PA100', 20, NULL);

INSERT INTO enrollment VALUES
('JO102', 18, NULL);

INSERT INTO enrollment VALUES
('JO102', 19, NULL);

INSERT INTO enrollment VALUES
('JO102', 20, NULL);


COMMIT;


select * from location;
select * from faculty;
select * from student;
select * from term;
select * from course;
select * from course_section;
select * from enrollment;


