--1.	Design a Database for a company to Manage all its projects.
create database company

create table office (officeId int primary key,
					 name varchar(20) not null,
					 city varchar(20),
					 country varchar(20),
					 address varchar(20),
					 phone int,
					 directorName varchar(20))
create table project (projectId int primary key,
					  title varchar(20) not null,
					  starting_date datetime,
					  end_date datetime,
					  budget money,
					  person_in_charge varchar(20),
					  officeId int foreign key references office(officeId))
create table project_detail(projectId int foreign key references project(projectId),
							operation varchar(20),
							city varchar(20),
							country varchar(20),
							number_inhabitants int)

--2.	Design a database for a lending company which manages lending among people (p2p lending)
create database lcompany
create table lender(lId int primary key,
					name varchar(20)not null,
					available_amount money)
create table borrower (bId int primary key,
					   company varchar(20) not null,
					   risk_value int not null)
create table loan(loanId int primary key,
				  total_amount money not null,
				  refund_deadline datetime not null,
				  interest_rate decimal not null,
				  purpose varchar(20),
				  bId int foreign key references borrower(bId))

create table invest(investId int primary key,
					loanId int foreign key references loan(loanId),
					lId int foreign key references lender(lId),
					amount money not null)
--3.	Design a database to maintain the menu of a restaurant.
create database menu
create table categories(catId int primary key,
						name varchar(20) not null,
						description varchar(20) not null,
						employee_in_charge varchar(20)not null)

create table course(courseId int primary key,
					name varchar(20) not null,
					description varchar(20) not null, 
					photo image not null,
					price money not null,
					catId int FOREIGN KEY REFERENCES categories(catId))
create table recipes(rId int primary key,
					 ingredients varchar(20) not null,
					 amount int not null,
					 unit varchar(20) not null,
					 current_amount int not null,
					 courseId int FOREIGN KEY REFERENCES course(courseId))