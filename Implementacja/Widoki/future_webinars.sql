create view future_webinars as
    select *
    from webinar_information
    where getdate() < DateAndBeginningTime