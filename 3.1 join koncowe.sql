--Ćwiczenie 1
--1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta
SELECT O.OrderId, SUM(Quantity) AS TotalQuantity, C.CompanyName
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
        JOIN Customers C
        ON O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
ORDER BY O.OrderID;

--2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których łączna liczbę zamówionych jednostek jest większa niż 250
SELECT O.OrderId, SUM(Quantity) AS TotalQuantity, C.CompanyName
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
        JOIN Customers C
        ON O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
HAVING SUM(Quantity)>250
ORDER BY O.OrderID;

--3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta
SELECT O.OrderID, SUM((OD.UnitPrice*OD.Quantity*(1-OD.Discount))) AS OrderValue, C.CompanyName
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
        JOIN Customers C
        ON O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
ORDER BY O.OrderID;

--4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których łączna liczba jednostek jest większa niż 250
SELECT O.OrderID, SUM((OD.UnitPrice*OD.Quantity*(1-OD.Discount))) AS OrderValue, C.CompanyName
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
        JOIN Customers C
        ON O.CustomerID = C.CustomerID
GROUP BY O.OrderID, C.CompanyName
HAVING SUM(OD.Quantity)>250
ORDER BY O.OrderID;

--5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówień
SELECT O.OrderID, SUM((OD.UnitPrice*OD.Quantity*(1-OD.Discount))) AS OrderValue, C.CompanyName, E.FirstName, E.LastName
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
        JOIN Customers C
        ON O.CustomerID = C.CustomerID
            JOIN Employees E
            ON O.EmployeeID = E.EmployeeID
GROUP BY O.OrderID, C.CompanyName, E.FirstName, E.LastName
HAVING SUM(OD.Quantity)>250
ORDER BY O.OrderID;

--Ćwiczenie 2
--1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów z tej kategorii
SELECT C.CategoryName, SUM(Quantity) AS Orderamount
FROM Categories C
    JOIN Products P
    ON C.CategoryID = P.CategoryID
        JOIN [Order Details] OD
        ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName;

--2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez klientów jednostek towarów z tej kategorii
SELECT C.CategoryName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Ordervalue
FROM Categories C
    JOIN Products P
    ON C.CategoryID = P.CategoryID
        JOIN [Order Details] OD
        ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName;

--3.1. Posortuj wyniki w zapytaniu z poprzedniego punktu według łącznej wartości zamówień
SELECT C.CategoryName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Ordervalue
FROM Categories C
    JOIN Products P
    ON C.CategoryID = P.CategoryID
        JOIN [Order Details] OD
        ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName
ORDER BY Ordervalue DESC;

--3.2. Posortuj wyniki w zapytaniu z poprzedniego punktu według łącznej liczby zamówionych przez klientów jednostek towarów
SELECT C.CategoryName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Ordervalue
FROM Categories C
    JOIN Products P
    ON C.CategoryID = P.CategoryID
        JOIN [Order Details] OD
        ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName
ORDER BY SUM(OD.Quantity) DESC;

--4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
SELECT O.OrderID, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount))+O.Freight AS Totalvalue
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
GROUP BY O.OrderID,O.Freight;

--Ćwiczenie 3
--1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
SELECT S.CompanyName, COUNT(O.OrderID) AS Orderamount
FROM Shippers S
    JOIN Orders O
    ON S.ShipperID = O.ShipVia
GROUP BY S.CompanyName, YEAR(O.ShippedDate)
HAVING YEAR(O.ShippedDate)=1997;

--2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika
SELECT TOP 1 S.CompanyName
FROM Shippers S
    JOIN Orders O
    ON S.ShipperID = O.ShipVia
GROUP BY S.CompanyName, YEAR(O.ShippedDate)
HAVING YEAR(O.ShippedDate)=1997
ORDER BY COUNT(O.OrderID) DESC;

--3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika
SELECT E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Ordervalue
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
GROUP BY E.FirstName, E.LastName;

--4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i nazwisko takiego pracownika
SELECT TOP 1 E.FirstName, E.LastName
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName, YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate)=1997
ORDER BY COUNT(O.OrderID) DESC;

--5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
SELECT TOP 1 E.FirstName, E.LastName
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
GROUP BY E.FirstName, E.LastName, YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate)=1997
ORDER BY SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) DESC;

--Ćwiczenie 4
--1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika
--1.1. Ogranicz wynik tylko do pracowników, którzy mają podwładnych
SELECT E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Ordervalue
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
    WHERE E.EmployeeID IN (SELECT DISTINCT ReportsTo
                           FROM Employees
                           WHERE ReportsTo IS NOT NULL)
GROUP BY E.FirstName, E.LastName;

--1.2. Ogranicz wynik tylko do pracowników, którzy nie mają podwładnych
SELECT E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Ordervalue
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
    WHERE E.EmployeeID IN (SELECT EmployeeID
                           FROM Employees
                           WHERE EmployeeID NOT IN (SELECT DISTINCT ReportsTo
                                                    FROM Employees
                                                    WHERE ReportsTo IS NOT NULL))
GROUP BY E.FirstName, E.LastName;