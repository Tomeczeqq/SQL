select buyer_name, sales.buyer_id, prod_id, qty
from buyers, sales
where buyers.buyer_id = sales.buyer_id;
select buyer_name, s.buyer_id, prod_id, qty
from buyers as b, sales as s                    --aliasy
where b.buyer_id = s.buyer_id;
select buyer_name, sales.buyer_id, prod_id, qty
from buyers
    inner join sales
    on buyers.buyer_id = sales.buyer_id;
select buyer_name, sales.buyer_id, prod_id, qty
from buyers
    inner join sales                    --aliasy
    on buyers.buyer_id = sales.buyer_id;

select buyer_name, s.buyer_id, qty
from buyers as b, sales as s
where s.buyer_id = b.buyer_id;
select buyer_name, s.buyer_id, qty
from buyers b
    inner join sales s
    on b.buyer_id = s.buyer_id;

--Napisz polecenie zwracające nazwy produktów i firmy je dostarczające tak aby produkty bez dostawców i dostawcy bez produktów nie pojawiali się w wyniku
select productname, companyname
from products
    inner join suppliers
    on products.supplierid = suppliers.supplierid;

--Napisz polecenie zwracające jako wynik nazwy klientów, którzy złożyli zamówienia po 01 marca 1998
select distinct companyname
from orders
    inner join customers
    on orders.customerid = customers.customerid
where orderdate > '1998-03-01';

select buyer_name, s.buyer_id, qty
from buyers b
    left join sales s           --sa dopasowane z tymi co maja puste pola - null
    on b.buyer_id = s.buyer_id;

--Napisz polecenie zwracające wszystkich klientów z datami zamówień
select companyname, customers.customerid, orderdate
from customers
    left outer join orders
    on customers.customerid = orders.customerid;

--Napisz polecenie zwracające klientów, którzy nigdy nie złożyli zamówienia
select companyname, customers.customerid, orderdate
from customers
    left outer join orders
    on customers.customerid = orders.customerid
where orderid is null;

--Ćwiczenia Northwind
--1. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
SELECT P.ProductName, P.UnitPrice, S.City, S.Address
FROM Products P
    JOIN Suppliers S
    ON P.SupplierID = S.SupplierID
WHERE UnitPrice BETWEEN 20 AND 30;

--2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Tradersʼ
SELECT P.ProductName,P.UnitsInStock
FROM Products P
    JOIN Suppliers S
    ON P.SupplierID = S.SupplierID
WHERE CompanyName='Tokyo Traders';

--3.Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe
SELECT C.CustomerID, C.Address
FROM Customers C
    LEFT JOIN Orders O
    ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) = 1997
WHERE OrderId IS NULL;

--4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie ma w magazynie.
SELECT S.CompanyName, S.Phone
FROM Products P
    JOIN Suppliers S
    ON P.SupplierID = S.SupplierID
WHERE UnitsInStock = 0;

--Ćwiczenia Library
--1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki. Interesuje nas imię, nazwisko i data urodzenia dziecka
SELECT m.firstname, m.lastname, j.birth_date
FROM member m
    JOIN juvenile j
    ON m.member_no = j.member_no;

--2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
SELECT DISTINCT t.title
FROM title t
    JOIN loan l
    ON t.title_no = l.title_no;

--3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao Teh Kingʼ. Interesuje nas
--data oddania książki, ile dni była przetrzymywana i jaką zapłacono karę
SELECT out_date, lh.in_date, lh.due_date, lh.fine_paid
FROM title t
    LEFT JOIN loanhist lh
    ON t.title_no = lh.title_no
WHERE lh.fine_paid IS NOT NULL AND t.title = 'Tao Teh King';

--4.Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych przez osobę o nazwisku: Stephen A. Graff
SELECT r.isbn
FROM member m
    JOIN reservation r
    ON m.member_no=r.member_no
WHERE m.lastname='Graff' AND m.firstname='Stephen' AND m.middleinitial='A';

select buyer_name, qty
from buyers cross join sales;
select buyer_name, qty
from buyers, sales;

--Napisz polecenie, wyświetlające CROSS JOIN między shippers i suppliers użyteczne dla listowania wszystkich
--możliwych sposobów w jaki dostawcy mogą dostarczać swoje produkty
select suppliers.companyname, shippers.companyname
from suppliers cross join shippers;

select buyer_name, prod_name, qty
from buyers
    inner join sales
    on buyers.buyer_id = sales.buyer_id
        inner join produce
        on sales.prod_id = produce.prod_id;
select buyer_name, prod_name, qty
from buyers, sales, produce
where buyers.buyer_id = sales.buyer_id and sales.prod_id = produce.prod_id;

--Napisz polecenie zwracające listę produktów zamawianych w dniu 1996-07-08
select distinct productname
from orders as O
    inner join [order details] as OD
    on O.orderid = OD.orderid
        inner join products as P
        on OD.productid = P.productid
where orderdate = '1996-07-08';

--Ćwiczenia Northwind
--1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj
--dane adresowe dostawcy, interesują nas tylko produkty z kategorii ‘Meat/Poultryʼ
SELECT P.ProductName, P.UnitPrice, S.City, S.Address
FROM Suppliers S
    JOIN Products P
    ON S.SupplierID = P.SupplierID
        JOIN Categories C
        ON P.CategoryID = C.CategoryID
WHERE (UnitPrice BETWEEN 20 AND 30) AND C.CategoryName = 'Meat/Poultry';

--2. Wybierz nazwy i ceny produktów z kategorii ‘Confectionsʼ dla każdego produktu podaj nazwę dostawcy
SELECT P.ProductName, P.UnitPrice, S.CompanyName
FROM Suppliers S
    JOIN Products P
    ON S.SupplierID = P.SupplierID
        JOIN Categories C
        ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Confections';

--3. Wybierz nazwy i numery telefonów klientów, którym w 1997 roku przesyłki dostarczała firma ‘United Packageʼ
SELECT DISTINCT C.CompanyName, C.Phone
FROM Shippers S
    JOIN Orders O
    ON S.ShipperID = O.ShipVia
        JOIN Customers C
        ON O.CustomerID = C.CustomerID
WHERE YEAR(ShippedDate) = 1997 AND S.CompanyName = 'United Package';
--3.1. Wybierz nazwy i numery telefonów klientów, którym w 1997 roku przesyłek nie dostarczała firma ‘United Packageʼ
SELECT C.CompanyName, C.Phone
FROM Customers C
WHERE C.CustomerID NOT IN
    (SELECT DISTINCT O.CustomerID
    FROM Orders O
        JOIN Shippers S
        ON O.ShipVia = S.ShipperID
    WHERE YEAR(O.OrderDate) = 1997 AND S.CompanyName = 'United Package');
SELECT C.CompanyName, C.Phone
FROM Shippers S
    INNER JOIN Orders O
    ON S.ShipperID = O.ShipVia  AND YEAR(OrderDate) = 1997
        RIGHT JOIN Customers C
        ON C.CustomerID = O.CustomerID  AND S.CompanyName = 'United Package'
WHERE O.CustomerID IS NULL;

--4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confectionsʼ
SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers C
    JOIN Orders O
    ON C.CustomerID = O.CustomerID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
            JOIN Products P
            ON OD.ProductID = P.ProductID
                JOIN Categories Cat
                ON P.CategoryID = Cat.CategoryID
WHERE Cat.CategoryName='Confections';
--4.1. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produkty z kategorii ‘Confections'
SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers C
WHERE C.CustomerID NOT IN
    (SELECT O.CustomerID
    FROM Orders O
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
            JOIN Products P
            ON OD.ProductID = P.ProductID
                JOIN Categories Cat
                ON P.CategoryID = Cat.CategoryID
    WHERE Cat.CategoryName='Confections');
--4.2 Wybierz nazwy i numery telefonów klientów, którzy w 1997 nie kupowali produkty z kategorii ‘Confections'
SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers C
WHERE C.CustomerID NOT IN
    (SELECT O.CustomerID
    FROM Orders O
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
            JOIN Products P
            ON OD.ProductID = P.ProductID
                JOIN Categories Cat
                ON P.CategoryID = Cat.CategoryID
    WHERE YEAR(O.OrderDate) = 1997 AND Cat.CategoryName='Confections');

--Ćwiczenia Library
--1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas
--imię, nazwisko, data urodzenia dziecka i adres zamieszkania dziecka.
SELECT m.firstname, m.lastname, j.birth_date, a.city
FROM member m
    JOIN juvenile j
    ON m.member_no=j.member_no
        JOIN adult a
        ON j.adult_member_no=a.member_no;

--2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas
--imię, nazwisko, data urodzenia dziecka, adres zamieszkania dziecka oraz imię i nazwisko rodzica.
SELECT m.firstname, m.lastname, j.birth_date, a.street , a.city , m.firstname, m.lastname
FROM member m
    JOIN juvenile j
    ON m.member_no = j.member_no
        JOIN adult a
        ON a.member_no = j.adult_member_no;

select a.buyer_id as buyer1, a.prod_id, b.buyer_id as buyer2
from sales as a
    join sales as b
    on a.prod_id = b.prod_id
where a.buyer_id > b.buyer_id;                      --WAŻNA JEST TU NIERÓWNOŚĆ OSTRA!!!

--Napisz polecenie, które pokazuje pary pracowników zajmujących to samo stanowisko
select a.employeeid, a.lastname as name, a.title as title, b.employeeid, b.lastname as name, b.title as title
from employees as a
    inner join employees as b
    on a.title = b.title
where a.employeeid < b.employeeid

--Ćwiczenia Northwind + library
--1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych
SELECT boss.FirstName + ' ' + boss.LastName boss_name, boss.EmployeeID, subordinate.FirstName + ' ' + subordinate.LastName subordinate_name, subordinate.EmployeeID
FROM Employees boss
    JOIN Employees subordinate
    ON boss.EmployeeID = subordinate.ReportsTo;

--2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych
SELECT Employees.FirstName + ' ' + Employees.LastName employee_leaf, Employees.EmployeeID
FROM Employees
EXCEPT
SELECT DISTINCT boss.FirstName + ' ' + boss.LastName, boss.EmployeeID
FROM Employees boss
    JOIN Employees subordinate
    ON boss.EmployeeID = subordinate.ReportsTo;

--3. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci urodzone przed 1 stycznia 1996
SELECT DISTINCT m.firstname, m.lastname, a.street, a.city, a.state, a.zip
FROM member m
    LEFT JOIN adult a
    ON m.member_no = a.member_no
        JOIN juvenile j
        ON a.member_no = j.adult_member_no
WHERE YEAR(j.birth_date) < 1996;

--4. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci urodzone przed 1 stycznia 1996
-- Interesują nas tylko adresy takich członków biblioteki, którzy aktualnie nie przetrzymują książek
SELECT DISTINCT m.firstname, m.lastname, a.street, a.city, a.state, a.zip
FROM member m
    LEFT JOIN adult a
    ON m.member_no = a.member_no
        JOIN juvenile j
        ON a.member_no = j.adult_member_no
WHERE YEAR(j.birth_date) < 1996
EXCEPT
SELECT DISTINCT m.firstname, m.lastname, a.street, a.city, a.state, a.zip
FROM loan l
    JOIN member m
    ON l.member_no = m.member_no
        JOIN adult a
        ON m.member_no = a.member_no
            JOIN juvenile j
            ON a.member_no = j.adult_member_no
WHERE YEAR(j.birth_date) < 1996;

--Union samo jeszcze domyslnie sortuje jednoczesnie usuwajac duplikacje (choc nie zawsze sa one duplikatami!!!)
--Łączna lista pracowników i klientów
select firstname + ' ' + lastname as name,city, postalcode, 'employee' status
from employees
union
select companyname, city, postalcode, 'customer'
from customers;

--Union all gdy wiemy, że nie ma powtórzeń
select 1
union all
select 1;

--Państwa z których mamy zarówno klientów jak i dostawców
select country from customers
intersect
select country from suppliers;

--Klienci którzy złożyli zamówienia w 1997 r. a nie złożyli zamówień w roku poprzednim
select customerid from orders where year(orderdate) = 1997
except
select customerid from orders where year(orderdate) = 1996;

--Ćwiczenia library
--1. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają więcej niż dwoje dzieci zapisanych do biblioteki
SELECT m.firstname, m.lastname, count(*) children
FROM member m
    JOIN adult a
    ON m.member_no = a.member_no
        JOIN juvenile j
        ON a.member_no = j.adult_member_no
WHERE a.state = 'AZ'
GROUP BY m.firstname, m.lastname
HAVING count(*) > 2;

--2. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej niż dwoje dzieci zapisanych do
--biblioteki oraz takich którzy mieszkają w Kaliforni (CA) i mają więcej niż troje dzieci zapisanych do biblioteki
SELECT m.firstname, m.lastname, count(*) children
FROM member m
    JOIN adult a
    ON m.member_no = a.member_no
        JOIN juvenile j
        ON a.member_no = j.adult_member_no
WHERE a.state = 'AZ'
GROUP BY m.firstname, m.lastname
HAVING count(*) > 2
UNION
SELECT m.firstname, m.lastname, count(*) children
FROM member m
    JOIN adult a
    ON m.member_no = a.member_no
        JOIN juvenile j
        ON a.member_no = j.adult_member_no
WHERE a.state = 'CA'
GROUP BY m.firstname, m.lastname
HAVING count(*) > 3;
WITH parents AS (
SELECT a.member_no, count(*) children, [state]
FROM adult a
    JOIN juvenile j
    ON a.member_no = j.adult_member_no
GROUP BY a.member_no, [state])
SELECT firstname, lastname, children
FROM parents p
    JOIN member m
    ON p.member_no = m.member_no
WHERE (p.children > 2 AND p.[state] = 'AZ') OR (p.children > 3 AND p.[state] = 'CA')
ORDER BY firstname, lastname, children;
SELECT m.firstname, m.lastname, COUNT(*) children
FROM adult a
    JOIN juvenile j
    ON a.member_no = j.adult_member_no
        JOIN member m
        ON a.member_no = m.member_no
GROUP BY a.state, m.firstname, m.lastname
HAVING (COUNT(*) > 2 AND a.[state] = 'AZ') OR (COUNT(*) > 3 AND a.[state] = 'CA')
ORDER BY firstname, lastname, children;