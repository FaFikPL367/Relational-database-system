create view future_meetings as
    select *
    from meetings_information
    where getdate() < DateAndBeginningTime