create view online_sync_meeting_information as
    select MeetingID,
           MeetingLink,
           RecordingLink,
           concat(FirstName, ' ', LastName) as translator_full_name,
           LanguageName
    from Online_Sync_Meetings left join Translators on Online_Sync_Meetings.TranslatorID = Translators.TranslatorID
    left join Languages on Online_Sync_Meetings.LanguageID = Languages.LanguageID