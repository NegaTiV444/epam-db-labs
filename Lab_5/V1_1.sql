USE AdventureWorks2012;
GO

IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'HumanResources.DepartmentsCountFor') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION HumanResources.DepartmentsCountFor
GO

IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'HumanResources.GetOldestDepartmentEmployees') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION HumanResources.GetOldestDepartmentEmployees
GO

--------------------------- SUBTASK a ---------------------------

CREATE FUNCTION HumanResources.DepartmentsCountFor(@GroupName nvarchar(50))
RETURNS int
BEGIN
	RETURN (
		SELECT COUNT(*) FROM HumanResources.Department
		WHERE Department.GroupName = @GroupName
	)
END;
GO

--------------------------- SUBTASK b ---------------------------

CREATE FUNCTION HumanResources.GetOldestDepartmentEmployees(@DepartmentID int)
RETURNS TABLE AS
RETURN (
	SELECT TOP(3) empl.* FROM HumanResources.Employee empl
	INNER JOIN HumanResources.EmployeeDepartmentHistory hist ON empl.BusinessEntityID = hist.BusinessEntityID
	WHERE hist.DepartmentID = @DepartmentID AND hist.StartDate >= '2005' AND hist.EndDate IS NULL
	ORDER BY empl.BirthDate ASC
);
GO

--------------------------- SUBTASK c ---------------------------

SELECT * FROM HumanResources.Department department
CROSS APPLY HumanResources.GetOldestDepartmentEmployees(department.DepartmentID);

SELECT * FROM HumanResources.Department department
OUTER APPLY HumanResources.GetOldestDepartmentEmployees(department.DepartmentID);

--------------------------- SUBTASK d ---------------------------

IF EXISTS (
    SELECT * FROM sysobjects WHERE id = object_id(N'HumanResources.GetOldestDepartmentEmployees') 
    AND xtype IN (N'FN', N'IF', N'TF')
)
    DROP FUNCTION HumanResources.GetOldestDepartmentEmployees
GO

CREATE FUNCTION HumanResources.GetOldestDepartmentEmployees(@DepartmentID int)
RETURNS @ResultTable TABLE(
	BusinessEntityID INT NOT NULL,
	BirthDate DATE NOT NULL,
	HireDate DATE NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @ResultTable
	SELECT TOP(3)
		empl.BusinessEntityID,
		empl.BirthDate,
		empl.HireDate,
		empl.rowguid,
		empl.ModifiedDate
	FROM HumanResources.Employee empl
	INNER JOIN HumanResources.EmployeeDepartmentHistory hist ON empl.BusinessEntityID = hist.BusinessEntityID
	WHERE hist.DepartmentID = @DepartmentID AND hist.StartDate >= '2005' AND hist.EndDate IS NULL
	ORDER BY empl.BirthDate ASC

	RETURN
END;
GO