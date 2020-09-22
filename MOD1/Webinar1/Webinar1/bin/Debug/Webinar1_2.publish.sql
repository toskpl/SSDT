﻿/*
Deployment script for WideWorldImportersWebinar1

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "WideWorldImportersWebinar1"
:setvar DefaultFilePrefix "WideWorldImportersWebinar1"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [Purchasing].[PurchaseOrderLines].[Twitter] on table [Purchasing].[PurchaseOrderLines] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [Purchasing].[PurchaseOrderLines])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping [Purchasing].[DF_Purchasing_PurchaseOrderLines_PurchaseOrderLineID]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] DROP CONSTRAINT [DF_Purchasing_PurchaseOrderLines_PurchaseOrderLineID];


GO
PRINT N'Dropping [Purchasing].[DF_Purchasing_PurchaseOrderLines_LastEditedWhen]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] DROP CONSTRAINT [DF_Purchasing_PurchaseOrderLines_LastEditedWhen];


GO
PRINT N'Dropping [Purchasing].[FK_Purchasing_PurchaseOrderLines_Application_People]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] DROP CONSTRAINT [FK_Purchasing_PurchaseOrderLines_Application_People];


GO
PRINT N'Dropping [Purchasing].[FK_Purchasing_PurchaseOrderLines_PackageTypeID_Warehouse_PackageTypes]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] DROP CONSTRAINT [FK_Purchasing_PurchaseOrderLines_PackageTypeID_Warehouse_PackageTypes];


GO
PRINT N'Dropping [Purchasing].[FK_Purchasing_PurchaseOrderLines_PurchaseOrderID_Purchasing_PurchaseOrders]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] DROP CONSTRAINT [FK_Purchasing_PurchaseOrderLines_PurchaseOrderID_Purchasing_PurchaseOrders];


GO
PRINT N'Dropping [Purchasing].[FK_Purchasing_PurchaseOrderLines_StockItemID_Warehouse_StockItems]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] DROP CONSTRAINT [FK_Purchasing_PurchaseOrderLines_StockItemID_Warehouse_StockItems];


GO
PRINT N'Starting rebuilding table [Purchasing].[PurchaseOrderLines]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [Purchasing].[tmp_ms_xx_PurchaseOrderLines] (
    [PurchaseOrderLineID]       INT             CONSTRAINT [DF_Purchasing_PurchaseOrderLines_PurchaseOrderLineID] DEFAULT ( NEXT VALUE FOR [Sequences].[PurchaseOrderLineID]) NOT NULL,
    [PurchaseOrderID]           INT             NOT NULL,
    [StockItemID]               INT             NOT NULL,
    [OrderedOuters]             INT             NOT NULL,
    [Description]               NVARCHAR (100)  NOT NULL,
    [ReceivedOuters]            INT             NOT NULL,
    [PackageTypeID]             INT             NOT NULL,
    [ExpectedUnitPricePerOuter] DECIMAL (18, 2) NULL,
    [LastReceiptDate]           DATE            NULL,
    [IsOrderLineFinalized]      BIT             NOT NULL,
    [LastEditedBy]              INT             NOT NULL,
    [Twitter]                   NVARCHAR (100)  NOT NULL,
    [LastEditedWhen]            DATETIME2 (7)   CONSTRAINT [DF_Purchasing_PurchaseOrderLines_LastEditedWhen] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Purchasing_PurchaseOrderLines1] PRIMARY KEY CLUSTERED ([PurchaseOrderLineID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [Purchasing].[PurchaseOrderLines])
    BEGIN
        INSERT INTO [Purchasing].[tmp_ms_xx_PurchaseOrderLines] ([PurchaseOrderLineID], [PurchaseOrderID], [StockItemID], [OrderedOuters], [Description], [ReceivedOuters], [PackageTypeID], [ExpectedUnitPricePerOuter], [LastReceiptDate], [IsOrderLineFinalized], [LastEditedBy], [LastEditedWhen])
        SELECT   [PurchaseOrderLineID],
                 [PurchaseOrderID],
                 [StockItemID],
                 [OrderedOuters],
                 [Description],
                 [ReceivedOuters],
                 [PackageTypeID],
                 [ExpectedUnitPricePerOuter],
                 [LastReceiptDate],
                 [IsOrderLineFinalized],
                 [LastEditedBy],
                 [LastEditedWhen]
        FROM     [Purchasing].[PurchaseOrderLines]
        ORDER BY [PurchaseOrderLineID] ASC;
    END

DROP TABLE [Purchasing].[PurchaseOrderLines];

EXECUTE sp_rename N'[Purchasing].[tmp_ms_xx_PurchaseOrderLines]', N'PurchaseOrderLines';

EXECUTE sp_rename N'[Purchasing].[tmp_ms_xx_constraint_PK_Purchasing_PurchaseOrderLines1]', N'PK_Purchasing_PurchaseOrderLines', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[FK_Purchasing_PurchaseOrderLines_PurchaseOrderID]...';


GO
CREATE NONCLUSTERED INDEX [FK_Purchasing_PurchaseOrderLines_PurchaseOrderID]
    ON [Purchasing].[PurchaseOrderLines]([PurchaseOrderID] ASC);


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[FK_Purchasing_PurchaseOrderLines_StockItemID]...';


GO
CREATE NONCLUSTERED INDEX [FK_Purchasing_PurchaseOrderLines_StockItemID]
    ON [Purchasing].[PurchaseOrderLines]([StockItemID] ASC);


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[FK_Purchasing_PurchaseOrderLines_PackageTypeID]...';


GO
CREATE NONCLUSTERED INDEX [FK_Purchasing_PurchaseOrderLines_PackageTypeID]
    ON [Purchasing].[PurchaseOrderLines]([PackageTypeID] ASC);


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[IX_Purchasing_PurchaseOrderLines_Perf_20160301_4]...';


GO
CREATE NONCLUSTERED INDEX [IX_Purchasing_PurchaseOrderLines_Perf_20160301_4]
    ON [Purchasing].[PurchaseOrderLines]([IsOrderLineFinalized] ASC, [StockItemID] ASC)
    INCLUDE([OrderedOuters], [ReceivedOuters]);


GO
PRINT N'Creating [Purchasing].[FK_Purchasing_PurchaseOrderLines_Application_People]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH NOCHECK
    ADD CONSTRAINT [FK_Purchasing_PurchaseOrderLines_Application_People] FOREIGN KEY ([LastEditedBy]) REFERENCES [Application].[People] ([PersonID]);


GO
PRINT N'Creating [Purchasing].[FK_Purchasing_PurchaseOrderLines_PackageTypeID_Warehouse_PackageTypes]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH NOCHECK
    ADD CONSTRAINT [FK_Purchasing_PurchaseOrderLines_PackageTypeID_Warehouse_PackageTypes] FOREIGN KEY ([PackageTypeID]) REFERENCES [Warehouse].[PackageTypes] ([PackageTypeID]);


GO
PRINT N'Creating [Purchasing].[FK_Purchasing_PurchaseOrderLines_PurchaseOrderID_Purchasing_PurchaseOrders]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH NOCHECK
    ADD CONSTRAINT [FK_Purchasing_PurchaseOrderLines_PurchaseOrderID_Purchasing_PurchaseOrders] FOREIGN KEY ([PurchaseOrderID]) REFERENCES [Purchasing].[PurchaseOrders] ([PurchaseOrderID]);


GO
PRINT N'Creating [Purchasing].[FK_Purchasing_PurchaseOrderLines_StockItemID_Warehouse_StockItems]...';


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH NOCHECK
    ADD CONSTRAINT [FK_Purchasing_PurchaseOrderLines_StockItemID_Warehouse_StockItems] FOREIGN KEY ([StockItemID]) REFERENCES [Warehouse].[StockItems] ([StockItemID]);


GO
PRINT N'Altering [Purchasing].[vPurchaseOrderLines]...';


GO
ALTER VIEW [Purchasing].[vPurchaseOrderLines]
	AS SELECT 
	[PurchaseOrderLineID] ,
    [PurchaseOrderID]     ,
    [StockItemID],
	[Description] 
	
FROM [Purchasing].[PurchaseOrderLines]
GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Detail lines from supplier purchase orders', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[PurchaseOrderLineID].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Numeric ID used for reference to a line on a purchase order within the database', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'PurchaseOrderLineID';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[PurchaseOrderID].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Purchase order that this line is associated with', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'PurchaseOrderID';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[StockItemID].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Stock item for this purchase order line', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'StockItemID';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[OrderedOuters].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Quantity of the stock item that is ordered', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'OrderedOuters';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[Description].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Description of the item to be supplied (Often the stock item name but could be supplier description)', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'Description';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[ReceivedOuters].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Total quantity of the stock item that has been received so far', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'ReceivedOuters';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[PackageTypeID].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Type of package received', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'PackageTypeID';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[ExpectedUnitPricePerOuter].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The unit price that we expect to be charged', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'ExpectedUnitPricePerOuter';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[LastReceiptDate].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The last date on which this stock item was received for this purchase order', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'LastReceiptDate';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[IsOrderLineFinalized].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Is this purchase order line now considered finalized? (Receipted quantities and weights are often not precise)', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'COLUMN', @level2name = N'IsOrderLineFinalized';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[FK_Purchasing_PurchaseOrderLines_PurchaseOrderID].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Auto-created to support a foreign key', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'INDEX', @level2name = N'FK_Purchasing_PurchaseOrderLines_PurchaseOrderID';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[FK_Purchasing_PurchaseOrderLines_StockItemID].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Auto-created to support a foreign key', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'INDEX', @level2name = N'FK_Purchasing_PurchaseOrderLines_StockItemID';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[FK_Purchasing_PurchaseOrderLines_PackageTypeID].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Auto-created to support a foreign key', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'INDEX', @level2name = N'FK_Purchasing_PurchaseOrderLines_PackageTypeID';


GO
PRINT N'Creating [Purchasing].[PurchaseOrderLines].[IX_Purchasing_PurchaseOrderLines_Perf_20160301_4].[Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Improves performance of order picking and invoicing', @level0type = N'SCHEMA', @level0name = N'Purchasing', @level1type = N'TABLE', @level1name = N'PurchaseOrderLines', @level2type = N'INDEX', @level2name = N'IX_Purchasing_PurchaseOrderLines_Perf_20160301_4';


GO
PRINT N'Refreshing [Integration].[GetPurchaseUpdates]...';


GO
EXECUTE sp_refreshsqlmodule N'[Integration].[GetPurchaseUpdates]';


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH CHECK CHECK CONSTRAINT [FK_Purchasing_PurchaseOrderLines_Application_People];

ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH CHECK CHECK CONSTRAINT [FK_Purchasing_PurchaseOrderLines_PackageTypeID_Warehouse_PackageTypes];

ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH CHECK CHECK CONSTRAINT [FK_Purchasing_PurchaseOrderLines_PurchaseOrderID_Purchasing_PurchaseOrders];

ALTER TABLE [Purchasing].[PurchaseOrderLines] WITH CHECK CHECK CONSTRAINT [FK_Purchasing_PurchaseOrderLines_StockItemID_Warehouse_StockItems];


GO
PRINT N'Update complete.';


GO
