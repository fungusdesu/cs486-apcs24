USE University
GO

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
	UNION
	SELECT @course_id
)
GO

CREATE OR ALTER TRIGGER trg_NoCircularPrerequisites
ON Prerequisite
AFTER INSERT, UPDATE
AS
BEGIN
	SELECT * FROM inserted
	SELECT * FROM Prerequisite

	IF EXISTS (
		SELECT 1
		FROM inserted i
		WHERE (i.course_id IN (SELECT * FROM dbo.uf_GetCoursePrerequisites(i.prerequisite_id)))
	)
	BEGIN;
		THROW 51000, 'There must be no circular prerequisites', 1
	END;
	ELSE INSERT INTO Prerequisite SELECT * FROM inserted
END
GO

INSERT INTO Prerequisite (course_id, prerequisite_id) VALUES ('CS04','CS05')
GO