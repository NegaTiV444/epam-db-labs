USE AdventureWorks2012;
GO

--------------------------- SUBTASK a ---------------------------

ALTER TABLE dbo.Person
ADD
	SalesYTD MONEY,
	SalesLastYear MONEY,
	OrdersNum INT,
	SalesDiff AS (SalesLastYear - SalesYTD);
GO

--------------------------- SUBTASK b ---------------------------

CREATE TABLE #Person (
	BusinessEntityID INT,
	PersonType nchar(2),
	NameStyle bit NULL,
	Title nvarchar(8),
	FirstName nvarchar(50),
	MiddleName nvarchar(50),
	LastName nvarchar(50),
	Suffix nvarchar(5),
	EmailPromotion INT,
	ModifiedDate datetime,
	ID bigint,
	SalesYTD MONEY,
	SalesLastYear MONEY,
	OrdersNum INT,
	PRIMARY KEY (BusinessEntityID)
);
GO

--------------------------- SUBTASK c ---------------------------

WITH OrdersNum_CTE AS (
	SELECT
		SalesPersonID as BusinessEntityID,
		COUNT(SalesOrderID) as Count
	FROM Sales.SalesOrderHeader
	GROUP BY SalesPersonID
)
INSERT INTO #Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	ID,
	SalesYTD,
	SalesLastYear,
	OrdersNum
)
SELECT
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	person.Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate,
	person.ID,
	sales.SalesYTD,
	sales.SalesLastYear,
	OrdersNum_CTE.Count
FROM dbo.Person person
LEFT JOIN Sales.SalesPerson sales ON sales.BusinessEntityID = person.BusinessEntityID
LEFT JOIN OrdersNum_CTE ON OrdersNum_CTE.BusinessEntityID = person.BusinessEntityID;

--------------------------- SUBTASK d ---------------------------

DELETE FROM dbo.Person WHERE BusinessEntityID = 290;

--------------------------- SUBTASK e ---------------------------

MERGE INTO dbo.Person AS target_t
USING #Person AS source_t ON target_t.BusinessEntityID = source_t.BusinessEntityID
WHEN MATCHED THEN
	UPDATE SET
		SalesYTD = source_t.SalesYTD,
		SalesLastYear = source_t.SalesLastYear,
		OrdersNum = source_t.OrdersNum
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		BusinessEntityID,
		PersonType,
		NameStyle,
		Title,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		EmailPromotion,
		ModifiedDate,
		SalesYTD,
		SalesLastYear,
		OrdersNum
	)
	VALUES (
		source_t.BusinessEntityID,
		source_t.PersonType,
		source_t.NameStyle,
		source_t.Title,
		source_t.FirstName,
		source_t.MiddleName,
		source_t.LastName,
		source_t.Suffix,
		source_t.EmailPromotion,
		source_t.ModifiedDate,
		source_t.SalesYTD,
		source_t.SalesLastYear,
		source_t.OrdersNum
	)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;