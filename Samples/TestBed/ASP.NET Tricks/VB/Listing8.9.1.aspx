<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<script language="VB" runat="server">
    public sub Page_Load(sender as Object, e as EventArgs) 
		Dim connStr as string = "server=localhost;uid=sa;pwd=;database=Northwind"
		Dim sql as string = "SELECT * FROM Customers"    
		Dim dataConn as SqlConnection = new SqlConnection(connStr)
		Dim adap as SqlDataAdapter = new SqlDataAdapter(sql,dataConn)
		Dim ds as DataSet = new DataSet()
		adap.Fill(ds,"Customers")
		Dim row as Datarow
		for each row in ds.Tables("Customers").Rows
		    Response.Write(row("ContactName").ToString() & "<br />")
		next	
		if (NOT dataConn Is Nothing) then dataConn.Close()
	end sub 

</script>
