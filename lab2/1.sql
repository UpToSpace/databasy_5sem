--1
create tablespace TS_KVS
DATAFILE 'C:\app\Tablespaces\TS_KVS.dbf'
SIZE 7 m
AUTOEXTEND ON NEXT 5 m
MAXSIZE 20 m
EXTENT MANAGEMENT LOCAL;

select tablespace_name, status, contents logging from sys.dba_tablespaces 
where tablespace_name = 'TS_KVS';

DROP TABLESPACE TS_KVS

--2
create temporary tablespace TS_KVS_TEMP
TEMPFILE 'C:\app\Tablespaces\TS_KVS_TEMP.dbf'
SIZE 5 m
AUTOEXTEND ON NEXT 3 m
MAXSIZE 30 m
EXTENT MANAGEMENT LOCAL;

select tablespace_name, status, contents logging from sys.dba_tablespaces 
where tablespace_name = 'TS_KVS_TEMP';

DROP TABLESPACE TS_KVS_TEMP


--3
select tablespace_name, status, contents logging from sys.dba_tablespaces;

--4, 5 
alter session set "_ORACLE_SCRIPT"=true;
CREATE ROLE RL_KVSCORE;
select * from dba_roles where role like 'RL%';

grant connect,
      CREATE TABLE,
      drop any table,
      CREATE VIEW,
      drop any view,
      CREATE PROCEDURE,
      DROP ANY PROCEDURE TO RL_KVSCORE;

      
select * from dba_sys_privs where grantee like '%RL%'

drop role RL_KVSCORE

--6
create profile PF_KVSCORE limit
password_life_time 180
sessions_per_user 3
failed_login_attempts 7
password_lock_time 1
password_reuse_time 10
password_grace_time default
connect_time 180
idle_time 30

SELECT * FROM DBA_PROFILES WHERE PROFILE like '%PF_KVSCORE%'

DROP PROFILE PF_KVSCORE

--7
SELECT * FROM DBA_PROFILES;
select * from dba_profiles where profile = 'DEFAULT';

--8
create user KVSCORE identified by 1234
DEFAULT TABLESPACE TS_KVS QUOTA UNLIMITED ON TS_KVS
TEMPORARY TABLESPACE TS_KVS_TEMP
PROFILE PF_KVSCORE
ACCOUNT UNLOCK
PASSWORD EXPIRE

grant RL_KVSCORE to KVSCORE

revoke RL_KVSCORE from KVSCORE

alter session set "_oracle_script"=true;
drop user KVSCORE cascade
--9 пароль 1111
--10
create table MYTABLE(a int, b int);

insert into MYTABLE values (1, 1);
insert into MYTABLE values (2, 2);

create view MYVIEW as select * from MYTABLE

select * from MYVIEW

drop table MYTABLE;
drop view MYVIEW;

--11
create tablespace KVS_QDATA
datafile 'C:\app\Tablespaces\KVS_QDATA.dbf'
size 10 M
autoextend on next 5 M
maxsize 30 M
offline;

select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES 
where tablespace_name = 'KVS_QDATA';

alter tablespace KVS_QDATA online;

alter user KVSCORE quota 2m on KVS_QDATA;

create table KVS_T1(a int) tablespace KVS_QDATA;
insert into KVS_T1 values(1);
insert into KVS_T1 values(2);
insert into KVS_T1 values(3);

select * from KVS_T1;

drop tablespace KVS_QDATA;
