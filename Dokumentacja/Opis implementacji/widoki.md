# Widoki
---
### Course_information
Widok przedstawia informacje o stworzonych kursach dostępnych i nie dostępnych. Przedstawia również informacje o ilości modułów i maksymalnej ilości miejsc na kursie (wyznaczana na podstawie limitu w modułach stacjonarnych).
```SQL
create view course_information as
    with count_modules as (select CourseID, count(ModuleID) as count_module
                           from Modules
                           group by CourseID
    ), limit_for_course as (select Courses.CourseID, min(Limit) as min_limit
                            from Courses inner join Modules on Courses.CourseID = Modules.CourseID
                            inner join In_person_Modules on Modules.ModuleID = In_person_Modules.ModuleID
                            group by Courses.CourseID)

    select Courses.CourseID,
           Name,
           Description,
           concat(FirstName, ' ', LastName) as Coordinator_full_name,
           StartDate,
           EndDate,
           isnull(count_module, 0) as Total_modules,
           min_limit as Total_places
    from Courses left join Employees on Courses.CoordinatorID = Employees.EmployeeID
    left join count_modules on Courses.CourseID = count_modules.CourseID
    left join limit_for_course on Courses.CourseID = limit_for_course.CourseID;
```
---

### Employees_information
Widok przedstawia informacje danych pracowników w systemie.
```SQL
CREATE view employees_information as
    select EmployeeID,
           FirstName,
           LastName,
           Phone,
           Email,
           Address,
           City,
           PostalCode,
           PositionName
    from Employees inner join Employees_Postions on Employees.PositionID = Employees_Postions.PositionID
```

---

### Future_course_sign
Widok przestawia informacje o ilości osób zapisanych na przyszłe kursy. Przyszłe kursy oznaczają wydarzenia o dalszej dacie niż aktualna.
```SQL
CREATE view future_course_sign as
    select future_courses.CourseID,
           Name,
           StartDate,
           EndDate,
           count(UserID) as Total_users
    from future_courses left join Users_Courses on Users_Courses.CourseID = future_courses.CourseID
    group by future_courses.CourseID, Name, StartDate, EndDate
```

---

### Future_courses
Widok przedstawia informacje o przyszłych kursach.
```SQL
create view future_courses as
    select *
    from course_information
    where getdate() < StartDate
```

---

### Future_studie_sign
Widok przedstawia informacje o ilości osób zapisanych na przyszłe studia.
```SQL
CREATE view future_studie_sign as
    select future_studies.StudiesID,
           Name,
           StartDate,
           EndDate,
           count(UserID) as Total_users
    from future_studies left join Users_Studies on Users_Studies.StudiesID = future_studies.StudiesID
    group by future_studies.StudiesID, Name, StartDate, EndDate;
```

---

### Future_studies
Widok przedstawia informacje o przyszłych studiach.
```SQL
create view future_studies as
    select *
    from studie_information
    where getdate() < StartDate
```

---

### Future_webinar_sign
Widok przedstawia informacje o ilości zapisanych osób na przyszłe webinary.
```SQL
CREATE view future_webinar_sign as
    select future_webinars.WebinarID, 
           Name,
           DateAndBeginningTime,
           Duration,
           count(UserID) as Total_users
    from future_webinars left join Users_Webinars on Users_Webinars.WebinarID = future_webinars.WebinarID
    group by future_webinars.WebinarID, Name, Duration, DateAndBeginningTime
```

---

### Future_webinars
Widok przedstawia informacje o przyszłych webinarach.
```SQL
create view future_webinars as
    select *
    from webinar_information
    where getdate() < DateAndBeginningTime
```

---

### In_person_module_information
Widok przedstawia informacje o modułach stacjonarnych w kursach.
```SQL
create view in_person_module_information as
    select ModuleID,
           Classroom,
           concat(FirstName, ' ', LastName) as Translator_full_name,
           LanguageName,
           Limit
    from In_person_Modules left join Translators on In_person_Modules.TranslatorID = Translators.TranslatorID
    left join Languages on In_person_Modules.LanguageID = Languages.LanguageID;
```

---

### Languages_count_translators
Widok przedstawia ilu tłumaczy mówi w danych językach.
```SQL
create view languages_count_translators as
    select LanguageName,
           count(TranslatorID) as Translators_count
    from Languages
        inner join Translators_Languages on Languages.LanguageID = Translators_Languages.LanguageID
    group by LanguageName;
```

---

### Module_information
Widok przedstawia informacje o modułach w kursach.
```SQL
create view module_information as
    select ModuleID,
           concat(FirstName, ' ', LastName) as Teacher_full_name,
           CourseID,
           Name,
           Description,
           DateAndBeginningTime,
           Duration,
           TypeName
    from Modules inner join Employees on Modules.TeacherID = Employees.EmployeeID
    inner join Types on Modules.TypeID = Types.TypeID;
```

---

### Online_sync_module_information
Widok przedstawia informacje o modułach online-synchronicznych w kursach.
```SQL
create view online_sync_module_information as
    select ModuleID,
           MeetingLink,
           RecordingLink,
           concat(FirstName, ' ', LastName) as Translator_full_name,
           LanguageName
    from Online_Sync_Modules inner join Translators on Online_Sync_Modules.TranslatorID = Translators.TranslatorID
    inner join Languages on Online_Sync_Modules.LanguageID = Languages.LanguageID;
```

---

### Online_async_module_information
Widok przedstawia informacje o modułach online-asynchronicznyhc w kursach.
```SQl
create view online_async_module_information as
    select ModuleID,
           RecordingLink
    from Online_Async_Modules;
```

---

### Studie_information
Widok przedstawia informacje o studiach wraz z ilością przedmiotów, ilością spotkań oraz maksymalną ilością miejsc na studiach (wyznaczaną po podstawie spotkań stacjonarnych).
```SQL
create view studie_information as
    with count_subjects as (select StudiesID, count(SubjectID) as total_subjects
                            from Subjects
                            group by StudiesID
    ), count_meetings as (select StudiesID, count(MeetingID) as total_meetings
                          from Meetings
                                   inner join Subjects on Meetings.SubjectID = Subjects.SubjectID
                          group by StudiesID
    ), limit_for_studie as (select StudiesID, min(Limit) as min_limit
                            from In_person_Meetings inner join Meetings on In_person_Meetings.MeetingID = Meetings.MeetingID
                            inner join Subjects on Meetings.SubjectID = Subjects.SubjectID
                            group by StudiesID
    )

    select Studies.StudiesID,
           concat(FirstName, ' ', LastName) as Coordinator_full_name,
           Name,
           Description,
           StartDate,
           EndDate,
           Price,
           isnull(total_subjects, 0) as Total_subjects,
           isnull(total_meetings, 0) as Total_meetings,
           min_limit as Total_places
    from Studies left join Employees on Studies.CoordinatorID = Employees.EmployeeID
    left join count_subjects on Studies.StudiesID = count_subjects.StudiesID
    left join count_meetings on Studies.StudiesID = count_meetings.StudiesID
    left join limit_for_studie on Studies.StudiesID = limit_for_studie.StudiesID;
```

---

### Translators_information
Widok przedstawia informacje o tłumaczach pracujących na platformie.
```SQL
CREATE view translators_information as
    select TranslatorID,
           FirstName,
           LastName,
           Phone,
           Email,
           Address,
           City,
           PostalCode
    from Translators;
```

---

### Translators_language
Widok przedstawia zestawienia tłumaczy wraz z językami, które tłumaczą
```SQL
create view translators_language as
    select concat(FirstName, ' ', LastName) as fullName,
           LanguageName
    from Translators
        inner join Translators_Languages on Translators.TranslatorID = Translators_Languages.TranslatorID
        inner join Languages on Languages.LanguageID = Translators_Languages.LanguageID;
```

---

### Users_information
Widok przedstawia informacje o użytkownikach systemu.
```SQL
CREATE view users_information as
    select UserID,
           FirstName,
           LastName,
           Phone,
           Email,
           Address,
           City,
           PostalCode
    from Users;
```

---

### Webinar_information
Widok przedstawia informacje o webinarach dostępnych czy nie dostępnych.
```SQL
create view webinar_information as
    select WebinarID,
           Name,
           Description,
           DateAndBeginningTime,
           Duration,
           concat(C.FirstName, ' ', C.LastName) as full_name_coordinator,
           concat(T.FirstName, ' ', T.LastName) as full_name_teacher,
           concat(isnull(Translators.FirstName, ''), ' ', isnull(Translators.LastName, '')) as full_name_translator,
           Price,
           LanguageName,
           RecordingLink,
           MeetingLink

    from Webinars inner join Employees T on Webinars.TeacherID = T.EmployeeID
    left join Employees C on C.EmployeeID = Webinars.CoordinatorID
    left join Translators on Webinars.TranslatorID = Translators.TranslatorID
    left join Languages on Webinars.LanguageID = Languages.LanguageID;
```

---