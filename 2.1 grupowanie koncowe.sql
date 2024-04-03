--Ćwiczenie 1:
--1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia w tablicy order details i zwraca wynik
-- posortowany w malejącej kolejności (wg wartości sprzedaży)
SELECT OrderID,SUM(UnitPrice*Quantity*(1-Discount)) as sum
FROM [Order Details]
GROUP BY OrderID
ORDER BY sum DESC;

--2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10 wierszy
SELECT TOP 10 OrderID,SUM(UnitPrice*Quantity*(1-Discount)) as sum
FROM [Order Details]
GROUP BY OrderID
ORDER BY sum DESC;

--Ćwiczenie 2:
--1. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których productid < 3
SELECT ProductID, SUM(Quantity) as total_quantity
FROM [Order Details]
GROUP BY ProductID
HAVING ProductID < 3;

--2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę zamówionych jednostek produktu dla wszystkich produktów
SELECT ProductID, SUM(Quantity) as total_quantity
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID;

--3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których łączna liczba zamawianych jednostek produktów jest > 250
SELECT OrderID, SUM(UnitPrice*Quantity*(1-Discount)) as sum
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(Quantity) > 250;

--Ćwiczenie 3:
--1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień
SELECT EmployeeID, COUNT(1) as sum
FROM Orders
GROUP BY EmployeeID
ORDER BY EmployeeID;

--2. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę" przewożonych przez niego zamówień
SELECT ShipVia, SUM(Freight) as freight_sum
FROM Orders
GROUP BY ShipVia
ORDER BY ShipVia;

--3. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę" przewożonych przez niego zamówień w latach o 1996 do 1997
SELECT ShipVia, SUM(Freight) as freight_sum
FROM Orders
WHERE YEAR (ShippedDate) IN (1996,1997)
GROUP BY ShipVia
ORDER BY ShipVia;

--Ćwiczenie 4:
--1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z podziałem na lata i miesiące
SELECT EmployeeID, MONTH(OrderDate) as month, COUNT(MONTH(OrderDate)) as month_tot, YEAR(OrderDate) as year, COUNT(YEAR(OrderDate)) as year_tot,  COUNT(1) as sum
FROM Orders
GROUP BY EmployeeID, (MONTH(OrderDate)), YEAR(OrderDate)
ORDER BY EmployeeID, year, month;

--2. Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej kategorii
SELECT CategoryID, MAX(UnitPrice) as max, MIN(UnitPrice) as min
FROM Products
GROUP BY CategoryID
ORDER BY CategoryID;