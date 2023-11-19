CREATE DATABASE SS5_OnTap01;
USE SS5_OnTap01;

CREATE TABLE TBLKhoa(
Makhoa char(10)primary key,
Tenkhoa char(30),
Dienthoai char(10)
);
 
CREATE TABLE TBLGiangVien(
Magv int primary key,
Hotengv char(30),
Luong decimal(5,2),
Makhoa char(10),
foreign key(Makhoa) references TBLKhoa(Makhoa)
);

CREATE TABLE TBLSinhVien(
Masv int primary key,
Hotensv char(40),
Makhoa char(10),
foreign key(Makhoa) references TBLKhoa(Makhoa),
Namsinh int,
Quequan char(30)
);

CREATE TABLE TBLDeTai(
Madt char(10)primary key,
Tendt char(30),
Kinhphi int,
Noithuctap char(30)
);

CREATE TABLE TBLHuongDan(
Masv int primary key,
foreign key(Masv) references TBLSinhVien(Masv),
Madt char(10),
foreign key(Madt) references TBLDeTai(Madt),
Magv int,
foreign key(Magv) references TBLGiangVien(Magv),
KetQua decimal(5,2)
);

INSERT INTO TBLKhoa VALUES
('Geo','Dia ly va QLTN',3855413),
('Math','Toan',3855411),
('Bio','Cong nghe Sinh hoc',3855412);

INSERT INTO TBLGiangVien VALUES
(11,'Thanh Binh',700,'Geo'),    
(12,'Thu Huong',500,'Math'),
(13,'Chu Vinh',650,'Geo'),
(14,'Le Thi Ly',500,'Bio'),
(15,'Tran Son',900,'Math');

INSERT INTO TBLSinhVien VALUES
(1,'Le Van Son','Bio',1990,'Nghe An'),
(2,'Nguyen Thi Mai','Geo',1990,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1992,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1989,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1991,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',1992,'Nghe An');

INSERT INTO TBLDeTai VALUES
('Dt01','GIS',100,'Nghe An'),
('Dt02','ARC GIS',500,'Nam Dinh'),
('Dt03','Spatial DB',100, 'Ha Tinh'),
('Dt04','MAP',300,'Quang Binh' );

INSERT INTO TBLHuongDan VALUES
(1,'Dt01',13,8),
(2,'Dt03',14,0),
(3,'Dt03',12,10),
(5,'Dt04',14,7),
(6,'Dt01',13,Null),
(7,'Dt04',11,10),
(8,'Dt03',15,6);

-- Đề I:
-- Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên
create view show_view as
select GV.Magv, GV.Hotengv,K.Makhoa 
from TBLGiangVien GV
join TBLKhoa K on GV.Makhoa = K.Makhoa;

select * from show_view;

-- Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
select K.Makhoa, K.Tenkhoa, GV.Hotengv 
from TBLGiangVien GV
join TBLKhoa K on GV.Makhoa = K.Makhoa
where K.Tenkhoa = 'DIA LY va QLTN';

-- Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
select count(*) as SoSinhVien
from TBLKhoa K 
join TBLSinhVien SV on K.Makhoa = SV.Makhoa
where K.Tenkhoa = 'CONG NGHE SINH HOC';

-- Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa ‘TOAN’
select K.Makhoa, K.Tenkhoa, SV.Hotensv, SV.Namsinh, SV.Quequan
from TBLSinhVien SV
join TBLKhoa K on SV.Makhoa = K.Makhoa
where K.Tenkhoa = 'TOAN';

-- Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
select count(*) as SoGiangVien
from TBLKhoa K 
join TBLGiangVien GV on K.Makhoa = GV.Makhoa
where K.Tenkhoa = 'CONG NGHE SINH HOC';

-- Cho biết thông tin về sinh viên không tham gia thực tập
select * from TBLSinhVien
where not exists (
    select 1
    from TBLHuongDan
    where TBLHuongDan.Masv = TBLSinhVien.Masv
);

-- Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
select K.Makhoa, K.Tenkhoa, COUNT(GV.Magv) as SoGiangVien
from TBLKhoa K
left join TBLGiangVien GV on K.Makhoa = GV.Makhoa
group by K.Makhoa, K.Tenkhoa;

-- Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
select K.Dienthoai, SV.Hotensv
from TBLKhoa K
join TBLSinhVien SV on K.Makhoa = SV.Makhoa
where SV.Hotensv = 'Le van son';

-- Đề II:
-- Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
select DT.Madt , DT.Tendt , GV.Hotengv
from TBLHuongDan HD
join TBLGiangVien GV on HD.Magv = GV.Magv
join TBLDeTai DT on HD.Madt = DT.Madt
where GV.Hotengv = 'Tran son';

-- Cho biết tên đề tài không có sinh viên nào thực tập
select * from TBLDeTai
where not exists (
    select 1
    from TBLHuongDan
    where TBLHuongDan.Madt = TBLDeTai.Madt
);

-- Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
select GV.Magv , GV.Hotengv , K.Tenkhoa
from TBLGiangVien GV
join TBLKhoa K on GV.Makhoa = K.Makhoa
join TBLHuongDan HD on GV.Magv = HD.Magv
group by GV.Magv , GV.Hotengv , K.Tenkhoa
having count(HD.Masv) >=3;

-- Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
select  Madt, Tendt from TBLDeTai
where Kinhphi = (select max(Kinhphi) from TBLDeTai);

-- Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
select DT.Madt , DT.Tendt 
from TBLDeTai DT
join TBLHuongDan HD on DT.Madt = HD.Madt
join TBLSinhVien SV on HD.MaSV = SV.MaSV
group by  DT.Madt , DT.Tendt 
having count(HD.Masv) > 2;

select DT.Madt,DT.Tendt from TBLDeTai DT
where DT.Madt in (
select HD.Madt from TBLHuongDan HD
group by HD.Madt
having COUNT(HD.Madt) > 2);

-- Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
select SV.Masv, SV.Hotensv
from TBLSinhVien SV
join TBLKhoa K on SV.Makhoa = K.Makhoa
where K.Tenkhoa = 'DIA LY va QLTN';

-- Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
select K.Tenkhoa , SV.Masv as SLSV
from TBLKhoa K 
join TBLSinhVien SV on K.Makhoa = SV.Makhoa;

-- Cho biết thông tin về các sinh viên thực tập tại quê nhà
select SV.Masv, SV.Hotensv, SV.Quequan
from TBLSinhVien SV
join TBLHuongDan HD on SV. Masv = HD. Masv
join TBLDeTai DT on DT. Madt = HD. Madt
where DT.Noithuctap = SV.Quequan;

-- Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
select SV.Masv, SV.Hotensv
from TBLSinhVien SV
where not exists (
        select 1
        from TBLHuongDan HD
        where HD.Masv = SV.Masv
    );


-- Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
select SV.Masv, SV.Hotensv, SV.Quequan
from TBLSinhVien SV
join TBLHuongDan HD on SV. Masv = HD. Masv
join TBLDeTai DT on DT. Madt = HD. Madt
where HD.KetQua = 0;


