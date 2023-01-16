-- 1 sys
select tablespace_name, file_name from dba_data_files; 
select tablespace_name, file_name from dba_temp_files; 

-- 2 drop tablespace kvs_qdata;
create tablespace kvs_qdata 
datafile 'C:\tablespaces\kvs_qdata.dbf'
size 10m
extent management local
offline;

alter tablespace kvs_qdata online;
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
--drop user kvs cascade;

create user kvs identified by 12345;
grant create session,create table, create view, 
create procedure,drop any table,drop any view,
drop any procedure to kvs;

alter user kvs quota 2m on kvs_qdata;

-- kvs
create table kvs_T1(
x number(20) primary key,
y number(20)) tablespace kvs_qdata;

insert into kvs_t1 values (1, 1);
insert into kvs_t1 values (2, 2);
insert into kvs_t1 values (3, 3);
select * from kvs_t1;

-- 3--sys список сегментов табличного пространства 
select * from dba_segments where tablespace_name = 'KVS_QDATA';

-- 4 --kvs
drop table kvs_T1;

--sys
select * from dba_segments where tablespace_name = 'KVS_QDATA';

--kvs
select * from user_recyclebin;

-- 5
flashback table kvs_t1 to before drop;

select * from kvs_t1;

-- 6
begin
for x in 4..10000
loop
insert into kvs_T1 values(x, x);
end loop;
commit;
end;

select count(*) from kvs_t1;

-- 7 сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. ѕолучите перечень всех экстентов. 
select * from user_segments where tablespace_name like 'KVS_QDATA';
select extents, blocks, bytes from user_segments where tablespace_name like 'KVS_QDATA';

-- 8 --sys
drop tablespace kvs_qdata including contents and datafiles;

-- 9 
select * from v$log;

-- 10  
select * from v$logfile;

-- 11 !
alter system switch logfile;
select * from v$log;

-- 12 !
alter database add logfile group 4 'C:\app\l\oradata\orcl\REDO04.LOG' size 50m blocksize 512;
alter database add logfile member 'C:\app\l\oradata\orcl\REDO041.LOG'  to group 4;
alter database add logfile member 'C:\app\l\oradata\orcl\REDO042.LOG'  to group 4;

select * from v$logfile;

-- swith to 4th group
alter system switch logfile;
select * from v$log;

-- 13 !
alter database drop logfile member 'C:\app\l\oradata\orcl\REDO041.LOG';
alter database drop logfile member 'C:\app\l\oradata\orcl\REDO042.LOG';
alter database clear unarchived logfile group 4;
alter database drop logfile group 4;

select * from v$logfile;

-- 14 выполн€етс€ или нет архивирование 
select instance_name, archiver from v$instance;

-- 15 номер последнего архива
select * from v$archived_log;

-- 16 
-- connect / as sysdba;
-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- archive log list;
-- alter database open;

select instance_name, archiver from v$instance;

-- 17 создайте архивный файл
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 ='LOCATION=C:\app\l\oradata\orcl\archive1.arc';
alter system switch logfile;
select * from v$archived_log;
-- 18
-- alter database noarchivelog;
select instance_name, archiver from v$instance;
-- 19 
select * from v$controlfile;
-- 20
show parameter control;
-- 21 местоположение файла параметров 
select * from v$parameter where name = 'spfile';
-- 22
create pfile = 'kvs_pfile.ora' from spfile; --C:\app\l\product\12.1.0\dbhome_1\database
-- 23 местоположение файла паролей 
select * from v$pwfile_users;
-- 24 перечень директориев дл€ файлов сообщений и диагностики. 
select * from v$diag_info;
-- 25 протокола работы инстанса
-- C:\app\l\diag\rdbms\orcl\orcl\alert\log.xml