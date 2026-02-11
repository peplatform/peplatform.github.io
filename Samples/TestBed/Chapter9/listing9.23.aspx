<%@ Page %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<script language="C#" runat="Server">
	private void Page_Load(object sender, System.EventArgs e) {
		string xmlStart = "<?xml version=\"1.0\"?><Northwind>";
		string xmlEnd   = "</Northwind>";
		string sql = @"SELECT * FROM Customers
		               INNER JOIN Orders
		               ON Customers.CustomerID = Orders.CustomerID
		               FOR XML AUTO";
		string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
		SqlConnection sqlConn = new SqlConnection(connStr);
		sqlConn.Open();
		SqlCommand cmd = new SqlCommand(sql,sqlConn);
		XmlTextReader reader = (XmlTextReader)cmd.ExecuteXmlReader();
		//XPathDocument will add a root node for us
		XPathDocument xmlDoc = new XPathDocument(reader);
		XslTransform xslDoc = new XslTransform();
		xslDoc.Load(Server.MapPath("customers.xsl"));
		xslDoc.Transform(xmlDoc,null,Response.Output); 
		sqlConn.Close();
		if (reader != null) reader.Close();
	}
</script>
