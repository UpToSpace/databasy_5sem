-- from pdborcl_admin

grant create tablespace to USER_PDBORCL;
grant unlimited tablespace to USER_PDBORCL;

-- from pdborcl_user

create tablespace ts1
DATAFILE 'C:\tablespaces\t1_lab16.dbf'
    SIZE 7 m
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
create tablespace ts2
DATAFILE 'C:\tablespaces\t2_lab16.dbf'
    SIZE 7 m
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
create tablespace ts3
DATAFILE 'C:\tablespaces\t3_lab16.dbf'
    SIZE 7 m
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
create tablespace ts4
DATAFILE 'C:\tablespaces\t4_lab16.dbf'
    SIZE 7 m
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
--1
    create table T_Range( id number, num number)
    partition by range(id)
    (
    Partition p1 values less than (25) tablespace ts1,
    Partition p2 values less than (50) tablespace ts2,
    Partition p3 values less than (75) tablespace ts3,
    Partition pmax values less than (maxvalue) tablespace ts4
    );
    
    insert into T_range(id, num) values(20,1);
    insert into T_range(id, num) values(37,1);
    insert into T_range(id, num) values(60,1);
    insert into T_range(id, num) values(100,1);
    
    
    select * from T_range partition(p1);
    select * from T_range partition(p2);
    select * from T_range partition(p3);
    select * from T_range partition(pmax);
    
    alter table t_range enable row movement;
    update t_range set id = 1 where id = 100;
    
--2
    create table T_Interval(id number, time_id date)
    partition by range(time_id)
    interval (interval '1' year)
    (
      partition pmin values less than  (to_date ('31-12-2019', 'dd-mm-yyyy'))
    );
    
    insert into T_Interval(id, time_id) values(1,'01-02-2008');
    insert into T_Interval(id, time_id) values(2,'01-01-2020');
    insert into T_Interval(id, time_id) values(3,'01-01-2021');
    insert into T_Interval(id, time_id) values(4,'01-01-2022');
    insert into T_Interval(id, time_id) values(5,'01-01-2016');
    
    select * from T_Interval partition(pmin);
    select * from user_tab_partitions t where t.table_name = 'T_INTERVAL';
    
    alter table T_Interval enable row movement;
    update T_Interval set time_id = '01-06-2022' where time_id = '01-01-2016';
--3
    create table T_hash (str varchar2(100), id number)
    partition by hash (str)
    (partition p1 tablespace ts1,
    partition p2 tablespace ts2,
    partition p3 tablespace ts3,
    partition p4 tablespace ts4
    );
    
    insert into T_hash (str,id) values('a', 1);
    insert into T_hash (str,id) values('b', 2);
    insert into T_hash (str,id) values('c', 3);
    insert into T_hash (str,id) values('d', 4);
    insert into T_hash (str,id) values('e', 5);
    
    select * from T_hash partition(p1);
    select * from T_hash partition(p2);
    select * from T_hash partition(p3);
    select * from T_hash partition(p4);

select * from user_tablespaces;
select * from user_tab_partitions where table_name = 'T_HASH';
select * from t_hash;

    alter table t_hash enable row movement;
    update t_hash set str = 'aaa' where str = 'a';

--4
    create table T_list(ch char(3))
    partition by list (ch)
    (
    partition p1 values ('a'),
    partition p2 values ('b'),
    partition p3 values (default)
    );
    insert into  T_list(ch) values('a' );
    insert into  T_list(ch) values('b' );
    insert into  T_list(ch) values('c' );
    insert into  T_list(ch) values('d' );
    
    select * from T_list partition (p1);
    select * from T_list partition (p2);
    select * from T_list partition (p3);
    
    alter table T_list enable row movement;
    update T_list set ch = 'l' where ch = 'a';
--5
alter table t_range merge partitions
    p1,p2 into partition p5;
    select * from T_range partition(p5);
    
--6
    create table T_list1(ch char(3));
    alter table T_list exchange partition  p2
        with table T_list1 without validation;
    select * from T_list partition (p2);
    select * from T_list1;
    
--7
    alter table t_interval split partition pmin at (to_date ('01-01-2010', 'dd-mm-yyyy')) 
    into (partition p1, partition p2);
    
    select * from t_interval partition (p1);
    select * from t_interval partition (p2);
    
    
drop table t_hash;
drop table t_interval;
drop table T_list;
drop table T_list1;
drop table t_range;