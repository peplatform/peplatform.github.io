<%@ Page %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="Server">
	private void Page_Load(object sender, System.EventArgs e) {
		Response.ContentType = "text/xml";
		string sql = "SELECT * FROM Customers FOR XML AUTO";
		string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
		SqlConnection sqlConn = new SqlConnection(connStr);
		sqlConn.Open();
		SqlCommand cmd = new SqlCommand(sql,sqlConn);
		XmlReader reader = cmd.ExecuteXmlReader();
		Response.Write("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
		Response.Write("<root>");
		while (reader.Read()) {
			Response.Write("<" + reader.Name + " ");
			if (reader.HasAttributes) {
				while (reader.MoveToNextAttribute()) {
					Response.Write(reader.Name + "=\"" +
					  new StringBuilder(reader.Value).Replace("&","&amp;") +
					  "\" " );
				}
			}
			Response.Write("/>");
		}
		Response.Write("</root>");
		sqlConn.Close();
		if (reader != null) reader.Close();
	}
</script>
