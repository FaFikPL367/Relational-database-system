create index Meetings_teacherID on Meetings (TeacherID);
create index Meetings_subjectID on Meetings (SubjectID);
create index Meetings_typeID on Meetings (TypeID);
create index Meetings_date on Meetings (DateAndBeginningTime, Duration);