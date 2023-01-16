alter session set NLS_LANGUAGE = 'RUSSIAN'  ;
select *from faculty;
select *from PULPIT;
select *from TEACHER;
select *from SUBJECT;
select *from AUDITORIUM_TYPE;
select *from AUDITORIUM;

--1
declare 
  pulpit_row pulpit%rowtype;
begin 
  select * into pulpit_row from pulpit where pulpit = 'ÈÑèÒ';
  dbms_output.put_line(pulpit_row.pulpit ||' '||pulpit_row.pulpit_name);
  exception
  when others
    then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

--2
declare 
  pulpit_row pulpit%rowtype;
begin 
  select * into pulpit_row from pulpit;
  dbms_output.put_line(pulpit_row.pulpit ||' '||pulpit_row.pulpit_name);
  exception
  when others
    then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

--3
declare 
  pulpit_row pulpit%rowtype;
begin 
  select * into pulpit_row from pulpit;
  dbms_output.put_line(pulpit_row.pulpit ||' '||pulpit_row.pulpit_name);
  exception
  when too_many_rows
    then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

--4
declare 
  pulpit_row pulpit%rowtype;
  b boolean;
begin 
  select * into pulpit_row from pulpit where pulpit = 'ÏÎÈÒ';
  dbms_output.put_line(pulpit_row.pulpit ||' '||pulpit_row.pulpit_name);
  exception
  when no_data_found    
    then dbms_output.put_line(sqlcode||' '||sqlerrm);
        b := sql%notfound;
    if b then dbms_output.put_line('rows not found');
    else dbms_output.put_line('rows found');
    end if;
end;

--5
select * from TEACHER where TEACHER = 'ÓÐÁ';

BEGIN
update TEACHER set TEACHER_NAME = 'Óðáàíîâè÷ Ïàâåë Ïàâëîâè÷÷' where TEACHER = 'ÓÐÁ';
 commit;
-- rollback;
EXCEPTION
when others
then
SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || ' msg oracle: ' || sqlerrm);
END;

--6
BEGIN
update TEACHER set PULPIT = 'ÏÎÈÒ' where teacher = 'ÓÐÁ';
 commit;
-- rollback;
EXCEPTION
when others
then
SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || ' msg oracle: ' || sqlerrm);
END;

--7
BEGIN
insert into TEACHER values ('ÏÖÉ', 'Ïàöåé Íàòàëüÿ Âëàäèìèðîâíà', 'ÈÑèÒ');
--commit;
rollback;
EXCEPTION
when others
then
SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || ' msg oracle: ' || sqlerrm);
END;

select * from TEACHER;

--8
BEGIN
insert into TEACHER values ('ÏÖ', 'Ïàöåé Íàòàëüÿ Âëàäèìèðîâíà', 'ÏÎÈÒ');
--commit;
rollback;
EXCEPTION
when others
then
SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || ' msg oracle: ' || sqlerrm);
END;

--9
select * from TEACHER where TEACHER = 'ÓÐÁ';

BEGIN
delete TEACHER where TEACHER = 'ÓÐÁ';
commit;
--rollback;
EXCEPTION
when others
then
SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || ' msg oracle: ' || sqlerrm);
END;

--10
BEGIN
delete from PULPIT where pulpit = 'ÈÑèÒ';
-- commit;
rollback;
EXCEPTION
when others
then
SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || ' msg oracle: ' || sqlerrm);
END;

--11 show
declare 
    cursor curs_teachers is select teacher, teacher_name, pulpit from teacher;
    m_teacher   teacher.teacher%type;
    m_teacher_name   teacher.teacher_name%type;
    m_pulpit   teacher.pulpit%type;
begin
    open curs_teachers;
    loop
    fetch curs_teachers into m_teacher, m_teacher_name, m_pulpit;
    exit when curs_teachers%notfound;
    dbms_output.put_line(' ' || curs_teachers%rowcount || ' ' || m_teacher || ' ' || m_teacher_name || 
                        ' ' || m_pulpit);
    end loop;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    close curs_teachers;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);    
end;

--12
declare 
    cursor curs_subject is select * from subject;
    rec_subject subject%rowtype;
begin
    open curs_subject;
    dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
    fetch curs_subject into rec_subject;
    while curs_subject%found
    loop
    dbms_output.put_line(' ' || curs_subject%rowcount || ' ' || rec_subject.subject || ' ' ||
                        rec_subject.subject_name || ' ' || rec_subject.pulpit);
    fetch curs_subject into rec_subject;
    end loop;
    dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
    close curs_subject;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);   
end;

--13
declare
  cursor curs_pulpit is select pulpit.pulpit, teacher.teacher_name
  from pulpit inner join teacher on pulpit.pulpit=teacher.pulpit;
  rec curs_pulpit%rowtype;
begin
    for rec in curs_pulpit
    loop
        dbms_output.put_line(curs_pulpit%rowcount||' '||rec.teacher_name||' '||rec.pulpit);
    end loop;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm); 
end;

--14
declare 
    cursor curs (capacity auditorium.auditorium_capacity%type, capacity1 auditorium.auditorium_capacity%type)
        is select auditorium, auditorium_capacity, auditorium_type
        from auditorium
        where auditorium_capacity >= capacity and auditorium_capacity <= capacity1;
begin
    dbms_output.put_line('capacity < 20 :');
    for aum in curs(0,20)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('21 < capacity < 30 :');
    for aum in curs(21,30)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('31 < capacity < 60 :');
    for aum in curs(31,60)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('61 < capacity < 80 :');
    for aum in curs(61,80)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('81 < capacity:');
    for aum in curs(81,1000)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

--15
DECLARE
     type auditorium_cursor_type is ref cursor
         return AUDITORIUM % rowtype;
     c_auditorium  auditorium_cursor_type;
     row_auditorium c_auditorium % rowtype;
BEGIN
    open c_auditorium for select * from AUDITORIUM;

    fetch c_auditorium into row_auditorium;

    while (c_auditorium % found)
    loop
        SYS.DBMS_OUTPUT.PUT_LINE(
            row_auditorium.AUDITORIUM ||' '||
            row_auditorium.AUDITORIUM_NAME ||' '||
            row_auditorium.AUDITORIUM_CAPACITY
            );
           fetch c_auditorium into row_auditorium;
    end loop;

    close c_auditorium;
EXCEPTION
    when others
        then
            SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || ' msg oracle: ' || sqlerrm);
END;

--16
declare 
  cursor curs_aut is select auditorium_type,
      cursor (select auditorium from auditorium aum
          where aut.auditorium_type = aum.auditorium_type)
      from auditorium_type aut;
  curs_aum sys_refcursor;
  aut auditorium_type.auditorium_type%type;
  txt varchar2(1000);
  aum auditorium.auditorium%type;
begin
  open curs_aut;
   fetch curs_aut into aut, curs_aum;
   while(curs_aut%found)
      loop
        txt:=rtrim(aut)||':';
        loop
          fetch curs_aum into aum;
          exit when curs_aum%notfound;
          txt := txt||','||rtrim(aum);
        end loop;
        dbms_output.put_line(txt);
        fetch curs_aut into aut, curs_aum;
      end loop;
  close curs_aut;
  exception
  when others
      then dbms_output.put_line(sqlerrm);
end;

--17
declare 
  cursor curs_auditorium(capacity auditorium.auditorium%type, capac auditorium.auditorium%type)
    is select auditorium, auditorium_capacity
      from auditorium
      where auditorium_capacity >=capacity and AUDITORIUM_CAPACITY <= capac for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  open curs_auditorium(40,80);
  fetch curs_auditorium into aum, cty;
  while(curs_auditorium%found)
    loop
      cty := cty * 0.9;
      update auditorium
      set auditorium_capacity = cty
      where current of curs_auditorium;
      dbms_output.put_line(' '||aum||' '||cty);
      fetch curs_auditorium into aum, cty;
    end loop;
  close curs_auditorium;
  --rollback;
  commit;
  exception
  when others
    then dbms_output.put_line(sqlerrm);
end;

--18
declare 
  cursor cur(cap auditorium.auditorium_capacity%type,cap1 auditorium.auditorium_capacity%type)
  is select auditorium, auditorium_capacity from auditorium
  where auditorium_capacity between cap and cap1 for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin
  open cur(0,20);
  fetch cur into aum, cap;
  while(cur%found)
      loop
          delete auditorium where current of cur;
          fetch cur into aum, cap;
      end loop;
  close cur;
      
  for a in cur(0,120) loop
     dbms_output.put_line(a.auditorium||' '||a.auditorium_capacity);
  end loop; 
  rollback;
end;

--19
declare 
cursor cur(capacity auditorium.auditorium%type) 
is select auditorium, auditorium_capacity, rowid 
from auditorium where auditorium_capacity >=capacity for update; 
aum auditorium.auditorium%type; 
cap auditorium.auditorium_capacity%type; 
begin 
for xxx in cur(80) 
 loop 
  if xxx.auditorium_capacity >= 90 
   then delete auditorium  
   where rowid = xxx.rowid and xxx.auditorium_capacity >= 90; 
  elsif xxx.auditorium_capacity >= 40 
   then update auditorium 
   set auditorium_capacity = auditorium_capacity + 3 
   where rowid = xxx.rowid; 
  end if; 
 end loop; 
for yyy in cur(20) 
 loop 
  dbms_output.put_line(yyy.auditorium||' '||yyy.auditorium_capacity); 
 end loop;  
rollback; 
end;

--20--show
declare 
    cursor curs_teachers is select teacher, teacher_name, pulpit from teacher;
    m_teacher   teacher.teacher%type;
    m_teacher_name   teacher.teacher_name%type;
    m_pulpit   teacher.pulpit%type;
begin
    open curs_teachers;
    loop
    fetch curs_teachers into m_teacher, m_teacher_name, m_pulpit;
    exit when curs_teachers%notfound;
    dbms_output.put_line(' ' || curs_teachers%rowcount || ' ' || m_teacher || ' ' || m_teacher_name || 
                        ' ' || m_pulpit);
    if (mod(curs_teachers%rowcount, 3) = 0) then dbms_output.put_line('-----------------------');
    end if;
    end loop;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    close curs_teachers;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);    
end;