--1
select * from v$bgprocess;

--2
SELECT * FROM V$SESSION INNER JOIN V$BGPROCESS ON V$SESSION.PADDR = V$BGPROCESS.PADDR WHERE v$session.STATUS = 'ACTIVE';

--3
SHOW PARAMETER DB_WRITER_PROCESSES;

--4
select * from v$session where username is not null;

--5
select username, server from v$session where username is not null;

--6
select * from v$services;  

--7
show parameter dispatcher;

--8
--Listener

--9
select username, server from v$session;

--10
--C:\app\user\product\12.1.0\dbhome_1\NETWORK\ADMIN

--11
--lsnrctl

--12
--services