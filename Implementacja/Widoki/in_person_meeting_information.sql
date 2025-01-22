create view in_person_meeting_information as
    select MeetingID,
           Classroom,
           concat(FirstName, ' ', LastName) as Translator_full_name,
           LanguageName,
           Limit
    from In_person_Meetings left join Translators on In_person_Meetings.TranslatorID = Translators.TranslatorID
    left join Languages on In_person_Meetings.LanguageID = Languages.LanguageID