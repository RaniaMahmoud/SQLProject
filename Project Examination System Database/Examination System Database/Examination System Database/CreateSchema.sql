--NOTUse
use ExaminationSystemDatabase

go
create schema Person
go
alter schema Person TRANSFER [dbo].[Student] 
alter schema Person TRANSFER [dbo].[Instructor]
go

go
create schema ITI
go
alter schema ITI TRANSFER [dbo].[Branch]
alter schema ITI TRANSFER [dbo].[Department]
alter schema ITI TRANSFER [dbo].[Intake]
alter schema ITI TRANSFER [dbo].[Track]
go
create schema Material
go
alter schema Material TRANSFER [dbo].[Choice]
alter schema Material TRANSFER [dbo].[Class]
alter schema Material TRANSFER [dbo].[Course]
alter schema Material TRANSFER [dbo].[Exam]
alter schema Material TRANSFER [dbo].[TextQuestion]
alter schema Material TRANSFER [dbo].[MultipleChoiceQuestion]
alter schema Material TRANSFER [dbo].[TrueAndFalseQuestion]
go