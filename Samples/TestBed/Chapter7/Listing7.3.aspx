<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<script language="C#" runat="server">
     public void Page_Load(Object sender, EventArgs E) {		
        string xmlPath = Server.MapPath("listing7.1.xml");
        string xslPath = Server.MapPath("listing7.2.xsl"); 
        
        //Instantiate the XPathDocument Class
		XPathDocument doc = new XPathDocument(xmlPath);
		
		//Instantiate the XslTransform Class
		XslTransform transform = new XslTransform();
		transform.Load(xslPath);
		
		transform.Transform(doc, null, Response.Output);
     }
</script>