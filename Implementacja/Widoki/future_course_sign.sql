create view future_course_sign as
    select future_courses.CourseID, count(UserID) as Total_users
    from future_courses inner join Users_Courses on Users_Courses.CourseID = future_courses.CourseID
    group by future_courses.CourseID;