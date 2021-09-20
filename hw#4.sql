--Assignment Day4 –SQL:  Comprehensive practice
--Answer following questions
--1.	What is View? What are the benefits of using views?
--		a view is a table based on the result set of an SQL statement, the benefit of using view is that it 
--		helps user to create a backward interface for a table with it's schema changes, and able to customize data.
--2.	Can data be modified through views?
--		data can not be moified through views.
--3.	What is stored procedure and what are the benefits of using it?
--		stored procedure groups one or more TSQL statments into a single logical unit, which stored as an object
--		in a SQL server database, it execute faster, increase database security, and help centralize TSQL cold in the data tier.
--4.	What is the difference between view and stored procedure?
--		view show data stored in the datable table, and stored procedure is a group of statement that can be excuted.
--5.	What is the difference between stored procedure and functions?
--		it's mandatory for function to use RETURNS and RETURN arguments, but stored procedure can return none or n values.
--6.	Can stored procedure return multiple result sets?
--		stored procedure can return multiple result sets.
--7.	Can stored procedure be executed as part of SELECT Statement? Why?
--		stored procedure can be executed as part of SELECT Statement, because it encourage code reusability
--8.	What is Trigger? What types of Triggers are there?
--		trigger is a special type of stored procedure that get executed when a specific event happens.
--		there are DDL and DML trigger
--9.	What are the scenarios to use Triggers?
--		Insert, Delete, Update statement on a specific table
--		CREATE, ALTER , or DROP statement on any schema object
--10.	What is the difference between Trigger and Stored Procedure?
--		trigger is a store procedure that runs automatically when various events happen, and stored procedure is
--		a group of code that can be run.
--Write queries for following scenarios
--Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.
--1.	Lock tables Region, Territories, EmployeeTerritories and Employees. Insert following information into the database. In case of an error, no changes should be made to DB.
--a.	A new region called “Middle Earth”;
select * from Region with (tablockx)
insert into Region(RegionID,RegionDescription) values(5,'Middle Earth')
--b.	A new territory called “Gondor”, belongs to region “Middle Earth”;
select * from Territories with (tablockx)
insert into Territories(TerritoryID,TerritoryDescription,RegionID)values (98105,'Gondor',5)
--c.	A new employee “Aragorn King” who's territory is “Gondor”.
select * from Employees
insert into Employees (FirstName,LastName)values ('Aragorn','King')
select * from EmployeeTerritories
insert into EmployeeTerritories (EmployeeID,TerritoryID) values(10,5)
--2.	Change territory “Gondor” to “Arnor”.
update Territories
set TerritoryDescription = 'Arnor'
where TerritoryDescription = 'Gondor'
--3.	Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget WHERE or you will delete everything.) In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.
delete from Region
where RegionDescription = 'Middle Earth'
--4.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
create view view_product_order_huang as
select ProductID, sum(Quantity) as total
from [Order Details]
group by ProductID
go
--5.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
create proc sp_product_order_quantity_huang @id int, @total int out
as
begin
select @total = sum(quantity) from [Order Details] where ProductID = @id
end
go
--6.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
create proc sp_product_order_city_huang @name varchar(20), @city varchar(20) out, @total int out
as
begin
select * from
(select o.shipcity,sum(od.Quantity)as total,DENSE_RANK()over(order by sum(od.quantity)desc)as rank
from Orders o
left join [Order Details] od on o.OrderID = od.OrderID
left join Products p on od.ProductID = p.ProductID
where p.ProductName=@name
group by o.ShipCity) dt
where dt.rank<=5
end
go
--7.	Lock tables Region, Territories, EmployeeTerritories and Employees. Create a stored procedure “sp_move_employees_[your_last_name]” that automatically find all employees in territory “Tory”; if more than 0 found, insert a new territory “Stevens Point” of region “North” to the database, and then move those employees to “Stevens Point”.
SELECT * FROM Region WITH (TABLOCKX)
SELECT * FROM Territories WITH (TABLOCKX)
SELECT * FROM EmployeeTerritories WITH (TABLOCKX)
SELECT * FROM Employees WITH (TABLOCKX)
create proc sp_move_employees_huang @terroity varchar(30) = 'tory'
AS
begin
IF EXISTS(
	SELECT e.FirstName, e.LastName FROM Employees e
	LEFT JOIN EmployeeTerritories et
	ON e.EmployeeID = et.EmployeeID
	LEFT JOIN Territories te
	ON et.TerritoryID = te.TerritoryID
	WHERE te.TerritoryDescription = 'Tory'
)
end

insert into Territories values (98106, 'Stevens Point',3)
--8.	Create a trigger that when there are more than 100 employees in territory “Stevens Point”, move them back to Troy. (After test your code,) remove the trigger. Move those employees back to “Troy”, if any. Unlock the tables.
create trigger movetrigger on territories
for update
as
update territories
set territoryDescription='Troy'
where territoryDescription = 'Stevens Point'
--9.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE city_huang (id int,City varchar(20),
);
INSERT INTO city_huang VALUES(1, 'Seattle')
INSERT INTO city_huang VALUES(2, 'Green Bay')

create table people_huang (ID int, name varchar(20),city int);
insert into people_huang values (1,'Aaron Rodgers',2)
insert into people_huang values (2,'Russell Wilson',1)
insert into people_huang values (3,'Jody Nelson, ',2)

delete from city_huang where city = 'Seattle'
update city_huang set city = 'Madison' where city is null

create view Packers_huang 
as 
select * from people_huang
where city=(select city from city_huang where city='Green Bay');
--10.	 Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
create proc sp_birthday_employees_huang as
begin
create table birthday_employees_huang as
	select FirstName, LastName, BirthDate 
	from Employees
	where month(BirthDate) = 2
end
--11.	Create a stored procedure named “sp_your_last_name_1” that returns all cites that have at least 2 customers who have bought no or only one kind of product. Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).
create proc sp_huang_1 as
begin
select c.City, COUNT(o.OrderID) AS Total
from Customers c
left join orders o on o.CustomerID = c.CustomerID
where c.CustomerID not in (select CustomerID from Customers)
group by c.City
having COUNT(o.orderID)<=1
end

create proc sp_huang_2 as
begin 
SELECT c.City, COUNT(o.OrderID) AS Total FROM Customers c
	LEFT JOIN Orders o
	ON c.CustomerID = o.CustomerID
	LEFT JOIN Customers cc
	ON c.CustomerID = cc.CustomerID
	WHERE c.CustomerID <> cc.CustomerID
	GROUP BY c.City
	HAVING COUNT(o.OrderID) <= 1
end
--12.	How do you make sure two tables have the same data?
--union 2 table, and if result set is more than the table, than they are not same
--14.
--First Name	Last Name	Middle Name
--John	Green	
--Mike	White	M
--Output should be
--Full Name
--John Green
--Mike White M.
--Note: There is a dot after M when you output.
select concat(firstname,lastname,middlename) as fullname
from table
--15.
--Student	Marks	Sex
--Ci	70	F
--Bob	80	M
--Li	90	F
--Mi	95	M
--Find the top marks of Female students.
--If there are to students have the max score, only output one.
select top 1 student, max(marks) from table
where sex = 'F'
--16.
--Student	Marks	Sex
--Li	90	F
--Ci	70	F
--Mi	95	M
--Bob	80	M
--How do you out put this?

select * from table
order by sex, marks desc