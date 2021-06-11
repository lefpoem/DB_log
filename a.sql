GO
CREATE SCHEMA "T-S" AUTHORIZATION sa;
go
CREATE TABLE Student(
    Sno     CHAR(9) PRIMARY KEY,
    Sname   CHAR(20) UNIQUE,
    Ssex    CHAR(2) CHECK(Ssex IN('男','女')),
    Sdept   CHAR(20),
    Sage    SMALLINT
);
CREATE TABLE Course(
    Cno     CHAR(4) PRIMARY KEY,
    Cpno    CHAR(4),
    Cname   CHAR(40) NOT NULL,
    Ccredit  SMALLINT,
    FOREIGN KEY(Cpno) REFERENCES Course(Cno)
);
CREATE TABLE SC(
    Sno     CHAR(9),
    Cno     CHAR(4),
    Grade   SMALLINT,
    PRIMARY KEY (Sno,Cno),
    FOREIGN KEY(Sno) REFERENCES Student(Sno),
    FOREIGN KEY(Cno) REFERENCES Course(Cno)
);
go
CREATE VIEW IS_Student
AS
SELECT Sno,Sname,Sage 
FROM Student,SC
WHERE Sdept='IS'
WITH CHECK OPTION;
go
CREATE VIEW BT_S(Sno,Sname,Sbirth)
AS 
SELECT Sno,Sname,2014-Sage 
FROM Student
GROUP BY Sno;
GO
ALTER TABLE Student ADD S_entrance DATE 
ALTER TABLE Student DROP S_entrance ;
ALTER TABLE Student ALTER COLUMN Sage int;
ALTER TABLE Course ADD UNIQUE(Cname);
CREATE UNIQUE INDEX Stusno ON Student(Sno);
CREATE UNIQUE INDEX Coucno ON Course(Cno);
CREATE UNIQUE INDEX SCno ON SC(Sno ASC,Cno DESC);
CREATE UNIQUE INDEX Stusname ON Student(Sname);
DROP INDEX Stusname;
SELECT Sno,Sname FROM Student;
SELECT * FROM Student;
SELECT Sname,2014-Sage FROM Student;
SELECT Sname,'year of birth:' BIRTH,2014-Sage BIRTHDAY,LOWER(Sdept) DEPARTMENT FROM Student;
SELECT DISTINCT Sno FROM Student;
SELECT Sname FROM Student
    WHERE Sdept='cs';
SELECT Sname,Sage FROM Student
    WHERE Sage<20;
SELECT DISTINCT Sn0 FROM SC
    WHERE Grade<60;
SELECT Sname,Sde阳pt,Sage FROM Student
    WHERE Sage BETWEEN 20 AND 23;
SELECT Sname,Sdept,Sage FROM Student
    WHERE Sage NOT BETWEEN 20 AND 23;
SELECT Sname,Ssex FROM Student
    WHERE Sdept IN('CS','MA','IS');
SELECT Sname,Ssex FROM Student
    WHERE Sdept NOT IN('CS','MA','IS');
SELECT * FROM Student
    WHERE Sno LIKE '201215121';
/*euivalent to this*/
SELECT * FROM Student
    WHERE Sno='201215121';
SELECT Sno,Sname,Ssex FROM Student
    WHERE Sname LIKE '刘%';
SELECT Sname FROM Student
    WHERE Sname LIKE '欧阳_';
SELECT Sname,Sno FROM Student
    WHERE Sname LIKE '_阳%';
SELECT Sname,Sno,Ssex FROM Student
    WHERE Sname NOT LIKE '刘%';
SELECT Cno,Ccredit FROM Course 
    WHERE Cname LIKE 'DB\_Design' ESCAPE'\';
SELECT * FROM Course  
    WHERE Cname LIKE 'DB\_%i__' ESCAPE'\';
SELECT Sno,Cno FROM Course 
    WHERE Grade IS NULL;/*IS NULL can't use substitution*/
SELECT Sno,Cno FROM Course 
    WHERE Grade IS NOT NULL;
SELECT Sname FROM Student
    WHERE Sdept='CS' AND Sage<20;
SELECT Sname,Ssex FROM Student
    where Sdept='CS' OR Sdept='MA' OR Sdept LIKE 'IS';
SELECT Sno,Grade FROM SC 
    WHERE Cno='3' 
    ORDER BY Grade DESC;
SELECT * FROM Student
    ORDER BY Sdept,Grade DESC;
SELECT COUNT(*) FROM Student;
SELECT COUNT(DISTINCT Sno) FROM SC;
SELECT AVG(Grade) FROM SC
    WHERE Cno='1';
SELECT MAX(Grade) FROM SC 
    WHERE Cno='1';
SELECT SUM(Ccredit) FROM SC,Course 
    WHERE SC.Cno=Course.Cno AND Sno='201215121';
SELECT Cno,COUNT(Cno) FROM Course 
    GROUP BY Cno;
SELECT Sno FROM SC 
    GROUP BY Sno 
    HAVING COUNT(*)>3;
SELECT Student.*,SC.*
    FROM Student,SC 
    WHERE Student.Sno=Student.Sno;
SELECT Student.sno,Sname 
    FROM Student,SC 
    WHERE Student.Sno=SC.sno AND
        SC.Cno='2' AND SC.Grade>90; 
SELECT Student.Sno,Sname,Sage,Ssex,Sdept,Cno,Grade
    FROM Student
    LEFT OUTER JOIN SC ON (Student.Sno=SC.Sno);/*左外连接*/
SELECT Studen.Sno,Sname,Cname,Grade
    FROM Student,SC,Course 
    WHERE Studen.Sno=SC.Sno AND SC.Cno=Course.Cno;
SELECT Sname 
    FROM Sudent 
    WHERE Sno IN (
        SELECT Sno 
        FROM SC
        WHERE Cno='2'
    );
SELECT S1.Sname,S1.Sdept,S1.Sno 
    FROM Studen S1,Student S2
    WHERE S1.Sdept=S2.Sdept AND S2.Sname='刘晨';
SELECT Sno,Cno 
    FROM SC x 
    WHERE Grade>=(
        SELECT AVG(Grade)
        FROM SC y 
        WHERE y.Sno=x.Sno
    );
SELECT Sname,Sage 
FROM Student
WHERE Sage<ANY(
    SELECT Sage
    FROM Student
    WHERE Sdept='CS'/*the set(20,19)*/
)
AND Sdept<>'CS';
/*equivalent way*/
SELECT Sname,Sage 
FROM Student
WHERE Sage < (
    SELECT MAX(Sage)
    FROM Student
    WHERE Sdept='CS'
)
AND Sdept<>'CS';
SELECT Sname 
    FROM Student
    WHERE EXISTS(
        SELECT *
        FROM SC 
        WHERE Sno=Student.Sno AND Cno='1'
    );
/*查询选修了全部课程的学生姓名*/
SELECT Sname
FROM Student
WHERE NOT EXISTS(
    SELECT *
    FROM Course 
    WHERE NOT EXISTS(
         SELECT *
         FROM SC 
         WHERE Sno=Student.Sno AND Cno=Course.Cno
    )
);
SELECT DISTINCT Sno 
    FROM SC SCX
    WHERE NOT EXISTS(
        SELECT *
        FROM SC SCY 
        WHERE SCY.Sno='201215122' AND
            NOT EXISTS
            (
                SELECT *
                FROM SC SCZ
                WHERE SCZ.Sno=SCX.Sno AND SCZ.Cno=SCY.Cno
            )
    );
SELECT *
    FROM Student
    WHERE Sdept='CS'
    UNION /*合并自动跳重复行 UNION ALL INTERSECT EXCEPT*/
    SELECT *
    FROM Student
    WHERE Sage<=19;
SELECT *
    FROM Student
    WHERE Sdept='CS'
    EXCEPT
    SELECT *
    FROM Student
    WHERE Sage<=19;
/*equalvalent way*/
SELECT *
    FROM Student
    WHERE Sdept='CS' AND Sage>19;
SELECT Sno,Cno 
FROM SC,(SELECT Sno,AVG(Grade) From SC GROUP BY Sno )
    AS Avg_sc(avg_sno,avg_grade)/**子查询生成一个派生表Avg_sc*/
    WHERE SC.Sno=Avg_sc.avg_sno and SC.Grade >= Avg_sc.avg_grade;
INSERT
INTO Student(Sno,Sname,Ssex,Sdept,Sage)
VALUES ('201215128','陈冬','男','IS','18');
INSERT
INTO Student
VALUES ('201215126','张成民','男','18','CS');
INSERT
INTO SC(Sno,Cno) 
VALUES ('201215128','1');
INSERT
INTO SC
VALUES ('201215128','1',NULL);
CREATE TABLE Dept_age(
    Sdept CHAR(15),
    Avg_age SMALLINT
);
INSERT
INTO Dept_age(Sdept,Avg_age)
SELECT Sdept,AVG(Sage)
FROM Student
GROUP BY Sdept;
/*update data for condionts*/
UPDATE Sudent
SET Sage=22
WHERE Sno='201215121';
/*update data for all*/
UPDATE SC 
SET Sage=Sage+1;

DELETE
FROM Student
WHERE Sno='201215128';
/*delete all value*/
DELETE
FROM SC 
WHERE Sno='201215128';
SELECT Sno,Sage 
FROM IS_Student
WHERE Sage<20;
/*equivalent way*/
SELECT Sno,Sage 
FROM Student 
WHERE Sdept='IS' AND Sage<20;
