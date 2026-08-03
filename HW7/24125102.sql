USE University
GO

-- A course must not have more than 4 teaching staff per section
CREATE OR ALTER TRIGGER trg_NoMoreThanFourInstructorPerSection
ON Teaching
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT
			t.section_id,
			COUNT(t.instructor_id) AS instructor_count
		FROM Teaching t
		GROUP BY t.section_id
		HAVING COUNT(t.instructor_id) > 4
	)
	BEGIN;
		THROW 51000, 'One section must not have more than four teaching staff', 1
	END;
END;
GO

-- A department's head must belong to that department
CREATE OR ALTER TRIGGER trg_DepartmentHeadMustBelongToDepartment
ON Department
AFTER INSERT, UPDATE
AS
BEGIN
	SELECT 1
	FROM inserted isrt

	IF EXISTS (
		SELECT 1
		FROM inserted isrt
			INNER JOIN Instructor i ON i.instructor_id = isrt.department_head
		WHERE (isrt.department_id != i.department_id)
	)
	BEGIN;
		THROW 51000, 'Department head must belong to department', 1;
	END;
END
GO

-- Students can only take a maximum of 4 subjects in one semester
CREATE OR ALTER TRIGGER trg_StudentsTakeMaximumFourSubjectsInOneSemester
ON GradeReport
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT
			gr.student_id,
			sec.semester,
			sec.school_year,
			COUNT(DISTINCT c.course_id) AS course_count
		FROM GradeReport gr
			INNER JOIN Section sec ON sec.section_id = gr.section_id
			INNER JOIN Course c ON c.course_id = sec.course_id
		GROUP BY gr.student_id, sec.semester, sec.school_year
		HAVING COUNT(DISTINCT c.course_id) > 4
	)
	BEGIN;
		THROW 51000, 'A student can only take a maximum of four course in a semester', 1;
	END;
END;
GO

-- Students must pass all prerequisites before enrolling in a course
CREATE OR ALTER TRIGGER trg_CheckPassedPrerequisites
ON GradeReport
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	IF EXISTS (
		SELECT gr1.student_id, sec1.course_id, p.prerequisite_id, MIN(gr2.grade_ABC) AS max_grade_ABC
		FROM GradeReport gr1
			INNER JOIN Section sec1 ON sec1.section_id = gr1.section_id
			INNER JOIN Prerequisite p ON p.course_id = sec1.course_id
			LEFT JOIN Section sec2 ON sec2.course_id = p.prerequisite_id
			LEFT JOIN GradeReport gr2 ON gr2.section_id = sec2.section_id
		WHERE (gr2.student_id IS NULL OR gr1.student_id = gr2.student_id)
		GROUP BY gr1.student_id, sec1.course_id, p.prerequisite_id
		HAVING (MIN(gr2.grade_ABC) IS NULL OR MIN(gr2.grade_ABC) = 'F')
	)
	BEGIN;
		THROW 51000, 'Student must pass all prerequisites', 1;
	END;
END;
GO

-- An instructor can teach at most three sections in the same semester and school year
CREATE OR ALTER TRIGGER trg_MaximumThreeSectionsPerInstructor
ON Teaching
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT t.instructor_id, sec.semester, sec.school_year, COUNT(t.section_id) AS section_count
		FROM Teaching t
			INNER JOIN Section sec ON t.section_id = sec.section_id
		GROUP BY t.instructor_id, sec.semester, sec.school_year
		HAVING COUNT(t.section_id) > 3
	)
	BEGIN;
		THROW 51000, 'An instructor can teach at most 3 courses in the same semester', 1;
	END;
END;
GO

-- An instructor cannot be the head of more than one department
CREATE OR ALTER TRIGGER trg_NoMoreThanOneDepartmentPerDepartmentHead
ON Department
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT
			d.department_head,
			COUNT(d.department_id) AS department_count
		FROM Department d
		GROUP BY d.department_head
		HAVING COUNT(d.department_id) > 1
	)
	BEGIN;
		THROW 51000, 'A department head must not be the head of multiple departments', 1;
	END;
END;
GO

-- The prerequisite relationship must not contain a cycle
CREATE OR ALTER FUNCTION uf_GetCoursePrerequisites(@course_id VARCHAR(9))
RETURNS TABLE
AS
RETURN (
	WITH CTE_PrereqInduction AS (
		-- base
		SELECT prerequisite_id
		FROM Prerequisite
		WHERE course_id = @course_id

		UNION ALL

		-- recurse
		SELECT p.prerequisite_id
		FROM CTE_PrereqInduction pi
			INNER JOIN Prerequisite p ON p.course_id = pi.prerequisite_id
	)
	SELECT *
	FROM CTE_PrereqInduction
)
GO

CREATE OR ALTER TRIGGER trg_NoCircularPrerequisites
ON Prerequisite
INSTEAD OF INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted i
		WHERE (i.course_id IN (SELECT * FROM dbo.uf_GetCoursePrerequisites(i.prerequisite_id)))
	)
	BEGIN;
		THROW 51000, 'There must be no circular prerequisites', 1
	END;
END
GO