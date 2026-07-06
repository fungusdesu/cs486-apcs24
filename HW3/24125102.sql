USE University
GO

-- Using CTE, for each department, find all the top 2 students based on the average grade. Include all the students that tied for the top 2.
;WITH CTE_AverageGradeReport AS ( -- aggregate grade report by average
	SELECT
		gr.student_id,
		s.department_id,
		AVG(gr.grade_100) AS average_grade_100
	FROM GradeReport gr
		INNER JOIN Student s ON s.student_id = gr.student_id
	GROUP BY gr.student_id, s.department_id
), CTE_Top2GradeReport AS ( -- filter homeless students and append rank column
	SELECT
		agr2.*,
		DENSE_RANK() OVER (PARTITION BY department_id ORDER BY agr2.average_grade_100 DESC) AS rank
	FROM CTE_AverageGradeReport agr2
	WHERE
		department_id IS NOT NULL
)
SELECT s.student_id, s.student_name, s.department_id, t2gr.average_grade_100
FROM CTE_Top2GradeReport t2gr
	INNER JOIN Student s ON s.student_id = t2gr.student_id
WHERE t2gr.[rank] <= 2

-- Find all courses that directly or indirectly depend on course CS07 as a prerequisite
;WITH CTE_PrereqInductionCS07 AS (
	-- base
	SELECT course_id
	FROM Prerequisite
	WHERE prerequisite_id = 'CS07'

	UNION ALL

	-- recurse
	SELECT p.course_id
	FROM CTE_PrereqInductionCS07 pi
		INNER JOIN Prerequisite p ON p.prerequisite_id = pi.course_id
)
SELECT *
FROM CTE_PrereqInductionCS07

-- Create the following tables with necessary constraints:
--	a. TeachingCapacity
--		i. instructor_id
-- 		ii. course_id
--		iii. nb_year
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

-- Update the grade_ABC column of the GradeReport table based on the value in the grade_100 column:
--	90-100: A
--	80-89: B
--	70-79: C
--	65-69: D
--	50-65: E
--	<50: F
UPDATE GradeReport
SET grade_ABC = CASE
	WHEN grade_100 BETWEEN 90 AND 100 THEN 'A'
	WHEN grade_100 BETWEEN 80 AND 89 THEN 'B'
	WHEN grade_100 BETWEEN 70 AND 79 THEN 'C'
	WHEN grade_100 BETWEEN 65 AND 69 THEN 'D'
	WHEN grade_100 BETWEEN 50 AND 65 THEN 'E'
	ELSE 'F'
END

-- Find the ID and name of each student, along with the average grade (grade_100) of the sections they have passed, where a passed section is defined as having a grade_100 of 50 or higher.
;WITH CTE_AveragePassedGradeReport AS (
	SELECT 
		student_id,
		AVG(grade_100) AS average_grade_100
	FROM GradeReport
	WHERE grade_100 >= 50
	GROUP BY student_id
)
SELECT 
	s.student_id,
	s.student_name,
	apgr.average_grade_100 AS grade_100
FROM CTE_AveragePassedGradeReport apgr
	INNER JOIN Student s ON s.student_id = apgr.student_id

-- Retrieve the code and name of ALL students, along with the count of courses they have passed, where a passed course is defined as having a grade_100 of 50 or higher.
;WITH CTE_PassedSectionsCounts AS (
	SELECT
		gr.student_id,
		s.course_id,
		COUNT (CASE WHEN grade_100 >= 50 THEN 1 END) AS passed_count
	FROM GradeReport gr
		INNER JOIN Section s ON s.section_id = gr.section_id
	GROUP BY gr.student_id, s.course_id
), CTE_PassedCoursesCounts AS (
	SELECT
		psc.student_id,
		COUNT (CASE WHEN passed_count > 0 THEN 1 END) AS passed_count
	FROM CTE_PassedSectionsCounts psc
	GROUP BY psc.student_id
)
SELECT
	pcc.student_id,
	s.student_name,
	pcc.passed_count
FROM CTE_PassedCoursesCounts pcc
	INNER JOIN Student s ON s.student_id = pcc.student_id

-- For each department, find the student(s) with the highest average grade across all enrolled sections. Return the department_id, department_name, student_id, student_name and average_grade
;WITH CTE_AverageGradeReport AS (
	SELECT 
		student_id,
		AVG(grade_100) AS average_grade_100
	FROM GradeReport
	GROUP BY student_id
)
SELECT
	s.department_id,
	d.department_name,
	agr.student_id,
	s.student_name,
	agr.average_grade_100
FROM CTE_AverageGradeReport agr
	INNER JOIN Student s ON s.student_id = agr.student_id
	INNER JOIN Department d ON d.department_id = s.department_id
WHERE (
	average_grade_100 = (
		SELECT MAX(agr2.average_grade_100)
		FROM CTE_AverageGradeReport agr2
			INNER JOIN Student s2 ON s2.student_id = agr2.student_id
		WHERE s2.department_id = s.department_id
	)
)

-- List students whose average grade is higher than the average of all students in their department.
;WITH CTE_AverageGradeReport AS (
	SELECT 
		student_id,
		AVG(grade_100) AS average_grade_100
	FROM GradeReport
	GROUP BY student_id
)
SELECT
	agr.student_id,
	s.student_name,
	agr.average_grade_100
FROM CTE_AverageGradeReport agr
	INNER JOIN Student s ON s.student_id = agr.student_id
WHERE (
	average_grade_100 > (
		SELECT AVG(agr2.average_grade_100)
		FROM CTE_AverageGradeReport agr2
			INNER JOIN Student s2 ON s2.student_id = agr2.student_id
		WHERE s2.department_id = s.department_id
	)
)

-- Create the StudentStatistics table with the primary key and all necessary foreign keys to summarize student information. The table should include the following columns: student_id, student_name, school_year, semester, and nb_credits (representing the total number of credits for the courses enrolled in each semester of each school year). After creating the table, populate it using data extracted from the existing database.
;WITH CTE_PassedSectionsCounts AS (
	SELECT
		gr.student_id,
		s.course_id,
		s.semester,
		s.school_year,
		COUNT (CASE WHEN grade_100 >= 50 THEN 1 END) AS passed_count
	FROM GradeReport gr
		INNER JOIN Section s ON s.section_id = gr.section_id
	GROUP BY gr.student_id, s.course_id, s.semester, s.school_year
), CTE_CreditsReport AS (
	SELECT
		psc.student_id,
		psc.semester,
		psc.school_year,
		SUM (CASE WHEN psc.passed_count > 0 THEN c.credit ELSE 0 END) AS nb_credits
	FROM CTE_PassedSectionsCounts psc
		INNER JOIN Course c ON c.course_id = psc.course_id
	GROUP BY psc.student_id, psc.semester, psc.school_year
)
SELECT * INTO StudentStatistics FROM (
	SELECT
		cr.student_id,
		s.student_name,
		cr.school_year,
		cr.semester,
		cr.nb_credits
	FROM CTE_CreditsReport cr
		INNER JOIN Student s ON s.student_id = cr.student_id
) new