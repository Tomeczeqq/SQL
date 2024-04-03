SELECT TOP 5 orderid, productid, quantity
FROM [order details]
ORDER BY quantity DESC;

SELECT TOP 5 WITH TIES orderid, productid, quantity
FROM [order details]
ORDER BY quantity DESC;

SELECT COUNT(*)
FROM employees;
SELECT COUNT(reportsto)
FROM employees;

--Policz średnią cenę jednostkową dla wszystkich produktów w tabeli products
SELECT AVG(unitprice) as average_price
FROM products;

--Zsumuj wszystkie wartości w kolumnie quantity w tabeli order details, dla wierszy w których wartość productid = 1
SELECT SUM(quantity) as sum_product1
FROM [order details]
WHERE productid = 1;

--1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż 20$
SELECT COUNT(UnitPrice) as number
FROM Products
WHERE UnitPrice NOT BETWEEN 10 AND 20;

--2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
SELECT TOP 1 UnitPrice
FROM Products
WHERE UnitPrice < 20
ORDER BY UnitPrice DESC;

--3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o produktach sprzedawanych w butelkach (‘bottle’)
SELECT MAX(UnitPrice) as maximum, MIN(UnitPrice) as minimum, AVG(UnitPrice) as average
FROM Products
WHERE QuantityPerUnit LIKE '%bottle%';

--4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
SELECT *
FROM Products
WHERE UnitPrice>(SELECT AVG(UnitPrice) FROM Products)
ORDER BY UnitPrice;

--5. Podaj sumę/wartość zamówienia o numerze 10250
SELECT SUM(UnitPrice*Quantity*(1-Discount)) as sum
FROM [Order Details]
WHERE OrderID=10250;

SELECT productid, orderid, quantity
FROM orderhist;
SELECT productid ,SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid;
SELECT productid, SUM(quantity) AS total_quantity
FROM orderhist
WHERE productid = 2
GROUP BY productid;

/*Napisz polecenie, które zwraca informacje o zamówieniach z tablicy order details. Zapytanie ma grupować
i wyświetlać identyfikator każdego produktu a następnie obliczać ogólną zamówioną ilość. Ogólna ilość jest sumowana
funkcją agregującą SUM i wyświetlana jako jedna wartość dla każdego produktu.*/
SELECT productid, SUM(quantity) AS total_quantity
FROM [order details]
GROUP BY productid;

--1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
SELECT OrderID,MAX(UnitPrice*Quantity*(1-Discount)) as max
FROM [Order Details]
GROUP BY OrderID;

--2. Posortuj zamówienia wg maksymalnej ceny produktu
SELECT OrderID,MAX(UnitPrice*Quantity*(1-Discount)) as max
FROM [Order Details]
GROUP BY OrderID
ORDER BY max DESC;

--3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
SELECT OrderID,MAX(UnitPrice*Quantity*(1-Discount)) as max, MIN(UnitPrice*Quantity*(1-Discount)) as min
FROM [Order Details]
GROUP BY OrderID;

--4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
SELECT SUM(1) as orders_sum
FROM Orders
GROUP BY ShipVia;

--5. Który z spedytorów był najaktywniejszy w 1997 roku
SELECT ShipVia
FROM Orders
WHERE YEAR(OrderDate) = 1997
GROUP BY ShipVia
ORDER BY SUM(1) DESC;

SELECT productid, orderid, quantity
FROM orderhist;
SELECT productid, SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid
HAVING SUM(quantity)>=30;

--Wyświetl listę identyfikatorów produktów i ilość dla tych produktów, których zamówiono ponad 1200 jednostek
SELECT productid, SUM(quantity) AS total_quantity
FROM [order details]
GROUP BY productid
HAVING SUM(quantity)>1200;

--1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
SELECT OrderID
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(1)>5;

--2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień (wyniki posortuj malejąco wg
--łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
SELECT CustomerID, SUM(Freight) as sum
FROM Orders
WHERE YEAR(OrderDate) = 1998
GROUP BY CustomerID
HAVING SUM(1) > 8
ORDER BY sum DESC;

SELECT productid, orderid, SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid, orderid
WITH ROLLUP
ORDER BY productid, orderid;

--Zwróć listę ogólnej ilości zamawianej dla każdego produktu w każdym zamówieniu, dla zamówień z orderid mniejszym niż 10250
SELECT orderid, productid, SUM(quantity) AS total_quantity
FROM [order details]
WHERE orderid < 10250
GROUP BY orderid, productid
ORDER BY orderid, productid;

SELECT orderid, productid, SUM(quantity) AS total_quantity
FROM [order details]
WHERE orderid < 10250
GROUP BY orderid, productid
WITH ROLLUP
ORDER BY orderid, productid;

SELECT productid, orderid, SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid, orderid
WITH CUBE
ORDER BY productid, orderid;