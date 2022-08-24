USE master
GO

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'��301_����������'
)
ALTER DATABASE ��301_���������� set single_user with rollback immediate
GO

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'��301_����������'
)
DROP DATABASE ��301_����������
GO

CREATE DATABASE ��301_����������
GO

USE ��301_����������
GO

IF EXISTS(
  SELECT *
    FROM sys.schemas
   WHERE name = N'������������_2'
) 
 DROP SCHEMA ������������_2
GO

CREATE SCHEMA ������������_2
GO

IF OBJECT_ID('��301_����������.������������_2.����������_��������', 'U') IS NOT NULL
  DROP TABLE  ��301_����������.������������_2.����������_��������
GO

CREATE TABLE ��301_����������.������������_2.����������_��������
(
	���_������� Integer, 
	��������_������� nvarchar(40) NULL
	CONSTRAINT Region_id PRIMARY KEY (���_�������) 
)
GO

IF OBJECT_ID('��301_����������.������������_2.����_�������_��������', 'U') IS NOT NULL
  DROP TABLE  ��301_����������.������������_2.����_�������_��������
GO

CREATE TABLE ��301_����������.������������_2.����_�������_��������
(
    ���_������� Integer,
	��������_���_������� Integer
	CONSTRAINT Number_id PRIMARY KEY (���_�������) 
)
GO

IF OBJECT_ID('��301_����������.������������_2.������_���������', 'U') IS NOT NULL
  DROP TABLE  ��301_����������.������������_2.������_���������
GO

CREATE TABLE ��301_����������.������������_2.������_���������
(
    ID_������ Integer IDENTITY,
	ID_������ Integer,
	����_����� Integer,
	�����_������� time(0),
	�����������_�������� INTEGER,
	CONSTRAINT PK_id PRIMARY KEY (ID_������) 
)
GO

IF OBJECT_ID('��301_����������.������������_2.������_�����', 'U') IS NOT NULL
  DROP TABLE  ��301_����������.������������_2.������_�����
GO

CREATE TABLE ��301_����������.������������_2.������_�����
(
    ID_������ Integer IDENTITY,
	���_����� nvarchar(20),
    ���_������� Integer CHECK((���_������� > 0 And ���_������� < 300) OR (���_������� > 699 AND ���_������� < 800)), 
	��������� nvarchar(10) CHECK(��������� = N'A' OR ��������� = N'B' OR ��������� = N'C' OR ��������� = N'D' OR ��������� = N'M'),
	CONSTRAINT PK_����� PRIMARY KEY (���_�����)
)
GO


CREATE TRIGGER ������������_��������_������_������ ON ������������_2.������_����� INSTEAD OF INSERT
AS
BEGIN
--����������� �� �������� ����
IF ((SELECT COUNT(*) 
	FROM inserted 
	WHERE ���_����� LIKE N'[������������ABCDEFGHIGKLMNOPQRSTUVWXYZ][0123456789][0123456789][0123456789][������������ABCDEFGHIGKLMNOPQRSTUVWXYZ][������������ABCDEFGHIGKLMNOPQRSTUVWXYZ][0123456789][0123456789][0123456789]') = 0
	AND 
	(SELECT COUNT(*) 
	FROM inserted 
	WHERE ���_����� LIKE N'[������������ABCDEFGHIGKLMNOPQRSTUVWXYZ][0123456789][0123456789][0123456789][������������ABCDEFGHIGKLMNOPQRSTUVWXYZ][������������ABCDEFGHIGKLMNOPQRSTUVWXYZ][0123456789][0123456789]') = 0)
	    BEGIN
	        RAISERROR(N'�������� ������ ��� ������', 10, 1)
			ROLLBACK
		END
	ELSE
	    BEGIN
		    INSERT INTO ������_�����(���_�����, ���_�������, ���������) SELECT ���_�����, SUBSTRING(���_�����, 7, 3), ��������� FROM inserted
		END
END
GO


CREATE TRIGGER ������������_��������_������ ON  ������������_2.������_��������� INSTEAD OF INSERT 
AS
BEGIN  
	   --����������� �� �����
    IF((SELECT COUNT(*) 
	FROM inserted, ������_��������� 
	WHERE inserted.ID_������ = ������_���������.ID_������ 
	AND DATEDIFF(SECOND, ������_���������.�����_�������, inserted.�����_�������) > 300) 
	=
	(SELECT COUNT(*) 
	FROM inserted, ������_���������
	WHERE inserted.ID_������ = ������_���������.ID_������))
	    BEGIN
	        --����������� �� ����������� ��������
		    IF ((SELECT TOP 1 ������_���������.�����������_��������
		    FROM inserted, ������_���������
			WHERE inserted.ID_������ = ������_���������.ID_������
			ORDER BY ������_���������.ID_������ DESC) = (SELECT inserted.�����������_�������� FROM inserted ))
				BEGIN
			        RAISERROR(N'����� ��� ���� ������ ������� � �������', 10, 1)
			            ROLLBACK				  
					END
			ELSE
			    BEGIN
					INSERT INTO ������_���������(����_�����, ID_������, �����_�������, �����������_��������) SELECT ����_�����, ID_������, �����_�������, �����������_�������� FROM inserted
				END
		END
	ELSE
		BEGIN
			RAISERROR(N'������� ��������� �������� ����� ���������', 10, 1)
			ROLLBACK
		END
END
GO

--�������� �� �����

--������������ ����� � �����
--INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A124BC1', N'A')
--������������ ����� �������
--INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A124BC999', N'A')
--������������ ���������
--INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A125BC66', N'Y')

--�������� �� ����� � ����� �����

--�������� ��� ���� �������
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:26:12', 1)
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:38:13', 1)
--�������� ��� ���� �������
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:23:11', 2)
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:40:11', 2)
--�������� ������� ������� � ����� �������
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:23:11', 1)
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:30:11', 2)
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:40:11', 2)
--�������� �������� �������
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:23:11', 1)
--INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 1, N'19:24:11', 2)

--������ ��� ������
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A123BC66', N'A')

INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A124BC196', N'A')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'C522NM93', N'B')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A256IU150', N'C')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'B995RV222', N'D')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'E345TN54', N'M')

INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A247BC96', N'B')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'C143NM759', N'A')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A255IU123', N'C')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'B996RV22', N'D')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'E348TN754', N'M')

INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A194BC90', N'A')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'C521NM122', N'B')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'A254IU66', N'C')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'B995RV96', N'D')
INSERT INTO ������������_2.������_�����(���_�����, ���������) VALUES (N'E345TN150', N'M')


INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 2, N'19:23:11', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (2, 3, N'19:25:12', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (2, 3, N'19:30:13', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 2, N'19:29:14', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (3, 4, N'19:30:15', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (3, 4, N'19:40:16', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 5, N'21:29:17', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (2, 5, N'22:41:18', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 6, N'20:10:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 6, N'23:29:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 7, N'11:10:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 7, N'14:29:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (2, 8, N'16:10:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (3, 8, N'17:29:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 9, N'05:10:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 9, N'06:29:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (1, 10, N'10:10:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (2, 10, N'13:29:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 11, N'15:11:19', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 11, N'18:25:10', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 12, N'17:00:19', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 12, N'23:01:10', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (4, 13, N'20:09:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 13, N'23:02:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 14, N'20:08:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 14, N'23:03:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 15, N'20:07:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 15, N'23:06:10', 2)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 16, N'20:05:19', 1)
INSERT INTO ������������_2.������_���������(����_�����, ID_������, �����_�������, �����������_��������) VALUES (5, 16, N'23:04:10', 2)





INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (66, 66)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (96, 66)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (196, 66)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (50, 50)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (90, 50)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (150, 50)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (190, 50)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (759, 50)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (790, 50)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (54, 54)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (154, 54)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (754, 54)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (22, 22)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (122, 22)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (222, 22)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (23, 23)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (93, 23)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (123, 23)
INSERT INTO ������������_2.����_�������_��������(���_�������, ��������_���_�������) VALUES (193, 23)


INSERT INTO ������������_2.����������_��������(���_�������, ��������_�������) VALUES (66, N'������������ �������')
INSERT INTO ������������_2.����������_��������(���_�������, ��������_�������) VALUES (50, N'���������� �������')
INSERT INTO ������������_2.����������_��������(���_�������, ��������_�������) VALUES (54, N'������������� �������')
INSERT INTO ������������_2.����������_��������(���_�������, ��������_�������) VALUES (22, N'��������� ����')
INSERT INTO ������������_2.����������_��������(���_�������, ��������_�������) VALUES (23, N'������������� ����')

GO

/*SELECT * FROM ������������_2.������_�����
SELECT * FROM ������������_2.������_���������
SELECT * FROM ������������_2.����������_��������
SELECT * FROM ������������_2.������_��������
GO*/

--���
CREATE VIEW ���_������ AS
SELECT ������.ID_������, 
       ������.���_����� AS ���_�����, 
	   ������.���������,
	   ���_�������_������.���_�������, 
	   ��������_���_�������,
	   �����_�������_������.��������_������� AS ��������_�������, 
	   ������_��������.����_����� AS ����_��������, 
	   ������_�������.����_����� AS ����_�������,
	   �����_��������.�����_������� AS �����_��������,
	   �����_�������.�����_�������  AS �����_�������
FROM 
    ������������_2.������_��������� AS ������_�������� INNER JOIN
	������������_2.������_��������� AS ������_������� ON  ������_��������.ID_������ = ������_�������.ID_������ INNER JOIN
    ������������_2.������_����� AS ������ ON ������_��������.ID_������ = ������.ID_������ INNER JOIN
    ������������_2.����_�������_�������� AS ���_�������_������ ON ������.���_������� = ���_�������_������.���_������� INNER JOIN 
	������������_2.����������_�������� AS �����_�������_������ ON  �����_�������_������.���_������� = ���_�������_������.��������_���_������� INNER JOIN
	������������_2.������_��������� AS �����_�������� ON �����_��������.�����_������� = ������_��������.�����_������� INNER JOIN
	������������_2.������_��������� AS �����_������� ON �����_�������.�����_������� = ������_�������.�����_�������
WHERE NOT (������_��������.ID_������ = ������_�������.ID_������) AND ������_��������.�����������_�������� = 1 
GO

--����������
CREATE VIEW ���������� AS 
SELECT * FROM ���_������
WHERE NOT (����_�������� = ����_�������) AND NOT(��������_���_������� = 66) AND (�����_�������� < �����_�������)
GO

--�����������
CREATE VIEW ����������� AS 
SELECT * FROM ���_������
WHERE ���_������.����_�������� = ���_������.����_������� AND (�����_�������� > �����_�������)
GO

--�������
CREATE VIEW ������� AS 
SELECT * FROM ���_������
WHERE (�����_�������� < �����_�������) AND (��������_���_������� = 66)
GO
--������
 CREATE VIEW ������ AS
 SELECT * FROM ���_������
 WHERE NOT ((�����_�������� < �����_�������) AND (��������_���_������� = 66)) 
      AND NOT (���_������.����_�������� = ���_������.����_������� AND (�����_�������� > �����_�������))
	  AND NOT(NOT (����_�������� = ����_�������) AND NOT(��������_���_������� = 66) AND (�����_�������� < �����_�������))
 GO


 /*SELECT * FROM ���_������ ORDER BY ID_������
 SELECT * FROM ���������� ORDER BY ID_������
 SELECT * FROM ����������� ORDER BY ID_������*/
 --SELECT * FROM ������� --ORDER BY ID_������
 --SELECT * FROM ������ ORDER BY ID_������
 GO