<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<script language="C#" runat="server">
	public void Page_Load(Object Src, EventArgs E) { 
		string connStr ="server=localhost;uid=sa;pwd=;database=Northwind";
		string sql = "SELECT * FROM Customers";	    
		SqlConnection dataConn = new SqlConnection(connStr);
		SqlDataAdapter adap = new SqlDataAdapter(sql,dataConn);
		DataSet ds = new DataSet();
		ds.DataSetName = "CustomerRecords";
		adap.Fill(ds,"Customers");
        xmlSchema.Text = ds.GetXmlSchema();
        xml.Text = ds.GetXml();
		if (dataConn != null) dataConn.Close();	
	} 
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
			<asp:TextBox id="xml" Runat="server" Columns="90" Rows="20" TextMode="MultiLine" /></body>
		</form>
</html>
