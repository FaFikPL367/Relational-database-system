CREATE view future_webinar_sign as
    select future_webinars.WebinarID, 
           Name,
           DateAndBeginningTime,
           Duration,
           count(UserID) as Total_users
    from future_webinars left join Users_Webinars on Users_Webinars.WebinarID = future_webinars.WebinarID
    group by future_webinars.WebinarID, Name, Duration, DateAndBeginningTime;