CREATE DATABASE SS5_BT01;
USE SS5_BT01;

CREATE TABLE Student(
RN int primary key,
Name varchar(20),
Age tinyint
);

CREATE TABLE Test(
TestID int primary key,
Name varchar(20)
);

CREATE TABLE StudentTest(
RN int,
TestID int,
Date datetime,
Mark float,
foreign key(RN) references Student(RN),
foreign key(TestID) references Test(TestID)
);

insert into Student values(1,'nguyen hong ha',20);
insert into Student values(2,'truong ngoc anh',30);
insert into Student values(3,'tuan minh',25);
insert into Student values(4,'dan tuong',22);

insert into Test values(1,'QQQ');
insert into Test values(2,'EEWWE');
insert into Test values(3,'SDDSSD');
insert into Test values(4,'HGHGH');

insert into StudentTest values(1,1,'2006-7-17',8);
insert into StudentTest values(1,2,'2006-7-18',5);
insert into StudentTest values(1,3,'2006-7-19',7);
insert into StudentTest values(2,1,'2006-7-17',7);
insert into StudentTest values(2,2,'2006-7-18',4);
insert into StudentTest values(2,3,'2006-7-19',2);
insert into StudentTest values(3,1,'2006-7-17',10);
insert into StudentTest values(3,3,'2006-7-18',1);

-- 2. Sử dụng alter để sửa đổi
-- a. Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
alter table Student add constraint check_age check(age>15 and age<55);

-- b. Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
ALTER TABLE StudentTest
ALTER COLUMN Mark SET DEFAULT 0;

-- c. Thêm khóa chính cho bảng studenttest là (RN,TestID)
ALTER TABLE StudentTest ADD PRIMARY KEY(RN,TestID);

-- d. Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
ALTER TABLE Test
ADD CONSTRAINT UQ_Name UNIQUE (Name);

-- e. Xóa ràng buộc duy nhất (unique) trên bảng Test
ALTER TABLE Test
DROP INDEX UQ_Name;

ALTER TABLE Test
DROP INDEX `Name`;

-- 3. Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi giống như hình sau:
select S.RN, S.Name as StudentName, T.Name as TestName, ST.Mark, ST.Date
from Student S
join StudentTest ST on S.RN = ST.RN
join Test T on ST.TestID = T.TestID
group by S.RN, S.Name, T.Name, ST.Mark, ST.Date;

-- 4. Hiển thị danh sách các bạn học viên chưa thi môn nào như hình sau:
SELECT S.RN ,S.Name , S.age
from Student S
left join StudentTest ST on S.RN = ST.RN
where S.RN = 4 AND St.RN is null;

-- 5. Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) như sau:
select S.RN, S.Name as TENHOCVIEN , T.Name as TENMONHOC, ST.Mark, ST.Date
from Student S
join StudentTest ST on S.RN = ST.RN
join  Test T on ST.TestID = T.TestID
group by S.RN,S.Name,T.Name,ST.Mark, ST.Date
having ST.Mark < 5;

-- 6. Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số điểm) như sau:
SELECT S.RN, S.Name , avg(ST.Mark) as DIEMTRUNGBINH
from Student S
left join StudentTest ST on S.RN = ST.RN
group by S.RN, S.Name
having COUNT(ST.RN)> 0
order by DIEMTRUNGBINH desc;

-- 7. Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
SELECT S.RN, S.Name , avg(ST.Mark) as DIEMTRUNGBINH
from Student S
left join StudentTest ST on S.RN = ST.RN
group by S.RN, S.Name
having COUNT(ST.RN)> 0
limit 1;

-- 8. Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau:
select T.Name, max(ST.Mark) as DIEMCAONHAT
from Test T
join StudentTest ST on T.TestID = ST.TestID
group by T.Name
order by T.Name;

-- 9. Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null như sau:
SELECT S.RN , S.Name as TENHOCVIEN, T.Name as TENMONHOC
From Student S
join StudentTest ST on S.RN = ST.RN
join Test T on ST.TestID = T.TestID
group by S.RN, S.Name , T.Name , ST.TestID;		

-- 10. Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update Student
set age = age + 1;

-- 11. Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table Student add column Status Varchar(10);

-- 12. Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, 
-- trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student lên như sau:
UPDATE Student 
SET Status = CASE WHEN Age < 30 THEN 'Young' ELSE 'Old' END;

-- 13. Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi như sau:
select S.RN, S.Name as StudentName, T.Name as TestName, ST.Mark, ST.Date
from Student S
join StudentTest ST on S.RN = ST.RN
join Test T on ST.TestID = T.TestID
group by S.RN, S.Name, T.Name, ST.Mark, ST.Date
order by ST.Date asc;

-- 14. Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
SELECT S.RN, S.Name ,S.Age, avg(ST.Mark) as DIEMTRUNGBINH
from Student S
left join StudentTest ST on S.RN = ST.RN
group by S.RN, S.Name
having COUNT(ST.RN)> 0 and  S.Name like 'T%' and avg(ST.Mark) > 4.5;

-- 15. Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng). Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1.
SELECT S.RN, S.Name ,S.Age, avg(ST.Mark) as DIEMTRUNGBINH
from Student S
left join StudentTest ST on S.RN = ST.RN
group by S.RN, S.Name
having COUNT(ST.RN)> 0
order by DIEMTRUNGBINH desc;

-- 16. Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
alter table Student modify Name nvarchar(255);

-- 17. Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau:
-- a. Nếu tuổi >20 -> thêm ‘Old’ vào trước tên (cột name)
-- b. Nếu tuổi <=20 thì thêm ‘Young’ vào trước tên (cột name)
update Student 
set Name = case 
           when Age > 20 then concat('old_', Name)
           when Age <= 20 then concat('Young_', Name)
		   End;
        
-- 18. Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi
delete fROM Test
WHERE TestID NOT IN (SELECT DISTINCT TestID FROM StudentTest);

-- 19. Xóa thông tin điểm thi của sinh viên có điểm <5.
delete fROM StudentTest
where Mark < 5;

