use ExaminationSystemDatabase

go
create type GenderType from varchar(1)
go
create rule GenderCheck as (@col in('F','M'))
go
sp_bindrule GenderCheck, GenderType
go
alter table [Person].[Student]
alter column [Gender]  GenderType
go
alter table [Person].[Instructor]
alter column [Gender]  GenderType
go
create type TrueFalseType from varchar(1)
go
create rule CheckAnsewrType as (@col in('F','T'))
go
sp_bindrule CheckAnsewrType, TrueFalseType
go
alter table [Material].[TrueAndFalseQuestion]
alter column [Answer] TrueFalseType
go
create type PhoneType from varchar(11)
go
alter table [Person].[Instructor]
alter column [Phone] PhoneType
go
alter table [Person].[Student]
alter column [Phone] PhoneType
go
create type NationalType from varchar(14)
go
alter table [Person].[Instructor]
alter column [NationalID] NationalType
go
alter table [Person].[Student]
alter column [NationalID] NationalType
go

/*Relation Between Exam and Questions */

create table [Material].[ExamQuestion]
(
	ExamID int not null,
	QuestionID int not null,
	Degree int not null
)
go
alter table [Material].[ExamQuestion]
add constraint 
PrimaryKeyForExamQuestion primary key ([ExamID], [QuestionID])

--Relation Between [Material].[Exam] Table and [Material].[Question]

alter table [Material].[ExamQuestion]
add constraint FKConstraintForExamQuestionEID FOREIGN KEY (ExamID) 
REFERENCES [Material].[Exam]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[ExamQuestion]
add constraint FKConstraintForExamQuestionQID FOREIGN KEY (QuestionID) 
REFERENCES [Material].[Question]([ID])
--ON DELETE CASCADE on update cascade ***** will cause cycle

--alter [startTime][EndTime][ExamDate] to allow null
go
alter table [Material].[Exam]
alter column [startTime] time null
go
alter table [Material].[Exam]
alter column [EndTime] time null
go
alter table [Material].[Exam]
alter column [ExamDate] date null
go
alter table [Material].[TrueAndFalseQuestion]
alter column [Answer] varchar(1) not null
go
