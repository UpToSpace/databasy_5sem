grant create job to lera;
create table t_from(a number(5), b varchar2(50));
create table t_to(a number(5), b varchar2(50));
create table report(status varchar(50), message varchar2(150));

begin
for i in 1 .. 20
loop
insert into t_from values(i, 'str' || i);
end loop;
end;

select * from t_from;

create or replace package my_pack
as
procedure copy_table_job;
procedure my_job;
procedure is_executing;
procedure stop_executing;
procedure set_date(newDate date);
procedure delete_job;
end;

create or replace package body my_pack 
as
procedure copy_table_job
is
cursor cur is select * from t_from;
one_row cur%rowtype;
row_count number;
begin
select count(*) into row_count from t_from;
if (row_count < 3) then
raise_application_error(-20000, 'theres no data');
end if;
for i in 0 .. 3
loop
fetch cur into one_row;
insert into t_to values one_row;
delete from t_from where t_from.a = one_row.a and t_from.b = one_row.b;
end loop;
insert into report values('success', 'inserted');
exception
when others
then
dbms_output.put_line(sqlcode || sqlerrm);
insert into report values('fail', 'not inserted');
end;

procedure my_job 
as
begin
sys.dbms_job.isubmit(
job => 1,
what => 'begin copy_table_job(); end;',
next_date => trunc(sysdate+7) + 3 / 24,
interval => 'trunc(sysdate + 7) + 60/86400');
commit;
end;

procedure is_executing is
cur_job user_jobs.what % type;
begin
select (select what from user_jobs 
where what = 'begin copy_table_job(); end;' and user_jobs.broken = 'N')
into cur_job from dual;
if cur_job is not null then
DBMS_OUTPUT.PUT_LINE('executing');
else
DBMS_OUTPUT.PUT_LINE('not executing');
end if;
end;

procedure stop_executing
as
begin
dbms_job.broken(1, TRUE);
commit;
end;

procedure set_date(newDate date) as
begin
DBMS_JOB.change(job => 1,
what => 'begin copy_table_job(); end;',
next_date => newDate,
interval =>'trunc(sysdate + 7) + 15*60*60/86400');
commit;
end;

procedure delete_job as
begin
dbms_job.remove(1);
commit;
end;

end;

select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;

begin
my_pack.my_job();
end;
begin
dbms_job.run(1);
end;
begin
my_pack.is_executing();
end;
begin
my_pack.stop_executing();
end;
begin
my_pack.set_date(sysdate);
end;
begin
my_pack.delete_job();
end;

create or replace package my_pack1
as
procedure copy_table_job;
procedure my_job;
procedure is_executing;
procedure stop_executing;
procedure set_date(newDate date);
procedure delete_job;
end;

create or replace package body my_pack1 
as
procedure copy_table_job
is
cursor cur is select * from t_from;
one_row cur%rowtype;
row_count number;
begin
select count(*) into row_count from t_from;
if (row_count < 3) then
raise_application_error(-20000, 'theres no data');
end if;
for i in 0 .. 3
loop
fetch cur into one_row;
insert into t_to values one_row;
delete from t_from where t_from.a = one_row.a and t_from.b = one_row.b;
end loop;
insert into report values('success', 'inserted');
exception
when others
then
dbms_output.put_line(sqlcode || sqlerrm);
insert into report values('fail', 'not inserted');
end;

procedure my_job 
as
begin
        dbms_scheduler.create_schedule(
                schedule_name => 'my_schedule',
                start_date => sysdate,
                repeat_interval => 'FREQ=WEEKLY;'
            );
        dbms_scheduler.create_program(
                program_name => 'my_program',
                program_type => 'STORED_PROCEDURE',
                program_action => 'my_pack1.copy_table_job',
                number_of_arguments => 0,
                enabled => true
            );
        dbms_scheduler.create_job(
                job_name =>'my_job',
                program_name => 'my_program',
                SCHEDULE_NAME => 'my_schedule',
                ENABLED => true
            );
end;

procedure is_executing is
cur_job varchar2(100);
begin
select (select job_name from all_scheduler_jobs where job_name = 'MY_JOB' and ENABLED = 'TRUE')
into cur_job from dual;
if cur_job is not null then
DBMS_OUTPUT.PUT_LINE('executing');
else
DBMS_OUTPUT.PUT_LINE('not executing');
end if;
end;

procedure stop_executing
as
begin
DBMS_SCHEDULER.disable('MY_JOB');
commit;
end;

procedure set_date(newDate date) as
begin
DBMS_SCHEDULER.SET_ATTRIBUTE(
name => 'MY_SCHEDULE',
attribute => 'start_date',
value => newDate
);
end;

procedure delete_job as
begin
DBMS_SCHEDULER.DROP_JOB(job_name => 'my_job');
DBMS_SCHEDULER.DROP_SCHEDULE(schedule_name => 'my_schedule');
DBMS_SCHEDULER.DROP_PROGRAM(program_name => 'my_program');
commit;
end;

end;

select * from all_scheduler_jobs;

begin
my_pack1.my_job();
end;
begin
my_pack1.is_executing();
end;
begin
my_pack1.stop_executing();
end;
begin
my_pack1.set_date(sysdate);
end;
begin
my_pack1.delete_job();
end;