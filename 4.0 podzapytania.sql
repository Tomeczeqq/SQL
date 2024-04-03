--Podzapytania do tabel
select t.orderid, t.customerid
from (select orderid, customerid
      from orders) as t;

--Podzapytanie w wyrażeniu
select productname, unitprice, (select avg(unitprice) from products) as average, unitprice-(select avg(unitprice) from products) diff
from products;

select productname, unitprice, (select avg(unitprice) from products) as average, unitprice - (select avg(unitprice) from products) as diff
from products
where unitprice > (select avg(unitprice)
                   from products);

--można uniknąć powielania kodu
select *, unitPrice - average as diff
from (select productname, unitprice, (select avg(unitprice) from products) as average
      from products) t
where unitPrice > average;

--Podzapytania skorelowane - moga byc slabe wydajnosciowe
select productname, categoryid, unitprice, (select avg(unitprice)
                                            from products as p_in
                                            where p_in.categoryid = p_out.categoryid ) as average
from products as p_out;

select productname, categoryid, unitprice, (select avg(unitprice)
                                            from products as p_in
                                            where p_in.categoryid = p_out.categoryid ) as average
from products as p_out
where UnitPrice > (select avg(unitprice)
                   from products as p_in
                   where p_in.categoryid = p_out.categoryid);

select productname, categoryid, unitprice, (select avg(unitprice)
                                            from products as p_in
                                            where p_in.categoryid = p_out.categoryid) as average,
                                unitprice - (select avg(unitprice)
                                             from products as p_in
                                             where p_in.categoryid = p_out.categoryid ) as diff
from products as p_out;

select *, UnitPrice - average as diff
from (select productname, categoryid, unitprice, (select avg(unitprice)
                                                  from products as p_in
                                                  where p_in.categoryid = p_out.categoryid) as average
      from products as p_out) t;

with t as (
select productname, categoryid, unitprice, (select avg(unitprice)
                                            from products as p_in
                                            where p_in.categoryid = p_out.categoryid) as average
from products as p_out)
select *, UnitPrice - average as diff
from t;

select p.ProductName, p.CategoryID, p.UnitPrice, p.UnitPrice - av.average as diff
from products p
    join (select categoryid, avg(unitprice) average
          from products
          group by categoryid) av
    on p.CategoryID = av.CategoryID;

with av as (
select categoryid, avg(unitprice) average
from products
group by categoryid)
select p.ProductName, p.CategoryID, p.UnitPrice, p.UnitPrice- - av.average as diff
from products p
    join av
    on p.CategoryID = av.CategoryID;

select o.orderid, o.customerid, c.companyname
from customers c
    join orders o
    on c.customerid = o.customerid;
select orderid, customerid, (select companyname
                             from customers c
                             where c.customerid = o.customerid) companyname
from orders o;

select productid, max(quantity)
from [order details]
group by productid;
select distinct productid, quantity
from [order details] as ord1
where quantity = (select max(quantity)
                  from [order details] as ord2
                  where ord1.productid = ord2.productid);

select lastname, employeeid
from employees as e
where employeeid in (select employeeid
                     from orders as o
                     where o.orderdate = '1997-09-05');
select distinct lastname, e.employeeid
from orders as o
    inner join employees as e
    on o.employeeid = e.employeeid
where o.orderdate = '1997-09-05';
select lastname, employeeid
from employees as e
where exists (select *
              from orders as o
              where e.employeeid = o.employeeid and o.orderdate = '1997-09-05');

select lastname, employeeid
from employees as e
where employeeid not in (select employeeid
                         from orders as o
                         where o.orderdate = '1997-09-05');
select lastname, e.employeeid
from orders as o
    right join employees as e
    on o.employeeid = e.employeeid and o.orderdate = '1997-09-05'
where orderid is null;
select lastname, employeeid
from employees
except
select lastname, e.employeeid
from orders as o
    inner join employees as e
    on o.employeeid = e.employeeid
where o.orderdate = '1997-09-05';
select lastname, employeeid
from employees as e
where not exists (select *
                  from orders as o
                  where e.employeeid = o.employeeid and o.orderdate = '1997-09-05');