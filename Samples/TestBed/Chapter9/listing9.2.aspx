<%@ Page %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<script language="C#" runat="Server">
    void Page_Load(object sender, EventArgs e) {
        string sql = Server.UrlEncode(@"SELECT Customers.CustomerID,
                     Customers.ContactName, Orders.OrderID, 
                     Orders.CustomerID FROM Customers 
                     INNER JOIN Orders 
                     ON Customers.CustomerID = Orders.CustomerID
                     FOR XML AUTO");
        string url = "http://localhost/northwind?sql=" + sql + "&root=Northwind";
        try {
            XPathDocument xmlDoc = new XPathDocument(url);
			XslTransform xslDoc = new XslTransform();
			xslDoc.Load(Server.MapPath("customers.xsl"));
			xslDoc.Transform(xmlDoc,null,Response.Output);
        }
        catch (Exception exc) {
			Response.Write(exc.ToString());
        }
    }
</script>
