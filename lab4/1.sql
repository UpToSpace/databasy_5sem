--1
select * from v$pdbs

--2
select * from v$instance

--3
select * from product_component_version

--4
--ORACLE DATABASE CONFIGURATION ASSISTANT KVS_PDB
ALTER PLUGGABLE DATABASE KVS_PDB OPEN;

--5
select * from v$pdbs

--6 create admin!
create tablespace TS_KVS_PDB 
    datafile 'C:\tablespaces\ts_kvs_pdb.dbf'
    size 7 m
    autoextend on next 5 m
    maxsize 20 m
    extent management local;
    
create temporary tablespace TS_KVS_PDB_TEMP
    tempfile 'C:\tablespaces\ts_kvs_pdb_temp.dbf'
    size 5 m
    autoextend on next 3 m
    maxsize 30 m
    extent management local;
    
select tablespace_name, status, 
    contents logging 
    from sys.dba_tablespaces;
    
alter session set "_ORACLE_SCRIPT"=true;

alter session set container=KVS_PDB; 

CREATE ROLE RL_KVS_PDB CONTAINER = CURRENT; 

drop role RL_KVS_PDB;

grant connect,
    create table,
    drop any table,
    create view,
    drop any view,
    create procedure, 
    drop any procedure
    TO RL_KVS_PDB;
    
create profile pf_kvs_pdb limit --------------------------
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default 
    connect_time 180
    IDLE_TIME 30
    container = current;
commit;

drop profile pf_kvs_pdb

create user u1_kvs_pdb 
    IDENTIFIED BY 1234
    --default tablespace ts_kvs_pdb quota unlimited on ts_kvs_pdb
    --temporary tablespace ts_kvs_pdb_temp
    --PROFILE PF_KVS_PDB
    container = current
    ACCOUNT UNLOCK;
    
drop user u1_kvs_pdb; 
    
grant rl_kvs_pdb to u1_kvs_pdb;

--7 connect u1_kvs_pdb developer ------------------------
create table KVS_TABLE(a int, b int);

INSERT INTO KVS_TABLE VALUES (1, 1);
INSERT INTO KVS_TABLE VALUES (2, 2);
select * from kvs_table;

--8
select * from ALL_USERS;  
select * from DBA_TABLESPACES;  
select * from DBA_DATA_FILES;  
select * from DBA_TEMP_FILES; 
select * from DBA_ROLES; 
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS; 
SELECT * FROM DBA_PROFILES; 

--9
CREATE USER C##KVS IDENTIFIED BY 1234;
grant create session to c##kvs;

grant create session to c##kvs;

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'C##KVS';

--10
drop user C##kvs

