create or replace procedure list_orders(o_name offices.office%type)
as
cursor cur is select orders.order_num as num, amount as amount from orders
join salesreps on salesreps.empl_num = orders.rep
join offices on salesreps.rep_office = offices.office 
where offices.office = o_name;
one cur%rowtype;
begin
open cur;
loop
fetch cur into one;
exit when (cur%notfound);
dbms_output.put_line(one.num || ', ' || one.amount);
end loop;
exception
when others then
dbms_output.put_line(sqlerrm);
end;

begin
list_orders(22);
end;

create or replace function max_sum(o_city offices.city%type,
o_year number)
return decimal
as
ans DECIMAL(9,2);
begin
if (o_year > 2022) then
raise_application_error(-20000, 'year too big');
end if;
if (o_year < 2000) then
raise_application_error(-20000, 'year too small');
end if;
select max(orders.amount) into ans from orders 
join salesreps on salesreps.EMPL_NUM = orders.rep
join offices on salesreps.rep_office = offices.office
where offices.city = o_city 
and orders.order_date between to_date('01-01-' || o_year, 'dd-mm-yyyy') 
and to_date('31-12-' || o_year, 'dd-mm-yyyy');
return ans;
exception
when others then
dbms_output.put_line(sqlerrm);
end;

begin
dbms_output.put_line(max_sum('New York', 2008));
end;