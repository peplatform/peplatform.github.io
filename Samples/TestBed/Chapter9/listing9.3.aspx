<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Xml"%>
<script language="C#" runat="server">
public void Page_Load(Object Src, EventArgs E) { 
    string sql = Server.UrlEncode(@"SELECT Customers.CustomerID,
                                    Customers.ContactName, Orders.OrderID,
                                    Orders.CustomerID FROM Customers
                                    INNER JOIN Orders 
                                    ON Customers.CustomerID = Orders.CustomerID
                                    WHERE Customers.CustomerID = 'ALFKI'
                                    FOR XML AUTO");
    string schemaFile = Server.MapPath("httpSelect.xsd");
    DataSet ds = new DataSet();   
    
    //**** Load the Schema File and XML
    ds.ReadXmlSchema(schemaFile); 
    ds.ReadXml("http://localhost/northwind?sql=" + sql + "&root=Northwind");
    //**** Add Two Rows to the DataSet

    DataRow row = ds.Tables[0].NewRow();
    row["CustomerID"] = "DLWID";
    row["ContactName"] = "Dan Wahlin";
    
    DataRow row2 = ds.Tables[1].NewRow();
    row2["OrderID"] = "11000";
    row2["CustomerID"] = "DLWID";
    
    ds.Tables[0].Rows.Add(row);
    ds.Tables[1].Rows.Add(row2);
    //To nest new rows you can use one of the following:
    //1:  ds.Tables[1].Rows[ds.Tables[1].Rows.Count-1]["Customers_id"] = ds.Tables[0].Rows[ds.Tables[0].Rows.Count-1]["Customers_id"];
	//2:  ds.Tables[1].Rows[ds.Tables[1].Rows.Count-1].SetParentRow(
	//    ds.Tables[0].Rows[ds.Tables[0].Rows.Count-1]);
    
    // Code to actually insert row goes here.....
    DataView view = new DataView(ds.Tables[0]);

    view.Sort = "CustomerID ASC";
    Customers.DataSource = view;
    Customers.DataBind(); 
    
    view.Table = ds.Tables[1];
    Orders.DataSource = view;
    Orders.DataBind(); 
    //Let's look at the schema
    schemaDiv.InnerHtml = ds.GetXmlSchema();
}
</script>
<html>
	<body bgcolor="#ffffff">
		<form runat="server">
			<h2>XML Data Loaded Directly from SQL Server 2000 into a DataSet</h2>
			<ASP:DataGrid id="Customers" runat="server" Width="700" BackColor="#E6E6CC" BorderColor="#000000" ShowFooter="false" CellPadding=5 CellSpacing="0" Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#6C0A00" HeaderStyle-ForeColor="#ffffff" MaintainState="false" />
			<p>
				&nbsp;
			</p>
			<ASP:DataGrid id="Orders" runat="server" Width="700" BackColor="#E6E6CC" BorderColor="#000000" ShowFooter="false" CellPadding=5 CellSpacing="0" Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#6C0A00" HeaderStyle-ForeColor="#ffffff" MaintainState="false" />
			<p>
				&nbsp;
			</p>
			<textarea rows="20" cols="80" id="schemaDiv" runat="server"></textarea></form>
	</body>
</html>
