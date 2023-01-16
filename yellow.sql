create or replace procedure list_all_items(
i_city offices.city%type) 
as
cursor cur is select distinct products.product_id  from products 
inner join orders on products.product_id = orders.product
inner join SALESREPS on orders.rep = SALESREPS.empl_num
inner join offices on offices.mgr = SALESREPS.EMPL_NUM 
where offices.city = i_city;
prod products.product_id%type;
begin
open cur;
loop
fetch cur into prod;
exit when cur%notfound;
dbms_output.put_line(prod);
end loop;
exception
when others then
dbms_output.put_line(sqlerrm);
end;

begin
list_all_items('New York');
end;

create or replace function num_orders(d_date date, e_date date)
return number
as
num number;
begin
select count (*) into num from orders where orders.order_date between d_date and e_date;
return num;
exception
when others then
dbms_output.put_line(sqlerrm);
end;

begin
dbms_output.put_line(num_orders('2007-12-17', '2008-02-10'));
end;

create or replace procedure list_off(i_beg date, i_end date)
as
cursor cur is select offices.city as city, sum(orders.amount) as summ from orders 
join SALESREPS on SALESREPS.EMPL_NUM = orders.rep
join offices on offices.mgr = SALESREPS.EMPL_NUM
where orders.order_date > i_beg and orders.order_date < i_end
group by offices.city order by sum(orders.amount) desc;
one cur%rowtype;
begin
open cur;
loop
fetch cur into one;
exit when cur%notfound;
dbms_output.put_line(one.city || ', ' || one.summ);
end loop;
end;

begin 
list_off('2000-12-17', '2022-01-22');
end;