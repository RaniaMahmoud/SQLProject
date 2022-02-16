use ExaminationSystemDatabase
go
/*Get Total degree of Student In specific Couse*/
go
create proc GetStuTotalDegreeInCourse @ExamID int, @StudentID int
as
begin
	declare @Total int,@StuName varchar(50), @CouseName varchar(50)
	set @Total = 0
	set @Total = (select sum([StudentQuestionDegree])
	from [Material].[StudentExamQ]
	where ExmaID = @ExamID and StudentID = @StudentID
	)

	set @StuName = (select [Name]
	from [Person].[Student]
	where ID = @StudentID
	)
	
	set @CouseName = (select [Name]
	from [Material].[Course]
	where ID in (
		select [CourseID]
		from [Material].[Exam]
		where ID = @ExamID
		)
	)

	select @StuName as 'StudentName', @CouseName as 'CourseName', @Total as 'TotelDegree'
end
go
exec GetStuTotalDegreeInCourse 3, 4