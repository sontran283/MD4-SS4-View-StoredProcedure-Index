CREATE DATABASE SS5_bt_nangcao;
USE SS5_bt_nangcao;

CREATE TABLE Students(
StudentID int primary key,
StudentName varchar(50),
Age tinyint,
Email varchar(50)
);

CREATE TABLE Classes(
ClassId int primary key,
ClassName varchar(50)
);

CREATE TABLE ClassStudent(
StudentID int,
ClassId int,
foreign key (StudentID) references Students(StudentID),
foreign key (ClassId) references Classes(ClassId)
);

CREATE TABLE Subjects(
SbjectID int primary key,
SbjectName varchar(50)
);

CREATE TABLE Marks(
Mark double,
SbjectID int,
StudentID int,
foreign key (SbjectID) references Subjects(SbjectID),
foreign key (StudentID) references Students(StudentID)
);

insert into Students values(1,'nguyen quang an', 18,'an@gmail.com');
insert into Students values(2,'nguyen cong vinh', 20,'vinh@gmail.com');
insert into Students values(3,'nguyen van quyen', 12,'quyen@gmail.com');
insert into Students values(4,'pham thanh binh', 38,'binh@gmail.com');
insert into Students values(5,'nguyen van tai', 30,'tai@gmail.com');

insert into Classes values(1,'C0706L');
insert into Classes values(2,'C0708G');

insert into ClassStudent values(1,1);
insert into ClassStudent values(2,1);
insert into ClassStudent values(3,2);
insert into ClassStudent values(4,2);
insert into ClassStudent values(5,2);

insert into Subjects values(1,'SQL');
insert into Subjects values(2,'JAVA');
insert into Subjects values(3,'CC');
insert into Subjects values(4,'VISUAL');

insert into Marks values(8,1,1);
insert into Marks values(4,2,1);
insert into Marks values(9,1,1);
insert into Marks values(7,1,3);
insert into Marks values(3,1,4);
insert into Marks values(5,2,5);
insert into Marks values(8,3,3);
insert into Marks values(1,3,5);
insert into Marks values(3,2,4);

-- Hien thi danh sach tat ca cac hoc vien
select * from Students;

-- Hien thi danh sach tat ca cac mon hoc
select * from Subjects;

-- Tinh diem trung binh
select S.StudentID,S.StudentName, AVG(Mark) as DiemTrungBinh
from Students S
Join Marks M
on S.StudentID = M.StudentID
group by S.StudentId,S.StudentName;

-- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
select S.StudentID,S.StudentName,SUB.SbjectName, M.Mark as DIEM_CAO_NHAT
from Subjects SUB
join Marks M on SUB.SbjectID = M.SbjectID
join Students S on M.StudentID = S.StudentID
order by M.Mark desc
limit 1;

-- Danh so thu tu cua diem theo chieu giam
alter table Marks add column STT text;
SELECT * FROM Marks
ORDER BY Mark DESC;

-- Thay doi kieu du lieu cua cot SbjectName trong bang Subjects thanh nvarchar(max)
alter table Subjects modify SbjectName nvarchar(255);

-- Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
update Subjects
set SbjectName = concat("Day la mon hoc" , SbjectName);

-- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
alter table Students add constraint check_Age check(Age > 10 and Age < 50);

-- Loai bo tat ca quan he giua cac bang
-- Xóa các ràng buộc khóa ngoại từ bảng ClassStudent
ALTER TABLE ClassStudent
DROP FOREIGN KEY classstudent_ibfk_1;

ALTER TABLE ClassStudent
DROP FOREIGN KEY classstudent_ibfk_2;

-- Xóa các ràng buộc khóa ngoại từ bảng Marks
ALTER TABLE Marks
DROP FOREIGN KEY marks_ibfk_1;

ALTER TABLE Marks
DROP FOREIGN KEY marks_ibfk_2;

-- Xoa hoc vien co StudentID la 1
delete from Students
where StudentID = 1;

-- Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table Students add column Status Bit default 1;

-- Cap nhap gia tri Status trong bang Student thanh 0
update Students 
set Status = 1
where Status = 0;


