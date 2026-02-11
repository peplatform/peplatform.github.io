<%@ Page %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<script language="C#" runat="Server">
	private void Page_Load(object sender, System.EventArgs e) {
		//Define the entity returned by the data
		string entityString = "<!ENTITY contact 'Anders'>";
		string sql = @"SELECT * FROM Customers
		               INNER JOIN Orders
		               ON Customers.CustomerID = Orders.CustomerID
		               WHERE Customers.CustomerID = 'ALFKI'
		               FOR XML AUTO";
		string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
		SqlConnection sqlConn = new SqlConnection(connStr);
		sqlConn.Open();
		SqlCommand cmd = new SqlCommand(sql,sqlConn);
		XmlReader reader = cmd.ExecuteXmlReader();
		reader.MoveToContent();
		//SQL 2000 will automatically escape & with &amp; so do a replace
		string xmlString = 
		  new StringBuilder(reader.ReadOuterXml()).Replace("&amp;","&").ToString();
		  
		//Create the parser context.  This specifies that the DOCTYPE root is 
		//Customers and the subset to add in (entityString in this case)
		XmlParserContext xmlContext = 
		  new XmlParserContext(null, null, "Customers", null, null, entityString,
		                       "", "", XmlSpace.None);
		XmlValidatingReader xmlReader = 
		  new XmlValidatingReader(xmlString,XmlNodeType.Element,xmlContext);
		xmlReader.ValidationType = ValidationType.None;
		XmlDocument xmlDoc = new XmlDocument();
		XmlElement root = xmlDoc.CreateElement("Northwind");
		xmlDoc.AppendChild(root);
		while (!xmlReader.EOF) {
		    root.AppendChild(xmlDoc.ReadNode(xmlReader));
		}
		
		//Do Transformation
		XslTransform xslDoc = new XslTransform();
		xslDoc.Load(Server.MapPath("customers.xsl"));
		xslDoc.Transform(xmlDoc,null,Response.Output); 
		sqlConn.Close();
		if (xmlReader != null) xmlReader.Close();
		if (reader != null) reader.Close();
		
	}
</script>
