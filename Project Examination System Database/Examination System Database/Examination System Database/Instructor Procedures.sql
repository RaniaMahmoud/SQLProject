create procedure InstAddQuestionToCourse (@InstID int,@CourseID int,@QuesId int,@QuesType varchar(20),@QueText varchar(100),@QuesAns varchar(100),@QuesDegree int)
as begin 
begin transaction
begin try
   if not exists(select [InstructorID] from [Material].[InstClassCourse] where [CourseID] = @CourseID and @InstID = [InstructorID] )
	 print 'Not your Course'
   else
   begin
	   if (@QuesType = 'MCQ')
	   begin
	    insert into [Material].[Question] values (@QuesId,'MCQ',@CourseID)
		insert into [Material].[MultipleChoiceQuestion] values (@QuesId,@QueText,@QuesAns,@QuesDegree)
	   end
	   else if (@QuesType = 'text')
	   begin
	     insert into [Material].[Question] values (@QuesId,'text',@CourseID)
		 insert into [Material].[TextQuestion] values (@QuesId,@QueText,@QuesAns,@QuesDegree)
	   end
	   else if (@QuesType = 'TF')
	   begin
	     insert into [Material].[Question] values (@QuesId,'TF',@CourseID)
		 insert into [Material].[TrueAndFalseQuestion] values (@QuesId,@QueText,@QuesAns,@QuesDegree)
	   end
   end 
   commit
end try
begin catch
  rollback
  print ERROR_MESSAGE()
end catch
end

------------------------------------------------
go
create procedure InstEditQuestion (@InstID int,@QuesId int,@QueText varchar(100),@QuesAns varchar(100),@QuesDegree int)
as begin 
	begin transaction
	begin try
       declare @CourseID int,@CourseInstID int,@QuesType varchar(20)
	   if not exists (
	     (select [InstructorID] from [Material].[InstClassCourse] where [CourseID] =
		 (select [CourseID] from [Material].[Question] where [ID] = @QuesId))
	   )
	   begin
	     print 'Enter valid Data'
	   end
	   else
	   begin
	     set @CourseID=(select [CourseID] from [Material].[Question] where [ID] = @QuesId)
	     set @CourseInstID=(select [InstructorID] from [Material].[InstClassCourse] where [CourseID] = @CourseID)
	     if(@CourseInstID != @InstID)
		   print 'Not your Course'
		 else
		   begin
		     set @QuesType=(select [Type] from [Material].[Question] where [ID] = @QuesId)
			 if (@QuesType = 'TF')
			   begin
			      update [Material].[TrueAndFalseQuestion] 
				  set [QuestionText]=@QueText,[Answer]=@QuesAns,[Degree]=@QuesDegree
				  where [QuestionID] = @QuesId
			   end
			else if (@QuesType = 'text')
			  begin
			     update [Material].[TextQuestion]
				 set [QuestionText]=@QueText,[Answer]=@QuesAns,[Degree]=@QuesDegree
				 where [QuestionID] = @QuesId
			  end
			  else if (@QuesType = 'MCQ')
			  begin
			     update [Material].[MultipleChoiceQuestion]
				 set [QuestionText]=@QueText,[Answer]=@QuesAns,[Degree]=@QuesDegree
				 where [QuestionID] = @QuesId
			  end
		   end
	   end  
	   commit
	end try
	begin catch
	  rollback
	  print ERROR_MESSAGE()
	end catch
end
---------------------------------------------------------------------------
create procedure InstDeleteQuestion ( @InstID int,@QuesId int )
as begin 
begin transaction
begin try
  declare @CourseID int,@CourseInstID int,@QuesType varchar(20)
	   if not exists (
	     (select [InstructorID] from [Material].[InstClassCourse] where [CourseID] =
		 (select [CourseID] from [Material].[Question] where [ID] = @QuesId))
	   )
	   begin
	     print 'Enter valid Data'
	   end
	   else
	   begin
	     set @CourseID=(select [CourseID] from [Material].[Question] where [ID] = @QuesId)
	     set @CourseInstID=(select [InstructorID] from [Material].[InstClassCourse] where [CourseID] = @CourseID)
	     if(@CourseInstID != @InstID)
		   print 'Not your Course'
		 else
		   begin
		     set @QuesType=(select [Type] from [Material].[Question] where [ID] = @QuesId)
			 if (@QuesType = 'TF')
			   begin
			      delete from [Material].[TrueAndFalseQuestion] where [QuestionID] = @QuesId
			   end
			else if (@QuesType = 'text')
			  begin
			      delete from [Material].[TextQuestion] where [QuestionID] = @QuesId
			  end
			  else if (@QuesType = 'MCQ')
			  begin
			      delete from [Material].[MultipleChoiceQuestion] where [QuestionID] = @QuesId  
			  end
			  delete from [Material].[Question] where [ID] = @QuesId
		   end
	   end
  commit
end try
begin catch
   rollback
   print ERROR_MESSAGE()
end catch
end
------------------------------------------------------------------------
-- Students can see the exam and do it only on the specified time 

create proc StudentSeeExam ( @examID int )
as begin
   declare @start time,@end time,@date date,@QuesID int,@QuesType varchar (20)
   set @start = (select  [startTime] from [Material].[Exam] where [ID] = @examID)
   set @end = (select [EndTime]  from [Material].[Exam] where [ID] = @examID)
   set @date = (select [ExamDate]  from [Material].[Exam] where [ID] = @examID)
   if ( CONVERT(TIME, GETDATE()) >= @start and CONVERT(TIME, GETDATE()) <= @end and CONVERT(date, GETDATE()) = @date)
   begin
	    declare cursorOnQues cursor for 
		( select [QuestionID] 
		from [Material].[ExamQuestion] where [ExamID] = @examID )
		open cursorOnQues
		fetch next from cursorOnQues into @QuesID
		while @@Fetch_Status = 0
		begin
		  set @QuesType = ( select [Type] from [Material].[Question]
		  where [ID] = @QuesID )
		  if ( @QuesType = 'TF' )
		    select [QuestionText] from [Material].[TrueAndFalseQuestion]
			where [QuestionID] = @QuesID
		  else if ( @QuesType = 'text' )
		    select [QuestionText] from [Material].[TextQuestion]
			where [QuestionID] = @QuesID
		  else if ( @QuesType = 'MCQ' )
		     select [QuestionText] from [Material].[MultipleChoiceQuestion]
			where [QuestionID] = @QuesID

		fetch next from cursorOnQues into @QuesID
		end
		close cursorOnQues
		deallocate cursorOnQues
   end   
   else 
     print 'Not Date or time for exam'
end
go
create rule QuestionType as @Type in ('TF','MCQ','text')
go
EXEC sp_bindrule QuestionType , '[Material].[Question].[Type]'