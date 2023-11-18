Create DATABASE SS5_BT02_View;
USE SS5_BT02_View;

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
oTotalprice float
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

insert into Ordere(oID,cID,oDate) values(1,1,'2023-11-11');
insert into Ordere(oID,cID,oDate) values(2,2,'2023-8-10');
insert into Ordere(oID,cID,oDate) values(3,1,'2023-6-9');

insert into Product(pID,pName,pPrice) values(1,'may giat',3);
insert into Product(pID,pName,pPrice) values(2,'tu lanh',5);
insert into Product(pID,pName,pPrice) values(3,'dieu hoa',7);
insert into Product(pID,pName,pPrice) values(4,'quat',1);
insert into Product(pID,pName,pPrice) values(5,'bep dien',2);

insert into OrderDetail(oID,pID,odQTY) values(1,1,3);
insert into OrderDetail(oID,pID,odQTY) values(2,1,1);
insert into OrderDetail(oID,pID,odQTY) values(3,1,8);

-- 2. Hiển thị các thông tin gồm oID,cID, oDate, oPrice của tất cả các hóa đơn trong bảng Ordere, 
-- danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên như hình sau
select oID, cID, oDate, oTotalprice from Ordere order by oID asc;

select oID, cID, oDate, oTotalprice, SUM(p.pPrice * od.odQTY) as oPrice
from Ordere o
join OrderDetail od on o.oID = od.oID
join Product p ON od.pID = p.pID
group by o.oID, o.cID, o.oDate
order by o.oDate desc;

-- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau
select pName, pPrice
from Product
where pPrice = (select MAX(pPrice) from Product);

-- 4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau: [2.0]
select c.cID,c.cName,o.oID,o.oDate,o.oTotalprice,odr.oID, odr.pID
from Custome c
join Ordere o on c.cID = o.cID
join OrderDetail odr on  o.oID = odr.oID;

-- 5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau: [2.0]
select c.cID, c.cName,o.oDate
from Custome c
left join  Ordere o on c.cID = o.cID 
where o.oDate is null;

-- 6. Hiển thị chi tiết của từng hóa đơn như sau : [2.0]
select o.oID,o.oDate, od.odQTY,p.pName,p.pPrice 
from Ordere o
join OrderDetail od on o.oID = od.oID
join Product P on od.pID = p.pID
order by o.oID,o.oDate, od.odQTY,p.pName,p.pPrice;

select o.oID, o.oDate, c.cID, c.cName, SUM(p.pPrice * od.odQTY) as Total
from Ordere o
join Custome c on o.cID = c.cID
join OrderDetail od on o.oID = od.oID
join Product p on od.pID = p.pID
group by o.oID, o.oDate, c.cID, c.cName;

-- 7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng 
-- tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice) như sau: [2.0]
select o.oID, o.oDate, sum(odQTY*pPrice) as Total
FROM  Ordere o
join OrderDetail od on o.oID = od.oID
join Product p on  od.oID = p.pID
group by od.oID, o.oDate;

-- 8. Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như sau: [2.5]
create view Sales as
select o.oID, o.oDate, c.cID, c.cName, SUM(p.pPrice * od.odQTY) as Total
from Ordere o
join Custome c on o.cID = c.cID
join OrderDetail od on o.oID = od.oID
join Product p on od.pID = p.pID
group by o.oID, o.oDate, c.cID, c.cName;

-- 9. Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng. [1.5]
-- xoá khoá ngoại
alter table OrderDetail drop foreign key orderdetail_ibfk_1;
alter table OrderDetail drop foreign key orderdetail_ibfk_2;
alter table Ordere drop foreign key ordere_ibfk_1;

-- xoá khoá chính
alter table Ordere drop primary key;
alter table Product drop primary key;
alter table Custome drop primary key;

-- 10. Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo: . [2.5]
delimiter //
create trigger cusUpdate
after update on Custome
for each row
begin
    update Ordere
    set cID = new.cID
    where cID = old.cID;
end;
//

-- 11. Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, 
-- strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, 
-- và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail:
delimiter //
create procedure delProduct(IN productName_new varchar(50))
begin
    -- Biến này được sử dụng để lưu trữ giá trị của ID sản phẩm liên quan đến tên sản phẩm được truyền vào stored procedure qua tham số.
    -- Dòng lệnh này khai báo một biến có tên là productIdToDelete và kiểu dữ liệu là INT. Nó cấp phát không gian trong bộ nhớ để lưu trữ giá trị số nguyên.
    declare productIdToDelete INT;

    -- Nhận ID sản phẩm dựa trên tên sản phẩm được cung cấp
    -- Dòng lệnh SELECT này trích xuất ID sản phẩm (pID) từ bảng Product nơi tên sản phẩm trùng với tham số productNameToDelete.
    -- Giá trị trích xuất sau đó được lưu vào biến productIdToDelete.
    select pID into productIdToDelete from Product where pName = productName_new;

    -- Xóa sản phẩm khỏi bảng Sản phẩm
    delete from Product where pName = productName_new;

    -- Xóa thông tin liên quan khỏi bảng OrderDetail
    delete from OrderDetail where pID = productName_new;
end;
//


