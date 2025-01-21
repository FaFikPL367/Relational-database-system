-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2025-01-20 20:13:49.343

-- tables
-- Table: Categories
CREATE TABLE Categories (
    CategoryID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(15)  NOT NULL CHECK (Name IN ('Course', 'Meeting', 'Studies', 'Webinar', 'Reunion')),
    CONSTRAINT Categories_pk PRIMARY KEY  (CategoryID)
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID int  NOT NULL,
    CoordinatorID int  NOT NULL,
    Name nvarchar(30)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    Price money  NOT NULL DEFAULT 100 CHECK (Price > 0),
    CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID int  NOT NULL IDENTITY(1, 1),
    FirstName nvarchar(50)  NOT NULL,
    LastName nvarchar(50)  NOT NULL,
    Phone varchar(20)  NOT NULL CHECK (LEN(PHONE) <= 20),
    Email nvarchar(50)  NOT NULL CHECK (Email LIKE '%_@%.%'),
    Address nvarchar(50)  NOT NULL,
    City nvarchar(30)  NOT NULL,
    PostalCode varchar(10)  NOT NULL,
    PositionID int  NOT NULL,
    CONSTRAINT EmployeePhone UNIQUE (Phone),
    CONSTRAINT EmployeeEmail UNIQUE (Email),
    CONSTRAINT EmployeeID PRIMARY KEY  (EmployeeID)
);

-- Table: Employees_Postions
CREATE TABLE Employees_Postions (
    PositionID int  NOT NULL IDENTITY(1, 1),
    PositionName nvarchar(30)  NOT NULL,
    CONSTRAINT Employees_Postions_pk PRIMARY KEY  (PositionID)
);

-- Table: In_person_Meetings
CREATE TABLE In_person_Meetings (
    MeetingID int  NOT NULL,
    Classroom int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    Limit int  NOT NULL DEFAULT 25 CHECK (Limit > 0),
    CONSTRAINT In_person_Meetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: In_person_Modules
CREATE TABLE In_person_Modules (
    ModuleID int  NOT NULL,
    Classroom int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    Limit int  NOT NULL DEFAULT 25 CHECK (Limit > 0),
    CONSTRAINT In_person_Modules_pk PRIMARY KEY  (ModuleID)
);

-- Table: Languages
CREATE TABLE Languages (
    LanguageID int  NOT NULL IDENTITY(1, 1),
    LanguageName nvarchar(30)  NOT NULL,
    CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
);

-- Table: Meetings
CREATE TABLE Meetings (
    MeetingID int  NOT NULL IDENTITY(1, 1),
    TeacherID int  NOT NULL,
    SubjectID int  NOT NULL,
    ReunionID int  NOT NULL,
    DateAndBeginningTime datetime  NOT NULL,
    Duration time(0)  NOT NULL DEFAULT '01:30:00' CHECK (Duration > '00:00:00'),
    Price money  NOT NULL DEFAULT 120 CHECK (Price > 0),
    TypeID int  NOT NULL,
    CONSTRAINT MeetingID PRIMARY KEY  (MeetingID)
);

-- Table: Modules
CREATE TABLE Modules (
    ModuleID int  NOT NULL IDENTITY(1, 1),
    TeacherID int  NOT NULL,
    CourseID int  NOT NULL,
    Name nvarchar(50)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    DateAndBeginningTime datetime  NOT NULL,
    Duration time(0)  NOT NULL DEFAULT '01:30:00' CHECK (Duration > '00:00:00'),
    TypeID int  NOT NULL,
    CONSTRAINT Modules_pk PRIMARY KEY  (ModuleID)
);

-- Table: Online_Async_Meetings
CREATE TABLE Online_Async_Meetings (
    MeetingID int  NOT NULL,
    RecordingLink nvarchar(100)  NOT NULL,
    CONSTRAINT Online_Async_Meetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: Online_Async_Modules
CREATE TABLE Online_Async_Modules (
    ModuleID int  NOT NULL,
    RecordingLink nvarchar(100)  NOT NULL,
    CONSTRAINT OnliceAsyncModulesRecordingLInk UNIQUE (RecordingLink),
    CONSTRAINT Online_Async_Modules_pk PRIMARY KEY  (ModuleID)
);

-- Table: Online_Sync_Meetings
CREATE TABLE Online_Sync_Meetings (
    MeetingID int  NOT NULL,
    MeetingLink nvarchar(100)  NOT NULL,
    RecordingLink nvarchar(100)  NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT OnlineSyncMeetingMeetingLink UNIQUE (MeetingLink),
    CONSTRAINT Online_Sync_Meetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: Online_Sync_Modules
CREATE TABLE Online_Sync_Modules (
    ModuleID int  NOT NULL,
    MeetingLink nvarchar(100)  NOT NULL,
    RecordingLink nvarchar(100)  NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT OnlineSyncModulesMeetingLink UNIQUE (MeetingLink),
    CONSTRAINT Online_Sync_Modules_pk PRIMARY KEY  (ModuleID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL IDENTITY(1, 1),
    UserID int  NOT NULL,
    OrderDate date  NOT NULL,
    PaymentLink nvarchar(100)  NOT NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Orders_Details
CREATE TABLE Orders_Details (
    SubOrderID int  NOT NULL IDENTITY(1, 1),
    OrderID int  NOT NULL,
    PaymentDeadline date  NOT NULL,
    ExtendedPaymentDeadline date  NULL,
    PaymentDate date  NULL,
    FullPrice money  NOT NULL CHECK (FullPrice >= 0),
    ProductID int  NOT NULL,
    Payment money  NULL CHECK (Payment >= 0),
    CONSTRAINT Orders_Details_pk PRIMARY KEY  (SubOrderID)
);

-- Table: Practices
CREATE TABLE Practices (
    PracticeID int  NOT NULL IDENTITY(1, 1),
    Description nvarchar(max)  NOT NULL,
    CompanyName nvarchar(30)  NOT NULL,
    Country nvarchar(30)  NOT NULL,
    City nvarchar(30)  NOT NULL,
    Address nvarchar(50)  NOT NULL,
    Phone varchar(20)  NOT NULL CHECK (LEN(Phone) <= 20),
    Email nvarchar(50)  NOT NULL CHECK (Email LIKE '%_@%.%'),
    CONSTRAINT PracticePhone UNIQUE (Phone),
    CONSTRAINT PracticeEmail UNIQUE (Email),
    CONSTRAINT Practices_pk PRIMARY KEY  (PracticeID)
);

-- Table: Products
CREATE TABLE Products (
    ProductID int  NOT NULL IDENTITY(1, 1),
    CategoryID int  NOT NULL,
    Status bit  NOT NULL DEFAULT 0,
    CONSTRAINT Products_pk PRIMARY KEY  (ProductID)
);

-- Table: Studies
CREATE TABLE Studies (
    StudiesID int  NOT NULL,
    CoordinatorID int  NOT NULL,
    Name nvarchar(30)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    Price money  NOT NULL DEFAULT 1200 CHECK (Price > 0),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudiesID)
);

-- Table: Studies_Reunion
CREATE TABLE Studies_Reunion (
    ReunionID int  NOT NULL IDENTITY(1, 1),
    ProductID int  NOT NULL,
    StudiesID int  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    CONSTRAINT Studies_Reunion_pk PRIMARY KEY  (ReunionID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  NOT NULL IDENTITY(1, 1),
    StudiesID int  NOT NULL,
    Name nvarchar(50)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    CONSTRAINT Subjects_pk PRIMARY KEY  (SubjectID)
);

-- Table: Translators
CREATE TABLE Translators (
    TranslatorID int  NOT NULL IDENTITY(1, 1),
    FirstName nvarchar(50)  NOT NULL,
    LastName nvarchar(50)  NOT NULL,
    Phone varchar(20)  NOT NULL CHECK (LEN(PHONE) <= 20),
    Email nvarchar(50)  NOT NULL CHECK (Email LIKE '%_@%.%'),
    Address nvarchar(50)  NOT NULL,
    City nvarchar(30)  NOT NULL,
    PostalCode varchar(10)  NOT NULL,
    CONSTRAINT TranslatorPhone UNIQUE (Phone),
    CONSTRAINT TranslatorEmail UNIQUE (Email),
    CONSTRAINT TranslatorID PRIMARY KEY  (TranslatorID)
);

-- Table: Translators_Languages
CREATE TABLE Translators_Languages (
    TranslatorID int  NOT NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT Translators_Languages_pk PRIMARY KEY  (TranslatorID,LanguageID)
);

-- Table: Types
CREATE TABLE Types (
    TypeID int  NOT NULL IDENTITY(1, 1),
    TypeName varchar(20)  NOT NULL DEFAULT 'In-person' CHECK (TypeName IN ('In-person', 'Online Sync', 'Online Async', 'Hybrid')),
    CONSTRAINT TypeID PRIMARY KEY  (TypeID)
);

-- Table: Users
CREATE TABLE Users (
    UserID int  NOT NULL IDENTITY(1, 1),
    FirstName nvarchar(50)  NOT NULL,
    LastName nvarchar(50)  NOT NULL,
    Phone varchar(20)  NOT NULL CHECK (LEN(PHONE) <= 20),
    Email nvarchar(50)  NOT NULL CHECK (Email LIKE '%_@%.%'),
    Address nvarchar(50)  NOT NULL,
    City nvarchar(30)  NOT NULL,
    PostalCode varchar(10)  NOT NULL,
    CONSTRAINT UserPhone UNIQUE (Phone),
    CONSTRAINT UserEmail UNIQUE (Email),
    CONSTRAINT UserID PRIMARY KEY  (UserID)
);

-- Table: Users_Courses
CREATE TABLE Users_Courses (
    UserID int  NOT NULL,
    CourseID int  NOT NULL,
    CONSTRAINT Users_Courses_pk PRIMARY KEY  (UserID,CourseID)
);

-- Table: Users_Meetings_Attendance
CREATE TABLE Users_Meetings_Attendance (
    UserID int  NOT NULL,
    MeetingID int  NOT NULL,
    Present bit  NULL,
    CONSTRAINT Users_Meetings_Attendance_pk PRIMARY KEY  (MeetingID,UserID)
);

-- Table: Users_Modules_Passes
CREATE TABLE Users_Modules_Passes (
    UserID int  NOT NULL,
    ModuleID int  NOT NULL,
    Passed bit  NULL,
    CONSTRAINT Users_Modules_Passes_pk PRIMARY KEY  (ModuleID,UserID)
);

-- Table: Users_Practices_Attendance
CREATE TABLE Users_Practices_Attendance (
    UserID int  NOT NULL,
    StudiesID int  NOT NULL,
    PracticeID int  NOT NULL,
    Present bit  NULL,
    CONSTRAINT Users_Practices_Attendance_pk PRIMARY KEY  (UserID,StudiesID,PracticeID)
);

-- Table: Users_Studies
CREATE TABLE Users_Studies (
    UserID int  NOT NULL,
    StudiesID int  NOT NULL,
    Grade int  NULL CHECK (Grade >=2 AND Grade <= 5),
    CONSTRAINT Users_Studies_pk PRIMARY KEY  (UserID,StudiesID)
);

-- Table: Users_Webinars
CREATE TABLE Users_Webinars (
    UserID int  NOT NULL,
    WebinarID int  NOT NULL,
    CONSTRAINT Users_Webinars_pk PRIMARY KEY  (UserID,WebinarID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID int  NOT NULL,
    Name nvarchar(30)  NOT NULL,
    Description nvarchar(max)  NOT NULL,
    DateAndBeginningTime datetime  NOT NULL,
    Duration time(0)  NOT NULL DEFAULT '01:30:00' CHECK (Duration > '00:00:00'),
    CoordinatorID int  NOT NULL,
    TeacherID int  NOT NULL,
    TranslatorID int  NULL,
    Price money  NOT NULL DEFAULT 0 CHECK (Price >= 0),
    LanguageID int  NOT NULL,
    RecordingLink nvarchar(100)  NULL,
    MeetingLink nvarchar(100)  NOT NULL,
    CONSTRAINT WebinarMeetingLink UNIQUE (MeetingLink),
    CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
);

-- foreign keys
-- Reference: Courses_Users_Courses (table: Users_Courses)
ALTER TABLE Users_Courses ADD CONSTRAINT Courses_Users_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: Employees_Courses (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Employees_Courses
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Employees_Modules (table: Modules)
ALTER TABLE Modules ADD CONSTRAINT Employees_Modules
    FOREIGN KEY (TeacherID)
    REFERENCES Employees (EmployeeID);

-- Reference: Employees_Postions_Employees (table: Employees)
ALTER TABLE Employees ADD CONSTRAINT Employees_Postions_Employees
    FOREIGN KEY (PositionID)
    REFERENCES Employees_Postions (PositionID);

-- Reference: In_person_Meetings_Languages (table: In_person_Meetings)
ALTER TABLE In_person_Meetings ADD CONSTRAINT In_person_Meetings_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: In_person_Meetings_Translators (table: In_person_Meetings)
ALTER TABLE In_person_Meetings ADD CONSTRAINT In_person_Meetings_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: In_person_Modules_Languages (table: In_person_Modules)
ALTER TABLE In_person_Modules ADD CONSTRAINT In_person_Modules_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Meetings_Employees (table: Meetings)
ALTER TABLE Meetings ADD CONSTRAINT Meetings_Employees
    FOREIGN KEY (TeacherID)
    REFERENCES Employees (EmployeeID);

-- Reference: Meetings_In_person_Meetings (table: In_person_Meetings)
ALTER TABLE In_person_Meetings ADD CONSTRAINT Meetings_In_person_Meetings
    FOREIGN KEY (MeetingID)
    REFERENCES Meetings (MeetingID);

-- Reference: Meetings_Modules_Types (table: Meetings)
ALTER TABLE Meetings ADD CONSTRAINT Meetings_Modules_Types
    FOREIGN KEY (TypeID)
    REFERENCES Types (TypeID);

-- Reference: Meetings_Online_Async_Meetings (table: Online_Async_Meetings)
ALTER TABLE Online_Async_Meetings ADD CONSTRAINT Meetings_Online_Async_Meetings
    FOREIGN KEY (MeetingID)
    REFERENCES Meetings (MeetingID);

-- Reference: Meetings_Online_Sync_Meetings (table: Online_Sync_Meetings)
ALTER TABLE Online_Sync_Meetings ADD CONSTRAINT Meetings_Online_Sync_Meetings
    FOREIGN KEY (MeetingID)
    REFERENCES Meetings (MeetingID);

-- Reference: Meetings_Studies_Reunion (table: Meetings)
ALTER TABLE Meetings ADD CONSTRAINT Meetings_Studies_Reunion
    FOREIGN KEY (ReunionID)
    REFERENCES Studies_Reunion (ReunionID);

-- Reference: Meetings_Subjects (table: Meetings)
ALTER TABLE Meetings ADD CONSTRAINT Meetings_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Meetings_Users_Meetings_Attendance (table: Users_Meetings_Attendance)
ALTER TABLE Users_Meetings_Attendance ADD CONSTRAINT Meetings_Users_Meetings_Attendance
    FOREIGN KEY (MeetingID)
    REFERENCES Meetings (MeetingID);

-- Reference: Modules_Courses (table: Modules)
ALTER TABLE Modules ADD CONSTRAINT Modules_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: Modules_In_person_Modules (table: In_person_Modules)
ALTER TABLE In_person_Modules ADD CONSTRAINT Modules_In_person_Modules
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID);

-- Reference: Modules_Online_Async_Modules (table: Online_Async_Modules)
ALTER TABLE Online_Async_Modules ADD CONSTRAINT Modules_Online_Async_Modules
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID);

-- Reference: Modules_Online_Sync_Modules (table: Online_Sync_Modules)
ALTER TABLE Online_Sync_Modules ADD CONSTRAINT Modules_Online_Sync_Modules
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID);

-- Reference: Modules_Types_Modules (table: Modules)
ALTER TABLE Modules ADD CONSTRAINT Modules_Types_Modules
    FOREIGN KEY (TypeID)
    REFERENCES Types (TypeID);

-- Reference: Modules_Users_Modules_Passes (table: Users_Modules_Passes)
ALTER TABLE Users_Modules_Passes ADD CONSTRAINT Modules_Users_Modules_Passes
    FOREIGN KEY (ModuleID)
    REFERENCES Modules (ModuleID);

-- Reference: Online_Sync_Meetings_Languages (table: Online_Sync_Meetings)
ALTER TABLE Online_Sync_Meetings ADD CONSTRAINT Online_Sync_Meetings_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Online_Sync_Meetings_Translators (table: Online_Sync_Meetings)
ALTER TABLE Online_Sync_Meetings ADD CONSTRAINT Online_Sync_Meetings_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Online_Sync_Modules_Languages (table: Online_Sync_Modules)
ALTER TABLE Online_Sync_Modules ADD CONSTRAINT Online_Sync_Modules_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Order_Details_Orders (table: Orders_Details)
ALTER TABLE Orders_Details ADD CONSTRAINT Order_Details_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Order_Details_Products (table: Orders_Details)
ALTER TABLE Orders_Details ADD CONSTRAINT Order_Details_Products
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: Orders_Users (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Products_Category (table: Products)
ALTER TABLE Products ADD CONSTRAINT Products_Category
    FOREIGN KEY (CategoryID)
    REFERENCES Categories (CategoryID);

-- Reference: Products_Courses (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Products_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Products (ProductID);

-- Reference: Products_Meetings (table: Meetings)
ALTER TABLE Meetings ADD CONSTRAINT Products_Meetings
    FOREIGN KEY (MeetingID)
    REFERENCES Products (ProductID);

-- Reference: Products_Studies (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Products_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Products (ProductID);

-- Reference: Products_Studies_Reunion (table: Studies_Reunion)
ALTER TABLE Studies_Reunion ADD CONSTRAINT Products_Studies_Reunion
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID);

-- Reference: Products_Webinars (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Products_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Products (ProductID);

-- Reference: Studies_Employees (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Studies_Reunion_Studies (table: Studies_Reunion)
ALTER TABLE Studies_Reunion ADD CONSTRAINT Studies_Reunion_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Studies_Users_Studies (table: Users_Studies)
ALTER TABLE Users_Studies ADD CONSTRAINT Studies_Users_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Subjects_Studies (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Translators_In_person_Modules (table: In_person_Modules)
ALTER TABLE In_person_Modules ADD CONSTRAINT Translators_In_person_Modules
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Translators_Languages_Languages (table: Translators_Languages)
ALTER TABLE Translators_Languages ADD CONSTRAINT Translators_Languages_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Translators_Online_Sync_Modules (table: Online_Sync_Modules)
ALTER TABLE Online_Sync_Modules ADD CONSTRAINT Translators_Online_Sync_Modules
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Translators_Translators_Language (table: Translators_Languages)
ALTER TABLE Translators_Languages ADD CONSTRAINT Translators_Translators_Language
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Users_Courses_Users (table: Users_Courses)
ALTER TABLE Users_Courses ADD CONSTRAINT Users_Courses_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Users_Meetings_Attendance_Users (table: Users_Meetings_Attendance)
ALTER TABLE Users_Meetings_Attendance ADD CONSTRAINT Users_Meetings_Attendance_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Users_Modules_Passes_Users (table: Users_Modules_Passes)
ALTER TABLE Users_Modules_Passes ADD CONSTRAINT Users_Modules_Passes_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Users_Practices_Attendance_Practices (table: Users_Practices_Attendance)
ALTER TABLE Users_Practices_Attendance ADD CONSTRAINT Users_Practices_Attendance_Practices
    FOREIGN KEY (PracticeID)
    REFERENCES Practices (PracticeID);

-- Reference: Users_Practices_Attendance_Users_Studies (table: Users_Practices_Attendance)
ALTER TABLE Users_Practices_Attendance ADD CONSTRAINT Users_Practices_Attendance_Users_Studies
    FOREIGN KEY (UserID,StudiesID)
    REFERENCES Users_Studies (UserID,StudiesID);

-- Reference: Users_Studies_Users (table: Users_Studies)
ALTER TABLE Users_Studies ADD CONSTRAINT Users_Studies_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Users_Webinars_Users (table: Users_Webinars)
ALTER TABLE Users_Webinars ADD CONSTRAINT Users_Webinars_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Webinars_Employees (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Employees
    FOREIGN KEY (CoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Webinars_Languages (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Languages
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: Webinars_Translators (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Webinars_Users_Webinars (table: Users_Webinars)
ALTER TABLE Users_Webinars ADD CONSTRAINT Webinars_Users_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID);

-- End of file.

