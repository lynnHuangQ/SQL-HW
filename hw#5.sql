--1.	What is an object in SQL?
--		An object is any SQL Server resource? used to store or reference data.
--2.	What is Index? What are the advantages and disadvantages of using Indexes?
--		Indexes are database objects based on table column for faster retrieval of data.
--		avantage- allow SQL server to find data in a table without scanning the entire table.
--		disadvantge- additional disk space, and slow down the insert, update,delete statement.
--3.	What are the types of Indexes?
--		clustered and none clustered inedex
--4.	Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
--		if a clustered index does not already exist on the table or view, then SQL Server automatically creates a index.
--   	It is under the primary key constraints
--5.	Can a table have multiple clustered index? Why?
--		no, only one clustered index in a table. data rows themselves can only be sorted in one order
--6.	Can an index be created on multiple columns? Is yes, is the order of columns matter?
--		Yes, order does not matter.
--7.	Can indexes be created on views?
--		Yes.
--8.	What is normalization? What are the steps (normal forms) to achieve normalization?
--		a process of organizing data to minimize data duplication.
--		1st NF, 2nd NF, 3rd NF, BCNF
--9.	What is denormalization and under which scenarios can it be preferable?
--		Denormalization is a database optimization technique in which we add redundant data to one or more tables.
--10.	How do you achieve Data Integrity in SQL Server?
--		apply Entity integrity to the Table by specifying a primary key, unique key, and not null.
--11.	What are the different kinds of constraint do SQL Server have?
--      NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK ,DEFAULT, CREATE INDEX
--12.	What is the difference between Primary Key and Unique Key?
--		primary key is a combination of not null and unique. only one primary key in a table, and can not accept null value.
--13.	What is foreign key?
--		a column or combination of columns that is used to establish and enforce a link between the data in 2 tables.
--14.	Can a table have multiple foreign keys?
--		yes
--15.	Does a foreign key have to be unique? Can it be null?
--		no, and it can be null
--16.	Can we create indexes on Table Variables or Temporary Tables?
--		Index cannot be created in Table variable, but it can be created in temp table
--17.	What is Transaction? What types of transaction levels are there in SQL Server?
--		a logical unit of work. Read Uncommitted, Read Committed, and Repeatable Read

--Write queries for following scenarios
--1.	Write an sql statement that will display the name of each customer and the sum of order totals placed by that customer during the year 2002
Create table customer(cust_id int,  iname varchar (50)) 
create table order(order_id int,cust_id int,amount money,order_date smalldatetime)

select c.iname, count(order_id) as total
from customer c
inner join order o on c.cust_id = o.cust_id
where year(o.order_date)=2002
group by c.iname

-- 2.  The following table is used to store information about company’s personnel:
Create table person (id int, firstname varchar(100), lastname varchar(100)) 
--write a query that returns all employees whose last names  start with “A”.
select * from person
where lastname like 'A%'

--3.  The information about company’s personnel is stored in the following table:
Create table person(person_id int primary key, manager_id int null, name varchar(100)not null)
--The filed managed_id contains the person_id of the employee’s manager.
--Please write a query that would return the names of all top managers(an employee who does not have  a manger, and the number of people that report directly to this manager.
SELECT name FROM person 
WHERE manager_id IS NULL
--4.  List all events that can cause a trigger to be executed.
--		DML statements like insert, delete and update

--5. Generate a destination schema in 3rd Normal Form.  
--Include all necessary fact, join, and dictionary tables, and all Primary and Foreign Key relationships.  
--The following assumptions can be made:
--a. Each Company can have one or more Divisions.
--b. Each record in the Company table represents a unique combination 
--c. Physical locations are associated with Divisions.
--d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
--e. Contacts can be associated with one or more divisions and the address, 
--	but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.


CREATE TABLE Company(
	companyId int primary key,
	name varchar(20) not null,
	address varchar(20),
	city varchar(20),
	country varchar(20)
)

CREATE TABLE Division(
	divisionId int primary key,
	name varchar(20)not null,
	address varchar(20),
	city varchar(20),
	country varchar(20),
	companyId int FOREIGN KEY REFERENCES Company(companyId)
)

CREATE TABLE Contact(
	contactID int primary key,
	name varchar(20)not null,
	address varchar(20),
	city varchar(20),
	country varchar(20)
)


CREATE TABLE Record(
	rid int primary key,
	companyId int FOREIGN KEY REFERENCES Company(companyId),
	divisionId int FOREIGN KEY REFERENCES Division(divisionId),
	contactId int FOREIGN KEY REFERENCES Contact(contactID)
)
