--1
BEGIN
NULL;
END;

--2
DECLARE 
    x char(20) :=  'Hello world!';
begin
    dbms_output.put_line(x);
end;

--3
DECLARE 
    z number (1, 0);
begin 
    Z := 5 / 0;
    dbms_output.put_line('z = '|| Z);
EXCEPTION
    WHEN OTHERS
    THEN DBMS_OUTPUT.PUT_LINE('errcode = ' || SQLCODE|| '; errmsg = ' || SQLERRM);
end;

--4
DECLARE 
    Z NUMBER(1, 0) := 5;
    begin
        DECLARE 
        z number (1, 0);
    begin 
        Z := 5 / 0;
        dbms_output.put_line('z = '|| Z);
    EXCEPTION
        WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('errcode = ' || SQLCODE|| '; errmsg = ' || SQLERRM);
    end;
    DBMS_OUTPUT.PUT_LINE('z = ' || Z);
end;

--5
select name, value from v$parameter where name = 'plsql_warnings';

--6
select keyword from v$reserved_words where length = 1 and keyword != 'A';

--7
select keyword from v$reserved_words where length > 1 and keyword !='A' order by keyword;

--8
select name,value from v$parameter where name like 'plsql%';
--in sqlplus: show parameter plsql;

--9
declare
--10
    x number(10);
    z number(10) := 5;
--12
    d number (5, 2);
    d1 number (3,2) := 2.33;
--13
    o1 number(4, -1);
    o number(5, -2) := 12235.567;
--14
    bf binary_float := 123456789.12345678911;
--15
    bd binary_double := 123456789.12345678911;
--16
    ne number(15,10) := 12345E-10;
--17
    boo boolean := true;
begin 
--11
    d := 1.33;
    dbms_output.put_line('-=-=-=-= 10 -=-=-==-=--=');
    x := 7;    
    dbms_output.put_line('x = '||x);
    dbms_output.put_line('z = '||z);
    dbms_output.put_line('-=-=-=-= 11 -=-=-==-=--=');
    dbms_output.put_line('sum : z + x = '||(z+x));
    dbms_output.put_line('minus : z - x = '||(z-x));
    dbms_output.put_line('division : z / x = '||z/x);
    dbms_output.put_line('multi : z * x = '||z*x);
    dbms_output.put_line('mod : z%x = '|| mod(z,x));
    dbms_output.put_line('-=-=-=-= 12 -=-=-==-=--=');
    dbms_output.put_line('d = '||d);
    dbms_output.put_line('d1 = '||d1);
    dbms_output.put_line('-=-=-=-= 13 -=-=-==-=--=');
    dbms_output.put_line('o = '||o);
    dbms_output.put_line('o1 = '||o1);
    dbms_output.put_line('-=-=-=-= 14 -=-=-==-=--=');
    dbms_output.put_line('bf = '||bf);
    dbms_output.put_line('-=-=-=-= 15 -=-=-==-=--=');
    dbms_output.put_line('bd = '||bd);
    dbms_output.put_line('-=-=-=-= 16 -=-=-==-=--=');
    dbms_output.put_line('ne = '||ne);
    dbms_output.put_line('-=-=-=-= 17 -=-=-==-=--=');
    if boo = true then dbms_output.put_line('true');
    else dbms_output.put_line('false');
    end if;
end;

--18
declare
    n constant number(5) := 6;
    v constant varchar2(10) := 'vconst';
    c constant char(10) := 'cconst';
begin
    dbms_output.put_line('const n = '||n);
    dbms_output.put_line('const n + n = '||(n+n));    
    dbms_output.put_line('const n * n = '||(n*n)); 
    dbms_output.put_line('const v = '||v);
    dbms_output.put_line('const c = '||c);
    exception 
        when others
        then dbms_output.put_line('error = '||SQLERRM);
end;

--19-20
select * from faculty;

declare
   v varchar(25) := 'chars';
   t v%TYPE := 'type of v';
   r  faculty%ROWTYPE;
begin
    dbms_output.put_line('v = '||v);
    dbms_output.put_line('t = '||t);
    r.faculty := 'myfaculty';
    dbms_output.put_line(r.faculty);
        exception 
        when others
        then dbms_output.put_line('error = '||sqlerrm);
end;

--21
declare
    x pls_integer := 10;
begin
    if x < 0 then dbms_output.put_line('x is negative, x = '||x);
    elsif x = 0 then dbms_output.put_line('x is zero, x = '||x);
    else dbms_output.put_line('x is positive, x = '||x);
    end if;
end;

--23
declare
    x pls_integer := 10;
begin
    case x
        when 10 then dbms_output.put_line('10');
        else dbms_output.put_line('not 10');
    end case;
    case
        when x = 5 then dbms_output.put_line('x = '||x);
        when x between 6 and 20 then dbms_output.put_line('between 6 and 20');
        else dbms_output.put_line('else...');
    end case;
end;

--24
declare
    x pls_integer :=0;
begin
dbms_output.put_line('-=-=-=-= 24 -=-=-==-=--=');
    loop x:=x+1;
        dbms_output.put_line(x);
        exit when x>3;
    end loop;
--25
dbms_output.put_line('-=-=-=-= 26 -=-=-==-=--=');
    while (x>0) loop x:=x-1;
        dbms_output.put_line(x);
    end loop;
--26
dbms_output.put_line('-=-=-=-= 25 -=-=-==-=--=');
    for k in 1..3
        loop dbms_output.put_line(k); 
    end loop;
end;

    