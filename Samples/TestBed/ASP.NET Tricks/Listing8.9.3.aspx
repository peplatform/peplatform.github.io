<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<script language="C#" runat="server">
	public void Page_Load(Object Src, EventArgs E) { 
		string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
		string sql = "SELECT * FROM Customers";	    
		SqlConnection dataConn = new SqlConnection(connStr);
		SqlDataAdapter adap = new SqlDataAdapter(sql,dataConn);
		DataSet ds = new DataSet();
		ds.DataSetName = "CustomerRecords";
		adap.Fill(ds,"Customers");
        XmlDataDocument dataDoc = new XmlDataDocument(ds);
        string xpath = "/CustomerRecords/Customers[CustomerID='ALFKI']/ContactName";
        XmlNode customer = dataDoc.SelectSingleNode(xpath);
        if (customer != null) Response.Write(customer.InnerText);
		if (dataConn != null) dataConn.Close();	
	} 
</script>
