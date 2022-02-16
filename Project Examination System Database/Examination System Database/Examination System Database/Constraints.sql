use ExaminationSystemDatabase
go
--PrimeryKey Constraint For All Tables
alter table [Person].[Student]
add constraint 
PrimaryKeyForStudentTable primary key (ID)

alter table [ITI].[Branch]
add constraint 
PrimaryKeyForBranchTable primary key nonclustered(ID)
----
go
--clusterIndexFor Branch Name
create clustered index BranchNameInstructor on [ITI].[Branch]([Name])
go
--clusterIndexFor Department Name
create clustered index nameindex on[ITI].[Department] ([Name])
go
alter table [ITI].[Department]
add constraint 
PrimaryKeyForDepartmentTable primary key nonclustered (ID)
go
--clusterIndexFor Intake Name
create clustered index nameindex on [ITI].[Intake]([Name])
go
alter table [ITI].[Intake]
add constraint 
PrimaryKeyForIntakeTable primary key nonclustered (ID)
go
alter table [ITI].[Track]
add constraint 
PrimaryKeyForTrackTable primary key nonclustered(ID)
go
--clusterIndexFor Track Name
create clustered index ClustenNameTrack on [ITI].[Track]([Name])
go
alter table [Material].[Choice]
add constraint 
PrimaryKeyForChoiceTable primary key (ID)

alter table [Material].[Class]
add constraint 
PrimaryKeyForClassTable primary key (ID)

alter table [Material].[Course]
add constraint 
PrimaryKeyForCourseTable primary key (ID)

alter table [Material].[Exam]
add constraint 
PrimaryKeyForExamTable primary key (ID)

alter table [Material].[StudentExamQ]
add constraint 
PrimaryKeyForStudentQExamTable primary key ([ExmaID], [StudentID], [QuestionID])
go
alter table [Person].[Instructor]
add constraint 
PrimaryKeyForInstructorTable primary key nonclustered (ID)
go
--clusterIndexFor Instructor Name
create clustered index ClustenNameInstructor on [Person].[Instructor]([Name])
go
--becouse same Instructor in same ([ClassID],[CourseID]) in diff year
alter table [Material].[InstClassCourse]
add constraint 
PrimaryKeyForInsClassCourTable primary key ([ClassID],[InstructorID],[CourseID])
go
--Relation Between Student Table and [Material].[Class]
alter table [Person].[Student]
add constraint FKConstraintForStudentClass FOREIGN KEY (ClassID) 
REFERENCES [Material].[Class]([ID])
ON DELETE CASCADE on update cascade

--Relation Between [Material].[MultipleChoiceQuestion] Table and [Material].[Choice]

alter table [Material].[Choice]
add constraint FKConstraintForMultipleChoice FOREIGN KEY ([MultipleChoiceID]) 
REFERENCES [Material].[MultipleChoiceQuestion]([QuestionID])
ON DELETE CASCADE on update cascade; 

--Relation Between [Person].[Instructor] Table and [Person].[Instructor]

alter table [Person].[Instructor]
add constraint FKConstraintForManager FOREIGN KEY (ManagerID) 
REFERENCES [Person].[Instructor]([ID])

--Relation Between [Person].[Instructor] Table and [Material].[Exam]

alter table [Material].[Exam]
add constraint FKConstraintForInstructorExam FOREIGN KEY (InstructorID) 
REFERENCES [Person].[Instructor]([ID])

--Relation Between [Material].[Course] Table and [Material].[Exam]

alter table [Material].[Exam]
add constraint FKConstraintForCourseExam FOREIGN KEY (CourseID) 
REFERENCES [Material].[Course]([ID])
ON DELETE CASCADE on update cascade

--Relation Between [Material].[Class] Table and [Material].[Exam]

alter table [Material].[Exam]
add constraint FKConstraintForClassExam FOREIGN KEY (ClassID) 
REFERENCES [Material].[Class]([ID])
ON DELETE CASCADE on update cascade

--unique For Class

alter table [Material].[Class]
add constraint uniqeConstraintForClass  unique ([BranchID], [IntakeID], [TrackID]) 

--Relation Between [ITI].[Department] Table and [ITI].[Track]

alter table [ITI].[Track]
add constraint FKConstraintForDepartmentTrack FOREIGN KEY (DepartmentID) 
REFERENCES [ITI].[Department]([ID])
ON DELETE CASCADE on update cascade

--Relation Between [Material].[Course] Table and [Material].[Question]

alter table [Material].[Question]
add constraint FKConstraintForQuestionCourse FOREIGN KEY (CourseID) 
REFERENCES [Material].[Course]([ID])
ON DELETE CASCADE on update cascade


--Relation Between [Material].[StudentExamQ] Table [Material].[Exam] , [Person].[Student] and [Material].[Question]

alter table [Material].[StudentExamQ]
add constraint FKConstraintForStdQEAnswerEID FOREIGN KEY ([ExmaID]) 
REFERENCES [Material].[Exam]([ID])
--ON DELETE CASCADE on update cascade

alter table [Material].[StudentExamQ]
add constraint FKConstraintForStdQEAnswerSID FOREIGN KEY ([StudentID]) 
REFERENCES [Person].[Student]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[StudentExamQ]
add constraint FKConstraintForStdQEAnswerQID FOREIGN KEY ([QuestionID]) 
REFERENCES [Material].[Question]([ID])
ON DELETE CASCADE on update cascade

--Relation Between [Material].[StudentExamQ] Table [Material].[Exam] , [Person].[Student] and [Material].[Question][ClassID][InstructorID][CourseID]

alter table [Material].[InstClassCourse]
add constraint FKConstraintForInstClassCourClID FOREIGN KEY ([ClassID]) 
REFERENCES [Material].[Class]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[InstClassCourse]
add constraint FKConstraintForInstClassCourCourID FOREIGN KEY ([CourseID]) 
REFERENCES [Material].[Course]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[InstClassCourse]
add constraint FKConstraintForInstClassCourInstID FOREIGN KEY ([InstructorID]) 
REFERENCES [Person].[Instructor]([ID])
ON DELETE CASCADE on update cascade

--Relation Between [Material].[Class] Table [ITI].[Branch],[ITI].[Intake],[ITI].[Track]

alter table [Material].[Class]
add constraint FKConstraintForClassBranchlID FOREIGN KEY ([BranchID]) 
REFERENCES [ITI].[Branch]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[Class]
add constraint FKConstraintForClassIntakelID FOREIGN KEY ([IntakeID]) 
REFERENCES [ITI].[Intake]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[Class]
add constraint FKConstraintForClassTracklID FOREIGN KEY ([TrackID]) 
REFERENCES [ITI].[Track]([ID])
ON DELETE CASCADE on update cascade

--unique For Exam

alter table [Material].[Exam]
add constraint uniqeConstraintForExam  unique ([CourseID],[ClassID]) 

--Asmaa
--clusterIndexFor Intake Name

--create clustered index nameindex on [ITI].[Intake]([Name])

--alter table [ITI].[Intake]
--add constraint 
--PrimaryKeyForIntakeTable primary key (ID)

--alter table [Material].[Class]
--add constraint FKConstraintForClassIntakelID FOREIGN KEY ([IntakeID]) 
--REFERENCES [ITI].[Intake]([ID])
--ON DELETE CASCADE on update cascade

--clusterIndexFor Department Name

--create clustered index nameindex on[ITI].[Department] ([Name])

--alter table [ITI].[Department]
--add constraint 
--PrimaryKeyForDepartmentTable primary key (ID)

--alter table [ITI].[Track]
--add constraint FKConstraintForDepartmentTrack FOREIGN KEY (DepartmentID) 
--REFERENCES [ITI].[Department]([ID])
--ON DELETE CASCADE on update cascade
--------------------------------------------------OUT---------------------------------------------------------------
--------------------------------------------------OUT-------------------------------------------------------
--------------------------------------------------OUT---------------------------------------------------------------
----Relation Between [Material].[Course] Table and [Material].[Exam]

--alter table [Material].[Exam]
--add constraint FKConstraintForCourseExam FOREIGN KEY (CourseID) REFERENCES [Material].[Course]([ID])

--Relation Between [ITI].[Track] Table and [Material].[Exam]

--alter table [Material].[Exam]
--add constraint FKConstraintForTrackExam FOREIGN KEY (TrackID) REFERENCES [ITI].[Track]([ID])

----Relation Between [ITI].[Branch], [ITI].[Intake] Table and [Material].[Exam]

--alter table [Material].[Exam]
--add constraint FKConstraintForBranchExam FOREIGN KEY (BranchID) REFERENCES [ITI].[Branch]([ID])

----Relation Between [ITI].[Intake] Table and [Material].[Exam]

--alter table [Material].[Exam]
--add constraint FKConstraintForIntakeExam FOREIGN KEY (IntakeID) REFERENCES [ITI].[Intake]([ID])



----Add Primery Key for [Material].[StudentExamQAMultipleChoice], [Material].[StudentExamQATextQuestion], [Material].[StudentExamQATrueAndFalse]

--alter table [Material].[StudentExamQAMultipleChoice]
--add constraint 
--PrimaryKeyForStuExamQAMulChoiceTable primary key ([StudentID],[ExmaID],[MultipleChoiceQuestionID])

--alter table [Material].[StudentExamQATextQuestion]
--add constraint 
--PrimaryKeyForStuExamQATextTable primary key ([StudentID],[ExmaID],[TextQuestionID])

--alter table [Material].[StudentExamQATrueAndFalse]
--add constraint 
--PrimaryKeyForStuExamQATrueAndFalseTable primary key ([StudentID],[ExmaID],[TrueAndFalseQuestionID])

----Relation Between [Material].[StudentExamQAMultipleChoice] Table , [Person].[Student] and [Material].[Exam],[Material].[MultipleChoiceQuestion]  (triple relation)

--alter table [Material].[StudentExamQAMultipleChoice]
--add constraint FKConstraintForStuExamQAMultChoice FOREIGN KEY ([ExmaID]) REFERENCES [Material].[Exam]([ID])

--alter table [Material].[StudentExamQAMultipleChoice]
--add constraint FKConstraintForStuExamQAMultChoiceStudentID FOREIGN KEY ([StudentID]) REFERENCES [Person].[Student](ID)

--alter table [Material].[StudentExamQAMultipleChoice]
--add constraint FKConstraintForStuExamQAMultChoiceMulChID FOREIGN KEY ([MultipleChoiceQuestionID]) REFERENCES [Material].[MultipleChoiceQuestion](ID)

----Relation Between [Material].[StudentExamQATextQuestion] Table , [Person].[Student] and [Material].[Exam], [Material].[TextQuestion]  (triple relation)

--alter table [Material].[StudentExamQATextQuestion]
--add constraint FKConstraintForStuExamQATextQExamID FOREIGN KEY ([ExmaID]) REFERENCES [Material].[Exam]([ID])

--alter table [Material].[StudentExamQATextQuestion]
--add constraint FKConstraintForStuExamQATextQStudentID FOREIGN KEY ([StudentID]) REFERENCES [Person].[Student](ID)

--alter table [Material].[StudentExamQATextQuestion]
--add constraint FKConstraintForStuExamQATextQID FOREIGN KEY ([TextQuestionID]) REFERENCES [Material].[TextQuestion](ID)

----Relation Between [Material].[StudentExamQATrueAndFalse] Table , [Person].[Student] and [Material].[Exam], [Material].[TrueAndFalseQuestion] (triple relation)

--alter table [Material].[StudentExamQATrueAndFalse]
--add constraint FKConstraintForStuExamQATandFQExamID FOREIGN KEY ([ExmaID]) REFERENCES [Material].[Exam]([ID])

--alter table [Material].[StudentExamQATrueAndFalse]
--add constraint FKConstraintForStuExamQATandFStudentID FOREIGN KEY ([StudentID]) REFERENCES [Person].[Student](ID)

--alter table [Material].[StudentExamQATrueAndFalse]
--add constraint FKConstraintForStuExamQATandFQID FOREIGN KEY ([TrueAndFalseQuestionID]) REFERENCES [Material].[TrueAndFalseQuestion](ID)

----Add Primery Key for [Material].[StudentCourse]

--alter table [Material].[StudentCourse]
--add constraint 
--PrimaryKeyForStudentCourseTable primary key ([StudentID],[CourseID])

----Relation Between [Material].[StudentCourse] Table , [Person].[Student] and [Material].[Course]

--alter table [Material].[StudentCourse]
--add constraint FKConstraintForStudentCourseStuID FOREIGN KEY ([StudentID]) REFERENCES [Person].[Student]([ID])

--alter table [Material].[StudentCourse]
--add constraint FKConstraintForStudentCourseCID FOREIGN KEY ([CourseID]) REFERENCES [Material].[Course]([ID])

----Relation Between [Material].[Course] Table and [Material].[MultipleChoiceQuestion]

--alter table [Material].[MultipleChoiceQuestion]
--add constraint FKConstraintForMultChQCourseID FOREIGN KEY ([CourseID]) REFERENCES [Material].[Course]([ID])
--ON DELETE CASCADE on update cascade;

------Relation Between [Material].[Course] Table and [Material].[TextQuestion]

--alter table [Material].[TextQuestion]
--add constraint FKConstraintForTextQCourseID FOREIGN KEY ([CourseID]) REFERENCES [Material].[Course]([ID])
--ON DELETE CASCADE on update cascade;

------Relation Between [Material].[Course] Table and [Material].[TrueAndFalseQuestion]

--alter table [Material].[TrueAndFalseQuestion]
--add constraint FKConstraintForTandFQCourseID FOREIGN KEY ([CourseID]) REFERENCES [Material].[Course]([ID])
--ON DELETE CASCADE on update cascade;

----Add Primery Key for [Material].[ExamQMultipleChoice], [Material].[ExamQTextQuestion], [Material].[ExamQTrueAndFalse]

--alter table [Material].[ExamQMultipleChoice]
--add constraint 
--PrimaryKeyForExamQMulChoiceTable primary key ([ExamID],[MultipleChoiceQuestionID])

--alter table [Material].ExamQTextQuestion
--add constraint 
--PrimaryKeyForExamQTextTable primary key ([ExamID],[TextQuestionID])

--alter table [Material].ExamQTrueAndFalse
--add constraint 
--PrimaryKeyForExamQTrueAndFalseTable primary key ([ExamID],[TrueAndFalseQuestionID])

----
----Relation Between [Material].[ExamQMultipleChoice],[Material].[MultipleChoiceQuestion] Table and [Material].[Exam]
    
--alter table [Material].[ExamQMultipleChoice]
--add constraint FKConstraintForMultipleChoiceExamID FOREIGN KEY (ExamID) REFERENCES [Material].[Exam]([ID]) 
--ON DELETE CASCADE on update cascade;

--alter table [Material].[ExamQMultipleChoice]
--add constraint FKConstraintForMultipleChoiceQMCID FOREIGN KEY ([MultipleChoiceQuestionID]) REFERENCES [Material].[MultipleChoiceQuestion]([ID])
--ON DELETE CASCADE on update cascade;

----Relation Between [Material].[ExamQTrueAndFalse],[Material].[TrueAndFalseQuestion] Table and [Material].[Exam]

--alter table [Material].[ExamQTrueAndFalse]
--add constraint FKConstraintForTrueAndFalseExamID FOREIGN KEY (ExamID) REFERENCES [Material].[Exam]([ID])
--ON DELETE CASCADE on update cascade;

--alter table [Material].[ExamQTrueAndFalse]
--add constraint FKConstraintForExamQTandFID FOREIGN KEY ([TrueAndFalseQuestionID]) REFERENCES [Material].[TrueAndFalseQuestion]([ID])
--ON DELETE CASCADE on update cascade;

----Relation Between [Material].[ExamQTextQuestion],[Material].[TextQuestion] Table and [Material].[Exam]

--alter table [Material].[ExamQTextQuestion]
--add constraint FKConstraintForTextExamID FOREIGN KEY (ExamID) REFERENCES [Material].[Exam]([ID])
--ON DELETE CASCADE on update cascade;

--alter table [Material].[ExamQTextQuestion]
--add constraint FKConstraintForExamQTextID FOREIGN KEY ([TextQuestionID]) REFERENCES [Material].[TextQuestion]([ID])
--ON DELETE CASCADE on update cascade;

--


--alter table [Material].[MultipleChoiceQuestion]
--add constraint 
--PrimaryKeyForMultipleChoiceQuestionTable primary key (ID)

--alter table [Material].[TextQuestion]
--add constraint 
--PrimaryKeyForTextQuestionTable primary key (ID)

--alter table [Material].[TrueAndFalseQuestion]
--add constraint 
--PrimaryKeyForTrueAndFalseQuestionTable primary key (ID)