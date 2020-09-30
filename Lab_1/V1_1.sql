USE master;
GO

IF EXISTS(select * from sys.databases where name='DUBOVSKI_VLADUSLAV')
DROP DATABASE DUBOVSKI_VLADUSLAV

CREATE DATABASE DUBOVSKI_VLADUSLAV
GO

USE DUBOVSKI_VLADUSLAV;
GO

CREATE SCHEMA sales;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);

BACKUP DATABASE DUBOVSKI_VLADUSLAV
	TO DISK = 'D:\DUBOVSKI_VLADUSLAV.bak'
GO

USE master;
GO

DROP DATABASE DUBOVSKI_VLADUSLAV

RESTORE DATABASE DUBOVSKI_VLADUSLAV
	FROM DISK = 'D:\DUBOVSKI_VLADUSLAV.bak'