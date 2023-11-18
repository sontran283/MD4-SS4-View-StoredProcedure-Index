CREATE DATABASE SS5_BT03_Assignment;
USE SS5_BT03_Assignment;

create table tblPhim(
PhimID int,
Ten_phim nvarchar(30),
Loai_phim nvarchar(25),
Thoi_gian int
);

insert into tblPhim(PhimID,Ten_phim,Loai_phim,Thoi_gian) values(1,'em be ha noi','tam li',90);
insert into tblPhim(PhimID,Ten_phim,Loai_phim,Thoi_gian) values(2,'nhiem vu bat kha thi','hanh dong',100);
insert into tblPhim(PhimID,Ten_phim,Loai_phim,Thoi_gian) values(3,'di nhan','vien tuong',90);
insert into tblPhim(PhimID,Ten_phim,Loai_phim,Thoi_gian) values(4,'cuon theo chieu gio','tinh cam',120);

create table tblPhong(
PhongID int,
Tenphong nvarchar(20),
Trang_thai tinyint
);

insert into tblPhong(PhongID,Tenphong,Trang_thai) values(1,'phong chieu 1',1);
insert into tblPhong(PhongID,Tenphong,Trang_thai) values(2,'phong chieu 2',1);
insert into tblPhong(PhongID,Tenphong,Trang_thai) values(3,'phong chieu 3',0);

create table tblGhe(
GheID int,
PhongID int,
So_ghe varchar(10)
);

insert into tblGhe(GheID,PhongID,So_ghe) values(1,1,'a3');
insert into tblGhe(GheID,PhongID,So_ghe) values(2,1,'b3');
insert into tblGhe(GheID,PhongID,So_ghe) values(3,2,'a7');
insert into tblGhe(GheID,PhongID,So_ghe) values(4,2,'d1');
insert into tblGhe(GheID,PhongID,So_ghe) values(5,3,'t2');

create table tblVe(
PhimID int,
GheID int,
Ngay datetime,
Trang_thai nvarchar(20)
);

insert into tblVe(PhimID,GheID,Ngay,Trang_thai) values(1,1,'2008-10-20','da ban');
insert into tblVe(PhimID,GheID,Ngay,Trang_thai) values(1,3,'2008-11-20','da ban');
insert into tblVe(PhimID,GheID,Ngay,Trang_thai) values(1,4,'2008-12-23','da ban');
insert into tblVe(PhimID,GheID,Ngay,Trang_thai) values(2,1,'2009-2-14','da ban');
insert into tblVe(PhimID,GheID,Ngay,Trang_thai) values(3,1,'2009-2-14','da ban');
insert into tblVe(PhimID,GheID,Ngay,Trang_thai) values(2,5,'2009-3-8','chua ban');
insert into tblVe(PhimID,GheID,Ngay,Trang_thai) values(2,3,'2009-3-8','chua ban');

-- khoá chính tblPhim
alter table tblPhim
add constraint new_primary_tblPhim primary key identity(PhimID);

-- khoá chính tblPhong
alter table tblPhong
add constraint new_primary_tblPhong primary key identity(PhongID);

-- khoá chính tblGhe
alter table tblGhe
add constraint new_primary_tblGhe primary key identity(GheID);

-- khoá ngoại
-- Thêm ràng buộc khóa ngoại cho trường PhongID trong bảng tblGhe
alter table tblGhe
add constraint FK_tblGhe_PhongID
foreign key (PhongID) references tblPhong(PhongID);

-- Thêm ràng buộc khóa ngoại cho trường PhimID trong bảng tblVe
alter table tblVe
add constraint FK_tblVe_PhimID
foreign key (PhimID) references tblPhim(PhimID);

-- Thêm ràng buộc khóa ngoại cho trường GheID trong bảng tblVe
alter table tblVe
add constraint FK_tblVe_GheID
foreign key (GheID) references tblGhe(GheID);

-- 2. Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)
select * from tblPhim
order by Thoi_Gian;

-- 3. Hiển thị Ten_phim có thời gian chiếu dài nhất
select PhimID,Ten_phim,Loai_phim,Thoi_gian from tblPhim
order by PhimID desc
limit 1;

-- 4. Hiển thị Ten_Phim có thời gian chiếu ngắn nhất
select PhimID,Ten_phim,Loai_phim,Thoi_gian from tblPhim
order by PhimID asc
limit 1;

-- 5. Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
select * from tblGhe where So_ghe like 'A%';
 
-- 6. Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)
alter table tblPhong modify Trang_thai nvarchar(25);

-- 7. Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:
-- Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
-- Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
-- Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
-- Sau đó hiển thị bảng tblPhong
update tblPhong
set Trang_thai = 
  CASE
    when Trang_thai=0 then concat('Đang sửa')
    when Trang_thai=1 then concat('Đang sử dụng')
    when Trang_thai=null then concat('Unknow')
  END;
select * from tblPhong;

-- 8. Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự
select Ten_phim from tblPhim where length(Ten_Phim)>15 AND length(Ten_Phim)< 25;

-- 9. Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
select Tenphong  as 'Trạng thái phòng chiếu',Trang_thai as 'Trạng thái phòng chiếu'  from tblPhong;

select CONCAT(Tenphong, ' - ', Trang_thai) as 'Trạng thái phòng chiếu'
from tblPhong;

-- 10. Tạo bảng mới có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
create table tblRank (
    STT int,
    TenPhim nvarchar(30),
    Thoi_gian int
);

insert into tblRank (TenPhim, Thoi_gian)  
select Ten_phim, Thoi_gian from tblPhim order by Ten_phim;
select * from tblRank;

-- 11. Trong bảng tblPhim :
-- a. Thêm trường Mo_ta kiểu nvarchar(max)
alter table tblPhim add Mo_ta nvarchar(255);

-- b. Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại ” + nội dung trường LoaiPhim
update tblPhim
set Mo_ta = 'Đây là bộ phim thể loại ' + Loai_phim;

-- c. Hiển thị bảng tblPhim sau khi cập nhật
select * from tblPhim;

-- d. Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film”
update tblPhim
set Mo_ta = replace(Mo_ta, 'bộ phim', 'film');

-- e. Hiển thị bảng tblPhim sau khi cập nhật
select * from tblPhim;

-- 12. Xóa tất cả các khóa ngoại trong các bảng trên.
-- Xóa ràng buộc khóa ngoại trong bảng tblGhe
alter table tblGhe
drop constraint FK_tblGhe_PhongID;

-- Xóa ràng buộc khóa ngoại trong bảng tblVe
alter table tblVe
drop constraint FK_tblVe_PhimID;

-- Xóa ràng buộc khóa ngoại trong bảng tblVe
alter table tblVe
drop constraint FK_tblVe_GheID;

-- 13. Xóa dữ liệu ở bảng tblGhe
delete from tblGhe;

-- 14. Hiển thị ngày giờ hiện tại và ngày giờ hiện tại cộng thêm 5000 phút
-- Hiển thị ngày giờ hiện tại
select now() as 'Ngày giờ hiện tại';

-- Hiển thị ngày giờ hiện tại cộng thêm 5000 phút
select DATE_ADD(now(), INTERVAL 5000 MINUTE) as 'Ngày giờ hiện tại cộng thêm 5000 phút';








