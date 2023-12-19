Create Database LabNet   ON
(
  NAME = 'LabNet_Data',
  FILENAME = 'E:\DBSHEFA PROJECT\LabNet_Data.mdf',
  SIZE = 5MB,
  MAXSIZE = 10MB,
  FILEGROWTH = 3

)

log on 
(

  NAME = 'LabNet_log',
  FILENAME = 'E:\DBSHEFA PROJECT\LabNet_log.ldf',
  SIZE = 5MB,
  MAXSIZE = 10MB,
  FILEGROWTH = 3


);


---------create filegroup for personal table in DB

alter database LabNet
add filegroup Personal_group


alter database LabNet
add file 
(

  NAME = 'Personal_Info',
  FILENAME = 'E:\DBSHEFA PROJECT\Personal_Info.ndf',
  SIZE = 5MB,
  MAXSIZE = 10MB,
  FILEGROWTH = 3

) to filegroup Personal_group


---------create schema for database 
CREATE SCHEMA User_Schema; 

CREATE SCHEMA Healthcare_Schema


---------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------CREATE  TABLES  IN DATABASE 

CREATE TABLE User_Schema.[Address](

AddressID int  IDENTITY(1,1)   primary key ,
City	  nvarchar(20) not null,
Street	  nvarchar(20) null  ,
Governerate nvarchar(20) not null
) ON Personal_group



CREATE TABLE User_Schema.[User](
UserID INT PRIMARY KEY IDENTITY(1,1),
Name VARCHAR(255),
Password VARCHAR(255) ,
Phone CHAR(11) check((LEN(Phone) = 11 AND ISNUMERIC(Phone) = 1) and ( Phone LIKE '011%' OR Phone LIKE '012%' OR Phone LIKE '010%'))  ,
AddressID int FOREIGN KEY REFERENCES User_Schema.[Address](AddressID) 

)ON Personal_group


CREATE TABLE User_Schema.Patient(
PatientID INT PRIMARY KEY IDENTITY(1,1),
UserID int FOREIGN KEY REFERENCES User_Schema.[User](UserID)  ,
National_Id int unique check((LEN(National_Id) = 14 AND ISNUMERIC(National_Id) = 1)),
Gender  nvarchar(10) check(Gender in ('Male' , 'Female')), 
Age  int 
)ON Personal_group


CREATE TABLE User_Schema.Doctors(
DoctorID INT PRIMARY KEY IDENTITY(1,1),
UserID int FOREIGN KEY REFERENCES User_Schema.[User](UserID)  ,
YearsOfExperience int , 
National_Id int unique check((LEN(National_Id) = 14 AND ISNUMERIC(National_Id) = 1)),	
Specialization  nvarchar(25)
)ON Personal_group


CREATE TABLE User_Schema.LabSpecialist (
LabSpecialistID INT PRIMARY KEY IDENTITY(1,1),
UserID int FOREIGN KEY REFERENCES User_Schema.[User](UserID)  ,
LabID  int 	FOREIGN KEY REFERENCES Healthcare_Schema.Laboratory(LabID),
WorkHours  int 
)ON Personal_group


CREATE TABLE User_Schema.PatientOffer(
PatientOfferID INT PRIMARY KEY IDENTITY(1,1), 
PatientID int FOREIGN KEY REFERENCES User_Schema.Patient(PatientID),
OfferID int FOREIGN KEY REFERENCES Healthcare_Schema.Offers (OfferID)

)ON Personal_group


CREATE TABLE User_Schema.LabSpecialistOffer  (
LabSpecialistOfferID INT PRIMARY KEY IDENTITY(1,1), 
OfferID int FOREIGN KEY REFERENCES Healthcare_Schema.Offers (OfferID),
LabSpecialistID int FOREIGN KEY REFERENCES User_Schema.LabSpecialist (LabSpecialistID)

)ON Personal_group


CREATE TABLE Healthcare_Schema.Laboratory(
LabID  INT PRIMARY KEY IDENTITY(1,1),
LabName  nvarchar(20),
logo image  ,
licensing  int  not null   unique

)



CREATE TABLE Healthcare_Schema.Recommendation(
Rec_ID INT PRIMARY KEY IDENTITY(1,1),
PatientID int FOREIGN KEY REFERENCES User_Schema.Patient(PatientID),	
DoctorID int FOREIGN KEY REFERENCES User_Schema.Doctors(DoctorID),	
RecMS	nvarchar(40) not null ,
[Status] nvarchar(20) check([Status] in ('Positive' , 'Negative '))
)

CREATE TABLE Healthcare_Schema.SystemRate (
RateID  INT PRIMARY KEY IDENTITY(1,1),	
UserID INT unique  FOREIGN KEY REFERENCES User_Schema.[User](UserID),
Feedbacke  nvarchar(40)	,
NumberOfStar int not null  check(NumberOfStar in (1,2,3,4,5))

)

CREATE TABLE Healthcare_Schema.Offers(
OfferID	INT PRIMARY KEY IDENTITY(1,1),	
Discount int ,	
Interval int not null
)

CREATE TABLE Healthcare_Schema.MedicalTest(
MT_ID  INT PRIMARY KEY IDENTITY(1,1),		
PatientID int FOREIGN KEY REFERENCES User_Schema.Patient(PatientID),	
DoctorID int FOREIGN KEY REFERENCES User_Schema.Doctors(DoctorID),		
TypeOfTest nvarchar(40) not null,	
Price  int not null ,
ImageTest  image	,
Result	nvarchar(40) not null,
 DateTest DATETIME DEFAULT GETDATE()

) 

CREATE TABLE Healthcare_Schema.MedicalArchive(
ArchiveID	INT PRIMARY KEY IDENTITY(1,1),
MT_ID   int FOREIGN KEY REFERENCES Healthcare_Schema.MedicalTest(MT_ID)	

) 

