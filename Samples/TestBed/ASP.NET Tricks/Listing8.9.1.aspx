<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<script language="C#" runat="server">
	public void Page_Load(Object Src, EventArgs E) { 
		string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
		string sql = "SELECT * FROM Customers";	    
		SqlConnection dataConn = new SqlConnection(connStr);
		SqlDataAdapter adap = new SqlDataAdapter(sql,dataConn);
		DataSet ds = new DataSet();
		adap.Fill(ds,"Customers");
		foreach (DataRow row in ds.Tables["Customers"].Rows) {
		    Response.Write(row["ContactName"].ToString() + "<br />");
		}	
		if (dataConn != null) dataConn.Close();	
	} 

</script>
