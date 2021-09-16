--Answer following questions
--1.	In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
--		join will be faster for small size database
--2.	What is CTE and when to use it?
--		CTE is known as common table expression, is use to create recursive query
--3.	What are Table Variables? What is their scope and where are they created in SQL Server?
--		table variable is a data type that can be used within a TSQL batch, stored procedure, or function,  
--		it is created and defined similarly to a table, only with a strictly defined lifetime scope.
--4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
--		truncate reseeds identity values, removes all records and doesn't fire triggers.
--		delete does not reseeds identity values.
--		truncate is faster than delete, because it use less of the transaction log.
--5.	What is Identity column? How does DELETE and TRUNCATE affect it?
--		Identity cloumn is the values for the column will be provided by the DBMS and not by the user and in some specific manner and restrictions
--		DELETE: Identity of column retains the identity after using DELETE Statement on table.
--		TURNCATE: Identity of the column is reset to its seed value if the table contains an identity column.
--6.	What is difference between “delete from table_name” and “truncate table table_name”?
--		The word TABLE in TRUNCATE TABLE is optional.
--		To remove only specific records in a table, TRUNCATE TABLE cannot be used. 
--		To remove records, must use DELETE statement that includes a WHERE clause

--Write queries for following scenarios
--All scenarios are based on Database NORTHWND.
--1.	List all cities that have both Employees and Customers.
select distinct c.City
from Customers c
inner join Suppliers s on c.City = s.City
--2.	List all cities that have Customers but no Employee.
--a.	Use sub-query
select distinct c.city
from Customers c
where c.city not in (select City from Employees)
--b.	Do not use sub-query
select distinct c.city
from Customers c
left join Employees e on c.city = e.city
where e.city is null
				
--3.	List all products and their total order quantities throughout all orders.
select p.ProductID, sum(od.Quantity) as total
from Products p
left join [Order Details] od on p.ProductID= od.ProductID
group by p.ProductID
--4.	List all Customer Cities and total products ordered by that city.
select c.City, count(o.ShipCity)as total
from Customers c
left join orders o on c.CustomerID=o.CustomerID
group by c.City
--5.	List all Customer Cities that have at least two customers.
--a.	Use union
select c.City, count(c.CustomerID)as total
from Customers c
group by c.City
having count(c.CustomerID)>=2
union
select cu.City, count(cu.CustomerID)as total
from Customers cu
group by cu.City
having count(cu.CustomerID)>=2
--b.	Use sub-query and no union
SELECT * FROM(
SELECT c.City,count(c.CustomerID) FROM Customers c
LEFT JOIN
(SELECT * FROM Northwind.dbo.Customers) cu
ON c.customerid = cu.CustomerID
GROUP BY c.City) dt
WHERE dt.Customers >= 2
--6.	List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City,count(od.ProductID) as total from Customers c
inner join Orders o on c.CustomerID=o.CustomerID
inner join [Order Details]od on od.OrderID=o.OrderID
group by c.City
having count(od.ProductID)>=2
--7.	List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT distinct c.CustomerID, c.ContactName, c.City, o.ShipCity from Customers c
inner join Orders o on c.CustomerID=o.CustomerID
where c.city != o.ShipCity
--8.	List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
select top 5 count(p.ProductID) as product,avg(od.UnitPrice * od.Quantity) as avagePrice, o.ShipCity
from Products p 
left join [Order Details] od on p.ProductID = od.ProductID
left join Orders o on od.OrderID = o.OrderID
group by o.ShipCity
order by avagePrice desc
--9.	List all cities that have never ordered something but we have employees there.
--a.	Use sub-query
SELECT e.City 
FROM Employees e
WHERE e.City NOT IN(SELECT o.ShipCity FROM Northwind.dbo.Orders o)
--b.	Do not use sub-query
select distinct e.City
from Employees e
inner join Orders o on e.EmployeeID = o.EmployeeID
where e.City not in (o.ShipCity)
--10.	List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
select  e.City, count(o.ShipCity)as orders, sum(od.Quantity) as total
from Employees e
inner join orders o on e.EmployeeID = e.EmployeeID
inner join [Order Details] od on o.OrderID=od.OrderID
group by e.City
order by orders desc
--11. How do you remove the duplicates record of a table?
-- use CTE
--12. Sample table to be used for solutions below- Employee ( empid integer, mgrid integer, deptid integer, salary integer) Dept (deptid integer, deptname text)
-- Find employees who do not manage anybody.
SELECT * FROM Employee
WHERE empid != mgrid
--13. Find departments that have maximum number of employees. (solution should consider scenario having more than 1 departments that have maximum number of employees). Result should only have - deptname, count of employees sorted by deptname.
select top 1 d.deptname, count(e.empid) as num
from Dept d
left join Employee e on d.deptid =e.deptid 
group by d.deptname
order by num desc
--14. Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.
select d.deptname,e.empid,top 3 e.salary 
from Dept d
left join Employee e on d.deptid =e.deptid 
order by e.salary