-- Add Course Clustered
alter table [Material].[Exam]
drop constraint FKConstraintForCourseExam

alter table [Material].[Question]
drop constraint FKConstraintForQuestionCourse

alter table [Material].[InstClassCourse]
drop constraint FKConstraintForInstClassCourCourID

alter table [Material].[Course]
drop constraint 
PrimaryKeyForCourseTable

create clustered index CourseNameSearch on [Material].[Course]([Name])

alter table [Material].[Course]
add constraint 
PrimaryKeyForCourseTable primary key (ID)

alter table [Material].[Exam]
add constraint FKConstraintForCourseExam FOREIGN KEY (CourseID) 
REFERENCES [Material].[Course]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[Question]
add constraint FKConstraintForQuestionCourse FOREIGN KEY (CourseID) 
REFERENCES [Material].[Course]([ID])
ON DELETE CASCADE on update cascade

alter table [Material].[InstClassCourse]
add constraint FKConstraintForInstClassCourCourID FOREIGN KEY ([CourseID]) 
REFERENCES [Material].[Course]([ID])
ON DELETE CASCADE on update cascade



-- Add Student Clustered
alter table [Material].[StudentExamQ]
drop constraint FKConstraintForStdQEAnswerSID 

alter table [Person].[Student]
drop constraint 
PrimaryKeyForStudentTable

create clustered index StudentNameSearch on [Person].[Student]([Name])

alter table [Person].[Student]
add constraint 
PrimaryKeyForStudentTable primary key (ID)

alter table [Material].[StudentExamQ]
add constraint FKConstraintForStdQEAnswerSID FOREIGN KEY ([StudentID]) 
REFERENCES [Person].[Student]([ID])
ON DELETE CASCADE on update cascade