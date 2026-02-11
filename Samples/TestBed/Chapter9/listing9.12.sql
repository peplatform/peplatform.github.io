SELECT   1                    as Tag, 
         NULL                 as Parent,
         Customers.CustomerID as [MyCustomer!1!CustID],
         NULL                 as [MyCustomerOrder!2!OrdID]
FROM Customers
WHERE Customers.CustomerID='ALFKI'
UNION ALL
SELECT   2, 
         1,
         Customers.CustomerID,
         Orders.OrderID
FROM Customers, Orders
WHERE Customers.CustomerID = Orders.CustomerID
AND Customers.CustomerID = 'ALFKI'
ORDER BY [MyCustomer!1!CustID], [MyCustomerOrder!2!OrdID]
FOR XML EXPLICIT