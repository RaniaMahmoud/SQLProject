create database ExaminationSystemDatabase

on Primary
(
	name='ExaminationSystemDatabase.mdf',
	filename = 'D:\ITI intake\ITI\SQL\Project Examination System Database\Examination System Database\ExaminationSystemDatabase.mdf',
	size = 20MB,
	maxsize= unlimited,
	filegrowth= 10MB
)
log on
(
	name='ExaminationSystemDatabase.ldf',
	filename = 'D:\ITI intake\ITI\SQL\Project Examination System Database\Examination System Database\ExaminationSystemDatabase.ldf',
	size = 15MB,
	maxsize= unlimited,
	filegrowth= 10MB
)
go
alter database ExaminationSystemDatabase add filegroup SecondaryFG
go
alter database ExaminationSystemDatabase add file (
	name='ExaminationSystemDatabase.ndf',
	filename = 'D:\ITI intake\ITI\SQL\Project Examination System Database\Examination System Database\ExaminationSystemDatabase.ndf',
	size = 20MB,
	maxsize= unlimited,
	filegrowth= 10MB
)to filegroup SecondaryFG
go
create schema Person
go
--alter schema Person TRANSFER [dbo].[Student] 
--alter schema Person TRANSFER [dbo].[Instructor]
go

go
create schema ITI
go
--alter schema ITI TRANSFER [dbo].[Branch]
--alter schema ITI TRANSFER [dbo].[Department]
--alter schema ITI TRANSFER [dbo].[Intake]
--alter schema ITI TRANSFER [dbo].[Track]
--go
create schema Material
go
create table [Person].[Student]
(
	ID int not null,
	NationalID varchar(14) not null,
	[Name] varchar(20) not null,
	Phone varchar(11),
	BirthOFDate Date not null,
	[Address] varchar(20),
	Email varchar(20),
	Gender varchar(1) not null,
	Faculty varchar(50)
)--on Primery
go
create table [Person].[Instructor]
(
	ID int not null,
	NationalID varchar(14) not null,
	[Name] varchar(20) not null,
	Phone varchar(11),
	BirthOFDate Date not null,
	[Address] varchar(20),
	Email varchar(20),
	Gender varchar(1) not null
)--on Primery

go
create table [Material].[Course]
(
	ID int not null,
	[Name] varchar(20) not null,
	[Description] varchar(50),
	MaxDegree int not null, 
	MinDegree int not null,
	[Hours] int not null
)--on Primery
go
create table [ITI].[Department]
(
	ID int not null,
	[Name] varchar(20) not null
)--on Primary
go
create table [ITI].[Intake]
(
	ID int not null,
	[Name] varchar(20) not null
)--on Primary
go
create table [ITI].[Branch]
(
	ID int not null,
	[Name] varchar(20) not null
)--on Primary
go
create table [ITI].[Track]
(
	ID int not null,
	[Name] varchar(20) not null
)--on Primary
go
create table [Material].[Question]
(
	ID int not null primary key,
	[Type] varchar(20)
)--on Primary
go
--ALTER DATABASE [ExaminationSystemDatabase] MODIFY FILEGROUP [Secondary] DEFAULT
create table [Material].[MultipleChoiceQuestion]
(
	QuestionID int not null REFERENCES [Material].[Question](ID),
	[QuestionText] varchar(100) not null,
	Answer varchar(20) not null,
	Degree int not null,
	PRIMARY KEY(QuestionID)
)on SecondaryFG
go
create table [Material].[TrueAndFalseQuestion]
(
	QuestionID int not null REFERENCES [Material].[Question](ID),
	[QuestionText] varchar(100) not null,
	Answer bit not null,
	Degree int not null,
	PRIMARY KEY(QuestionID)
)on SecondaryFG
go
create table [Material].[TextQuestion]
(
	QuestionID int not null REFERENCES [Material].[Question](ID),
	[QuestionText] varchar(100) not null,
	Answer varchar(100) not null,
	Degree int not null,
	PRIMARY KEY(QuestionID)
)on SecondaryFG
go
create table [Material].[Choice]
(
	ID int not null,
	QuestionChoice varchar(20) not null
)on SecondaryFG

go
create table [Material].[Exam]
(
	ID int not null,
	[Type] varchar(10) not null,
	startTime time not null, 
	EndTime time not null,
	ExamDate date not null,
	AllowanceOptions varchar(30) not null
)on SecondaryFG
go

create table [Material].[Class]
(
	ID int not null,
	--[Name] varchar(20) not null
)on SecondaryFG
go

--
alter table [Person].[Student]
add  ClassID int not null

alter table [Material].[Class]
add  
BranchID int not null,
IntakeID int not null, 
TrackID int not null

alter table [Material].[MultipleChoiceQuestion]
add  
ExamID int not null

alter table [Material].[TextQuestion]
add  
ExamID int not null

alter table [Material].[TrueAndFalseQuestion]
add  
ExamID int not null

alter table [Person].[Instructor]
add  
ManagerID int--exec

alter table [Material].[Exam]
add  
InstructorID int not null--exec

alter table [Material].[Exam]
add  
CourseID int not null--exec

alter table [Material].[Exam]
add  
ClassID int not null--exec

alter table [ITI].[Track]
add
DepartmentID int not null--exec

alter table [Material].[Question]
add  
CourseID int not null --exec

--Student Exam Question Table (triple)
create table [Material].[StudentExamQ]
(
	ExmaID int not null,
	StudentID int not null,
	QuestionID int not null,
	Answer varchar(100) not null,
	StudentQuestionDegree int not null
)--exec

--Instructor Course Class Table (triple)
create table [Material].[InstClassCourse]
(
	ClassID int not null,
	InstructorID int not null,
	CourseID int not null,	
	[Year] varchar(4) not null
)--exec

---------------------------------------------------------------------------
alter table [Material].[Choice]
add  
MultipleChoiceID int not null

alter table [Material].[Exam]
add  
CourseID int not null

alter table [Material].[Exam]
add
TrackID int not null, 
IntakeID int not null,
BranchID int not null

--Student Exam Question Table (triple)
create table [Material].[StudentExamQAMultipleChoice]
(
	ExmaID int not null,
	StudentID int not null,
	MultipleChoiceQuestionID int not null,
	Answer varchar(20) not null,
	StudentQuestionDegree int not null
)
go
create table [Material].[StudentExamQATrueAndFalse]
(
	ExmaID int not null,
	StudentID int not null,
	TrueAndFalseQuestionID int not null,
	Answer varchar(100) not null,
	StudentQuestionDegree int not null
)
go
create table [Material].[StudentExamQATextQuestion]
(
	ExmaID int not null,
	StudentID int not null,
	TextQuestionID int not null,
	Answer bit not null,
	StudentQuestionDegree int not null
)

go
create table [Material].[StudentCourse]
(
	CourseID int not null,
	StudentID int not null,
	StudentFinalDegree int 
)
go
alter table [Material].[MultipleChoiceQuestion]
add
CourseID int not null
go
alter table [Material].[TextQuestion]
add
CourseID int not null
go
alter table [Material].[TrueAndFalseQuestion]
add
CourseID int not null
go
--
--Create ExamQuestion Table
create table [Material].[ExamQMultipleChoice]
(
	ExamID int not null,
	MultipleChoiceQuestionID int not null,

)
go
create table [Material].[ExamQTrueAndFalse]
(
	ExamID int not null,
	TrueAndFalseQuestionID int not null,
)
go
create table [Material].[ExamQTextQuestion]
(
	ExamID int not null,
	TextQuestionID int not null,
)
--