--NOTUse
use ExaminationSystemDatabase
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



create table [Material].[MultipleChoiceQuestion]
(
	ID int not null,
	[Text] varchar(100) not null,
	Answer varchar(20) not null,
	Degree int not null
)--on Secondary
go
create table [Material].[TrueAndFalseQuestion]
(
	ID int not null,
	[Text] varchar(100) not null,
	Answer bit not null,
	Degree int not null
)--on Secondary
go
create table [Material].[TextQuestion]
(
	ID int not null,
	[Text] varchar(100) not null,
	Answer varchar(100) not null,
	Degree int not null
)--on Secondary
go
create table [Material].[Exam]
(
	ID int not null,
	[Type] varchar(10) not null,
	startTime time not null, 
	EndTime time not null,
	ExamDate date not null,
	AllowanceOptions varchar(30) not null
)--on Secondary
go
create table [Material].[Choice]
(
	ID int not null,
	QuestionChoice varchar(20) not null
)--on Secondary
go
create table [Material].[Class]
(
	ID int not null,
	[Name] varchar(20) not null
)--on Secondary
go