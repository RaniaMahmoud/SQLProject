use ExaminationSystemDatabase
go
/*View For View all Questions with Answers*/
go
create view QuestionsWithAns as(
	select QuestionID, MCQ.[QuestionText], MCQ.Answer
	from [Material].[MultipleChoiceQuestion] as MCQ
	union  
	select QuestionID, TQ.[QuestionText], TQ.Answer
	from [Material].[TextQuestion] as TQ
	union
	select QuestionID, TFQ.[QuestionText], TFQ.Answer 
	from [Material].[TrueAndFalseQuestion] as TFQ	
)
go
go
/*Define table type to put in it Students that instractor will Assign them in his Exam 
it will contain StudentID*/
go
create type Students AS TABLE(StuID int)
go
/*create Temp table to save StudentID and ExamID to assigin this information in table [Material].[StudentExamQ]
when student start to solve the Exam Questions
*/
go
--create table #ExamStudent
--(
--	ExamID int,
--	StudentID int
--	primary key (ExamID,StudentID)
--)
go
/* Assign Student To Exist Exam procedure take ExamID and start time, end time and Date of exam 
and take Table of Students this table contain StudentID
*steps
	1 - check that the this Exam exist
	2 - if yes it will update exam table to up exam date end start and end time of exam
	3 - then will iterate on Student table to assign Student to this Exam and insert data in [Material].[StudentExamQ] table
	4 - when it iterate it will check if the this student is exist in students table
*/
go
create procedure AssignStudentToExistExam @ExamID int, @StudentList Students readonly, @StartTime time, @EndTime time, @ExamDate date 
as begin
begin transaction
begin try
	--declare @EndT time, @Exam int
	--print @Exam

	if not exists(select *
		from [Material].[Exam]
		where @ExamID = ID
	)
	begin
		select 'Exam Not Existed'
	end
	else
	begin
		update [Material].[Exam]
		set [startTime] = @StartTime, 
		[EndTime] = @EndTime, 
		[ExamDate] = @ExamDate
		where @ExamID = ID
				
		declare cursorOnStudent cursor for 
		select * 
		from @StudentList
		open cursorOnStudent
		declare @ID int
		fetch next from cursorOnStudent into @ID
		while @@Fetch_Status = 0
		begin
			if not exists (
			select * 
			from [Person].[Student] 
			where [ID] = @ID
			)
			begin
				print 'this Student not exist'+convert(varchar(100),@ID)
			end
			else
			begin
				print'In FWhile'
				declare cursorExamQ cursor LOCAL for 
				select [QuestionID]
				from [Material].[ExamQuestion]
				where ExamID = @ExamID
				open cursorExamQ
				declare @QesID int
				fetch next from cursorExamQ into @QesID
				while @@Fetch_Status = 0
				begin	
					print'In SWhile'
					insert into [Material].[StudentExamQ]
					([ExmaID],[StudentID],[QuestionID])
					values(@ExamID, @ID, @QesID)
					fetch next from cursorExamQ into @QesID
					print 'Done'
				end
				close cursorExamQ
				deallocate cursorExamQ
				print 'All Add'
			end
		fetch next from cursorOnStudent into @ID
		end
		print 'Added'
		commit
		close cursorOnStudent
		deallocate cursorOnStudent
		print 'Finshed'
	end 
end try
begin catch
	rollback
	select ERROR_MESSAGE() as ErrorMessage
end catch
end 
go
/* Assign New Student To Exist Exam procedure take ExamID
and take Table of Students this table contain StudentID
*steps
	1 - check that the this Exam exist
	2 - if yes it will iterate on Student table to assign Student to this Exam and  insert data in [Material].[StudentExamQ] table
	3 - when it iterate it will check if the this student is exist in students table
*/
go
create procedure AssignNewStudentToExistExam @ExamID int, @StudentList Students readonly
as begin
begin transaction
begin try

	if not exists(select *
		from [Material].[Exam]
		where @ExamID = ID
	)
	begin
		select 'Exam Not Exist'
	end
	else
	begin
		declare cursorOnStudent cursor for 
		select * 
		from @StudentList
		open cursorOnStudent
		declare @ID int
		fetch next from cursorOnStudent into @ID
		while @@Fetch_Status = 0
		begin
			if not exists (
			select * 
			from [Person].[Student] 
			where [ID] = @ID
			)
			begin
				print 'this Srudent not exist'+convert(varchar(100),@ID)
			end
			else
			begin
				declare cursorOnExamQs cursor local for 
				select [QuestionID] 
				from [Material].[ExamQuestion]
				where [ExamID] = @ExamID

				open cursorOnExamQs
				declare @QesID int
				fetch next from cursorOnExamQs into @QesID
				while @@Fetch_Status = 0
				begin		
					insert into [Material].[StudentExamQ]
					([ExmaID],[StudentID],[QuestionID])
					values(@ExamID, @ID, @QesID)
					fetch next from cursorOnExamQs into @QesID
					print 'Done'
				end
				close cursorOnExamQs
				deallocate cursorOnExamQs
				print 'All Add'
			end
		fetch next from cursorOnStudent into @ID
		end
		print 'Added'
		commit
		close cursorOnStudent
		deallocate cursorOnStudent

		print 'Finshed'
	end 
end try
begin catch
	rollback
	select ERROR_MESSAGE() as ErrorMessage
end catch
end 
go
/* Student Answer To Exist Exam Questions procedure take ExamID
and take StudentID and student Answer of Question in exam and QuestionID 
*steps
	1 - check that the this Exam exist
	2 - if yes it check if this student assign to this exam
	3 - if yes it will check of student Answer for this question if true it will take degree of this question
	if not true it will take zero
*/
go
create procedure StudentExamAnswer @ExamID int, @StudentID int, @Answer varchar(100), @QID int
as begin
begin transaction
begin try
	if not exists(select *
		from [Material].[Exam]
		where @ExamID = ID
	)
	begin
		print 'Enter Correct Data'
	end
	else
	begin
		declare @CorrectAns varchar(100), @QDegree int 
		if not exists(
			select *
			from [Material].[StudentExamQ]
			where @StudentID = StudentID and [ExmaID] = @ExamID and  @QID = QuestionID
		)
		begin
			select 'this Student not assign in this exam'
		end
		else
		begin
			set @CorrectAns = (select [Answer]
				from QuestionsWithAns
				where QuestionID = @QID
				)
			print convert (varchar(10),@CorrectAns)+' QAns'
			
			if @CorrectAns = @Answer
			begin
				set @QDegree = (select [Degree] 
				from [Material].[ExamQuestion]
				where @QID = QuestionID and ExamID = @ExamID
				)
				print convert (varchar(10),@QDegree)+' QDegree'			
				update [Material].[StudentExamQ]
				set [Answer] = @Answer,
				[StudentQuestionDegree] = @QDegree
				where  @StudentID = StudentID and [ExmaID] = @ExamID and  @QID = QuestionID
				print 'Done Correct'
			end
			else if @CorrectAns <> @Answer
			begin
				set @QDegree = 0
				print convert (varchar(10),@CorrectAns)+' QAns = 0'
				update [Material].[StudentExamQ]
				set [Answer] = @Answer,
				[StudentQuestionDegree] = @QDegree
				where  @StudentID = StudentID and [ExmaID] = @ExamID and  @QID = QuestionID
				print 'Done False'
			end
			else
			begin
				print 'No Answer'
			end
		end
		commit
	end
end try
begin catch
	rollback
	select ERROR_MESSAGE() as ErrorMessage
end catch
end 
go
----------Test Query-------------

declare @Student Students

insert into @Student 
values (3),(4),(1)

select * 
from @Student

declare @result varchar(100)
exec AssignStudentToExistExam 6, @Student,'17:31PM','1:31PM', '1990-12-17'
go

declare @Student Students

insert into @Student 
values (2)

exec AssignNewStudentToExistExam 6, @Student

select*
from @Student

--delete from #ExamStudent

--delete from [Material].[Exam] 

--select *
--from #ExamStudent
go
select *
from [Material].[Exam]
go

----------Test Query-------------

select *
from QuestionsWithAns

--select *
--from #ExamStudent

exec StudentExamAnswer 6,4,'aswer',1
exec StudentExamAnswer 6,4,'aswer',2
exec StudentExamAnswer 3,4,'F',3
exec StudentExamAnswer 3,4,'F',4

select *
from [Material].[StudentExamQ]
