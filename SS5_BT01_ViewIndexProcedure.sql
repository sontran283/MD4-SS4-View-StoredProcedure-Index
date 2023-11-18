CREATE DATABASE SS5_BT01_ViewIndexProcedure;
USE SS5_BT01_ViewIndexProcedure;

CREATE TABLE Products(
id int primary key auto_increment,
productCode int,
productName varchar(50),
productPrice double,
productAmount int,
productDescription text,
productStatus bit default 1
);

insert into Products(productCode,productName,productPrice,productAmount,productDescription) values(001,'san pham 1',12000,1,'ngon bo gie');
insert into Products(productCode,productName,productPrice,productAmount,productDescription) values(002,'san pham 2',12000,2,'ngon bo gie');
insert into Products(productCode,productName,productPrice,productAmount,productDescription) values(003,'san pham 3',12000,3,'ngon bo gie');

-- Bước 3:
-- Bước 3:
-- • Tạo Unique Index trên bảng Products (sử dụng cột productCode để tạo chỉ mục)
CREATE unique index index_productCode ON Products(productCode);

-- • Tạo Composite Index trên bảng Products (sử dụng 2 cột productName và productPrice)
create index index_Composite_Products ON Products(productName,productPrice);

-- • Sử dụng câu lệnh EXPLAIN để biết được câu lệnh SQL của bạn thực thi như nào
explain select * from Products where productCode =001;

-- Bước 4:
-- Bước 4:
-- • Tạo view lấy về các thông tin: productCode, productName, productPrice, productStatus từ bảng products.
create view show_view_products 
as
select P.productCode, P.productName, P.productPrice, P.productStatus 
from Products P
order by P.productCode, P.productName, P.productPrice, P.productStatus;

-- • Tiến hành sửa đổi view
-- c1:
create view show_view_products 
as
select P.productCode, P.productName, P.productPrice, P.productStatus 
from Products P
join Category C ON P.id = C.id
where p.price > 10000;

-- c2:
create or REPLACE view show_view_products as
select productCode, productName, productPrice, productStatus, productAmount
from Products;

-- lay ra view
select * from show_view_products;

-- xoa view
drop view show_view_products;

-- Bước 5:
-- Bước 5:
-- • Tạo store procedure lấy tất cả thông tin của tất cả các sản phẩm trong bảng product
delimiter //
create procedure get_procedure_products()
begin
 select * from Products;
end;
call get_procedure_products;

-- • Tạo store procedure thêm một sản phẩm mới
delimiter //
create procedure add_product(IN productCode_new int ,IN productName_new varchar(50),IN productPrice_new double,IN productAmount_new int,IN productDescription_new text)
begin
insert into Products(productCode,productName,productPrice,productAmount,productDescription) values (productCode_new,productName_new,productPrice_new,productAmount_new,productDescription_new);
end;
//
call add_product(004,'san pham 4',12000,4,'ngon bo gie');

-- Tạo thủ tục lấy ra 5 sản phẩm có giá cao nhất 
delimiter //
create procedure lay_ra_5sp()
begin
    select * from Product order by pPrice desc limit 5;
end ;
//
call lay_ra_5sp;

-- • Tạo store procedure sửa thông tin sản phẩm theo id
delimiter //
create procedure update_product(IN productCode_new int ,IN productName_new varchar(50),IN productPrice_new double,IN productAmount_new int,IN productDescription_new text)
begin
  update Products
  set productCode = productCode_new, productName = productName_new
  where id = productCode_new;
end;
//
call update_product(1);

-- • Tạo store procedure xoá sản phẩm theo id
delimiter //
create procedure delete_product(in id_new int)
begin
 delete from Products where id = id_new;
end;
//
call delete_product(1);



























