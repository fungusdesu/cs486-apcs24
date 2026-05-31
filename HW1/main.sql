CREATE DATABASE University
GO

USE University

CREATE TABLE Department (
	department_id VARCHAR(5),
	department_name NVARCHAR(50) NOT NULL,
	office VARCHAR(5),
	department_head VARCHAR(9),

	PRIMARY KEY (department_id)
)
GO

CREATE TABLE Instructor (
	instructor_id VARCHAR(9),
	instructor_name NVARCHAR(50) NOT NULL,
	phone NVARCHAR(9) NOT NULL,
	department_id VARCHAR(5),
	salary INT CHECK (salary > 0),

	PRIMARY KEY (instructor_id),
	FOREIGN KEY (department_id) REFERENCES Department(department_id)
)
GO

ALTER TABLE Department
ADD FOREIGN KEY (department_head) REFERENCES Instructor(instructor_id)
GO

CREATE TABLE Student (
	student_id VARCHAR(9),
	student_name NVARCHAR(50) NOT NULL,
	gender CHAR(1) CHECK (gender IN ('F', 'M', 'O')),
	birthdate DATETIME,
	class VARCHAR(5),
	department_id VARCHAR(5),

	PRIMARY KEY (student_id),
	FOREIGN KEY (department_id) REFERENCES Department(department_id)
)
GO

CREATE TABLE Course (
	course_id VARCHAR(9),
	course_name NVARCHAR(50) NOT NULL UNIQUE,
	credit INT CHECK (credit > 0),
	department_id VARCHAR(5),

	PRIMARY KEY (course_id),
	FOREIGN KEY (department_id) REFERENCES Department(department_id)
)
GO

CREATE TABLE Section (
	section_id INT NOT NULL,
	course_id VARCHAR(9) NOT NULL,
	semester VARCHAR(9) NOT NULL,
	[year] INT NOT NULL,
	capacity INT CHECK (capacity > 0),

	UNIQUE (course_id, semester, [year]),
	PRIMARY KEY (section_id),
	FOREIGN KEY (course_id) REFERENCES Course(course_id)
)
GO

CREATE TABLE Teaching (
	section_id INT NOT NULL,
	instructor_id VARCHAR(9) NOT NULL,
	[role] VARCHAR(9) CHECK ([role] IN ('Lecturer', 'TA')),

	PRIMARY KEY (section_id, instructor_id),
	FOREIGN KEY (section_id) REFERENCES Section(section_id),
	FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
)
GO

CREATE TABLE GradeReport (
	section_id INT NOT NULL,
	student_id VARCHAR(9) NOT NULL,
	grade_100 INT CHECK (grade_100 >= 0),
	grade_ABC CHAR(1) CHECK (grade_ABC IN ('A', 'B', 'C', 'D', 'E', 'F')),

	PRIMARY KEY (section_id, student_id),
	FOREIGN KEY (section_id) REFERENCES Section(section_id),
	FOREIGN KEY (student_id) REFERENCES Student(student_id)
)
GO

CREATE TABLE Prerequisite (
	course_id VARCHAR(9) NOT NULL,
	prerequisite_id VARCHAR(9) NOT NULL,

	PRIMARY KEY (course_id, prerequisite_id),
	FOREIGN KEY (course_id) REFERENCES Course(course_id),
	FOREIGN KEY (prerequisite_id) REFERENCES Course(course_id)
)
GO


USE University
INSERT INTO Department VALUES('AI', 'Artificial Intelligence', 'I86', NULL)
INSERT INTO Department VALUES('CS', 'Computer Science', 'I81', NULL)
INSERT INTO Department VALUES('IS', 'Information System', 'I84', NULL)
INSERT INTO Department VALUES('NW', 'Network', 'I87', NULL)
INSERT INTO Department VALUES('SE', 'Software Engineering', 'I82', NULL)
GO

INSERT INTO Instructor VALUES('I001', 'Dang Huynh Bao Khanh', '080913213', 'CS', 1000)
INSERT INTO Instructor VALUES('I002', 'Alex Grant', '082412613', 'CS', 2000)
INSERT INTO Instructor VALUES('I003', 'Tran Hoang Lan', '080921234', 'SE', 1500)
INSERT INTO Instructor VALUES('I004', 'Nguyen Ngoc Khanh', '090245613', 'IS', 1500)
INSERT INTO Instructor VALUES('I005', 'James Cobb', '092193213', 'SE', 2000)
INSERT INTO Instructor VALUES('I006', 'Le Khanh', '090799131', 'IS', 2200)
INSERT INTO Instructor VALUES('I007', 'Vu Ngoc Bao', '090511342', 'SE', 2100)
INSERT INTO Instructor VALUES('I008', 'Tran Hong An', '099912353', 'NW', 1900)
INSERT INTO Instructor VALUES('I009', 'Nguyen Hai Lam', '080911234', 'AI', 1500)
INSERT INTO Instructor VALUES('I010', 'Dang Hoang Phong', '090233451', 'AI', 2300)
GO

UPDATE Department SET department_head = 'I009' WHERE department_id = 'AI'
UPDATE Department SET department_head = 'I001' WHERE department_id = 'CS'
UPDATE Department SET department_head = 'I004' WHERE department_id = 'IS'
UPDATE Department SET department_head = 'I003' WHERE department_id = 'SE'
GO

INSERT INTO Student VALUES('ST001', 'Nguyen Ai Linh', 'F', DATETIMEFROMPARTS(2002, 12, 1, 0, 0, 0, 0), NULL, 'CS');
INSERT INTO Student VALUES('ST002', 'Tran Thanh Sang', 'M', DATETIMEFROMPARTS(2003, 9, 2, 0, 0, 0, 0), NULL, 'CS');
INSERT INTO Student VALUES('ST003', 'Huynh Thanh Phong', 'M', DATETIMEFROMPARTS(2001, 5, 3, 0, 0, 0, 0), NULL, 'SE');
INSERT INTO Student VALUES('ST004', 'Hoang Nhat Linh', 'F', DATETIMEFROMPARTS(2002, 5, 10, 0, 0, 0, 0), NULL, 'SE');
INSERT INTO Student VALUES('ST005', 'Le Ba Khanh', 'M', DATETIMEFROMPARTS(2001, 11, 12, 0, 0, 0, 0), NULL, 'SE');
INSERT INTO Student VALUES('ST006', 'Ly Quoc Phong', 'M', DATETIMEFROMPARTS(2000, 8, 12, 0, 0, 0, 0), NULL, 'SE');
INSERT INTO Student VALUES('ST007', 'Tran Thanh An', 'F', DATETIMEFROMPARTS(2000, 11, 9, 0, 0, 0, 0), NULL, 'IS');
INSERT INTO Student VALUES('ST008', 'Le Nha Thu', 'F', DATETIMEFROMPARTS(2002, 8, 9, 0, 0, 0, 0), NULL, 'IS');
INSERT INTO Student VALUES('ST009', 'Ho Ngoc Anh', 'F', DATETIMEFROMPARTS(2003, 11, 1, 0, 0, 0, 0), NULL, 'AI');
INSERT INTO Student VALUES('ST010', 'Nguyen Thanh Son', 'M', DATETIMEFROMPARTS(2003, 12, 5, 0, 0, 0, 0), NULL, 'NW');
GO

INSERT INTO Course VALUES('CS01', 'Databases', 4, 'IS');
INSERT INTO Course VALUES('CS02', 'Database Management System', 4, 'IS');
INSERT INTO Course VALUES('CS03', 'Introduction to Programming', 4, 'SE');
INSERT INTO Course VALUES('CS04', 'Object-Oriented Programming', 4, 'SE');
INSERT INTO Course VALUES('CS05', 'Basic Network', 4, 'NW');
INSERT INTO Course VALUES('CS06', 'Advanced Network', 4, 'NW');
INSERT INTO Course VALUES('CS07', 'Introduction to Artificial Intelligence', 4, 'AI');
INSERT INTO Course VALUES('CS08', 'Introduction to Machine Learning', 4, 'CS');
INSERT INTO Course VALUES('CS09', 'Computer Vision', 4, 'CS');
INSERT INTO Course VALUES('CS10', 'Robotics', 4, 'AI');
GO

INSERT INTO Prerequisite VALUES('CS02', 'CS01');
INSERT INTO Prerequisite VALUES('CS04', 'CS03');
INSERT INTO Prerequisite VALUES('CS06', 'CS05');
INSERT INTO Prerequisite VALUES('CS08', 'CS07');
INSERT INTO Prerequisite VALUES('CS09', 'CS07');
INSERT INTO Prerequisite VALUES('CS10', 'CS07');
GO

INSERT INTO Section VALUES(1, 'CS01', 'Fall', 2022, 30);
INSERT INTO Section VALUES(2, 'CS02', 'Fall', 2022, 30);
INSERT INTO Section VALUES(3, 'CS03', 'Fall', 2022, 30);
INSERT INTO Section VALUES(4, 'CS04', 'Fall', 2022, 30);
INSERT INTO Section VALUES(5, 'CS01', 'Spring', 2022, 20);
INSERT INTO Section VALUES(6, 'CS02', 'Spring', 2022, 20);
INSERT INTO Section VALUES(7, 'CS03', 'Spring', 2022, 20);
INSERT INTO Section VALUES(8, 'CS05', 'Spring', 2022, 20);
INSERT INTO Section VALUES(9, 'CS05', 'Fall', 2023, 12);
INSERT INTO Section VALUES(10, 'CS06', 'Fall', 2023, 12);
INSERT INTO Section VALUES(11, 'CS07', 'Fall', 2023, 12);
GO

INSERT INTO Teaching VALUES(1, 'I004', 'Lecturer');
INSERT INTO Teaching VALUES(1, 'I006', 'TA');
INSERT INTO Teaching VALUES(2, 'I004', 'Lecturer');
INSERT INTO Teaching VALUES(2, 'I007', 'TA');
INSERT INTO Teaching VALUES(3, 'I003', 'TA');
INSERT INTO Teaching VALUES(3, 'I005', 'Lecturer');
INSERT INTO Teaching VALUES(4, 'I005', 'Lecturer');
INSERT INTO Teaching VALUES(4, 'I009', 'TA');
INSERT INTO Teaching VALUES(5, 'I004', 'Lecturer');
INSERT INTO Teaching VALUES(5, 'I006', 'TA');
INSERT INTO Teaching VALUES(6, 'I004', 'Lecturer');
INSERT INTO Teaching VALUES(7, 'I005', 'Lecturer');
INSERT INTO Teaching VALUES(8, 'I008', 'Lecturer');
GO


INSERT INTO GradeReport VALUES(1, 'ST001', 80, 'B');
INSERT INTO GradeReport VALUES(1, 'ST002', 82, 'B');
INSERT INTO GradeReport VALUES(1, 'ST003', 35, 'F');
INSERT INTO GradeReport VALUES(1, 'ST004', 60, 'F');
INSERT INTO GradeReport VALUES(1, 'ST005', 100, 'A');
INSERT INTO GradeReport VALUES(1, 'ST006', 100, 'A');
INSERT INTO GradeReport VALUES(1, 'ST007', 90, 'A');
INSERT INTO GradeReport VALUES(1, 'ST008', 52, 'F');
INSERT INTO GradeReport VALUES(1, 'ST009', 36, 'F');
INSERT INTO GradeReport VALUES(1, 'ST010', 99, 'A');
INSERT INTO GradeReport VALUES(2, 'ST001', 77, 'C');
INSERT INTO GradeReport VALUES(2, 'ST002', 84, 'B');
INSERT INTO GradeReport VALUES(2, 'ST003', 60, 'F');
INSERT INTO GradeReport VALUES(2, 'ST004', 53, 'F');
INSERT INTO GradeReport VALUES(2, 'ST005', 99, 'A');
INSERT INTO GradeReport VALUES(2, 'ST006', 93, 'A');
INSERT INTO GradeReport VALUES(2, 'ST007', 82, 'B');
INSERT INTO GradeReport VALUES(2, 'ST008', 63, 'F');
INSERT INTO GradeReport VALUES(2, 'ST009', 62, 'F');
INSERT INTO GradeReport VALUES(2, 'ST010', 88, 'B');
GO

DECLARE @sqlText VARCHAR(MAX)
SET @sqlText = ''
SELECT @sqlText = @sqlText + ' SELECT * FROM ' + QUOTENAME(name) + CHAR(13) FROM sys.tables
EXEC(@sqlText)