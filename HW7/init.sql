--Create database
go
create database University
go
use University

create table Department (
    department_id varchar(5) primary key,
    department_name varchar(50) not null,
    office varchar(5),
    department_head varchar(9)
)

--Create table
create table Student (
    student_id varchar(9) primary key,
    student_name nvarchar(50) not null,
    gender char(1) check (gender IN ('F', 'M', 'O')),
    birthdate  datetime,
    class  varchar(5),
    department_id varchar(5), 
    foreign key(department_id) references Department 
)

create table Course (
    course_id varchar(9) primary key,
    course_name nvarchar(50) not null unique,
    credit int check (credit > 0),
    department_id varchar(5), 
    foreign key(department_id) references Department 
)

create table Section (
    section_id  int primary key,
    course_id  varchar(9) not null, 
    semester  varchar(9) not null,
    school_year  int not null,
    capacity  int check (capacity > 0),
    unique (course_id, semester, school_year),
    foreign key (course_id) references Course
)

create table Instructor (
    instructor_id varchar(9) primary key,
    instructor_name nvarchar(50) not null,
    phone nvarchar(9) not null,
    department_id varchar(5),
    salary int check (salary > 0),
    foreign key(department_id) references Department
)

create table Teaching (
    section_id  int not null,
    instructor_id  varchar(9) not null,
    teaching_role  varchar(9) check (teaching_role in ('Lecturer', 'TA')),
    primary key (section_id, instructor_id),
    foreign key (instructor_id) references Instructor,
    foreign key (section_id) references Section
)

create table GradeReport (
    section_id  int not null, 
    student_id  varchar(9) not null, 
    grade_100  int check(grade_100 >= 0), 
    grade_ABC  char(1) check (grade_ABC in ('A', 'B', 'C', 'D', 'E', 'F')),
    primary key (section_id, student_id),
    foreign key(section_id) references Section,
    foreign key(student_id) references Student
)

create table Prerequisite (
    course_id  varchar(9) not null, 
    prerequisite_id  varchar(9) not null, 
    primary key (course_id, prerequisite_id),
    foreign key (course_id) references Course,
    foreign key (prerequisite_id) references Course
)

go
alter table Department add foreign key(department_head) references Instructor

go
--Insert data

insert into Department values ('CS', 'Computer Science', 'I81', null)
insert into Department values ('SE', 'Software Engineering', 'I82', null)
insert into Department values ('IS', 'Information System', 'I84', null)
insert into Department values ('AI', 'Artificial Intelligence', 'I86', null)
insert into Department values ('NW', 'Network', 'I87', null)

insert into Student values ('ST001', 'Nguyen Ai Linh', 'F', '2002/12/01', '23TT1', 'CS')
insert into Student values ('ST002', 'Tran Thanh Sang', 'M', '2003/09/02', '23TT1', 'CS')
insert into Student values ('ST003', 'Huynh Thanh Phong', 'M', '2001/05/03', '23TT1', 'SE')
insert into Student values ('ST004', 'Hoang Nhat Linh', 'F', '2002/05/10', '23TT1', 'SE')
insert into Student values ('ST005', 'Le Ba Khanh', 'M', '2001/11/12', '23TT1', null)
insert into Student values ('ST006', 'Ly Quoc Phong', 'M', '2000/08/12', '23TT1', 'SE')
insert into Student values ('ST007', 'Tran Thanh An', 'F', '2000/11/09', '23TT1', 'IS')
insert into Student values ('ST008', 'Le Nha Thu', 'F', '2002/08/09', '23TT1', null)
insert into Student values ('ST009', 'Ho Ngoc Anh', 'F', '2003/11/01', '23TT1', 'AI')
insert into Student values ('ST010', 'Nguyen Thanh Son', 'M', '2003/12/05', '23TT1', 'NW')

INSERT INTO Student (student_id, student_name, gender, birthdate, class, department_id) VALUES
('ST011', N'Nguyễn Thị Thảo', 'F', '2003/09/15', '23TT2', 'CS'),
('ST012', N'Trần Văn Hùng', 'M', '2002/05/20', '23TT2', null),
('ST013', N'Lê Thị Mai', 'F', '2004/11/01', '23TT2', 'IS'),
('ST014', N'Phạm Minh Đức', 'M', '2003/03/25', '23TT2', null),
('ST015', N'Hoàng Thanh Trúc', 'F', '2002/07/10', '23TT2', 'NW'),
('ST016', N'Vũ Anh Khoa', 'M', '2004/01/30', '23TT2', 'CS'),
('ST017', N'Đặng Thị Lan Anh', 'F', '2003/06/12', '23TT2', 'SE'),
('ST018', N'Bùi Xuân Tùng', 'M', '2005/12/05', '23TT2', 'IS'),
('ST019', N'Ngô Thúy Hằng', 'F', '1999/08/18', '23TT2', 'AI'),
('ST020', N'Đỗ Minh Quân', 'M', '2003/02/28', '23TT2', null);

insert into Course values ('CS01', 'Databases', 4, 'IS')
insert into Course values ('CS02', 'Database Management System', 4, 'IS')
insert into Course values ('CS03', 'Introduction to Programming', 4, 'SE')
insert into Course values ('CS04', 'Object-Oriented Programming', 4, 'SE')
insert into Course values ('CS05', 'Basic Network', 4, 'NW')
insert into Course values ('CS06', 'Advanced Network', 4, 'NW')
insert into Course values ('CS07', 'Introduction to Artificial Intelligence', 4, 'AI')
insert into Course values ('CS08', 'Introduction to Machine Learning', 4, 'CS')
insert into Course values ('CS09', 'Computer Vision', 4, 'CS')
insert into Course values ('CS10', 'Robotics', 4, 'AI')

insert into Instructor values ('I001', 'Dang Huynh Bao Khanh', '080913213', 'CS', 1000)
insert into Instructor values ('I002', 'Alex Grant', '082412613', 'CS', 2000)
insert into Instructor values ('I003', 'Tran Hoang Lan', '080921234', 'SE', 1500)
insert into Instructor values ('I004', 'Nguyen Ngoc Khanh', '090245613', 'IS', 1500)
insert into Instructor values ('I005', 'James Cobb', '092193213', 'SE', 2000)
insert into Instructor values ('I006', 'Le Khanh', '090799131', 'IS', 2200)
insert into Instructor values ('I007', 'Vu Ngoc Bao', '090511342', 'SE', 2100)
insert into Instructor values ('I008', 'Tran Hong An', '099912353', 'NW', 1900)
insert into Instructor values ('I009', 'Nguyen Hai Lam', '080911234', 'AI', 1500)
insert into Instructor values ('I010', 'Dang Hoang Phong', '090233451', 'AI', 2300)
insert into Instructor values ('I011', 'John Grant', '087392133', 'CS', 1000)
insert into Instructor values ('I012', 'Danny John', '083493012', 'AI', 3000)
/* 
1 6
2 7
3 8
4
9 11
12
5 10 13
*/
insert into Section values (1, 'CS01', 'Fall', 2022, 30)
insert into Section values (2, 'CS02', 'Fall', 2022, 30)
insert into Section values (3, 'CS03', 'Fall', 2022, 30)
insert into Section values (4, 'CS04', 'Fall', 2022, 30)
insert into Section values (5, 'CS07', 'Fall', 2022, 30)
insert into Section values (6, 'CS01', 'Spring', 2022, 20)
insert into Section values (7, 'CS02', 'Spring', 2022, 20)
insert into Section values (8, 'CS03', 'Spring', 2022, 20)
insert into Section values (9, 'CS05', 'Spring', 2022, 20)
insert into Section values (10, 'CS07', 'Spring', 2022, 30)
insert into Section values (11, 'CS05', 'Fall', 2023, 12)
insert into Section values (12, 'CS06', 'Fall', 2023, 12)
insert into Section values (13, 'CS07', 'Fall', 2023, 12)
insert into Section values (14, 'CS08', 'Fall', 2023, 12)

insert into Teaching values (1, 'I004', 'Lecturer')
insert into Teaching values (1, 'I006', 'TA')
insert into Teaching values (2, 'I004', 'Lecturer')
insert into Teaching values (2, 'I007', 'TA')
insert into Teaching values (3, 'I005', 'Lecturer')
insert into Teaching values (3, 'I003', 'TA')
insert into Teaching values (4, 'I005', 'Lecturer')
insert into Teaching values (4, 'I009', 'TA')
insert into Teaching values (5, 'I004', 'Lecturer')
insert into Teaching values (5, 'I006', 'TA')
insert into Teaching values (6, 'I004', 'Lecturer')
insert into Teaching values (7, 'I005', 'Lecturer')
insert into Teaching values (8, 'I008', 'Lecturer')

insert into Prerequisite values ('CS02', 'CS01')
insert into Prerequisite values ('CS04', 'CS03')
insert into Prerequisite values ('CS06', 'CS05')
insert into Prerequisite values ('CS08', 'CS07')
insert into Prerequisite values ('CS09', 'CS07')
insert into Prerequisite values ('CS10', 'CS07')

insert into GradeReport values (1, 'ST001', 80, null)
insert into GradeReport values (1, 'ST002', 82, null)
insert into GradeReport values (1, 'ST003', 35, null)
insert into GradeReport values (1, 'ST004', 60, null)
insert into GradeReport values (1, 'ST005', 100, null)
insert into GradeReport values (1, 'ST006', 100, null)
insert into GradeReport values (1, 'ST007', 90, null)
insert into GradeReport values (1, 'ST008', 52, null)
insert into GradeReport values (1, 'ST009', 36, null)
insert into GradeReport values (1, 'ST010', 99, null)

insert into GradeReport values (2, 'ST001', 77, null)
insert into GradeReport values (2, 'ST002', 84, null)
insert into GradeReport values (2, 'ST003', 60, null)
insert into GradeReport values (2, 'ST004', 53, null)
insert into GradeReport values (2, 'ST005', 99, null)
insert into GradeReport values (2, 'ST006', 93, null)
insert into GradeReport values (2, 'ST007', 82, null)
insert into GradeReport values (2, 'ST008', 63, null)
insert into GradeReport values (2, 'ST009', 62, null)
insert into GradeReport values (2, 'ST010', 88, null)

insert into GradeReport values (3, 'ST001', 80, null)
insert into GradeReport values (3, 'ST002', 82, null)
insert into GradeReport values (3, 'ST003', 53, null)
insert into GradeReport values (3, 'ST004', 36, null)
insert into GradeReport values (3, 'ST005', 72, null)
insert into GradeReport values (3, 'ST006', 88, null)
insert into GradeReport values (3, 'ST007', 98, null)
insert into GradeReport values (3, 'ST008', 44, null)
insert into GradeReport values (3, 'ST009', 50, null)
insert into GradeReport values (3, 'ST010', 72, null)

insert into GradeReport values (4, 'ST001', 92, null)
insert into GradeReport values (4, 'ST002', 78, null)
insert into GradeReport values (4, 'ST003', 85, null)
insert into GradeReport values (4, 'ST004', 43, null)
insert into GradeReport values (4, 'ST005', 88, null)
insert into GradeReport values (4, 'ST006', 97, null)
insert into GradeReport values (4, 'ST007', 87, null)
insert into GradeReport values (4, 'ST008', 54, null)
insert into GradeReport values (4, 'ST009', 73, null)
insert into GradeReport values (4, 'ST010', 36, null)

INSERT INTO GradeReport VALUES (1, 'ST011', 85, NULL);
INSERT INTO GradeReport VALUES (1, 'ST012', 72, NULL);
INSERT INTO GradeReport VALUES (1, 'ST013', 45, NULL);
INSERT INTO GradeReport VALUES (1, 'ST014', 68, NULL);
INSERT INTO GradeReport VALUES (1, 'ST015', 92, NULL);
INSERT INTO GradeReport VALUES (1, 'ST016', 79, NULL);
INSERT INTO GradeReport VALUES (1, 'ST017', 55, NULL);
INSERT INTO GradeReport VALUES (1, 'ST018', 88, NULL);
INSERT INTO GradeReport VALUES (1, 'ST019', 30, NULL);
INSERT INTO GradeReport VALUES (1, 'ST020', 95, NULL);

INSERT INTO GradeReport VALUES (2, 'ST011', 78, NULL);
INSERT INTO GradeReport VALUES (2, 'ST012', 81, NULL);
INSERT INTO GradeReport VALUES (2, 'ST013', 65, NULL);
INSERT INTO GradeReport VALUES (2, 'ST014', 50, NULL);
INSERT INTO GradeReport VALUES (2, 'ST015', 98, NULL);
INSERT INTO GradeReport VALUES (2, 'ST016', 85, NULL);
INSERT INTO GradeReport VALUES (2, 'ST017', 70, NULL);
INSERT INTO GradeReport VALUES (2, 'ST018', 60, NULL);
INSERT INTO GradeReport VALUES (2, 'ST019', 75, NULL);
INSERT INTO GradeReport VALUES (2, 'ST020', 89, NULL);

INSERT INTO GradeReport VALUES (3, 'ST011', 90, NULL);
INSERT INTO GradeReport VALUES (3, 'ST012', 75, NULL);
INSERT INTO GradeReport VALUES (3, 'ST013', 58, NULL);
INSERT INTO GradeReport VALUES (3, 'ST014', 37, NULL);
INSERT INTO GradeReport VALUES (3, 'ST015', 36, NULL);
INSERT INTO GradeReport VALUES (3, 'ST016', 91, NULL);
INSERT INTO GradeReport VALUES (3, 'ST017', 99, NULL);
INSERT INTO GradeReport VALUES (3, 'ST018', 40, NULL);
INSERT INTO GradeReport VALUES (3, 'ST019', 60, NULL);
INSERT INTO GradeReport VALUES (3, 'ST020', 83, NULL);

INSERT INTO GradeReport VALUES (4, 'ST011', 95, NULL);
INSERT INTO GradeReport VALUES (4, 'ST012', 80, NULL);
INSERT INTO GradeReport VALUES (4, 'ST013', 88, NULL);
INSERT INTO GradeReport VALUES (4, 'ST014', 37, NULL);
INSERT INTO GradeReport VALUES (4, 'ST015', 90, NULL);
INSERT INTO GradeReport VALUES (4, 'ST016', 92, NULL);
INSERT INTO GradeReport VALUES (4, 'ST017', 77, NULL);
INSERT INTO GradeReport VALUES (4, 'ST018', 55, NULL);
INSERT INTO GradeReport VALUES (4, 'ST019', 70, NULL);
INSERT INTO GradeReport VALUES (4, 'ST020', 82, NULL);

INSERT INTO GradeReport VALUES (5, 'ST001', 95, NULL);
INSERT INTO GradeReport VALUES (5, 'ST012', 80, NULL);
INSERT INTO GradeReport VALUES (5, 'ST003', 88, NULL);
INSERT INTO GradeReport VALUES (5, 'ST014', 48, NULL);
INSERT INTO GradeReport VALUES (5, 'ST005', 90, NULL);
INSERT INTO GradeReport VALUES (5, 'ST016', 92, NULL);
INSERT INTO GradeReport VALUES (5, 'ST007', 77, NULL);
INSERT INTO GradeReport VALUES (5, 'ST018', 36, NULL);
INSERT INTO GradeReport VALUES (5, 'ST009', 70, NULL);
INSERT INTO GradeReport VALUES (5, 'ST020', 82, NULL);

INSERT INTO GradeReport VALUES (10, 'ST011', 95, NULL);
INSERT INTO GradeReport VALUES (10, 'ST002', 80, NULL);
INSERT INTO GradeReport VALUES (10, 'ST013', 88, NULL);
INSERT INTO GradeReport VALUES (10, 'ST004', 48, NULL);
INSERT INTO GradeReport VALUES (10, 'ST015', 90, NULL);
INSERT INTO GradeReport VALUES (10, 'ST006', 92, NULL);
INSERT INTO GradeReport VALUES (10, 'ST017', 77, NULL);
INSERT INTO GradeReport VALUES (10, 'ST008', 55, NULL);
INSERT INTO GradeReport VALUES (10, 'ST019', 70, NULL);
INSERT INTO GradeReport VALUES (10, 'ST010', 82, NULL);

INSERT INTO GradeReport VALUES (13, 'ST011', 95, NULL);
INSERT INTO GradeReport VALUES (13, 'ST012', 80, NULL);
INSERT INTO GradeReport VALUES (13, 'ST013', 88, NULL);
INSERT INTO GradeReport VALUES (13, 'ST014', 48, NULL);
INSERT INTO GradeReport VALUES (13, 'ST015', 90, NULL);
INSERT INTO GradeReport VALUES (13, 'ST006', 92, NULL);
INSERT INTO GradeReport VALUES (13, 'ST007', 77, NULL);
INSERT INTO GradeReport VALUES (13, 'ST008', 55, NULL);
INSERT INTO GradeReport VALUES (13, 'ST009', 70, NULL);
INSERT INTO GradeReport VALUES (13, 'ST010', 82, NULL);
update Department set department_head = 'I001' where department_id = 'CS'
update Department set department_head = 'I009' where department_id = 'AI'
update Department set department_head = 'I004' where department_id = 'IS'
update Department set department_head = 'I003' where department_id = 'SE'




update GradeReport set grade_ABC = 
    CASE  
    WHEN grade_100 between 90 and 100 then 'A'
    WHEN grade_100 between 80 and 89 then 'B'
    WHEN grade_100 between 70 and 79 then 'C'
    WHEN grade_100 between 65 and 69 then 'D'
    WHEN grade_100 <65 then 'F'
    end

select * from gradereport

CREATE TABLE TeachingCapacity (
	instructor_id VARCHAR(9) NOT NULL,
	course_id VARCHAR(9) NOT NULL,
	nb_year INT,

	CONSTRAINT PK_iid_cid
		PRIMARY KEY (instructor_id, course_id),
	CONSTRAINT FK_instructor_id
		FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id),
	CONSTRAINT FK_course_id
		FOREIGN KEY (course_id) REFERENCES Course(course_id),
	CONSTRAINT CHK_positive_year
		CHECK (nb_year > 0)
)

-- Insert data into the above table using a query.
INSERT INTO TeachingCapacity(instructor_id, course_id, nb_year)
SELECT 
	t.instructor_id,
	sec.course_id,
	COUNT(DISTINCT school_year) AS nb_year
FROM Teaching t
	INNER JOIN Section sec ON sec.section_id = t.section_id
GROUP BY t.instructor_id, sec.course_id
ORDER BY t.instructor_id, sec.course_id

UPDATE GradeReport
SET grade_ABC = CASE
	WHEN grade_100 BETWEEN 90 AND 100 THEN 'A'
	WHEN grade_100 BETWEEN 80 AND 89 THEN 'B'
	WHEN grade_100 BETWEEN 70 AND 79 THEN 'C'
	WHEN grade_100 BETWEEN 65 AND 69 THEN 'D'
	WHEN grade_100 BETWEEN 50 AND 65 THEN 'E'
	ELSE 'F'
END

CREATE OR ALTER FUNCTION uf_CountInstructorsAssignedToSectionId(@section_id INT)
RETURNS INT
AS
BEGIN
	DECLARE @count AS INT

	SELECT @count = COUNT(*)
	FROM Teaching t
	WHERE t.section_id = @section_id

	IF (@count IS NULL) SET @count = 0
	RETURN @count
END
GO

-- Write a function that counts the number of students registered for a given section_id
CREATE OR ALTER FUNCTION uf_CountStudentsRegisteredToSectionId(@section_id INT)
RETURNS INT
AS
BEGIN
	DECLARE @count AS INT

	SELECT @count = COUNT(*)
	FROM GradeReport gr
	WHERE gr.section_id = @section_id

	IF (@count IS NULL) SET @count = 0
	RETURN @count
END
GO

-- Write a stored procedure to retrieve the section ID, course name, semester, school year, number of instructors assigned to the section, and number of students registered for the section.
-- Input: section_id
-- Output: section_id, course_name, semester, school_year, number of registered students, number of instructors assigned to the section
CREATE OR ALTER PROCEDURE usp_GetSectionInfo
	@section_id INT
AS
BEGIN
SELECT
	s.section_id,
	c.course_name,
	s.semester,
	s.school_year,
	dbo.uf_CountInstructorsAssignedToSectionId(@section_id) AS instructor_count,
	dbo.uf_CountStudentsRegisteredToSectionId(@section_id) AS student_count
FROM Section s
	INNER JOIN Course c ON c.course_id = s.course_id
WHERE s.section_id = @section_id
END
GO

-- Write a stored procedure to retrieve the codes and names of students who have enrolled in all courses manged by a given department name.
-- Input: department_name
-- Output: student_id, student_name
CREATE OR ALTER PROCEDURE usp_GetStudentsEnrolledInAllCoursesByDepartment
	@department_name VARCHAR(50)
AS
BEGIN
	IF NOT EXISTS (SELECT department_id FROM Department WHERE department_name = @department_name)
		SELECT s.student_id, s.student_name FROM Student s WHERE 1 = 2
	ELSE
	WITH CTE_Dividend AS (
		SELECT DISTINCT
			s.student_id,
			c.course_id
		FROM Student s
			INNER JOIN GradeReport gr ON gr.student_id = s.student_id
			INNER JOIN Section sec ON sec.section_id = gr.section_id
			INNER JOIN Course c ON c.course_id = sec.course_id
	),
	CTE_Divisor AS (
		SELECT DISTINCT c.course_id
		FROM Course c
			INNER JOIN Department d ON d.department_id = c.department_id
		WHERE d.department_name = @department_name
	),
	CTE_BlackMagic AS (
		SELECT dividend.student_id, divisor.course_id
			FROM CTE_Dividend dividend
				CROSS JOIN CTE_Divisor divisor
		
		EXCEPT

		SELECT *
			FROM CTE_Dividend
	)
	SELECT DISTINCT s.student_id, s.student_name
	FROM CTE_Dividend dividend
		INNER JOIN Student s ON s.student_id = dividend.student_id
	WHERE dividend.student_id NOT IN (SELECT bm.student_id FROM CTE_BlackMagic bm)
END
GO

-- Write a stored procedure to retrieve instructor_id, year, semester, number of classes taught by each lecturer
-- Input: year,, semester
-- Output: instructor_id, year, semester, number of classes taught by each lecturer
CREATE OR ALTER PROCEDURE usp_CountCoursesTaughtPerLecturerInYearAndSemester
	@school_year INT,
	@semester VARCHAR(9)
AS
BEGIN
	SELECT
		t.instructor_id,
		sec.school_year,
		sec.semester,
		COUNT(DISTINCT course_id) AS course_count
	FROM Section sec
		INNER JOIN Teaching t ON t.section_id = sec.section_id
	WHERE (sec.school_year = @school_year AND sec.semester = @semester AND t.teaching_role = 'Lecturer')
	GROUP BY t.instructor_id, sec.school_year, sec.semester
END
GO

-- Write a function that calculates the total number of registered credits of a student in 1 semester of an academic year
-- Input: student_id, year, semester
-- Output: number of registered credits
CREATE OR ALTER FUNCTION uf_GetTotalCreditsInOneYearSemester(@student_id VARCHAR(9), @school_year INT, @semester VARCHAR(9))
RETURNS INT
AS
BEGIN
	DECLARE @count AS INT

	SELECT @count = SUM(nb_credits)
	FROM StudentStatistics ss
	WHERE (ss.student_id = @student_id AND ss.school_year = @school_year AND ss.semester = @semester)

	IF (@count IS NULL) SET @count = 0
	RETURN @count
END
GO