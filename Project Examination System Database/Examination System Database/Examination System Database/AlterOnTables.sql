--NOTUse
use ExaminationSystemDatabase

alter table [Person].[Student]
add  BranchID int not null

alter table [Person].[Student]
add  
IntakeID int not null, 
TrackID int not null