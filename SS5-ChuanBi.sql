CREATE DATABASE SS5_CHUAN_BI;
USE SS5_CHUAN_BI;

CREATE TABLE orders (
customer_id int primary key,
order_date date,
total_amount int
);
insert into orders values(1,'2023-2-2',12000);
insert into orders values(2,'2023-2-2',11000);
insert into orders values(3,'2023-2-2',10000);

select * from orders
limit 1 offset 2;

--  Cú pháp tạo chỉ mục INDEX
CREATE TABLE USER(
id int ,
email varchar(50),
age varchar(30)
);

insert into USER values(1,'ths@gmail.com',26);
insert into USER values(2,'th@gmail.com',27);
insert into USER values(3,'ts@gmail.com',28);

CREATE UNIQUE INDEX test_index
on USER(email);

EXPLAIN select * FROM USER WHERE email LIKE 'ths%'; 
EXPLAIN select * FROM USER WHERE email LIKE 'th%'; 









