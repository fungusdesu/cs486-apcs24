USE University
GO

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

SELECT * FROM StudentStatistics