<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<script language="C#" runat="server">
public class SqlConnect {
    private SqlConnection dataConn = null;
    private SqlDataReader reader = null;
	
    public string OpenConnection(HttpResponse Response,
        string dbConnectString,string cmdString, string paramName, string paramValue) {
        try {
            dataConn = new SqlConnection(dbConnectString);
            SqlCommand sqlCmd = new SqlCommand(cmdString,dataConn);
            sqlCmd.CommandType = CommandType.StoredProcedure;

            SqlParameter param = sqlCmd.Parameters.Add(new SqlParameter(paramName,SqlDbType.Char, 5));

            param.Direction = ParameterDirection.Input;
            sqlCmd.Parameters[paramName].Value = paramValue;
            dataConn.Open();
            reader = sqlCmd.ExecuteReader();
            Response.Write("<table><tr><td><b>Product Name</b></td>");
            Response.Write("<td><b>Total</b></td></tr>");
            while (reader.Read()) {
                Response.Write("<tr>");
                Response.Write("<td>"+reader["ProductName"].ToString());
                Response.Write("</td>");
                Response.Write("<td>"+reader["Total"].ToString());
                Response.Write("</td></tr>");
            }
            Response.Write("</table>");
            return "<p>Stored Procedure called successfully!";
        }
        catch (Exception e) {
            return(e.ToString());
        }
        finally {
            if (reader != null) {
                reader.Close();
            }
            if (dataConn != null) {
                dataConn.Close();
            }
        }
    }
 } // End Class
 public void Page_Load(Object Src, EventArgs E) { 
    string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
    string sql = "CustOrderHist";	
    //Open Sql Connection
    SqlConnect sqlconn = new SqlConnect();
    sqlconn.OpenConnection(Response, connStr,sql,"@customerID","ALFKI");
 } 
</script>