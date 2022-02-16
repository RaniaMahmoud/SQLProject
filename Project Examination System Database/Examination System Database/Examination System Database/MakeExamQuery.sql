use ExaminationSystemDatabase
go
/*Define table type to put in it Questions that instractor will put it in his Exam 
it will contain Question ID and Degree of each Question*/
go
create type Questions AS TABLE(Id int, Degree int)
go
/*procedure for Make Exam With Random Questions*/
go
/* Make New Exam By Random Question Selection procedure take ExamID and all information of Exam 
and Degree for the question
*steps:
	1-check that the this Instructor teach this course
	2- if yes it will insert exam info in Exam Table
	3-then will iterate to get ID of Question by useing Random Function it retern number between 1 to Number of Total Question in Question table
	4- if this id in Question table and not reppeted in ExamQuestion Table will finsh the while 
	5- then it will check if MaxDegree of Questions are insert for this exam are exeed Max degree of couse or not 
	if not it will insert insert Qesion in ExamQuestion table
*/
go
create procedure MakeExamByRandomQ @ExamID int, @ExamType varchar(10), @Degree int, @AllowanceOptions varchar(10), @CourseID int, @InstructorID int, @ClassID int
as begin
begin transaction
begin try
	declare @SelectedInstID int, @MaxDegree int, @NumberOfExam int,@checkMaxDgree int, @QID int, @NumOFQ int
	declare @Iterator int, @ExistFlag int
	set @checkMaxDgree = 0
	set @MaxDegree =( select MaxDegree
		from [Material].[Course] as course
		where @CourseID = course.ID
	)
	set @NumOFQ = (select count([ID])
			from [Material].[Question]
	)
			
	if not exists( select *
		from [Material].[InstClassCourse] as ICC
		where @CourseID = ICC.CourseID and ICC.InstructorID = @InstructorID and ICC.ClassID = @ClassID
	)
	begin 
		print 'Enter Correct Data'
	end
	else
	begin 
		if not exists (select *
			from [Material].[ExamQuestion]
			where ExamID = @ExamID
		)
		begin
			insert into [Material].[Exam] 
			([ID],[Type],[AllowanceOptions],[InstructorID],[CourseID],[ClassID]) 
			values (@ExamID, @ExamType, @AllowanceOptions, @InstructorID, @CourseID, @ClassID)
			
			print @Degree

			set @Iterator = 1

			while (@Iterator = 1)
			begin
				set @QID = floor(rand()*(@NumOFQ-1+1))+1
				if not exists(
					select *
					from [Material].[Question]
					where @QID = [ID]
				)
				begin
					print 'Question Not Exist'
				end
				else
				begin
					print 'this Question Exist in table' 
					set @Iterator = 0	
				end
				print convert(varchar(70),@QID) + 'QID'
			end
			insert into [Material].[ExamQuestion] 
			values (@ExamID, @QID, @Degree)
			print 'Done'
		end
		else
		begin
			declare @ExamDegree int

			set @ExamDegree = ( select sum([Degree])
				from [Material].[ExamQuestion]
				where ExamID = @ExamID
			)

			declare @NumInExam int, @NumOFQReppet int
			set @Iterator = 1
			while (@Iterator = 1)
			begin
				set @QID = floor(rand()*(@NumOFQ-1+1))+1
								
				if not exists(select *
				from [Material].[ExamQuestion]
				where [QuestionID] = @QID and [ExamID] = @ExamID
				)
				begin
					set @NumOFQReppet = 0 
				end
				else
				begin
					set @NumOFQReppet = 1
				end

				if not exists(
					select *
					from [Material].[Question]
					where @QID = [ID]
				)
				begin
					print 'Question Not Exist'
					set @ExistFlag = 0
				end
				else
				begin
					print 'this Question Exist in table' 
					set @ExistFlag = 1	
				end
				if(@NumOFQReppet = 0 and @ExistFlag = 1)
				begin
					set @Iterator = 0
				end
			end

			print @ExamDegree + @Degree
			print @MaxDegree
			if(@ExamDegree + @Degree > @MaxDegree)
			begin
				set @checkMaxDgree = 1				
			end
			else
			begin
				print @QID
				print @Degree
				insert into [Material].[ExamQuestion] 
				values (@ExamID, @QID, @Degree)
				print 'Done'
			end
		end
		if (@checkMaxDgree = 1)
		begin
			set @checkMaxDgree = 0
			Select 'data ExceedMaxDegree'
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
/*Insert New Question Random In Exist Exam procedure take ExamID
and Degree for question
*steps
	1 - check that the this Instructor teach this course
	2 - if yes it will iterate to get ID of Question by useing Random Function it retern number between 1 to Number of Total Question in Question table 
	3 - if this id in Question table and not reppeted and check if the number of questions in this exam are = number of Questions Table  will finsh the while 
	4 - then it will check if MaxDegree of Questions are insert for this exam are exeed Max degree of couse or not 
	if not it will insert insert Qesion in ExamQuestion table
*/
go
create procedure InsertNewRandomQ @ExamID int, @Degree int, @CourseID int, @InstructorID int, @ClassID int
as begin
begin transaction
begin try
	declare @SelectedInstID int, @MaxDegree int, @NumberOfExam int,@checkMaxDgree int, @QID int, @NumOFQ int,@NumOfQuestionInExam int
	declare @Iterator int, @ExistFlag int
	set @checkMaxDgree = 0
	set @MaxDegree =( select MaxDegree
		from [Material].[Course] as course
		where @CourseID = course.ID
	)
	set @NumOFQ = (select count([ID])
			from [Material].[Question]
	)
			
	if not exists( select *
		from [Material].[InstClassCourse] as ICC
		where @CourseID = ICC.CourseID and ICC.InstructorID = @InstructorID and ICC.ClassID = @ClassID
	)
	begin 
		print 'Enter Correct Data'
	end
	else
	begin 
		if not exists (select *
			from [Material].[ExamQuestion]
			where ExamID = @ExamID
		)
		begin
			print 'Exam Not Exist'
		end
		else
		begin
			declare @ExamDegree int

			set @ExamDegree = ( select sum([Degree])
				from [Material].[ExamQuestion]
				where ExamID = @ExamID
			)
			
			set @NumOfQuestionInExam = ( select count([QuestionID])
				from [Material].[ExamQuestion]
				where ExamID = @ExamID
			)

			declare @NumInExam int, @NumOFQReppet int
			set @Iterator = 1
			while (@Iterator = 1)
			begin
				set @QID = floor(rand()*(@NumOFQ-1+1))+1
				
				if not exists(select *
				from [Material].[ExamQuestion]
				where [QuestionID] = @QID and [ExamID] = @ExamID
				)
				begin
					set @NumOFQReppet = 0 
				end
				else
				begin
					set @NumOFQReppet = 1
				end

				if not exists(
					select *
					from [Material].[Question]
					where @QID = [ID]
				)
				begin
					print 'Question Not Exist'
					set @ExistFlag = 0
				end
				else
				begin
					print 'this Question Exist in table' 
					set @ExistFlag = 1	
				end
				
				if(@NumOfQuestionInExam = @NumOFQ)
				begin
					set @Iterator = 0
					select 'All Questions in table Question in this Exam'
				end
				
				if(@NumOFQReppet = 0 and @ExistFlag = 1)
				begin
					set @Iterator = 0
				end
			end

			print @ExamDegree + @Degree
			print @MaxDegree
			if(@ExamDegree + @Degree > @MaxDegree)
			begin
				set @checkMaxDgree = 1				
			end
			else
			begin
				print @QID
				print @Degree
				insert into [Material].[ExamQuestion] 
				values (@ExamID, @QID, @Degree)
				print 'Done'
			end
		end
		if (@checkMaxDgree = 1)
		begin
			set @checkMaxDgree = 0
			Select 'data ExceedMaxDegree'
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
/*procedure for Instractor Make Exam*/
go
/*Insert New Question In Exist Exam procedure take ExamID
and take Table of Question this table contain QuestionID and Degree for each question
*steps
	1-check that the this Exam exist
	2- if yes it will iterate on question table to assign questions of the exam
	3-when it iterate it will check if the tatal degree of the questions not exeed the total degree of course
*/
go
create procedure InstractorAddQInExam @ExamID int, @Questions Questions readonly, @CourseID int, @InstructorID int, @ClassID int 
as begin
begin transaction
begin try

	declare @SelectedInstID int, @MaxDegree int, @NumberOfExam int,@Counter bit
	set @Counter = 0

	set @MaxDegree =( select MaxDegree
		from [Material].[Course] as course
		where @CourseID = course.ID
	)
	if not exists (select *
	from [Material].[InstClassCourse] as ICC
	where @CourseID = ICC.CourseID and ICC.InstructorID = @InstructorID and ICC.ClassID = @ClassID
	)
	begin 
		print 'Enter Correct Data'
		return 
	end
	else
	begin
		
		print @NumberOfExam
		
		if not exists (select ExamID
		from [Material].[ExamQuestion]
		where ExamID = @ExamID
		)
		begin
			print 'Exam Not Found'
		end	
		else
		begin
			declare cursorOnInst cursor for 
			select * 
			from @Questions
		
			open cursorOnInst
			declare @ID int, @Degree int
			fetch next from cursorOnInst into @ID, @Degree
			while @@Fetch_Status = 0
			begin
				print @ID
				print @Degree
				if not exists(
				select *
				from [Material].[Question]
				where @ID = [ID]
				)
				begin
					Print 'Question Not In Question Table'
				end
				else
				begin
					declare @ExamDegree int
					set @ExamDegree = (select sum([Degree])
					from [Material].[ExamQuestion]
					where ExamID = @ExamID
					)
				
					print @ExamDegree + @Degree
					print @MaxDegree

					if(@ExamDegree + @Degree > @MaxDegree)
					begin
					print 'in'
						set @Counter = 1
					end
					else
					begin	
						insert into [Material].[ExamQuestion] 
						values (@ExamID, @ID, @Degree)
						print 'Done'			
					end
					fetch next from cursorOnInst into @ID, @Degree
				end
			end
			if (@Counter = 1)
			begin
				Select 'there are a Qustions Not Put in Exam because total degrees must not exceed the course Max Degree'
			end
			commit
			close cursorOnInst
			deallocate cursorOnInst 
		end
	end
end try
begin catch
	rollback
	select ERROR_MESSAGE() as ErrorMessage
end catch
end
go
/* Make New Exam procedure take ExamID and all information of Exam 
and take Table of Question this table contain QuestionID and Degree for each question
*steps:
	1-check that the this Instructor teach this course
	2- if yes it will inser exam info in Exam Table
	3-then will iterate on question table to assign questions of the exam
	4-when it iterate it will check if the tatal degree of the questions not exeed the total degree of course
*/
go
create procedure InsertExamInfo @ExamID int, @ExamType varchar(10), @Questions Questions readonly, @AllowanceOptions varchar(10), @CourseID int, @InstructorID int, @ClassID int
as begin
begin transaction
begin try
	declare @SelectedInstID int,@MaxDegree int, @NumberOfExam int,@Counter bit
	set @Counter = 0
	if not exists (select *
	from [Material].[InstClassCourse] as ICC
	where @CourseID = ICC.CourseID and ICC.InstructorID = @InstructorID and ICC.ClassID = @ClassID
	)
	begin
		print 'Enter Correct Data'
	end
	else 
	begin
		insert into [Material].[Exam] 
		([ID],[Type],[AllowanceOptions],[InstructorID],[CourseID],[ClassID]) 
		values (@ExamID, @ExamType, @AllowanceOptions, @InstructorID, @CourseID, @ClassID)
		/*Add QuestionsInExam*/
		set @MaxDegree =( select MaxDegree
		from [Material].[Course] as course
		where @CourseID = course.ID
		)
		declare cursorOnInst cursor for 
		select * 
		from @Questions
		
		open cursorOnInst
		declare @ID int, @Degree int
		fetch next from cursorOnInst into @ID, @Degree
		while @@Fetch_Status = 0
		begin
			print @ID
			print @Degree
			if not exists(
			select *
			from [Material].[Question]
			where @ID = [ID]
			)
			begin
				Print 'Question Not In Question Table'
			end
			else
			begin
				declare @ExamDegree int
				set @ExamDegree = (select sum([Degree])
				from [Material].[ExamQuestion]
				where ExamID = @ExamID
				)
				
				print @ExamDegree + @Degree
				print @MaxDegree

				if(@ExamDegree + @Degree > @MaxDegree)
				begin
					set @Counter = 1
				end
				else
				begin	
					insert into [Material].[ExamQuestion] 
					values (@ExamID, @ID, @Degree)
					print 'Done'			
				end
				fetch next from cursorOnInst into @ID, @Degree
			end
		end
		if (@Counter = 1)
		begin
			Select 'there are a Qustions Not Put in Exam because total degrees must not exceed the course Max Degree'
		end
		commit
		close cursorOnInst
		deallocate cursorOnInst 
	end
end try
begin catch
	rollback
	select ERROR_MESSAGE() as ErrorMessage
end catch
end
go
/*View For View all Questions to instractor to know which pick*/
go
create view QuestionsView as(
	select QuestionID, MCQ.[QuestionText]
	from [Material].[MultipleChoiceQuestion] as MCQ
	union  
	select QuestionID, TQ.[QuestionText] 
	from [Material].[TextQuestion] as TQ
	union
	select QuestionID, TFQ.[QuestionText] 
	from [Material].[TrueAndFalseQuestion] as TFQ	
)
go

-------------Test Query-------------------
select *
from QuestionsView
go
/*Add New Exam*/
declare @PickQuestion Questions

insert into @PickQuestion 
values (1 , 5),(2 , 5),(3 , 100)
select * from @PickQuestion

declare @result varchar(10)
exec InsertExamInfo 3,'Exam', @PickQuestion,'Cal', 3, 2, 1

select *
from [Material].[ExamQuestion]

select *
from [Material].[Exam]

--delete from [Material].[Exam] where ID = 3
go
/*Update In ExamQuestion And add New Questions form exist exam */
declare @PickMQuestion Questions
insert into @PickMQuestion 
values (3 , 2),(4,11)
select * from @PickMQuestion

declare @result2 varchar(10)
exec InstractorAddQInExam 3, @PickMQuestion, 4, 4, 1

select *
from [Material].[ExamQuestion]

select *
from [Material].[Question]


select *
from [Material].[Exam]
go
-----------------------Test Random Qusetion Select------------------------

exec MakeExamByRandomQ 6, 'exam', 5, 'open', 1, 2, 2
exec InsertNewRandomQ 6, 5, 1, 2, 2
exec InsertNewRandomQ 6, 5, 1, 2, 2
exec InsertNewRandomQ 6, 5, 1, 2, 2
exec InsertNewRandomQ 6, 5, 1, 2, 2
exec InsertNewRandomQ 6, 5, 1, 2, 2
exec InsertNewRandomQ 6, 5, 1, 2, 2