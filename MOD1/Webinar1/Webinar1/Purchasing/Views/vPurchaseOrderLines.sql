CREATE VIEW [Purchasing].[vPurchaseOrderLines]
	AS SELECT 
	[PurchaseOrderLineID] ,
    [PurchaseOrderID]     ,
    [StockItemID],
	[Description] 
	
FROM [Purchasing].[PurchaseOrderLines]