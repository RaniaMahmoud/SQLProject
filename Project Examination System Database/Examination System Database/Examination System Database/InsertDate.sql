insert into [ITI].[Branch] values (1,'branch1')
insert into [ITI].[Branch] values (2,'branch2')
insert into [ITI].[Branch] values (3,'branch3')
insert into [ITI].[Branch] values (4,'branch3')
insert into [ITI].[Branch] values (5,'branch3')
insert into [ITI].[Branch] values (6,'branch3')

-----------------------------------------------------------------------
insert into [ITI].[Department] values (1,'dept1'),(2,'dept2')
------------------------------------------------------------
insert into [ITI].[Intake] values (1,'int1'),(2,'int2')
insert into [ITI].[Intake] values(3,'int3'),(4,'int4'),(5,'int5')
---------------------------------------------------------------
insert into [ITI].[Track] values (1,'track1',1),(2,'track2',2)
insert into [ITI].[Track] values (3,'track3',1),(4,'track4',1),(5,'track5',1)
----------------------------------------------------------------
insert into [Material].[Class] values(1,1,1,1) 
insert into [Material].[Class] values(3,3,3,3)
insert into [Material].[Class] values(4,4,4,4),(5,5,5,5)
--------------------------------------------------------
insert into [Material].[Course] values (1,'course1','desc1',100,60,3)
insert into [Material].[Course] values (2,'course2','desc2',100,60,3)
insert into [Material].[Course] values (3,'course3','desc3',100,60,3),(4,'course4','desc4',100,60,3)
------------------------------------------------------------------------
insert into [Person].[Instructor] ([ID],[NationalID],[Name],[BirthOFDate],[Gender])
values (1,11111111111111,'asmaa',getdate(),'F')
insert into [Person].[Instructor] ([ID],[NationalID],[Name],[BirthOFDate],[Gender],[ManagerID])
values (2,11111111111111,'asmaa',getdate(),'F',1)
insert into [Person].[Instructor] ([ID],[NationalID],[Name],[BirthOFDate],[Gender],[ManagerID])
values (3,11111111111111,'asymaa',getdate(),'F',2)
insert into [Person].[Instructor] ([ID],[NationalID],[Name],[BirthOFDate],[Gender],[ManagerID])
values (4,11111111111111,'asmoaa',getdate(),'F',1)
------------------------------------------------------------------------------------------------

insert into [Person].[Student] 
([ID],[NationalID],[Name],[BirthOFDate],[Gender],[ClassID])
values (1,1111111111111,'ali',GETDATE(),'M',1),
(2,1111111111111,'hany',GETDATE(),'M',1), 
(3,1111111111111,'ali',GETDATE(),'M',2)

-----------------------------------------------------------------------------------------

insert into [Material].[Exam] 
([ID],[Type],[startTime],[EndTime],[ExamDate],[AllowanceOptions],[InstructorID],[CourseID],[ClassID])
values (1,'cor','11:31PM','12:31PM',GETDATE(),'calculater',1,1,1), 
(2,'cor2','12:31PM','1:31PM',GETDATE(),'openbook',2,2,2)
-----------------------------------------------------------------------------------------

insert into [Material].[InstClassCourse] 
values (1,1,1,1999)
insert into [Material].[InstClassCourse] 
values (1,1,1,1998)
insert into [Material].[InstClassCourse] 
values (1,4,4,1798)
insert into [Material].[InstClassCourse] 
values (1,3,3,1928)
insert into [Material].[InstClassCourse] 
values (1,2,3,1928)
--------------------------------------------------------------------
insert into [Material].[Question] values (1,'MCQ',1)
insert into [Material].[Question] values (2,'MCQ',1)
insert into [Material].[Question] values (3,'TF',1)
insert into [Material].[Question] values (4,'TF',1)
insert into [Material].[Question] values (5,'TExt',1)
insert into [Material].[Question] values (6,'TEXT',1)

insert into [Material].[MultipleChoiceQuestion]
values (1,'txet','aswer',2)
insert into [Material].[MultipleChoiceQuestion]
values (2,'txet','aswer',2)

insert into [Material].[TrueAndFalseQuestion]
values (3,'txet',1,2),(4,'txet',1,2)

insert into [Material].[TextQuestion]
values (5,'texte',0,2),(6,'texte',0,2)
-----------------------------------------------------
insert into [Material].[StudentExamQ]
values (1,1,1,'answer',1),(1,1,2,'answer',2)
------------------------------------------------------------------


















