<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<script language="VB" runat="server">
    public sub Page_Load(sender as Object, e as EventArgs) 
		Dim connStr as string ="server=localhost;uid=sa;pwd=;database=Northwind"
		Dim sql as string = "SELECT * FROM Customers"	    
		Dim dataConn as SqlConnection = new SqlConnection(connStr)
		Dim adap as SqlDataAdapter = new SqlDataAdapter(sql,dataConn)
		Dim ds as DataSet= new DataSet()
		ds.DataSetName = "CustomerRecords"
		adap.Fill(ds,"Customers")
        xmlSchema.Text = ds.GetXmlSchema()
        xml.Text = ds.GetXml()
		if (NOT dataConn Is Nothing) then dataConn.Close()
	end sub 
</script>
<html>
	<body>
		<form runat="server">
			<b>DataSet XML Schema:</b>
			<br />
			<asp:TextBox id="xmlSchema" Runat="server" Columns="90" Rows="20" TextMode="MultiLine" />
			<p />
			<b>DataSet XML:</b>
			<br />
			<asp:TextBox id="xml" Runat="server" Columns="90" Rows="20" TextMode="MultiLine" />
		</form>
	</body>
</html>
