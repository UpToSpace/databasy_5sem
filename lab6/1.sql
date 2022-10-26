--1.	
select sum(value) from v$sga;

--2.	
select component, current_size from v$sga_dynamic_components;

--3.	
select component, granule_size from v$sga_dynamic_components
where current_size > 0;

--4.	
select sum(current_size) from v$sga_dynamic_free_memory;

--5.	
select component, current_size from v$sga_dynamic_components
where component like '%cache%';

--6.	
CREATE TABLE KEEP_TABLE(X INT) STORAGE(BUFFER_POOL KEEP);
INSERT INTO KEEP_TABLE VALUES (1);
SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL FROM sys.USER_SEGMENTS WHERE SEGMENT_NAME like '%KEEP_TABLE%';

drop table KEEP_TABLE;

--7.	
CREATE TABLE DEFTABLE(A INT) STORAGE(BUFFER_POOL DEFAULT);

drop table deftable;

SELECT SEGMENT_NAME, BUFFER_POOL FROM USER_SEGMENTS WHERE SEGMENT_NAME = 'DEFTABLE';

--8.	
SHOW PARAMETER LOG_BUFFER;

--9.	
select * from (select POOL, name, BYTES from V$SGASTAT where POOL = 'shared pool' 
order by bytes desc) where rownum <= 10

--10.	
select POOL, name, BYTES from V$SGASTAT where POOL = 'large pool' and name = 'free memory';

--11.	
select * from V$SESSION;

--12.	
select USERNAME, SERVER from V$SESSION;

--13.	
select owner, name, type, executions from v$db_object_cache order by executions desc;
