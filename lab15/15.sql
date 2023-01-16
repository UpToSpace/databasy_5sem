grant create trigger to U1_KVS_PDB;

-- from user_pdb
-- drop table my;
create table my(
a number(10) primary key,
b number(10),
c varchar2(50)
);

begin
for i in 1 .. 10
loop
insert into my values (i, i + i, 'i' || i);
end loop;
end;

select * from my;

--1 drop trigger before_operation_trigger;
create or replace trigger before_operation_trigger
before insert or update or delete on my
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('before_trigger on inserted');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('before_trigger on updated');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('before_trigger on deleted');
    end if;
end;

select * from my;
insert into my values (100, 200, 'i100');
update my set b = 99 where a > 9;
delete my where b = 99;

--2 drop trigger before_row_trigger;
create or replace trigger before_row_trigger
before insert or update or delete on my  
for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('before_row_trigger on inserted');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('before_row_trigger on updated');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('before_row_trigger on deleted');
    end if;
end;

select * from my;
insert into my values (10, 20, 'i10');
insert into my values (100, 200, 'i100');
update my set b = 99 where a > 9;
delete my where b = 99;

--3 drop trigger after_operator_trigger;
create or replace trigger after_operator_trigger
after insert or update or delete on my
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('after_operator_trigger on inserted');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('after_operator_trigger on updated');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('after_operator_trigger on deleted');
    end if;
end;

select * from my;
insert into my values (10, 20, 'i10');
insert into my values (100, 200, 'i100');
update my set b = 99 where a > 9;
delete my where b = 99;

--4 drop trigger after_row_trigger;
create or replace trigger after_row_trigger
after insert or update or delete on my  
for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('after_row_trigger on inserted');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('after_row_trigger on updated');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('after_row_trigger on deleted');
    end if;
end;

select * from my;
insert into my values (10, 20, 'i10');
insert into my values (100, 200, 'i100');
update my set b = 99 where a > 9;
delete my where b = 99;

--5
create table audits(
OperationDate date,
OperationType varchar2(10),
TriggerName varchar2(25),
Data varchar2(50)
);

select * from audits;
-- drop table audits;

create or replace trigger before_operation_trigger
before insert or update or delete on my
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('before_trigger on inserted');
    insert into audits values(sysdate, 'insert', 'before_operation_trigger', 'no data');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('before_trigger on updated');
    insert into audits values(sysdate, 'update', 'before_operation_trigger', 'no data');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('before_trigger on deleted');
    insert into audits values(sysdate, 'delete', 'before_operation_trigger', 'no data');
    end if;
end;

create or replace trigger before_row_trigger
before insert or update or delete on my  
for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('before_row_trigger on inserted');
    insert into audits values(sysdate, 'insert', 'before_row_trigger', 'new: ' || :new.a || '; '|| :new.b || '; '|| :new.c);
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('before_row_trigger on updated');
        insert into audits values(sysdate, 'update', 'before_row_trigger', 'old: '||:old.a|| '; ' ||:old.b|| '; '|| :old.c || 'new: ' || :new.a || '; '|| :new.b || '; '|| :new.c);
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('before_row_trigger on deleted');
        insert into audits values(sysdate, 'delete', 'before_row_trigger', 'old: '||:old.a|| '; ' ||:old.b|| '; '|| :old.c);
    end if;
end;

create or replace trigger after_operator_trigger
after insert or update or delete on my
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('after_operator_trigger on inserted');
    insert into audits values(sysdate, 'insert', 'after_operator_trigger', 'no data');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('after_operator_trigger on updated');
    insert into audits values(sysdate, 'update', 'after_operator_trigger', 'no data');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('after_operator_trigger on deleted');
    insert into audits values(sysdate, 'delete', 'after_operator_trigger', 'no data');
    end if;
end;

create or replace trigger after_row_trigger
after insert or update or delete on my  
for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('after_row_trigger on inserted');
    insert into audits values(sysdate, 'insert', 'after_row_trigger', 'new: ' || :new.a || '; '|| :new.b || '; '|| :new.c);
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('after_row_trigger on updated');
     insert into audits values(sysdate, 'update', 'after_row_trigger', 'old: '||:old.a|| '; ' ||:old.b|| '; '|| :old.c || 'new: ' || :new.a || '; '|| :new.b || '; '|| :new.c);
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('after_row_trigger on deleted');
     insert into audits values(sysdate, 'delete', 'after_row_trigger', 'old: '||:old.a|| '; ' ||:old.b|| '; '|| :old.c);
    end if;
end;

select * from audits;

select * from my;
insert into my values (10, 20, 'i10');
insert into my values (100, 200, 'i100');
update my set b = 99 where a > 9;
delete my where b = 99;

-- 6
insert into my values (1, 2, 'i1');

--7
create or replace trigger disable_drop
before drop on u1_kvs_pdb.SCHEMA
begin
if dictionary_obj_name = 'MY' then 
raise_application_error(-20000, 'cannot drop');
end if;
end;

drop table my;
--drop trigger disable_drop;

--8
drop table audits;

--9
create view myview as SELECT * FROM my;
    
CREATE OR REPLACE TRIGGER myview_trigger
instead of insert on myview
BEGIN
if inserting then
dbms_output.put_line('insert');
insert into my VALUES (97, 94, 'i94');
end if;
END myview_trigger;
    
INSERT INTO myview values(1000, 2000, 'i1000');
SELECT * FROM my;

-- drop view myview;