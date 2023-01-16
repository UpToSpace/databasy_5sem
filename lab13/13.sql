grant create procedure to USER_PDBORCL;

select * from teacher;
--1
declare
procedure GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
is
  cursor cur_teachers is select * from teacher where pulpit = pcode;
  row_teacher teacher%rowtype;
begin
  open cur_teachers;
  loop
    fetch cur_teachers into row_teacher;
    exit when cur_teachers%notfound;
    dbms_output.put_line(row_teacher.teacher_name||' '||row_teacher.pulpit);
  end loop;
  close cur_teachers;
end GET_TEACHERS;
begin
  get_teachers('ศั่า');
end;

--2
declare
function GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
is
  count_teachers number;
begin
  select count(*) into count_teachers from teacher where pulpit = pcode;
  return count_teachers;
end GET_NUM_TEACHERS;
begin
  dbms_output.put_line('count '||get_num_teachers('ศั่า'));
end;

--3
select * from faculty;

create or replace procedure GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
is
  cursor cur_teachers is select teacher.teacher_name, teacher.pulpit from teacher
  inner join pulpit on pulpit.pulpit = teacher.pulpit 
  where pulpit.faculty = fcode;
  
  row_teacher cur_teachers%rowtype;
begin
  open cur_teachers;
  loop
    fetch cur_teachers into row_teacher;
    exit when cur_teachers%notfound;
    dbms_output.put_line(row_teacher.teacher_name||' '||row_teacher.pulpit);
  end loop;
  close cur_teachers;
end;

begin
  get_teachers('าฮย');
end;  

create or replace procedure GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
is
  cursor cur_subject is select * from subject where pulpit = pcode;
  one_subject cur_subject%rowtype;
begin 
  open cur_subject;
  loop
    fetch cur_subject into one_subject;
    exit when cur_subject%notfound;
    dbms_output.put_line(one_subject.subject_name||' '||one_subject.pulpit);
  end loop;
  close cur_subject;
end;

begin
  get_subjects('ศั่า');
end;

--4
declare
function GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
is
  count_teachers number;
begin
  select count(*) into count_teachers from teacher
  inner join pulpit on teacher.pulpit = pulpit.pulpit 
  where pulpit.faculty = fcode;
  return count_teachers;
end;
begin
  dbms_output.put_line('count of teachers '||GET_NUM_TEACHERS('าฮย'));
end; 

declare
function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
is
  count_subjects number;
begin
  select count(*) into count_subjects from subject where subject.pulpit = pcode;
  return count_subjects;
end;
begin
  dbms_output.put_line('count of subjects '||get_num_subjects('ศั่า'));
end;

--5

create or replace package TEACHERS as
  PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE);
  PROCEDURE GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE);
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER;
  FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
end TEACHERS;

create or replace package body TEACHERS as

procedure GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
is
  cursor cur_teachers is select * from teacher where pulpit = pcode;
  row_teacher teacher%rowtype;
begin
  open cur_teachers;
  loop
    fetch cur_teachers into row_teacher;
    exit when cur_teachers%notfound;
    dbms_output.put_line(row_teacher.teacher_name||' '||row_teacher.pulpit);
  end loop;
  close cur_teachers;
end;

function GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
is
  count_teachers number;
begin
  select count(*) into count_teachers from teacher where pulpit = pcode;
  return count_teachers;
end;

procedure GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
is
  cursor cur_teachers is select teacher.teacher_name, teacher.pulpit from teacher
  inner join pulpit on pulpit.pulpit = teacher.pulpit 
  where pulpit.faculty = fcode;
  
  row_teacher cur_teachers%rowtype;
begin
  open cur_teachers;
  loop
    fetch cur_teachers into row_teacher;
    exit when cur_teachers%notfound;
    dbms_output.put_line(row_teacher.teacher_name||' '||row_teacher.pulpit);
  end loop;
  close cur_teachers;
end;

procedure GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
is
  cursor cur_subject is select * from subject where pulpit = pcode;
  one_subject cur_subject%rowtype;
begin 
  open cur_subject;
  loop
    fetch cur_subject into one_subject;
    exit when cur_subject%notfound;
    dbms_output.put_line(one_subject.subject_name||' '||one_subject.pulpit);
  end loop;
  close cur_subject;
end;

function GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
is
  count_teachers number;
begin
  select count(*) into count_teachers from teacher
  inner join pulpit on teacher.pulpit = pulpit.pulpit 
  where pulpit.faculty = fcode;
  return count_teachers;
end;

function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
is
  count_subjects number;
begin
  select count(*) into count_subjects from subject where subject.pulpit = pcode;
  return count_subjects;
end;

END TEACHERS;

--6
begin
  teachers.get_teachers('าฮย');
end;
