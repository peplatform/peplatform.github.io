<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.OleDb"%>
<script language="C#" runat="server">
public class OleDbConnect {
    private OleDbConnection dataConn = null;
    private OleDbDataReader reader = null;
    public string OpenConnection(HttpResponse Response,string dbConnectString,string cmdString,
        string paramName,string paramValue) {
    try {
        dataConn = new OleDbConnection(dbConnectString);
        OleDbCommand oleDbCmd = new OleDbCommand(cmdString,dataConn);
        oleDbCmd.CommandType = CommandType.StoredProcedure;
        OleDbParameter param = null;
        param = oleDbCmd.Parameters.Add(paramName, OleDbType.Char, 5);
        param.Direction = ParameterDirection.Input;
        oleDbCmd.Parameters[paramName].Value = paramValue;
        dataConn.Open();
        reader = oleDbCmd.ExecuteReader();
        Response.Write("<table><tr><td><b>Product Name</b></td><td><b>Total</b></td></tr>");
        while (reader.Read()) {
            Response.Write("<tr>");
            Response.Write("<td>" + reader["ProductName"].ToString() + "</td>");
            Response.Write("<td>" + reader["Total"].ToString() + "</td>");
            Response.Write("</tr>");
        }
        Response.Write("</table>");
        return "<p>OleDb Server Data Connection Opened";
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
  } //openConnection
} //OleDbConnect
 public void Page_Load(Object Src, EventArgs E) { 
    string connStr = @"Provider=SQLOLEDB.1;Data Source=(local);
				      uid=sa;pwd=;Initial Catalog=Northwind";
    string sql = "CustOrderHist";	
    //Open Sql Connection
    OleDbConnect oleDbconn = new OleDbConnect();
    oleDbconn.OpenConnection(Response, connStr,sql,"@customerID","ALFKI");
 } 
</script>