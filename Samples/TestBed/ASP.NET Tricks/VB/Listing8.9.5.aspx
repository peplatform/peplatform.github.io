<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<%@ Import Namespace="System.IO"%>
<html>
	<script language="VB" runat="server">
    public sub Page_Load(sender as Object, e as EventArgs) 
		Dim ds as DataSet = new DataSet()  
		'**** Load the Schema File
		Dim reader as StreamReader
		try 
			reader = new StreamReader(Server.MapPath("schema.xsd"))
			ds.ReadXmlSchema(reader)
		finally
		     reader.Close()
		end try
		'**** Add Row to the Empty DataSet
		Dim row as DataRow = ds.Tables("Customers").NewRow()  
		row("CustomerID") = "DLWID"
		row("CompanyName") = "Wahlin Consulting"
		row("ContactName") = "Dan Wahlin"
		row("ContactTitle") = "Programmer/Author"
	     
		'****** Let's see how well the schema validates
		try 
			row("test") = "Testing Schema"
		
		catch exc as Exception
			'Don't do the insert because column["test"] doesn't really exist
		end try
		ds.Tables("Customers").Rows.Add(row)
		' Code to actually insert the row into a data source would go here
	     
		BeforeDataGrid.DataSource = ds.Tables("Customers").DefaultView
		BeforeDataGrid.DataBind()
	end sub
 </script>
	</head>
	<body bgcolor="#ffffff">
		<form runat="server">
			<h2>
				Data Loaded into a DataSet and Validated by a Schema
			</h2>
			<ASP:DataGrid id="BeforeDataGrid" runat="server" Width="700" BackColor="#E6E6CC" BorderColor="#000000" ShowFooter="false" CellPadding="5" CellSpacing="0" Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#6C0A00" HeaderStyle-ForeColor="#ffffff" EnableViewState="false" />
		</form>
	</body>
</html>
