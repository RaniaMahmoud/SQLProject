use ExaminationSystemDatabase
go
/*Get info for specific Exam */
go
create function GetExamInfo(@ExamID int)
returns table
as 
return
(
	select *
	from [Material].[Exam]
	where ID = @ExamID
)
go
--------------------Test Query----------------
select * from GetExamInfo(7)
go
/*Get Qestions for specific Exam */
go
create function GetQuestionsOFExam(@ExamID int)
returns table
as 
return
(
	select *
	from [Material].[ExamQuestion]
	where [ExamID] = @ExamID
)
go
--------------------Test Query----------------
select * from GetQuestionsOFExam(7)
go
