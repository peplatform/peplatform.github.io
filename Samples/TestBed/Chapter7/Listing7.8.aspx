<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<script language="C#" runat="server">
    public void Page_Load(Object sender, EventArgs E) {		
        string xmlPath = Server.MapPath("listing7.1.xml");
        string xslPath = Server.MapPath("listing7.2.xsl"); 
	    
        FileStream fs = new FileStream(xmlPath,FileMode.Open,
                                       FileAccess.Read);
        StreamReader reader = new StreamReader(fs,Encoding.UTF8);
        XmlTextReader xmlReader = new XmlTextReader(reader);
	    
        //Instantiate the XPathDocument Class
        XPathDocument doc = new XPathDocument(xmlReader);
        Response.Write("XPathDocument successfully created!");
		
        //Close Readers
        reader.Close();
        xmlReader.Close();
     }
</script>