USE University

-- Find the Students who were born between 2000s and 2005s
SELECT *
FROM Student
WHERE 2000 <= YEAR(birthdate) AND YEAR(birthdate) <= 2005

-- Find the students enrolled in the course 'CS07' offered in the Fall semester of 2022
SELECT DISTINCT s.*
FROM Student s
	JOIN GradeReport gr ON s.student_id = gr.student_id
	JOIN Section sec ON sec.section_id = gr.section_id
WHERE sec.course_id = 'CS07' AND sec.semester = 'Fall' AND sec.school_year = '2022'

-- Extract the names and salary (after a 10% increase) of the instructor teaching the course CS07
SELECT i.instructor_name, i.salary * 1.1 AS salary
FROM Instructor i
	JOIN Teaching t ON i.instructor_id = t.instructor_id
	JOIN Section sec on sec.section_id = t.section_id
WHERE sec.course_id = 'CS07'

-- Retrieve the (course_id, course_name, prerequisite_name) for all courses in the 'IS' department
SELECT c1.course_id, c1.course_name, c2.course_name AS prerequisite_name
FROM Course c1
	LEFT JOIN Prerequisite p ON p.course_id = c1.course_id
	LEFT JOIN Course c2 ON p.prerequisite_id = c2.course_id
WHERE c1.department_id = 'IS'

-- Retrieve the instructors of department 'Computer Science' whose salary is between $2000 and $3000
SELECT i.*
FROM Instructor i
	JOIN Department d ON d.department_id = i.department_id
WHERE
	d.department_name = 'Computer Science'
	AND i.salary >= 2000
	AND i.salary <= 3000

-- Retrieve the instructors and their teaching courses with the role "Lecturer". The result should be sorted first by department name and then alphabetically by instructor name
SELECT DISTINCT i.*, d.department_name, c.course_id, c.course_name
FROM Instructor i
	JOIN Teaching t ON t.instructor_id = i.instructor_id
	JOIN Section sec ON t.section_id = sec.section_id
	JOIN Course c ON c.course_id = sec.course_id
	JOIN Department d ON d.department_id = i.department_id
WHERE t.teaching_role = 'Lecturer'
ORDER BY d.department_name, i.instructor_name

-- Extract a list of (course_id, course_name) where instructor 'I002' has not participated in teaching
SELECT DISTINCT c.course_id, c.course_name
FROM Course c
	LEFT JOIN Section sec ON sec.course_id = c.course_id
	LEFT JOIN Teaching t ON t.section_id = sec.section_id
WHERE t.instructor_id IS NULL OR t.instructor_id != 'I002'

-- Provide a list of instructors (instructor_id) who have participated in teaching in both the role of 'Lecturer' and the role of 'TA'
SELECT *
FROM Instructor i
	JOIN (
		SELECT instructor_id, COUNT(DISTINCT teaching_role) AS role_count
		FROM Teaching
		WHERE teaching_role IN ('Lecturer', 'TA')
		GROUP BY instructor_id
		HAVING COUNT(DISTINCT teaching_role) = 2
	) AS cunt ON i.instructor_id = cunt.instructor_id

-- Retrieve a list of (student_id, student_name) who passed the course CS03 but failed the course CS04 in the Fall semester of 2022
SELECT s.student_id, s.student_name
FROM Student s
	JOIN GradeReport gr03 ON gr03.student_id = s.student_id
	JOIN Section sec03 ON sec03.section_id = gr03.section_id
	JOIN GradeReport gr04 ON gr04.student_id = s.student_id
	JOIN Section sec04 ON sec04.section_id = gr04.section_id
WHERE
	sec03.course_id = 'CS03'
	AND sec03.semester = 'Fall'
	AND sec03.school_year = '2022'
	AND sec04.course_id = 'CS04'
	AND sec04.semester = 'Fall'
	AND sec04.school_year = '2022'
	AND gr03.grade_ABC != 'F'
	AND gr04.grade_ABC = 'F'

-- Retrieve the codes and names of students who have passed more than two courses
SELECT s1.student_id, s1.student_name, SUM(passed) AS pass_count
FROM (
	SELECT s2.student_id, s2.student_name, sec.course_id, MAX(CASE WHEN gr.grade_ABC = 'F' THEN 0 ELSE 1 END) AS passed
	FROM Student s2
		JOIN GradeReport gr ON s2.student_id = gr.student_id
		JOIN Section sec ON sec.section_id = gr.section_id
	GROUP BY s2.student_id, s2.student_name, sec.course_id
) AS s1
GROUP BY s1.student_id, s1.student_name
ORDER BY s1.student_id

-- Retrieve the school years and semesters, along with the number of courses held in each semester of every year
SELECT sec.semester, sec.school_year, COUNT(sec.semester) AS course_count
FROM Section sec
GROUP BY sec.semester, sec.school_year

-- Retrieve the code and names of courses with the highest number of instructors who have taught those courses
;WITH c AS (
	SELECT c2.course_id, c2.course_name, COUNT(c2.course_id) AS lecturer_count
	FROM Course c2
		JOIN Section sec ON sec.course_id = c2.course_id
		JOIN Teaching t ON t.section_id = sec.section_id
	WHERE t.teaching_role = 'Lecturer'
	GROUP BY c2.course_id, c2.course_name
)

SELECT c.course_id, c.course_name
FROM c
WHERE lecturer_count = (SELECT MAX(lecturer_count) FROM c)

-- Retrieve the codes and names of instructors who have only taught courses managed by their own department
SELECT DISTINCT i.instructor_id, i.instructor_name
FROM Instructor i
	JOIN Teaching t ON t.instructor_id = i.instructor_id
	JOIN Section sec ON sec.section_id = t.section_id
	JOIN Course c ON c.course_id = sec.course_id
WHERE (i.department_id = c.department_id)

-- Retrieve the code and name of ALL students, along with the count of courses managed by each department that they have participated in

SELECT s.student_id, s.student_name, c.department_id, COUNT(c.department_id) AS course_count
FROM Student s
	JOIN GradeReport gr ON gr.student_id = s.student_id
	JOIN Section sec ON sec.section_id = gr.section_id
	JOIN Course c ON c.course_id = sec.course_id
GROUP BY s.student_id, s.student_name, c.department_id
ORDER BY student_id, department_id

-- Find the top scoring student in each section. Print all top students with their IDs if their scores are tied
;WITH max_table AS (
	SELECT sec.section_id, MAX(gr.grade_100) as max_score
	FROM Section sec
		JOIN GradeReport gr ON gr.section_id = sec.section_id
		JOIN Student s ON s.student_id = gr.student_id
	GROUP BY sec.section_id
)

SELECT gr.section_id, s.student_id, s.student_name, gr.grade_100
FROM Student s
	JOIN GradeReport gr ON gr.student_id = s.student_id
	JOIN max_table mt ON mt.section_id = gr.section_id
WHERE gr.grade_100 = mt.max_score