create view future_courses as
    select *
    from course_information
    where getdate() < StartDate