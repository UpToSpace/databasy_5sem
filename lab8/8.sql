--before
DROP USER U1_KVS_PDB CASCADE;
drop table mytable;

create user u1_kvs_pdb 
    IDENTIFIED BY 1234
    CONTAINER = CURRENT
    ACCOUNT UNLOCK;
    
GRANT CREATE SESSION TO U1_KVS_PDB;
GRANT CREATE TABLE TO U1_KVS_PDB;
grant create view to U1_KVS_PDB;
GRANT UNLIMITED TABLESPACE TO U1_KVS_PDB;
commit;

CREATE TABLE MYTABLE(A INT);
INSERT INTO MYTABLE VALUES(1);
COMMIT;

--1
--C:\app\user\product\12.1.0\dbhome_1\NETWORK\ADMIN

--2 sqlplus system/Vv1542139
show parameter instance;

--3 (sqlplus pdb) conn system/Vv1542139@localhost:1521/KVS_PDB; 

select * from v$tablespace;
select * from sys.dba_data_files; --- показать
select * from dba_role_privs;
select * from all_users;

--4 regedit HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE

--5 Oracle Net Manager U1_KVS_PDB_KVS_PDB
ALTER DATABASE KVS_PDB OPEN;

--6 sqlplus
-- connect U1_KVS_PDB/1234@U1_KVS_PDB_KVS_PDB

--7 select * from mytable;

--8 help timing
--Timi start
--Set timi on
--select * from mytable;
--SET TIMI OFF
--Timi stop

--9 help describe
-- describe mytable


--10
-- select * from user_segments;

--11
create or replace view task11 as
select count(*) as count,
    count(extents) as count_extents,
    count(blocks) as count_blocks,
    sum(bytes) as bytes from user_segments;
    
select * from task11;

select * from dictionary;
