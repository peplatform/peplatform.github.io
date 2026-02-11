<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Data.OleDb"%>

<script language="C#" runat="server">
public class SqlConnect {
	private SqlConnection dataConn = null;
	private SqlDataReader reader = null;
	
	public string openConnection(HttpResponse Response,string dbConnectString,string cmdString) {
		try {
			dataConn = new SqlConnection(dbConnectString);
			SqlCommand sqlCmd = new SqlCommand(cmdString,dataConn);
			dataConn.Open();
		    reader = sqlCmd.ExecuteReader();
			Response.Write("<table><tr><td><b>ID</b></td><td><b>Name</b></td></tr>");
			while (reader.Read()) {
				Response.Write("<tr>");
				Response.Write("<td>" + reader["CategoryID"].ToString() + "</td>");
				Response.Write("<td>" + reader["CategoryName"].ToString() + "</td>");
				Response.Write("</tr>");
			}
			Response.Write("</table>");
			return "<p>Sql Server Data Connection Opened";
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
}

public class OleDbConnect {
	private OleDbConnection dataConn = null;
	private OleDbDataReader reader = null;
	
	public string openConnection(HttpResponse Response,string dbConnectString,string cmdString) {
		try {
			dataConn = new OleDbConnection(dbConnectString);
			OleDbCommand oleDbCmd = new OleDbCommand(cmdString,dataConn);
			dataConn.Open();
			reader = oleDbCmd.ExecuteReader();
			Response.Write("<table><tr><td><b>ID</b></td><td><b>Name</b></td></tr>");
			while (reader.Read()) {
					Response.Write("<tr>");
					Response.Write("<td>" + reader["CategoryID"].ToString() + "</td>");
					Response.Write("<td>" + reader["CategoryName"].ToString() + "</td>");
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
	}
}

public void Page_Load(Object Src, EventArgs E) { 
	string OleDbconnStr = @"Provider=SQLOLEDB.1;Data Source=(local);
						  uid=sa;pwd=;Initial Catalog=Northwind";
	string SqlconnStr = "server=localhost;uid=sa;pwd=;database=Northwind";
	string sql = "SELECT * FROM Categories";
	
	//Open Sql Connection
	Response.Write("<b>Sql Managed Provider:</b><p>");
	SqlConnect Sqlconn = new SqlConnect();
	Response.Write(Sqlconn.openConnection(Response,SqlconnStr,sql) + " to " + SqlconnStr + "<p>");
	
	//Open OleDb Connection
	Response.Write("<p><b>OleDb Managed Provider:</b><p>");
	OleDbConnect OleDbconn = new OleDbConnect();
	Response.Write(OleDbconn.openConnection(Response,OleDbconnStr,sql) + " to " + OleDbconnStr + "<p>");

} 
</script>