--Ćwiczenie 1
--1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)
SELECT O.OrderID, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount))+O.Freight AS Value
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, O.Freight
HAVING O.OrderID=10250;

--2. Podaj łączną wartość każdego zamówienia (uwzględnij cenę za przesyłkę)
SELECT O.OrderID, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount))+O.Freight AS Value
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, O.Freight
ORDER BY O.OrderID;

--3. Dla każdego produktu podaj maksymalną wartość zakupu tego produktu
SELECT P.ProductID, MAX(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Value
FROM Products P
    JOIN [Order Details] OD
    ON P.ProductID = OD.ProductID
GROUP BY P.ProductID
ORDER BY P.ProductID, Value DESC;

--4. Dla każdego produktu podaj maksymalną wartość zakupu tego produktu w 1997r
SELECT P.ProductID, MAX(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS Value
FROM Products P
    JOIN [Order Details] OD
    ON P.ProductID = OD.ProductID
        JOIN Orders O
        ON OD.OrderID = O.OrderID
GROUP BY P.ProductID, YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate)=1997
ORDER BY P.ProductID, Value DESC;

--Ćwiczenie 2
--1. Dla każdego klienta podaj łączną wartość jego zamówień (bez opłaty za przesyłkę) z 1996r
WITH UOD AS(
SELECT OrderId, SUM(UnitPrice*Quantity*(1-Discount)) partvalue
FROM [Order Details]
GROUP BY OrderId)
SELECT C.CompanyName, C.CustomerId, SUM(partvalue) AS Value
FROM Orders O
    JOIN UOD
    ON O.OrderID=UOD.OrderID AND YEAR(O.OrderDate)=1996
        RIGHT JOIN Customers C
        ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerId, C.CompanyName;
SELECT C.CompanyName, C.CustomerID, SUM((OD.UnitPrice*OD.Quantity*(1-OD.Discount))) as Value
from Customers C
    LEFT JOIN Orders O
    ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate)=1996
        LEFT JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID, C.CompanyName;

--2. Dla każdego klienta podaj łączną wartość jego zamówień (uwzględnij opłatę za przesyłkę) z 1996r
WITH FreightTot AS (
SELECT CustomerID, SUM(Freight) AS TotalFreight
FROM Orders
WHERE YEAR(OrderDate)=1996
GROUP BY CustomerID)
SELECT C.CompanyName, C.CustomerID, COALESCE(SUM(COALESCE(OD.UnitPrice*OD.Quantity*(1-OD.Discount),0)),0) + COALESCE(FT.TotalFreight,0) AS TotalValue
FROM Customers C
    LEFT JOIN (Orders O
                   JOIN [Order Details] OD
                   ON O.OrderID = OD.OrderID AND YEAR(O.OrderDate)=1996)
    ON C.CustomerID = O.CustomerID
        LEFT JOIN FreightTot FT
        ON C.CustomerID = FT.CustomerID
GROUP BY C.CustomerID, C.CompanyName, FT.TotalFreight;

--3. Dla każdego klienta podaj maksymalną wartość zamówień złożonych przez tego klienta w 1997r
SELECT C.CustomerID, MAX(OD.UnitPrice*OD.Quantity*(1-Od.Discount)) AS Maxordervalue
FROM Customers C
    LEFT JOIN Orders O
    ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate)=1997
        LEFT JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID;

--Ćwiczenie 3
--1. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko oraz liczbę jego dzieci
SELECT m.member_no, m.firstname, m.lastname, COUNT(DISTINCT j.member_no) AS Childrennumber
FROM member m
    JOIN adult a
    ON m.member_no = a.member_no
        LEFT JOIN juvenile j
        ON a.member_no = j.adult_member_no
GROUP BY m.member_no, m.firstname, m.lastname;

--2. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko, liczbę jego dzieci, liczbę zarezerwowanych książek oraz liczbę wypożyczonych książek
SELECT m.member_no, m.firstname, m.lastname, COUNT(DISTINCT j.member_no) AS Childrennumber, COUNT(DISTINCT r.member_no) AS Reservedbooks, COUNT(DISTINCT l.member_no) AS Loanedbooks
FROM member m
    JOIN adult a
    ON m.member_no = a.member_no
        LEFT JOIN juvenile j
        ON a.member_no = j.adult_member_no
            LEFT JOIN reservation r
            ON m.member_no = r.member_no
                LEFT JOIN loan l
                ON m.member_no = l.member_no
GROUP BY m.member_no, m.firstname, m.lastname;

--3. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko, liczbę jego dzieci, liczbę książek zarezerwowanych i wypożyczonych przez niego i jego dzieci
SELECT m.member_no, m.firstname, m.lastname, COUNT(DISTINCT j.member_no) AS Childrennumber, COUNT(DISTINCT r.isbn) AS ReservedBooksForMember,
    COUNT(DISTINCT r_child.isbn) AS ReservedBooksForChildren, COUNT(DISTINCT l.isbn) AS LoanedBooksForMember, COUNT(DISTINCT l_child.isbn) AS LoanedBooksForChildren
FROM member m
    JOIN adult a
    ON m.member_no = a.member_no
        LEFT JOIN juvenile j
        ON a.member_no = j.adult_member_no
            LEFT JOIN reservation r
            ON m.member_no = r.member_no
                LEFT JOIN reservation r_child
                ON j.member_no = r_child.member_no
                    LEFT JOIN loan l
                    ON m.member_no = l.member_no
                        LEFT JOIN loan l_child
                        ON j.member_no = l_child.member_no
GROUP BY m.member_no, m.firstname, m.lastname;

--4. Dla każdego tytułu książki podaj ile razy ten tytuł był wypożyczany w 2001r
SELECT t.title, COUNT(lh.out_date) AS loannumber
FROM title t
    LEFT JOIN loanhist lh
    ON t.title_no = lh.title_no
    WHERE YEAR(lh.out_date)=2001
GROUP BY t.title;

--5. Dla każdego tytułu książki podaj ile razy ten tytuł był wypożyczany w 2002r
SELECT t.title, COUNT(lh.out_date) AS loannumber
FROM title t
    LEFT JOIN loanhist lh
    ON t.title_no = lh.title_no
    WHERE YEAR(lh.out_date)=2002
GROUP BY t.title;

--Ćwiczenie 4
--1. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak to pokaż ich dane adresowe
SELECT C.CompanyName, C.Address
FROM Customers C
    LEFT JOIN Orders O
    ON C.CustomerID = O.CustomerID and YEAR(O.OrderDate)=1997
WHERE O.OrderDate IS NULL;

--2. Wybierz nazwy i numery telefonów klientów, którym w 1997 roku przesyłki dostarczała firma United Package
SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers C
    JOIN Orders O
    ON C.CustomerID = O.CustomerID and YEAR(O.OrderDate)=1997
        JOIN Shippers S
        ON O.ShipVia = S.ShipperID
WHERE S.CompanyName LIKE 'United Package';

--3. Wybierz nazwy i numery telefonów klientów, którym w 1997 roku przesyłek nie dostarczała firma United Package
SELECT C.CompanyName, C.Phone
FROM Customers C
EXCEPT
SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers C
    JOIN Orders O
    ON C.CustomerID = O.CustomerID and YEAR(O.OrderDate)=1997
        JOIN Shippers S
        ON O.ShipVia = S.ShipperID
WHERE S.CompanyName LIKE 'United Package';
SELECT C.CompanyName, C.Phone
FROM Customers C
WHERE C.CustomerID NOT IN (SELECT DISTINCT C.CustomerID
                           FROM Customers C
                               JOIN Orders O
                               ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate)=1997
                                   JOIN Shippers S
                                   ON O.ShipVia = S.ShipperID
                           WHERE S.CompanyName = 'United Package');

--4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections
SELECT DISTINCT C.CompanyName, C.Phone
FROM Customers C
    JOIN Orders O
    ON C.CustomerID = O.CustomerID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
            JOIN Products P
            ON OD.ProductID = P.ProductID
                JOIN Categories Ct
                ON P.CategoryID = Ct.CategoryID
WHERE Ct.CategoryName LIKE 'Confections';

--5. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections
SELECT C.CompanyName, C.Phone
FROM Customers C
WHERE C.CompanyName NOT IN (SELECT DISTINCT C.CompanyName
                            FROM Customers C
                                JOIN Orders O
                                ON C.CustomerID = O.CustomerID
                                    JOIN [Order Details] OD
                                    ON O.OrderID = OD.OrderID
                                        JOIN Products P
                                        ON OD.ProductID = P.ProductID
                                            JOIN Categories Ct
                                            ON P.CategoryID = Ct.CategoryID
                            WHERE Ct.CategoryName LIKE 'Confections');

--Ćwiczenie 5
--1. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
WITH Prod AS(
SELECT AVG(UnitPrice) AS avprice
FROM Products)
SELECT P.ProductName
FROM Products P, Prod
WHERE P.UnitPrice<avprice;

--2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej kategorii
WITH Cat AS(
SELECT CategoryID, AVG(UnitPrice) AS Catavprice
FROM Products
GROUP BY CategoryID)
SELECT P.ProductName
FROM Products P
    JOIN Cat
    ON P.CategoryID=Cat.CategoryID
WHERE P.UnitPrice<Catavprice;

--3. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich produktów oraz różnicę między ceną produktu a średnią ceną wszystkich produktów
WITH Prod AS(
SELECT AVG(UnitPrice) AS avprice
FROM Products)
SELECT P.ProductName, P.UnitPrice, avprice, P.UnitPrice-avprice AS diff
FROM Products P, Prod;
--CROSS JOIN Prod;

--4. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a średnią ceną wszystkich produktów danej kategorii
WITH Cat AS(
SELECT CategoryID, AVG(UnitPrice) AS Catavprice
FROM Products
GROUP BY CategoryID)
SELECT P.ProductName, C.CategoryName, P.UnitPrice, Catavprice, P.UnitPrice-Catavprice AS Diff
FROM Products P
    JOIN Cat
    ON P.CategoryID=Cat.CategoryID
        JOIN Categories C
        ON P.CategoryID = C.CategoryID;

--Ćwiczenie 6
--1. Podaj produkty kupowane przez więcej niż jednego klienta
SELECT P.ProductName, COUNT(DISTINCT O.CustomerID) AS Diffclients
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID
        JOIN Products P
        ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
HAVING COUNT(DISTINCT O.CustomerID)>1;

--2. Podaj produkty kupowane w 1997r przez więcej niż jednego klienta
SELECT P.ProductName, COUNT(DISTINCT O.CustomerID) AS Diffclients
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID AND YEAR(O.OrderDate)=1997
        JOIN Products P
        ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
HAVING COUNT(DISTINCT O.CustomerID)>1;

--3. Podaj nazwy klientów którzy w 1997r kupili co najmniej dwa różne produkty z kategorii 'Confections'
SELECT Cm.CompanyName, COUNT(DISTINCT P.ProductID) AS Diffproducts
FROM Orders O
    JOIN [Order Details] OD
    ON O.OrderID = OD.OrderID AND YEAR(O.OrderDate)=1997
        JOIN Products P
        ON OD.ProductID = P.ProductID
            JOIN Categories C
            ON P.CategoryID = C.CategoryID AND C.CategoryName LIKE 'Confections'
                JOIN Customers Cm
                ON O.CustomerID = Cm.CustomerID
GROUP BY Cm.CompanyName
HAVING COUNT(DISTINCT P.ProductID)>1;

--Ćwiczenie 7
--1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika
--(przy obliczaniu wartości zamówień uwzględnij cenę za przesyłkę)
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)+O.Freight) AS Totalvalue
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY E.EmployeeID;

--2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
SELECT TOP 1 E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)+O.Freight) AS Totalvalue
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID AND YEAR(O.OrderDate)=1997
GROUP BY E.FirstName, E.LastName, YEAR(O.OrderDate)
ORDER BY Totalvalue DESC;

--3. Ogranicz wynik z pkt 1 tylko do pracowników
--3.1. którzy mają podwładnych
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)+O.Freight) AS Totalvalue
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
WHERE E.EmployeeID IN (SELECT DISTINCT ReportsTo
                       FROM Employees
                       WHERE ReportsTo IN (SELECT EmployeeID
                                               FROM Employees))
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY E.EmployeeID;

--3.2. którzy nie mają podwładnych
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)+O.Freight) AS Totalvalue
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
WHERE E.EmployeeID NOT IN (SELECT DISTINCT ReportsTo
                       FROM Employees
                       WHERE ReportsTo IN (SELECT EmployeeID
                                               FROM Employees))
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY E.EmployeeID;

--4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę ostatnio obsłużonego zamówienia
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)+O.Freight) AS Totalvalue, MAX(O.OrderDate) AS LatestOrderDate
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
WHERE E.EmployeeID IN (SELECT DISTINCT ReportsTo
                       FROM Employees
                       WHERE ReportsTo IN (SELECT EmployeeID
                                               FROM Employees))
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY E.EmployeeID;
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)+O.Freight) AS Totalvalue, MAX(O.OrderDate) AS LatestOrderDate
FROM Employees E
    JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
        JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
WHERE E.EmployeeID NOT IN (SELECT DISTINCT ReportsTo
                       FROM Employees
                       WHERE ReportsTo IN (SELECT EmployeeID
                                               FROM Employees))
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY E.EmployeeID;