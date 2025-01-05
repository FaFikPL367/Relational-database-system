create index Courses_coordinatorID on Courses (CoordinatorID);

create index idx_course_startdate on Courses (StartDate);
create index idx_course_enddate on Courses (EndDate);
create index idx_course_totaldate on Courses (StartDate, EndDate);