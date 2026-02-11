<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<script language="VB" runat="server">
    public sub Page_Load(sender as Object, e as EventArgs) 
        Dim connStr as string = "server=localhost;uid=sa;" & _
                                    "pwd=;database=Northwind"
        Dim sql as string = "SELECT * FROM Customers"    
        Dim dataConn as SqlConnection = new SqlConnection(connStr)
        Dim adap as SqlDataAdapter = new SqlDataAdapter(sql,dataConn)
        Dim ds as DataSet = new DataSet()
        ds.DataSetName = "CustomerRecords"
        adap.Fill(ds,"Customers")
        Dim dataDoc as XmlDataDocument = new XmlDataDocument(ds)
        Dim xpath as string = _
            "/CustomerRecords/Customers[CustomerID='ALFKI']/ContactName"
        Dim customer as XmlNode = dataDoc.SelectSingleNode(xpath)
        if (NOT customer Is Nothing) then 
            Response.Write(customer.InnerText)
        end if
	  if (NOT dataConn Is Nothing) then dataConn.Close()
	end sub 
</script>
