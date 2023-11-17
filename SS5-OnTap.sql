CREATE DATABASE SS5_ONTAP_01;
USE SS5_ONTAP_01;

CREATE TABLE Custome(
cID int auto_increment primary key,
cName varchar(50),
cAge int
);

CREATE table Ordere(
oID int auto_increment primary key,
cID int ,
foreign key (cID) references Custome(cID),
oDate date,
oTotalprice float,
status bit(1)
);

CREATE TABLE Product(
pID int  auto_increment primary key,
pName varchar(50),
pPrice float
);

CREATE TABLE OrderDetail(
oID int auto_increment primary key,
foreign key (oID) references Ordere(oID),
pID int, 
foreign key (pId) references Product(pId),
odQTY int
);

insert into Custome(cID,cName,cAge) values(1,'minh quan',10);
insert into Custome(cID,cName,cAge) values(2,'ngoc oanh',20);
insert into Custome(cID,cName,cAge) values(3,'hong ha',50);

insert into Ordere(oID,cID,oDate,oTotalprice,status) values(1,1,'2023-11-11',12000,1);
insert into Ordere(oID,cID,oDate,oTotalprice,status) values(2,2,'2023-8-10',13000,0);
insert into Ordere(oID,cID,oDate,oTotalprice,status) values(3,1,'2023-6-9',14000,1);

insert into Product(pID,pName,pPrice) values(1,'may giat',3);
insert into Product(pID,pName,pPrice) values(2,'tu lanh',5);
insert into Product(pID,pName,pPrice) values(3,'dieu hoa',7);
insert into Product(pID,pName,pPrice) values(4,'quat',1);
insert into Product(pID,pName,pPrice) values(5,'bep dien',2);

insert into OrderDetail(oID,pID,odQTY) values(1,1,3);
insert into OrderDetail(oID,pID,odQTY) values(2,1,1);
insert into OrderDetail(oID,pID,odQTY) values(3,1,8);


-- Thực hiện đánh chỉ mục trên trường name, bảng customer 
create unique index index_test on Custome(cName);


-- Tạo view hiển thị danh sách đơn hàng (case when ) id , userName , status
-- status = 0 thì hiển thị đang chờ xử lý
-- status = 1 thì hiện thị dang giao hàng
-- status = 2 thì hiển thị đã hoàn tất 
create view hien_thi_don_hang as
select o.oID as id,c.cName as userName,
case
	when o.status = 0 then 'Đang chờ xử lý'
	when o.status = 1 then 'Đang giao hàng'
	when o.status = 2 then 'Đã hoàn tất'
	else 'Không xác định'
end as status
from Ordere o
join Custome c on o.cID = c.cID;


-- Tạo thủ tục thêm mới sản phẩm
DELIMITER //
create procedure them_moi_sp(in pProductName varchar(50), in pProductPrice float)
begin
    insert into Product(pName, pPrice) values (pProductName, pProductPrice);
end ;
//


-- Tạo thủ tục lấy ra 5 sản phẩm có giá cao nhất 
DELIMITER //
create procedure lay_ra_5sp()
begin
    select * from Product order by pPrice desc limit 5;
end ;
//


-- Tạo thủ tục cập nhật
DELIMITER //
create procedure cap_nhat_sp( in pProductID int,in pProductName varchar(50),in pProductPrice float)
begin
    update Product
    set pName = pProductName, pPrice = pProductPrice
    where pID = pProductID;
end ;
//


-- Tạo thủ tục xóa sản phẩm 
DELIMITER //
create procedure xoa_san_pham(in pProductID int)
begin
    delete from Product where pID = pProductID;
end ;
//










