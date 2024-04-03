SELECT employeeid, lastname, firstname, title
FROM employees;

--Wybór kolumn:
--1. Wybierz nazwy i adresy wszystkich klientów
SELECT CompanyName, Address
FROM Customers;
--2. Wybierz nazwiska i numery telefonów pracowników
SELECT LastName,HomePhone
FROM Employees;
--3. Wybierz nazwy i ceny produktów
SELECT ProductName,UnitPrice
FROM Products;
--4. Pokaż wszystkie kategorie produktów (nazwy i opisy)
SELECT CategoryName,Description
FROM Categories;
--5. Pokaż nazwy i adresy stron www dostawców
SELECT CompanyName,HomePage
FROM Suppliers;

SELECT employeeid, lastname, firstname, title
FROM employees
WHERE employeeid = 5;

SELECT lastname, city
FROM employees
WHERE country = 'USA';

SELECT *
FROM Orders
WHERE YEAR(OrderDate)=1996;

--Znajdź numer zamówienia (orderid) oraz identyfikator klienta (customerid) dla zamówień z datą wcześniejszą niż 8/1/96
SELECT orderid, customerid
FROM orders
WHERE orderdate < '8/1/96';
SELECT orderid, customerid
FROM orders
WHERE orderdate < '1996-08-01';

--Wybór wierszy:
--1. Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
SELECT CompanyName,Address
FROM Customers
WHERE City = 'London';
--2. Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii
SELECT CompanyName,Address
FROM Customers
WHERE Country = 'France' or Country = 'Spain';
SELECT CompanyName,Address
FROM Customers
WHERE Country IN ('France','Spain');
--3. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 20 and 30;
SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice >= 20 and UnitPrice <= 30;
--4. Wybierz nazwy i ceny produktów z kategorii 'Meat/Poultry'
SELECT ProductName,UnitPrice
FROM Products
WHERE CategoryID=6;
DECLARE @id INT
SET @id=(SELECT CategoryID  FROM Categories WHERE CategoryName='Meat/Poultry')
SELECT * FROM Products WHERE CategoryID=@id;
SELECT *
FROM Products
WHERE CategoryID=(SELECT CategoryID  FROM Categories WHERE CategoryName='Meat/Poultry');
SELECT ProductName, UnitPrice, CategoryName
FROM Products, Categories
WHERE CategoryName='Meat/Poultry' AND Products.CategoryID = Categories.CategoryID;
SELECT ProductName, UnitPrice , CategoryName
FROM Products JOIN Categories
    ON Products.CategoryID = Categories.CategoryID
WHERE CategoryName='Meat/Poultry';
--5. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
SELECT ProductName,UnitsInStock
FROM Products
WHERE SupplierID=4;
--6. Wybierz nazwy produktów których nie ma w magazynie
SELECT ProductName
FROM Products
WHERE Discontinued='true';

SELECT companyname
FROM customers
WHERE companyname like '%Restaurant%';

--Porównywarka napisów:
--1. Szukamy informacji o produktach sprzedawanych w butelkach (‘bottle’)
SELECT ProductName
FROM Products
WHERE QuantityPerUnit like '%bottle%';
--2. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę z zakresu od B do L
SELECT Title,LastName
FROM Employees
WHERE LastName like '[B-L]%';
select Title,LastName
from Employees
where LastName>='B' and LastName<'M';
--3. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę B lub L
SELECT Title,LastName
FROM Employees
WHERE LastName like '[BL]%';
--4. Znajdź nazwy kategorii, które w opisie zawierają przecinek
SELECT CategoryName
FROM Categories
WHERE Description like '%,%';
--5. Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo ‘Store’
SELECT CompanyName
FROM Customers
WHERE CompanyName like '%Store%';

SELECT productid, productname, supplierid, unitprice
FROM products
WHERE (productname LIKE 'T%' OR productid = 46) AND (unitprice > 16.00);

SELECT productid, productname, supplierid, unitprice
FROM products
WHERE (productname LIKE 'T%') OR productid = 46 AND unitprice > 16.00;

SELECT productname, unitprice
FROM products
WHERE unitprice BETWEEN 10 AND 20;
SELECT productname, unitprice
FROM products
WHERE unitprice >= 10 AND unitprice <= 20;

--Zakres wartości:
--1. Szukamy informacji o produktach o cenach mniejszych niż 10 lub większych niż 20
SELECT *
FROM Products
WHERE UnitPrice < 10 or UnitPrice > 20;
--2. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 20 and 30;

--Warunki logiczne:
--1. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan) lub we Włoszech (Italy)
SELECT CompanyName,Country
FROM Customers
WHERE Country='Japan' or Country='Italy';
SELECT Companyname,Country
FROM Customers
WHERE Country IN ('Japan', 'Italy');

SELECT companyname, country
FROM suppliers
WHERE country IN ('Japan', 'Italy');

SELECT companyname, fax
FROM suppliers
WHERE fax IS NULL;

select GETDATE();
--Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer klienta
--dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem odbiorcy jest Argentyna
SELECT OrderID,OrderDate,CustomerID
FROM Orders
WHERE ShipCountry='Argentina' and (ShippedDate is null or ShippedDate>getdate());

SELECT productid, productname, unitprice
FROM products
ORDER BY unitprice;
SELECT productid, productname, unitprice
FROM products
ORDER BY unitprice DESC;

SELECT productid, productname, categoryid, unitprice
FROM products
ORDER BY categoryid, unitprice DESC;
SELECT productid, productname, categoryid, unitprice
FROM products
ORDER BY 3,4 DESC;

--Sortowanie danych:
--1. Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w ramach danego kraju nazwy firm posortuj alfabetycznie
SELECT CompanyName,Country
FROM Customers
ORDER BY 2,1;
--2. Wybierz informację o produktach (grupa, nazwa, cena), produkty posortuj wg grup a w grupach malejąco wg ceny
SELECT CategoryID,ProductName,UnitPrice
FROM Products
ORDER BY CategoryID,3 DESC;
--3. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan) lub we Włoszech (Italy), wyniki posortuj tak jak w pkt 1
SELECT CompanyName,Country
FROM Customers
WHERE Country in ('Japan','Italy')
ORDER BY Country,CompanyName;

SELECT country
FROM suppliers
ORDER BY country;
SELECT DISTINCT country
FROM suppliers
ORDER BY country;

SELECT firstname AS First, lastname AS Last,employeeid AS 'Employee ID'
FROM employees;

SELECT firstname, lastname,'Identification number:' as number, 1 as jeden, employeeid
FROM employees;

SELECT orderid, unitprice * 1.05 as newunitprice
FROM [order details];

SELECT firstname + ' ' + lastname as imie_nazwisko
FROM employees;

--1. Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 10250
SELECT ProductID, (1-Discount)*UnitPrice*Quantity as Wartosc_pozycji
FROM [Order Details]
WHERE OrderID=10250;
--2. Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą kolumnę zawierającą nr telefonu
--i nr faksu w formacie (numer telefonu i faksu mają być oddzielone przecinkiem)
select ISNULL(Phone, '---') + ', ' + ISNULL(Fax, '---') as kontakt
from Suppliers;