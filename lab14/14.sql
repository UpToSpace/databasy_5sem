-- from system
select * from pulpit;
select * from subject;

create or replace procedure add_subject(
in_subject char,
in_subject_name varchar2,
in_pulpit char)
as
begin
insert into subject (subject, subject_name, pulpit) values (in_subject, in_subject_name, in_pulpit);
commit;
exception
  when others then
    dbms_output.put_line(sqlerrm);
end;

create or replace procedure addFaculty (facult char, fname varchar2)
as 
begin 
insert into FACULTY   (FACULTY,   FACULTY_NAME ) values  (facult,   fname);
commit;
exception
when others then
raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
end;

-- from sys
select * from all_db_links;

drop database link link1;

CREATE DATABASE LINK link1
CONNECT TO system
IDENTIFIED BY Vv1542139
USING '  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = courseProject)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = orcl)
    )
  )';
  
select * from teacher@link1;
insert into teacher@link1 values('А','Б','ОВ');
update teacher@link1 set teacher_name = 'БББ' where teacher ='А';
delete teacher@link1 where teacher ='А';

begin
SYSTEM.add_subject@link1('НПО', 'Надежность Программного Обеспечения', 'ИСиТ');
dbms_output.put_line('####################');
dbms_output.put_line(system.TEACHERS.GET_NUM_TEACHERS@link1('ТОВ'));
end; 

select * from subject@link1;

delete from subject@link1 where subject = 'НПО';
  
select * from dba_db_links;

drop public database link link2;

-- from system
CREATE PUBLIC DATABASE LINK link2
CONNECT TO system
IDENTIFIED BY Ks7631738
USING 'Kek:1521/orcl';   
 
select * from teacher@link2;
insert into teacher@link2 values('А','Б','ОВ');
update teacher@link2 set teacher_name = 'БББ' where teacher ='А';
delete teacher@link2 where teacher ='А';
begin
system.addFaculty@link2('ФИ', 'Факультет ИТ' );
--dbms_output.put_line('####################');
--dbms_output.put_line(system.TEACHERS.GET_NUM_TEACHERS@link2('ТОВ'));
end;
select * from faculty;
create table B ( a number(10), b number(10) );

insert into SED@link2 values ('aaaa', 'bbb');
update SED@link2 set FH = 'vvv' where FH = 'aaaa';
select * from B;

select * from faculty;

select * from faculty@link2;
delete from faculty@link2 where faculty = 'ФИТ';