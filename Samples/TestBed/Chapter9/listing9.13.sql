SELECT   1                    as Tag, 
         NULL                 as Parent,
         Customers.CustomerID as [MyCustomer!1!CustID!ID],
         NULL                 as [MyCustomerOrder!2!OrdID!IDREF],
         NULL		      as [Employee!3!!cdata]
FROM Customers
WHERE Customers.CustomerID='ALFKI'

UNION ALL

SELECT   2, 
         1,
         Customers.CustomerID,
         Orders.OrderID,
         'NONE'
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
AND Customers.CustomerID = 'ALFKI'

UNION ALL

SELECT	 3,
         2,
         'NONE',
         Orders.OrderID,
         Employees.LastName
FROM Employees
INNER JOIN Orders ON Orders.EmployeeID = Orders.EmployeeID
INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.CustomerID = 'ALFKI'

ORDER BY [MyCustomer!1!CustID!ID], [MyCustomerOrder!2!OrdID!IDREF]
FOR XML EXPLICIT, XMLDATA