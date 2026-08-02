USE University
GO

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

SELECT dbo.uf_GetTotalCreditsInOneYearSemester('ST004', 2022, 'Fall')