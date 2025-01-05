## Indeksy
---
### Tabela Orders
```SQL
create index Orders_userID on Orders (UserID);
```
---

### Tabela Course_Modules
```SQL
create index Modules_teacherID on Modules (TeacherID);
create index Modules_courseID on Modules (CourseID);
create index Modules_typeID on Modules (TypeID);
create index Modules_date on Modules (DateAndBeginningTime,Duration);
```
---

### Tabela Courses
```SQL
create index Courses_coordinatorID on Courses (CoordinatorID);
create index idx_course_startdate on Courses (StartDate);
create index idx_course_enddate on Courses (EndDate);
create index idx_course_totaldate on Courses (StartDate, EndDate);
```
---

### Tabela Employees
```SQL
CREATE INDEX Employees_Position on Employees (PositionID);
CREATE INDEX Employees_full_name on Employees (FirstName, LastName);
```
---

### Tabela In_person_Meetings
```SQL
create index In_person_meetings_translatorID on In_person_Meetings (TranslatorID);
create index In_person_meetings_languageID on In_person_Meetings (LanguageID);
```
---

### Tabela In_person_modules
```SQL
create index In_person_modules_translatorID on In_person_modules (TranslatorID);
create index In_person_modules_languageID on In_person_modules (LanguageID);
```
---

### Tabela Meetings
```SQL
create index Meetings_teacherID on Meetings (TeacherID);
create index Meetings_subjectID on Meetings (SubjectID);
create index Meetings_typeID on Meetings (TypeID);
create index Meetings_date on Meetings (DateAndBeginningTime, Duration);
```
---

### Tabela Online_Sync_Meetings
```SQL
create index Online_sync_meetings_translatorID on Online_Sync_Meetings (TranslatorID);
create index Online_sync_meetings_languageID on Online_Sync_Meetings (LanguageID);
```
---

### Tabela Online_Sync_Modules
```SQL
create index Online_sync_modules_translatorID on Online_sync_modules (TranslatorID);
create index Online_sync_modules_languageID on Online_sync_modules (LanguageID);
```
---

### Tabela Orders_Details
```SQL
create index Orders_details_orderID on Orders_Details (OrderID);
create index Orders_details_productID on Orders_Details (ProductID);
```
---

### Tabela Products
```SQL
create index Products_categoryID on Products (CategoryID);
```
---

### Tabela Studies
```SQL
create index Studies_coordinatorID on Studies (CoordinatorID);
create index idx_studies_startdate on Studies (StartDate);
create index idx_studies_enddate on Studies (EndDate);
create index idx_studies_totaldate on Studies (StartDate, EndDate)
```
---

### Tabela Subjects
```SQL
create index Subjects_studiesID on Subjects (StudiesID);
```
---

### Tabela Translators_Languages
```SQL
CREATE INDEX Translator_language_translatorID on Translators_Languages (TranslatorID);
CREATE INDEX Translator_language_languageID on Translators_Languages (LanguageID);
```
---

### Tabela Translators
```SQL
create index Translators_full_name on Translators (FirstName, LastName);
```
---

### Tabela Users_Courses
```SQL
create index Users_courses_userID on Users_Courses (UserID);
CREATE INDEX Users_courses_courseID on Users_Courses (CourseID);
```
---

### Tabela Users_Meetings_Attendance
```SQL
create index Users_meetings_attendance_userID on Users_Meetings_Attendance (UserID);
CREATE index Users_meetings_attendance_meetingID on Users_Meetings_Attendance (MeetingID);
```
---

### Tabela Users_Modules_Passes
```SQL
create index Users_modules_passes_userID on Users_Modules_Passes (UserID);
create index Users_modules_passes_moduleID on Users_Modules_Passes (ModuleID);
```
---

### Tabela Users_Practices_Attendance
```SQL
create index Users_modules_passes_userID on Users_Modules_Passes (UserID);
create index Users_modules_passes_moduleID on Users_Modules_Passes (ModuleID);
```
---

### Tabela Users_Studies
```SQL
create index Users_studies_userID on Users_Studies (UserID);
create index Users_studies_studiesID on Users_Studies (StudiesID);
```
---

### Tabela Users_Webinars
```SQL
create index Users_webinars_userID on Users_Webinars (UserID);
create index Users_webinars_webinarID on Users_Webinars (WebinarID);
```
---

### Tabela Users
```SQL
CREATE INDEX Users_full_name on Users (FirstName, LastName);
```
---

### Tabela Webinars
```SQL
CREATE INDEX Webinars_coordinatorID on Webinars (CoordinatorID);
CREATE INDEX Webinars_translatorID on Webinars (TranslatorID);
CREATE INDEX Webinars_languageID on Webinars (LanguageID);
create index Webinars_date on Webinars (DateAndBeginningTime, Duration)
```