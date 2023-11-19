CREATE DATABASE SS5_BT04_Protected_View;
USE SS5_BT04_Protected_View;

CREATE TABLE Class (
    ClassID int primary key auto_increment,
    ClassName nvarchar(255) not null,
    StartDate datetime not null,
    Status bit
);

insert into Class(ClassName,StartDate,Status) values ('A1','2008-12-20',1);
insert into Class(ClassName,StartDate,Status) values ('A2','2008-12-22',1);
insert into Class(ClassName,StartDate,Status) values ('B3',curdate(),0);

CREATE TABLE Student(
StudentID int not null primary key,
StudentName nvarchar(30),
Address nvarchar(50),
Phone varchar(20),
Status bit,
ClassID int not null
);

insert into Student(StudentID,StudentName,Address,Phone,Status,ClassID) values (1,'hung','ha noi',098765788,1,1);
insert into Student(StudentID,StudentName,Address,Phone,Status,ClassID) values (2,'hoa','hai phong',null,1,1);
insert into Student(StudentID,StudentName,Address,Phone,Status,ClassID) values (3,'manh','ho chi minh',089876545,0,2);

CREATE TABLE Subject(
SubID int not null primary key auto_increment,
SubName nvarchar(30) not null,
Credit tinyint not null default 1 check (Credit >= 1),
Status bit default 1
);

insert into Subject(SubName,Credit) values ('CF',5);
insert into Subject(SubName,Credit) values ('C',6);
insert into Subject(SubName,Credit) values ('HDJ',5);
insert into Subject(SubName,Credit) values ('RDBMS',10);

CREATE TABLE Mark(
MarkID int not null primary key auto_increment,
SubID int not null,
StudentID int not null,
Mark float default 0 check (Mark between 0 and 100),
ExamTime tinyint default 1
);

insert into Mark(SubID,StudentID,Mark,ExamTime) values (1,1,8,1);
insert into Mark(SubID,StudentID,Mark,ExamTime) values (1,2,10,2);
insert into Mark(SubID,StudentID,Mark,ExamTime) values (2,1,12,1);

-- 3. Sử dụng câu lệnh sử đổi bảng để thêm các ràng buộc vào các bảng theo mô tả:
-- a. Thêm ràng buộc khóa ngoại trên cột ClassID của bảng Student, tham chiếu đến cột ClassID trên bảng Class.
alter table Student
add constraint FK_Student_Class
foreign key (ClassID) references Class(ClassID);

-- b. Thêm ràng buộc cho cột StartDate của bảng Class là ngày hiện hành.
alter table Class
add constraint CK_Class_StartDate
CHECK (StartDate <= GETDATE());

-- c. Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.
alter table Student 
add constraint CK_Student_Status
check(Status = 1);

-- d. Thêm ràng buộc khóa ngoại cho bảng Mark trên cột:
-- SubID trên bảng Mark tham chiếu đến cột SubID trên bảng Subject
alter table Mark
ADD CONSTRAINT FK_Mark_Subject
foreign key (SubID) references Subject(SubID);

-- StudentID tren bảng Mark tham chiếu đến cột StudentID của bảng Student.
alter table Mark
ADD CONSTRAINT FK_Mark_Student
foreign key (StudentID) references Student(StudentID);

-- 5. Cập nhật dữ liệu.
-- a.Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
update Student
set ClassID = 2
where StudentName = 'hung';

-- b. Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
update Student
set Phone = 'No phone'
where Phone is null;

-- c. Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
-- (Chú ý: phải sử dụng phương thức write).
update Class 
set ClassName =  Case
              when Status = 0 then concat('New_', ClassName) else ClassName
			  End;
              
update Class
set ClassName = concat(if(Status= 0, ('New_', ClassName ), ClassName), Name);

-- d. Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
-- (Chú ý: phải sử dụng phương thức write)
update Class
set ClassName = replace(ClassName , 'New', 'Old')
where Status = 1 and ClassName like 'New%';

-- e. Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
update Class 
set Status = 0
where not exists(select 1 from Student where Student.ClassID = Class.ClassID);

-- f. Cập nhật trạng thái của lớp học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.
update Subject 
set Status = 0
where not exists(
   select 1
   from Student S
   join Mark M on S.StudentID = M.StudentID
   WHERE  M.SubID = Subject.SubID
   order by 1
  );


-- 6 Hiện thị thông tin.
-- Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
select * from Student where StudentName like 'h%';

-- a. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select * from Class where StartDate like '%12%';

-- b. Hiển thị giá trị lớn nhất của credit trong bảng subject.
select Credit
from Subject
where Credit = (select MAX(Credit) from Subject);

-- c. Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
select SubID,SubName, Credit, Status
from Subject
where Credit = (select MAX(Credit) from Subject);

-- d. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
select SubID,SubName, Credit, Status
from Subject
where Credit between 3 and 5;

-- e. Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
select C.classID, C.className, S.studentname, S.Address
from Class C
join Student S on C.ClassID = S.ClassID;

-- f. Hiển thị các thông tin môn học chưa có sinh viên dự thi.
-- Kiểm tra xem có bản ghi nào trong bảng Mark có SubID tương ứng với SubID trong bảng Subject hay không. Nếu không có, môn học đó sẽ được hiển thị
select * from Subject
where not exists (
    select 1
    from Mark
    where Mark.SubID = Subject.SubID
);

-- g. Hiển thị các thông tin môn học có điểm thi lớn nhất.
select SUB.SubID, SUB.SubName, max(M.Mark)
from Subject SUB
join Mark M on SUB.SubID = M.SubID
group by SUB.SubID
order by SUB.SubName asc
limit 1;

-- h. Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
select S.StudentID, S.StudentName, avg(M.Mark) as DIEMTRUNGBINH
from Student S
join Mark M on S.StudentID = M.StudentID
group by S.StudentID, S.StudentName;

-- i. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
-- c1:
select S.StudentID, S.StudentName, avg(M.Mark) as DIEMTRUNGBINH
from Student S
join Mark M on S.StudentID = M.StudentID
group by S.StudentID, S.StudentName
order by DIEMTRUNGBINH asc;

-- c2:
select
    Student.StudentID,
    Student.StudentName,
    avg(Mark.Mark) as DIEMTRUNGBINH,
    rank() over (order by avg(Mark.Mark) desc) as Ranking
from Student
join Mark on Student.StudentID = Mark.StudentID
group by Student.StudentID, Student.StudentName
order by DIEMTRUNGBINH desc;

-- j. Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
select S.StudentID, S.StudentName, avg(M.Mark) as DIEMTRUNGBINH
from Student S
join Mark M on S.StudentID = M.StudentID
group by S.StudentID, S.StudentName
order by DIEMTRUNGBINH > 10;

-- k. Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
select S.StudentName, SUB.SubName, M.Mark
from Student S
join Mark M on S.StudentID = M.StudentID
join Subject SUB on M.SubID = SUB.SubID
order by M.Mark desc, S.StudentName asc;

-- 7. Xóa dữ liệu.
-- a. Xóa tất cả các lớp có trạng thái là 0.
delete from Class where Status = 0;

-- b. Xóa tất cả các môn học chưa có sinh viên dự thi.
delete from Subject
where not exists (
    select 1
    from Mark
    where Mark.SubID = Subject.SubID
);

-- 8. Thay đổi.
-- a. Xóa bỏ cột ExamTimes trên bảng Mark.
alter table Mark drop column ExamTimes;

-- b. Sửa đổi cột status trên bảng class thành tên ClassStatus.
alter table Class
change column Status ClassStatus bit;

-- c. Đổi tên bảng Mark thành SubjectTest.
rename table Mark to SubjectTest;


