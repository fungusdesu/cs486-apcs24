-- Write a function that counts the number of instructors assigned to a given section_id
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