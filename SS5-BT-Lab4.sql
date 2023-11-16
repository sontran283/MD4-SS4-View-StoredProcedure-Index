CREATE DATABASE SS5_bt02;
USE SS5_bt02;

CREATE TABLE Custome(
cID int primary key,
cName varchar(50),
cAge int
);

CREATE table Ordere(
oID int primary key,
cID int ,
foreign key (cID) references Custome(cID),
oDate date,
oTotalprice float
);

CREATE TABLE Product(
pID int primary key,
pName varchar(50),
pPrice float
);

CREATE TABLE OrderDetail(
oID int primary key,
foreign key (oID) references Ordere(oID),
pID int, 
foreign key (pId) references Product(pId),
odQTY int
);

insert into Custome(cID,cName,cAge) values(1,'minh quan',10);
insert into Custome(cID,cName,cAge) values(2,'ngoc oanh',20);
insert into Custome(cID,cName,cAge) values(3,'hong ha',50);

insert into Ordere(oID,cID,oDate,oTotalprice) values(1,1,'2023-11-11',null);
insert into Ordere(oID,cID,oDate,oTotalprice) values(2,2,'2023-10-10',null);
insert into Ordere(oID,cID,oDate,oTotalprice) values(3,1,'2023-9-9',null);

insert into Product(pID,pName,pPrice) values(1,'may giat',3);
insert into Product(pID,pName,pPrice) values(2,'tu lanh',5);
insert into Product(pID,pName,pPrice) values(3,'dieu hoa',7);
insert into Product(pID,pName,pPrice) values(4,'quat',1);
insert into Product(pID,pName,pPrice) values(5,'bep dien',2);

insert into OrderDetail(oID,pID,odQTY) values(1,1,3);
insert into OrderDetail(oID,pID,odQTY) values(2,1,1);
insert into OrderDetail(oID,pID,odQTY) values(3,1,8);

-- 2. Hiển thị các thông tin gồm oID,cID, oDate, oPrice của tất cả các hóa đơn trong bảng Ordere,
-- danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên như hình sau:
select oID,cID, oDate, oTotalprice 
from Ordere
order by oDate desc;

-- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:
select product.pName, product.pPrice
from Product
where pPrice = (select max(pPrice) from Product);

-- 4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau:
select C.cID,C.cName,P.pName
FROM Custome C
join Ordere O ON C.cID = O.cID
join OrderDetail ORD ON O.oID = ORD.oID
join Product P ON ORD.pID = p.pID
group by C.cID,C.cName,P.pName;

-- 5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau:
select C.cID, C.cName , O.oDate
from Custome C
left join Ordere O ON C.cID = O.cID
where O.oDate is null;

-- 6. Hiển thị chi tiết của từng hóa đơn như sau :
select O.oID , O.oDate, ORD.odQTY, P.pName, P.pPrice
From Ordere O
join OrderDetail ORD ON O.oID = ORD.oID
join Product P ON ORD.pID = P.pID;

-- 7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán
-- của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice) như sau:
select O.oID , O.oDate , sum(odQTY*pPrice) as GIA_TIEN
from Ordere O
join OrderDetail ORD ON O.oID = ORD.oID
join Product P ON ORD.pID = P.pID
group by  O.oID , O.oDate

