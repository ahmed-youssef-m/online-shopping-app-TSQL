-- Creating database for online shopping system which allows consumers to directly buy goods from our store or another seller using our website.

-------------------------------------------------------------------------------- Database FILES
use master;
go

create database onlineShopping  on(
name = onlineShopping_meta_data,
filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\onlineShopping_meta_data.mdf',
size=10,
maxsize=12,
filegrowth=2)
log on(
name = onlineShopping_log_data,
filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\onlineShopping_log_data.ldf',
size=10,
maxsize=12,
filegrowth=2);

go
-------------------------------------------------------------------------------- PRIME SCHEMA

use onlineShopping ;
go

create schema onlineShopping_primeSchema;

-------------------------------------------------------------------------------- CANCELLATION RELATION (TABLE 1)

use onlineShopping ;
go

create table onlineShopping_primeSchema.CANCELLATION(
ORD_ID bigint,
CANC_Date datetime2 not null,
RefundAmount money not null,
ACC_ID bigint,

constraint pk_CANCELLATION primary key (ORD_ID)
-- Not existing RELATIONS (1)
-- constraint fk_ORDER_CANCELLATION foreign key (ORD_ID) references onlineShopping_primeSchema.ORDER (ORD_ID)
-- on update cascade     on delete cascade,
-- constraint fk_ACCOUNT_CANCELLATION foreign key (ACC_ID) references onlineShopping_primeSchema.ACCOUNT (ACC_ID)
-- on update cascade     on delete cascade
);

-------------------------------------------------------------------------------- CUSTOMER RELATION (TABLE 2)

create table onlineShopping_primeSchema.CUSTOMER(
CUST_ID bigint,
FirstName varchar(25),
LastName varchar(25),
Email  varchar(50),
Address varchar(100) not null,

constraint pk_CUSTOMER primary key (CUST_ID),
constraint un_CUSTOMER unique (FirstName,LastName,Email)
);

-------------------------------------------------------------------------------- PhoneNumber RELATION (TABLE 3)

create table onlineShopping_primeSchema.PhoneNumber(
CUST_ID bigint,
PhoneNumber varchar (25),

constraint pk_PhoneNumber primary key (CUST_ID,PhoneNumber),
constraint fk_CUSTOMER_CANCELLATION foreign key (CUST_ID) references onlineShopping_primeSchema.CUSTOMER (CUST_ID)
on update cascade on delete cascade 
);

-------------------------------------------------------------------------------- PRODUCT RELATION (TABLE 4)

use onlineShopping ;
go

create table onlineShopping_primeSchema.PRODUCT(
PROD_ID bigint,
PROD_Name varchar(50) not null,
Brand varchar(20) default 'NEW BRAND',
PROD_Price money not null,
Description varchar(300) default 'It is just a new product',
Availability varchar(15) not null default 'Not Available',

constraint pk_PRODUCT primary key (PROD_ID),
);

-------------------------------------------------------------------------------- CART RELATION (TABLE 5)

create table onlineShopping_primeSchema.CART(
    CAR_ID bigint,
    ORD_ID bigint default 1002,
    ItemsQuantity int not null default 0,

    constraint pk_CART primary key (CAR_ID)
    -- Not existing RELATIONS (2)
    -- constraint fk_ORDER_CART foreign key (ORD_ID) references onlineShopping_primeSchema.ORDER (ORD_ID)
    -- on update cascade on delete set default 
);

-------------------------------------------------------------------------------- ACCOUNT RELATION (TABLE 6)

create table onlineShopping_primeSchema.ACCOUNT(
ACC_ID bigint,
UserName varchar(25),
Password varchar(30),
CUST_ID bigint,

constraint pk_ACCOUNT primary key (ACC_ID),
constraint un_ACCOUNT unique (UserName,Password),
constraint fk_CUSTOMER_ACCOUNT foreign key (CUST_ID) references onlineShopping_primeSchema.CUSTOMER (CUST_ID)
on update cascade on delete cascade 
);

-------------------------------------------------------------------------------- BILL RELATION (TABLE 7)

use onlineShopping ;
go

create table onlineShopping_primeSchema.BILL(
ORD_ID bigint,
BIL_Date datetime2 not null,
BIL_Value money,
Discount numeric(4,2),
CardName varchar(20) not null,
CardNumber varchar(50) not null,
ACC_ID bigint,

constraint pk_BILL primary key (ORD_ID),
-- Not existing RELATIONS (3)
-- constraint fk_ORDER_BILL foreign key (ORD_ID) references onlineShopping_primeSchema.ORDERS (ORD_ID)
-- on update cascade on delete set null,
constraint fk_ACCOUNT_BILL foreign key (ACC_ID) references onlineShopping_primeSchema.ACCOUNT (ACC_ID)
on update cascade on delete cascade,
constraint ck_BILL check (Discount between 00.00 and 100.00)
-- constraint ck_BILL check ( 00.00 <= Discount and Discount < 100.00)
);

-------------------------------------------------------------------------------- ORDER RELATION (TABLE 8)

create table onlineShopping_primeSchema.ORDERS(
    ORD_ID bigint,
    ORD_Number bigint identity(1,1),
    ORD_Date datetime2 not null, 
    ACC_ID bigint ,

    constraint pk_ORDER primary key (ORD_ID),
    constraint fk_ACCOUNT_ORDER foreign key (ACC_ID) references onlineShopping_primeSchema.ACCOUNT (ACC_ID)
    on update cascade on delete cascade 
);

-------------------------------------------------------------------------------- AddedTO RELATION (TABLE 9)

create table onlineShopping_primeSchema.AddedTO(
    PROD_ID bigint,
    CAR_ID bigint,

    constraint pk_AddedTO primary key (PROD_ID,CAR_ID),
    constraint fk_PRODUCT_AddedTO foreign key (PROD_ID) references onlineShopping_primeSchema.PRODUCT (PROD_ID)
    on update cascade on delete cascade,
    constraint fk_CART_AddedTO foreign key (CAR_ID) references onlineShopping_primeSchema.CART (CAR_ID)
    on update cascade on delete cascade 
);

-------------------------------------------------------------------------------- ADDED RELATION (TABLE 10)

create table onlineShopping_primeSchema.ADDED(
    ACC_ID bigint ,
    PROD_ID bigint,

    constraint pk_ADDED primary key (ACC_ID,PROD_ID),
    constraint fk_PRODUCT_ADDED foreign key (PROD_ID) references onlineShopping_primeSchema.PRODUCT (PROD_ID)
    on update cascade on delete cascade,
    constraint fk_ACCOUNT_ADDED foreign key (ACC_ID) references onlineShopping_primeSchema.ACCOUNT (ACC_ID)
    on update cascade on delete cascade
);

-------------------------------------------------------------------------------- Not existing RELATIONS MODIFICATION (1)

use onlineShopping ;
go

alter table onlineShopping_primeSchema.CANCELLATION
add constraint fk_ORDER_CANCELLATION foreign key (ORD_ID) references onlineShopping_primeSchema.ORDERS (ORD_ID)
on update cascade     on delete cascade;
alter table onlineShopping_primeSchema.CANCELLATION
add constraint fk_ACCOUNT_CANCELLATION foreign key (ACC_ID) references onlineShopping_primeSchema.ACCOUNT (ACC_ID);

-------------------------------------------------------------------------------- Not existing RELATIONS MODIFICATION (2)

use onlineShopping ;
go

alter table onlineShopping_primeSchema.CART 
add constraint fk_ORDER_CART foreign key (ORD_ID) references onlineShopping_primeSchema.ORDERS (ORD_ID)
on update cascade on delete set default;

-------------------------------------------------------------------------------- Not existing RELATIONS MODIFICATION (3)

use onlineShopping ;
go

alter table onlineShopping_primeSchema.BILL 
add constraint fk_ORDER_BILL foreign key (ORD_ID) references onlineShopping_primeSchema.ORDERS (ORD_ID);

-------------------------------------------------------------------------------- STEPS FOR THE PURPOSE OF PRACTICAL APPLING (DATA DIFINITION LANGUAGE/DDL) --------------------

use master;
go

create database alternativeOnlineShopping;
drop database alternativeOnlineShopping;

use onlineShopping ;
go

create schema onlineShopping_viceSchema;
drop schema  onlineShopping_viceSchema;

create table onlineShopping_primeSchema.PRACTICE(
    PRACT_ID int not null
);

alter table onlineShopping_primeSchema.PRACTICE
add PRACT_Number int ;

alter table onlineShopping_primeSchema.PRACTICE
add constraint pk_PRACTICE primary key (PRACT_ID);

alter table onlineShopping_primeSchema.PRACTICE
alter column PRACT_Number bigint not null;

alter table onlineShopping_primeSchema.PRACTICE
drop constraint pk_PRACTICE;

alter table onlineShopping_primeSchema.PRACTICE
drop column PRACT_Number;

drop table onlineShopping_primeSchema.PRACTICE;

-------------------------------------------------------------------------------- STEPS FOR THE PURPOSE OF PRACTICAL APPLING (DATA MANIPULATION LANGUAGE/DML) -------------------

use onlineShopping;
go

insert into onlineShopping_primeSchema.CUSTOMER(
CUST_ID,FirstName,LastName,Email,Address
)
output inserted.CUST_ID,inserted.FirstName,inserted.LastName,inserted.Email,inserted.Address
values
(100,'Ali','Maged','alimaged@yahoomail.com','5 Tawfiq Diab St Qasr El Nile Cairo Gov'),
(101,'Raouf','Mohanad','raoufmohanad@yahoomail.com','49 Abdulaziz Al Soud Al Manyal Old Cairo');

update onlineShopping_primeSchema.CUSTOMER
set LastName='Yasser'
where CUST_ID=100;

delete 
from onlineShopping_primeSchema.CUSTOMER
where CUST_ID=100;

insert into onlineShopping_primeSchema.CUSTOMER(
CUST_ID,FirstName,LastName,Email,Address
)
output inserted.CUST_ID,inserted.FirstName,inserted.LastName,inserted.Email,inserted.Address
values
(100,'Ali','Maged','alimaged@yahoomail.com','5 Tawfiq Diab St Qasr El Nile Cairo Gov');

-------------------------------------------------------------------------------- STEPS FOR THE PURPOSE OF PRACTICAL APPLING (DATA QUERY LANGUAGE/DQL) -------------------

use onlineShopping;
go

select FirstName ,LastName
from onlineShopping_primeSchema.CUSTOMER
where CUST_ID=101;

select count(FirstName)
from onlineShopping_primeSchema.CUSTOMER;

select avg(CUST_ID)
from onlineShopping_primeSchema.CUSTOMER;

select sum(CUST_ID)
from onlineShopping_primeSchema.CUSTOMER;

select max(CUST_ID)
from onlineShopping_primeSchema.CUSTOMER;

select min(CUST_ID)
from onlineShopping_primeSchema.CUSTOMER;

select FirstName ,LastName
from onlineShopping_primeSchema.CUSTOMER
where CUST_ID between 99 and 102;

select FirstName ,LastName
from onlineShopping_primeSchema.CUSTOMER
order by FirstName desc;

select Address
from onlineShopping_primeSchema.CUSTOMER
where Address like '%Cairo%';

select FirstName ,LastName
from onlineShopping_primeSchema.CUSTOMER
where CUST_ID in( 100 ,101);

insert into onlineShopping_primeSchema.ACCOUNT(
ACC_ID,UserName,Password,CUST_ID
)
output inserted.ACC_ID,inserted.UserName,inserted.Password,inserted.CUST_ID
values
(200,'ali200','a200',100),
(201,'raouf201','r201',101);

select onlineShopping_primeSchema.ACCOUNT.ACC_ID,onlineShopping_primeSchema.ACCOUNT.UserName,onlineShopping_primeSchema.CUSTOMER.CUST_ID
from onlineShopping_primeSchema.ACCOUNT
inner join onlineShopping_primeSchema.CUSTOMER on onlineShopping_primeSchema.ACCOUNT.CUST_ID=onlineShopping_primeSchema.CUSTOMER.CUST_ID;

select onlineShopping_primeSchema.ACCOUNT.ACC_ID,onlineShopping_primeSchema.ACCOUNT.UserName,onlineShopping_primeSchema.CUSTOMER.CUST_ID
from onlineShopping_primeSchema.ACCOUNT
full join onlineShopping_primeSchema.CUSTOMER on onlineShopping_primeSchema.ACCOUNT.CUST_ID=onlineShopping_primeSchema.CUSTOMER.CUST_ID;

select count(FirstName)
from onlineShopping_primeSchema.CUSTOMER
group by LastName;

select FirstName
from onlineShopping_primeSchema.CUSTOMER
union 
select LastName
from onlineShopping_primeSchema.CUSTOMER;

create table onlineShopping_primeSchema.PRACTICE(
    PRACT_ID int not null
);

insert into onlineShopping_primeSchema.PRACTICE(
PRACT_ID)
output inserted.PRACT_ID
values
(10),
(20);

truncate table onlineShopping_primeSchema.PRACTICE;
use onlineShopping;
select FirstName
from onlineShopping_primeSchema.CUSTOMER
where CUST_ID in (select CUST_ID
				  from onlineShopping_primeSchema.CUSTOMER
				  where CUST_ID >20);

insert into onlineShopping_primeSchema.PRACTICE(
PRACT_ID)
output inserted.PRACT_ID
values
(10),
(20);

begin transaction;
update onlineShopping_primeSchema.PRACTICE
set PRACT_ID=15
where PRACT_ID=10;

--rollback;

commit;
