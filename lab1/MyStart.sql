create table KVS_t(x number(3) primary key, s varchar(50));

insert into kvs_t values (200, 'hello');
insert into kvs_t values (300, 'how r u');
insert into kvs_t values (400, 'goodbye');
insert into kvs_t values (500, 'hey');
insert into kvs_t values (600, 'whats up');
insert into kvs_t values (700, 'bye');

commit;
select * from kvs_t;

update kvs_t set x=100 where x=200;
update kvs_t set x=200 where x=300;
commit;
select * from kvs_t;

select sum(x) from kvs_t;
select * from kvs_t where s = 'hello';

delete from kvs_t where x = 200;
commit;

create table KVS_t1(
y number(3), c varchar(50),
constraint kvs_tykey foreign key (y) references kvs_t(x));

insert into kvs_t1 values (100, 'greeting');
insert into kvs_t1 values (400, 'farewell');
commit;
select * from kvs_t1;

select * from kvs_t inner join kvs_t1 on kvs_t.x = kvs_t1.y;
select * from kvs_t left join kvs_t1 on kvs_t.x = kvs_t1.y;
select * from kvs_t right join kvs_t1 on kvs_t.x = kvs_t1.y;

drop table kvs_t;
drop table kvs_t1;