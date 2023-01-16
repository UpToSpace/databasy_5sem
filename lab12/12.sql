alter database pdborcl open;
CREATE USER USER_PDBORCL 
    IDENTIFIED BY 1234
    CONTAINER = CURRENT
    ACCOUNT UNLOCK;

grant create session to USER_PDBORCL;
grant alter any table to USER_PDBORCL;
grant create table to USER_PDBORCL;
grant select any table to USER_PDBORCL;
--grant create any cursor to USER_PDBORCL;
grant create view to USER_PDBORCL;
--grant create record to USER_PDBORCL;
alter user USER_PDBORCL quota unlimited on users;
commit;

select * from user_sys_privs;

--1 (pdb user)
select * from teacher;

alter table teacher add (birthday date, salary int);

update teacher set birthday = to_date('19.12.1996', 'DD.MM.YYYY'),
                    salary = 1000
                    where pulpit like '%ИСиТ%';

update teacher set birthday = to_date('18.07.1990', 'DD.MM.YYYY'),
                    salary = 100000
                    where pulpit like '%ПОиСОИ%';

update teacher set birthday = to_date('21.07.2003', 'DD.MM.YYYY'),
                    salary = 100
                    where pulpit like 'О%';
                    
update teacher set birthday = to_date('27.01.1992', 'DD.MM.YYYY'),
                    salary = 13
                    where pulpit like 'Л%';

update teacher set birthday = to_date('17.12.1968', 'DD.MM.YYYY'),
                    salary = 17
                    where pulpit like 'Т%';

update teacher set birthday = to_date('17.12.1994', 'DD.MM.YYYY'),
                    salary = 176
                    where birthday is null;
commit;

--2
select * from teacher;

select teacher_name from TEACHER; 
 
select substr(teacher_name, 1, regexp_instr(teacher_name, '\s', 1) + 1)||'. '|| 
       substr(regexp_substr(teacher_name,'\s\S', 1, 2), 2, 1)||'. '  
from teacher; 
 
--3
select * from teacher where TO_CHAR((birthday), 'd') = 2; 
 
--4 
create view NextMonthBirth  
as  
select * from TEACHER  
where to_char(BIRTHDAY,'Month') = to_char(sysdate + 30,'Month'); 
 
select * from NextMonthBirth; 
-- drop view NextMonthBirth; 
 
--5 
create view count_birth_teachers  
as  
select to_char(birthday, 'Month')месяц , count(*) количество 
from teacher 
group by to_char(birthday, 'Month'); 
 
select * from count_birth_teachers; 
-- drop view count_birth_teachers; 
 
--6
cursor TeacherBirtday(teacher%rowtype) return teacher%rowtype  
is 
select * from teacher 
where MOD((TO_CHAR(sysdate,'yyyy') - TO_CHAR(birthday, 'yyyy')+1), 5)=0; 
 
--7 
cursor Salary(teacher%rowtype) return salary%type  
is 
select pulpit,floor(avg(salary))  
from teacher 
group by pulpit; 
 
cursor Salary(teacher%rowtype) return salary%type  
is 
select P.faculty,floor(avg(salary))  
from teacher T inner join pulpit P on T.pulpit = P.pulpit 
group by P.faculty ;
 
cursor Salary(teacher%rowtype) return salary%type  
is 
select floor(avg(salary)) from teacher; 
 
--8 
declare 
type contacts is record( email VARCHAR2(50), phone number(13)); 
type person is record(name teacher.teacher_name%type, pulpit teacher.pulpit%type, contact contacts); 
per1 PERSON; 
begin 
per1.name:= 'dszfsd'; 
per1.pulpit:='FIT'; 
per1.contact.email := 'isjdk@mail.ru'; 
per1.contact.phone := 5562564; 
dbms_output.put_line( per1.name||' '|| per1.pulpit||' '|| per1.contact.email||'  '|| per1.contact.phone); 
end;
      
      
      
      
      
      