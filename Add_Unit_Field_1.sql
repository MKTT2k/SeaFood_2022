/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Product
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	Name nvarchar(255) NULL,
	Code nvarchar(255) NULL,
	Description nvarchar(MAX) NULL,
	Detail ntext NULL,
	Images nvarchar(MAX) NULL,
	Avatar nvarchar(MAX) NULL,
	Quantity int NULL,
	UnitPrice decimal(18, 0) NULL,
	Price decimal(18, 0) NULL,
	SaleOff decimal(18, 0) NULL,
	StartDate datetime NULL,
	EndDate datetime NULL,
	Published bit NULL,
	[View] int NULL,
	IsHot bit NULL,
	Unit nvarchar(255) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Product SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Product ON
GO
IF EXISTS(SELECT * FROM dbo.Product)
	 EXEC('INSERT INTO dbo.Tmp_Product (Id, Name, Code, Description, Detail, Images, Avatar, Quantity, UnitPrice, Price, SaleOff, StartDate, EndDate, Published, [View], IsHot)
		SELECT Id, Name, Code, Description, Detail, Images, Avatar, Quantity, UnitPrice, Price, SaleOff, StartDate, EndDate, Published, [View], IsHot FROM dbo.Product WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Product OFF
GO
ALTER TABLE dbo.OrderItem
	DROP CONSTRAINT FK_OrderItem_Product
GO
DROP TABLE dbo.Product
GO
EXECUTE sp_rename N'dbo.Tmp_Product', N'Product', 'OBJECT' 
GO
ALTER TABLE dbo.Product ADD CONSTRAINT
	PK_Product PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.OrderItem ADD CONSTRAINT
	FK_OrderItem_Product FOREIGN KEY
	(
	ProductId
	) REFERENCES dbo.Product
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.OrderItem SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO

