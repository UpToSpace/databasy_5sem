--1
DROP USER U1_KVS_PDB cascade; 

ALTER DATABASE KVS_PDB OPEN;

CREATE USER U1_KVS_PDB 
    IDENTIFIED BY 1234
    default tablespace TS_KVS_PDB
    CONTAINER = CURRENT
    ACCOUNT UNLOCK;
    
GRANT CREATE SESSION TO U1_KVS_PDB;
grant create table to U1_KVS_PDB;
grant create sequence to U1_KVS_PDB;
grant create cluster to U1_KVS_PDB;
grant create synonym to U1_KVS_PDB;
grant create public synonym to U1_KVS_PDB;
GRANT CREATE VIEW TO U1_KVS_PDB;
GRANT CREATE MATERIALIZED VIEW TO U1_KVS_PDB;
alter user U1_KVS_PDB quota unlimited on users; 

SELECT * FROM USER_SYS_PRIVS;

--2
CREATE SEQUENCE S1 
INCREMENT BY 10
START WITH 1000
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE
NOORDER;

select S1.nextval from dual;
SELECT S1.CURRVAL FROM DUAL;

--3
create sequence S2
    start with 10
    increment by 10
    maxvalue 100
    nocycle;

select S2.nextval from dual;
select S2.currval from dual;

--4
CREATE SEQUENCE S3
    start with -10 --was 10
    INCREMENT by -10
    MINVALUE -100
    NOCYCLE
    ORDER;
    
SELECT S3.NEXTVAL FROM DUAL;
select S3.currval from dual;
    
--5
create sequence S4
    start WITH 1
    INCREMENT BY 1
    maxvalue 10 --was minvalue
    cycle
    CACHE 5
    noorder;
    
SELECT S4.NEXTVAL FROM DUAL;
select S4.currval from dual;

--6
SELECT * FROM SYS.ALL_SEQUENCES WHERE SEQUENCE_OWNER LIKE 'U1%';

--7
create table T1 (
        N1 NUMBER(20),
        N2 NUMBER(20),
        N3 NUMBER(20),
        N4 NUMBER(20)) cache storage(buffer_pool keep);

begin
for i in 1..7 loop
insert into T1(N1, N2, N3, N4) values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
end loop;
end;

select * from T1;

--7
create cluster ABC (
        X NUMBER(10),
        V VARCHAR2(12)) 
        HASHKEYS 200;
        
--8
create table A(XA number(10),
               VA varchar2(12), 
               AA number(10)) cluster ABC (XA, VA); 

--9 
create table B(XB number(10),
               VB varchar2(12), 
               BB number(10)) cluster ABC (XB, VB); 

--10 
create table C(XC number(10),
               VC VARCHAR2(12), 
               CC number(10)) cluster ABC (XC, VC); 

--11
SELECT * FROM USER_TABLES;
select * from user_clusters;

--12
create synonym SC for U1_KVS_PDB.C;
SELECT * FROM SC;

--13
create public synonym SB for U1_KVS_PDB.B;
select * from SB;

--14
CREATE TABLE A1(A NUMBER(10), B VARCHAR(12), CONSTRAINT a_PK PRIMARY KEY (a));
create table B1(a number(10), b varchar(12), constraint a_fk foreign key (a) references A1(a));

insert into A1 (a, b) values (3,'a');
insert into A1 (a, b) values (4,'b');

INSERT INTO B1 (a, b) VALUES (3,'c');
insert into B1 (a, b) values (4,'d');

SELECT * FROM A1;
select * from B1;
commit;
CREATE VIEW V1 AS SELECT A1.B AS A1B, B1.B AS B1B, A1.A FROM A1 INNER JOIN B1 ON A1.A=B1.A;

SELECT * FROM V1;

--15
create materialized view MV
build immediate 
refresh complete on demand next sysdate + numtodsinterval(1, 'minute') 
as SELECT A1.B AS A1B, B1.B AS B1B, A1.A FROM A1 INNER JOIN B1 ON A1.A=B1.A;

select * from MV;    

--deleting
drop materialized view MV;
drop view V1;
DROP TABLE B1;
drop table A1;
DROP PUBLIC SYNONYM SB;
DROP SYNONYM SC;
DROP TABLE C;
DROP TABLE A;
DROP TABLE B;
DROP CLUSTER ABC;
DROP TABLE T1;
DROP SEQUENCE S1;
DROP SEQUENCE S2;
drop sequence S3;
drop sequence S4;