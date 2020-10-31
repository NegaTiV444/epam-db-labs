USE AdventureWorks2012;
GO

--------------------------- SUBTASK a ---------------------------

CREATE TABLE Production.ProductCategoryHst (
	ID bigint PRIMARY KEY IDENTITY(1, 1),
	Action nchar(16) CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate datetime,
	SourceID int,
	UserName nvarchar(256)
);
GO

--------------------------- SUBTASK b ---------------------------

CREATE TRIGGER Production.ProductCategoryActionTrigger ON Production.ProductCategory
AFTER INSERT, UPDATE, DELETE AS
	DECLARE @datetime DATETIME;
	SET @datetime = CURRENT_TIMESTAMP;

	INSERT INTO Production.ProductCategoryHst (
		Action,
		ModifiedDate,
		SourceID,
		UserName
	)
	SELECT
		'UPDATE',
		@datetime,
		INSERTED.ProductCategoryID,
		CURRENT_USER
	FROM INSERTED
	INNER JOIN DELETED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
	UNION ALL
		SELECT
			'INSERT',
			@datetime,
			INSERTED.ProductCategoryID,
			CURRENT_USER
		FROM INSERTED
		LEFT JOIN DELETED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
		WHERE DELETED.ProductCategoryID IS NULL
	UNION ALL
		SELECT
			'DELETE',
			@datetime,
			DELETED.ProductCategoryID,
			CURRENT_USER
		FROM DELETED
		LEFT JOIN INSERTED ON INSERTED.ProductCategoryID = DELETED.ProductCategoryID
		WHERE INSERTED.ProductCategoryID IS NULL;
GO

--------------------------- SUBTASK c ---------------------------

CREATE VIEW Production.ProductCategoryView AS
	SELECT * FROM Production.ProductCategory;
GO

--------------------------- SUBTASK d ---------------------------

INSERT INTO Production.ProductCategoryView (Name)
VALUES ('Name 1');

UPDATE Production.ProductCategoryView SET Name = 'Name 2' WHERE Name = 'Name 1';

DELETE Production.ProductCategoryView WHERE Name = 'Name 2';

SELECT * FROM Production.ProductCategoryHst;