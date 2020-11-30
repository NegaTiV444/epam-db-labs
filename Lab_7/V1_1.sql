USE AdventureWorks2012;
GO

IF OBJECT_ID(N'tempdb..#Employees') IS NOT NULL
BEGIN
DROP TABLE #Employees
END
GO

DECLARE @XML XML;

SET @XML = (
    SELECT BusinessEntityID AS '@ID', NationalIDNumber, JobTitle
    FROM HumanResources.Employee
    FOR XML PATH ('Employee'), ROOT ('Employees')
);

SELECT
    node.value('@ID', 'INT') as BusinessEntityID,
    node.value('NationalIDNumber[1]', 'NVARCHAR(15)') as NationalIDNumber,
    node.value('JobTitle[1]', 'NVARCHAR(50)') as JobTitle
INTO #Employees
FROM @XML.nodes('/Employees/Employee') AS xml(node);

SELECT * FROM #Employees;