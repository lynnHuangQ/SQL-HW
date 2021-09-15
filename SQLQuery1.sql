--1.	What is a result set?
--		It's a set of data which return by a select statement, or stored precedure, saved in RAM and will display on the screen.
--2.	What is the difference between Union and Union All?
--		Union will only extracts the rows that's being specified.
--		and union all will extracts all the rows which also includes duplicates.
--3.	What are the other Set Operators SQL Server has?
--		 INTERSECT
--4.	What is the difference between Union and Join?
--		union-combines data into new distinct rows,number of columns selected from each table shoud be same
--		join-it cambines data into new columns,combines data from many tables based on a matched condition
--5.	What is the difference between INNER JOIN and FULL JOIN?
--		inner join- return only the matched row from both table.
--		full join- return rows from both table, even the non-matching rows.
--6.	What is difference between left join and outer join
--		left join- return all rows from left table, and matched rows from right table.
--		outer join- join types, there are three outer joins, left join, right join, full join.
--7.	What is cross join?
--		also known as cartesian join, because it returns the cartesian product of the sets of records from 2 joined tables.
--8.	What is the difference between WHERE clause and HAVING clause?
--		where clause used to qualify the rows that are returned before data is grouped, is used before group by
--		having clause qualifies the aggregated data after the data has been grouped, is used after group by
--9.	Can there be multiple group by columns?
--		yes

--Write queries for following scenarios
--1.	How many products can you find in the Production.Product table?
SELECT count(ProductID) from Production.Product
--2.	Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT count(ProductID) from Production.Product
WHERE ProductSubcategoryID is not null
--3.	How many Products reside in each SubCategory? Write a query to display the results with the following titles.
--ProductSubcategoryID CountedProducts
---------------------- ---------------
SELECT ProductSubcategoryID, count(1)as CountedProducts from Production.Product 
group by ProductSubcategoryID
--4.	How many products that do not have a product subcategory. 
SELECT count(ProductID) from Production.Product
WHERE ProductSubcategoryID is null
--5.	Write a query to list the summary of products quantity in the Production.ProductInventory table.
SELECT * from Production.ProductInventory
--6.	 Write a query to list the summary of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--              ProductID    TheSum
-------------        ----------
SELECT ProductID, sum(Quantity)as TheSum from Production.ProductInventory
WHERE LocationID=40 and Quantity<100
group by ProductID
--7.	Write a query to list the summary of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
--Shelf      ProductID    TheSum
------------ -----------        -----------
SELECT shelf, ProductID, sum(Quantity)as TheSum from Production.ProductInventory
WHERE LocationID=40 and Quantity<100
group by ProductID
--8.	Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT avg(Quantity) from Production.ProductInventory
where LocationID=10
--9.	Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
--ProductID   Shelf      TheAvg
------------- ---------- -----------
SELECT ProductID, Shelf, avg(Quantity) as TheAvg from Production.ProductInventory
group by shelf, ProductID
--10.	Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
--ProductID   Shelf      TheAvg
------------- ---------- -----------
SELECT ProductID, Shelf, avg(Quantity) as TheAvg from Production.ProductInventory
group by  shelf, ProductID
having Shelf not in ('N/A')

--11.	List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--Color           	Class 	TheCount   	 AvgPrice
----------------	- ----- 	----------- 	---------------------
SELECT Color, Class, count(1) as TheCount, avg(ListPrice) as AvgPrice from Production.Product
group by color, class
having Color not in ('N/A') and Class not in ('N/A')
--Joins:
--12.	  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 

--Country                        Province
-----------                          ----------------------
select c.CountryRegionCode as Country,s.Name as Province
from person.CountryRegion c
left join person.StateProvince s on c.CountryRegionCode=s.CountryRegionCode


--13.	Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

--Country                        Province
-----------                          ----------------------

select c.CountryRegionCode as Country,s.Name as Province
from person.CountryRegion c
left join person.StateProvince s on c.CountryRegionCode=s.CountryRegionCode
where c.Name in ('Germany','Canada')

--        Using Northwnd Database: (Use aliases for all the Joins)
--14.	List all Products that has been sold at least once in last 25 years.
select od.ProductID
from dbo.[Order Details] od
left join Orders o on od.OrderID=o.OrderID
where DATEDIFF(YEAR,o.OrderDate,GETDATE())<=25
--15.	List top 5 locations (Zip Code) where the products sold most.
select top 5 o.ShipPostalCode, sum(od.Quantity) as sold
from dbo.[Order Details] od
left join Orders o on od.OrderID=o.OrderID
group by o.ShipPostalCode
order by sum(od.Quantity) desc
--16.	List top 5 locations (Zip Code) where the products sold most in last 20 years.
select top 5 o.ShipPostalCode, sum(od.Quantity) as sold
from dbo.[Order Details] od
left join Orders o on od.OrderID=o.OrderID
where DATEDIFF(YEAR,o.OrderDate,GETDATE())<=20
group by o.ShipPostalCode
order by Quantity desc
--17.	 List all city names and number of customers in that city.   
select city, count(1)as NumCustomer
from dbo.Customers 
group by city
--18.	List city names which have more than 10 customers, and number of customers in that city 
select city, count(1)as NumCustomer
from dbo.Customers 
group by city
having count(1)>10
--19.	List the names of customers who placed orders after 1/1/98 with order date.
select c.ContactName, o.OrderDate
from dbo.Orders o
left join Customers c on o.CustomerID=c.CustomerID
where o.OrderDate>= '1998-01-01'

--20.	List the names of all customers with most recent order dates 
select c.ContactName, o.OrderDate
from dbo.Orders o
left join Customers c on o.CustomerID=c.CustomerID
order by o.OrderDate desc

--21.	Display the names of all customers  along with the  count of products they bought 
select c.ContactName, sum(od.Quantity)as quantity
from dbo.Orders o
join Customers c on o.CustomerID=c.CustomerID
join dbo.[Order Details] od on o.OrderID = od.OrderID
group by c.ContactName

--22.	Display the customer ids who bought more than 100 Products with count of products.
select o.CustomerID, sum(od.Quantity)as quantity
from dbo.Orders o
join dbo.[Order Details] od on o.OrderID = od.OrderID
group by o.CustomerID
having sum(od.Quantity)>100

--23.	List all of the possible ways that suppliers can ship their products. Display the results as below
--Supplier Company Name   	Shipping Company Name
-----------------------------------            ----------------------------------
SELECT DISTINCT s.CompanyName AS 'Supplier Company Name', sh.CompanyName AS 'Shipping Company Name' FROM Northwind.dbo.Orders o
JOIN Northwind.dbo.Shippers sh
ON o.ShipVia = sh.ShipperID
JOIN Northwind.dbo.[Order Details] d
ON o.OrderID = d.OrderID
JOIN Northwind.dbo.Products p
ON d.ProductID = p.ProductID
JOIN Northwind.dbo.Suppliers s
ON s.SupplierID = p.SupplierID
order by s.CompanyName
--24.	Display the products order each day. Show Order date and Product Name.
select p.ProductName, o.OrderDate
from Products p
join [Order Details] od on p.ProductID=od.ProductID
join Orders o on o.OrderID=od.OrderID

--25.	Displays pairs of employees who have the same job title.
select distinct e.EmployeeID,e.LastName, e.FirstName, e.Title
from Employees e
inner join Employees es on e.Title = es.Title
where e.EmployeeID <> es.EmployeeID
--26.	Display all the Managers who have more than 2 employees reporting to them.
select e.EmployeeID, count(1) as numEmp
from Employees e
join Employees es on e.EmployeeID= es.ReportsTo
group by e.EmployeeID
having count(1)>2
--27.	Display the customers and suppliers by city. The results should have the following columns
--City 
--Name 
--Contact Name,
--Type (Customer or Supplier)
select city,CompanyName,ContactName, 'Customers' as type
from Customers

select city,CompanyName,ContactName, 'Suppliers' as type
from Suppliers

-- 28. Have two tables T1 and T2
--F1.T1	F2.T2
--1	2
--2	3
--3	4
SELECT a.*
FROM T1 a
INNER JOIN T2 b
ON a.F1 = b.F2

result: 2, 3
--Please write a query to inner join these two tables and write down the result of this query.
-- 29. Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
SELECT a.*
FROM T1 a
left JOIN T2 b
ON a.F1 = b.F2

result:1,2,3