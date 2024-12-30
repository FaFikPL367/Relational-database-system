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