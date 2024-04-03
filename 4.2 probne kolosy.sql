--Kolos 2022 wt. 13:00
--Ćwiczenie 1
/*Dla każdego klienta podaj imię i nazwisko pracownika, który w 1997r obsłużył najwięcej jego zamówień, podaj
także liczbę tych zamówień (jeśli jest kilku takich pracownikow to wystarczy podać imię nazwisko jednego nich).
Za datę obsłużenia zamówienia należy przyjąć orderdate. Zbiór wynikowy powinien zawierać nazwę klienta, imię
i nazwisko pracownika oraz liczbę obsłużonych zamówień*/
--nie jest w pelni to co ma byc
SELECT C.CompanyName, E.FirstName, E.LastName, COUNT(O.OrderID) AS Totalorders
FROM Customers C
    JOIN Orders O
    ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate)=1997
        JOIN Employees E
        ON O.EmployeeID = E.EmployeeID
GROUP BY C.CompanyName, E.FirstName, E.LastName
ORDER BY C.CompanyName, Totalorders DESC;

--Ćwiczenie 2
/*Podaj liczbę̨ zamówień oraz wartość zamówień (uwzględnij opłatę za przesyłkę) obsłużonych przez każdego
pracownika w lutym 1997. Za datę obsłużenia zamówienia należy uznać datę jego złożenia (orderdate). Jeśli
pracownik nie obsłużył w tym okresie żadnego zamówienia, to też powinien pojawić się na liście (liczba
obsłużonych zamówień oraz ich wartość jest w takim przypadku równa 0). Zbiór wynikowy powinien zawierać:
imię i nazwisko pracownika, liczbę obsłużonych zamówień, wartość obsłużonych zamówień*/
SELECT E.FirstName, E.LastName, COUNT(O.OrderID) AS Totalnumber, COALESCE(SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)+O.Freight),0) AS Totalvalue
FROM Employees E
    LEFT JOIN Orders O
    ON E.EmployeeID = O.EmployeeID AND YEAR(O.OrderDate)=1997 AND MONTH(O.OrderDate)=2
        LEFT JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
GROUP BY E.FirstName, E.LastName;

--Kolos 2022 wt. 15:00
--Ćwiczenie 1
/*Podaj liczbę̨ zamówień oraz wartość zamówień (bez opłaty za przesyłkę) obsłużonych przez każdego pracownika
w marcu 1997. Za datę obsłużenia zamówienia należy uznać datę jego złożenia (orderdate). Jeśli pracownik nie
obsłużył w tym okresie żadnego zamówienia, to też powinien pojawić się na liście (liczba obsłużonych zamówień
oraz ich wartość jest w takim przypadku równa 0). Zbiór wynikowy powinien zawierać: imię i nazwisko pracownika,
liczbę obsłużonych zamówień, wartość obsłużonych zamówień, oraz datę najpóźniejszego zamówienia (w badanym okresie)*/
SELECT E.FirstName, E.LastName, COUNT(O.OrderDate) AS Totalnumber, COALESCE(SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)),0) AS Totalvalue, MAX(O.OrderDate) AS LastOrderDate
FROM Employees E
    LEFT JOIN Orders O
    ON E.EmployeeID = O.EmployeeID AND YEAR(O.OrderDate)=1997 AND MONTH(O.OrderDate)=3
        LEFT JOIN [Order Details] OD
        ON O.OrderID = OD.OrderID
GROUP BY E.FirstName, E.LastName;

--Ćwiczenie 2
/*Dla każdego klienta podaj imię i nazwisko pracownika, który w 1997r obsłużył najwięcej jego zamówień, podaj
także liczbę tych zamówień (jeśli jest kilku takich pracownikow to wystarczy podać imię nazwisko jednego nich).
Zbiór wynikowy powinien zawierać nazwę klienta, imię i nazwisko pracownika oraz liczbę obsłużonych zamówień*/
--nie jest w pelni to co ma byc
SELECT C.CompanyName, E.FirstName, E.LastName, COUNT(O.OrderID) AS Totalorders
FROM Customers C
    JOIN Orders O
    ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate)=1997
        JOIN Employees E
        ON O.EmployeeID = E.EmployeeID
GROUP BY C.CompanyName, E.FirstName, E.LastName
ORDER BY C.CompanyName, Totalorders DESC;