<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Data.OleDb"%>

<script language="C#" runat="server">
public class SqlConnect {
	
    public string OpenConnection(HttpResponse Response,string dbConnectString,string cmdString) {
        try {
            DataSet dsOrders = new DataSet();
            SqlConnection dataConn = new SqlConnection(dbConnectString);
            SqlDataAdapter sqlAdapter = new SqlDataAdapter(cmdString,dataConn);
            sqlAdapter.Fill(dsOrders,"Orders");
            // Loop through DataSet "Orders" table
            Response.Write("<table><tr><td><b>Order ID</b></td></tr>");
            foreach (DataRow Order in dsOrders.Tables["Orders"].Rows) {
                Response.Write("<tr>");
                Response.Write("<td>" + Order["OrderId"].ToString()  + "</td>");
                Response.Write("</tr>");
            }
            Response.Write("</table>");
            return "<p>Sql Server Data Connection Opened";
        }
        catch (Exception e) {
            return(e.ToString());
        }
    }
}

public class OleDbConnect {

	public string OpenConnection(HttpResponse Response,string dbConnectString,string cmdString) {
		try {
			DataSet dsOrders = new DataSet();
			OleDbConnection dataConn = new OleDbConnection(dbConnectString);
			OleDbDataAdapter oleDbAdapter = new OleDbDataAdapter(cmdString,dataConn);
			oleDbAdapter.Fill(dsOrders,"Orders");
			// Loop through DataSet "Orders" table
			Response.Write("<table><tr><td><b>Order ID</b></td></tr>");
			foreach (DataRow Order in dsOrders.Tables["Orders"].Rows) {
				Response.Write("<tr>");
				Response.Write("<td>" + Order["OrderId"].ToString()  + "</td>");
				Response.Write("</tr>");
			}
			Response.Write("</table>");
      		return "<p>OleDb Server Data Connection Opened";
		}
		catch (Exception e) {
			return(e.ToString());
		}
	}
}

public void Page_Load(Object Src, EventArgs E) { 
    string SqlconnStr = "server=localhost;uid=sa;pwd=;database=Northwind";
	string OleDbconnStr = @"Provider=SQLOLEDB.1;Data Source=(local);
						  uid=sa;pwd=;Initial Catalog=Northwind";
    
	string sql = "SELECT OrderID FROM Orders";
	Response.Write("<b>SQL Managed Provider DataSet:</b>");
    SqlConnect sqlConn = new SqlConnect();
    sqlConn.OpenConnection(Response,SqlconnStr,sql);
    
    Response.Write("<p /><b>OleDb Managed Provider DataSet:</b>");
    OleDbConnect oleDbConn = new OleDbConnect();
    oleDbConn.OpenConnection(Response,OleDbconnStr,sql);

} 
</script>