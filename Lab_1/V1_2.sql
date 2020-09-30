USE AdventureWorks2012;
GO

---------------------------SUBTASK 1---------------------------

SELECT 
	BusinessEntityID,
	JobTitle,
	Gender,
	HireDate
FROM
	AdventureWorks2012.HumanResources.Employee
WHERE
	JobTitle 
IN
	('Accounts Manager', 'Benefits Specialist', 'Engineering Manager', 'Finance Manager', 'Maintenance Supervisor', 'Master Scheduler', 'Network Manager')

---------------------------SUBTASK 2---------------------------

SELECT COUNT(*) as EmpCount
FROM
	AdventureWorks2012.HumanResources.Employee
WHERE
	HireDate > '12/31/2003'  

---------------------------SUBTASK 3---------------------------

SELECT TOP 5
	BusinessEntityID,
	JobTitle,
	MaritalStatus,
	Gender,
	BirthDate,
	HireDate
FROM
	AdventureWorks2012.HumanResources.Employee
WHERE
	MaritalStatus = 'M' 
AND
	Year(HireDate) = 2004
ORDER BY 
	BirthDate
DESC 