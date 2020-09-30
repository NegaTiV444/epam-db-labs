USE AdventureWorks2012;
GO

---------------------------SUBTASK 1---------------------------

SELECT 
	e.BusinessEntityID,
	JobTitle,
	MAX(Rate) as MaxRate
FROM
	AdventureWorks2012.HumanResources.Employee e
INNER JOIN 
	AdventureWorks2012.HumanResources.EmployeePayHistory ph
ON 
	(e.BusinessEntityID = ph.BusinessEntityID)
GROUP BY
	e.BusinessEntityID, JobTitle;

---------------------------SUBTASK 2---------------------------

SELECT
	e.BusinessEntityID,
	e.JobTitle,
	ph.Rate,
	DENSE_RANK() OVER (ORDER BY ph.Rate) AS RankRate
FROM 
	HumanResources.EmployeePayHistory ph
INNER JOIN 
	HumanResources.Employee e
ON 
	e.BusinessEntityID = ph.BusinessEntityID
ORDER BY 
	ph.Rate;
	
---------------------------SUBTASK 3---------------------------

SELECT
	d.Name as DepName,
	e.BusinessEntityID,
	e.JobTitle,
	edh.ShiftID
FROM 
	HumanResources.Department d
LEFT JOIN 
	HumanResources.EmployeeDepartmentHistory edh 
ON 
	edh.DepartmentID = d.DepartmentID
LEFT JOIN 
	HumanResources.Employee e 
ON 
	e.BusinessEntityID = edh.BusinessEntityID
WHERE 
	edh.EndDate IS NULL
ORDER BY
	d.Name,
CASE 
	WHEN 
		d.Name = 'Document Control' 
	THEN 
		edh.ShiftID 
	ELSE 
		e.BusinessEntityID 
	END;