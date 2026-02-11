DECLARE @docID int
DECLARE @XmlDoc varchar(2000)
SET @XmlDoc ='
<ROOT>
 <Customer CustomerID="DLWID" ContactName="Dan Wahlin">
    <Order OrderID="10248" CustomerID="DLWID"
           OrderDate="2000-09-09T00:00:00">
       <OrderDetail ProductID="11" Quantity="12"/>
       <OrderDetail ProductID="42" Quantity="10"/>
    </Order>
 </Customer>
 <Customer CustomerID="JJDID" ContactName="John Doe">
    <Order OrderID="10283" CustomerID="JJDID" 
           OrderDate="2000-09-04T00:00:00">
       <OrderDetail ProductID="72" Quantity="3"/>
    </Order>
 </Customer>
 </ROOT>'
 EXEC sp_xml_preparedocument @docID OUTPUT, @XmlDoc
 SELECT *
 FROM OPENXML (@docID, '/ROOT/Customer',1)
       WITH (CustomerID  varchar(10),
             ContactName varchar(20),
             OrderDate DateTime './Order',
             ProductID int './Order/OrderDetail/@ProductID')
 EXEC sp_xml_removedocument @docID
