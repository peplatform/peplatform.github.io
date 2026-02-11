<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.IO" %>
<script language="C#" runat="server">
    public void Page_Load(Object sender, EventArgs E) {		
        string xmlPath = Server.MapPath("listing8.8.2.xml");
        string xslPath = Server.MapPath("listing8.8.6.xsl"); 
	    
        FileStream fs = new FileStream(xmlPath,FileMode.Open,
                                       FileAccess.Read);
        StreamReader reader = new StreamReader(fs,Encoding.UTF8);
        XmlTextReader xmlReader = new XmlTextReader(reader);
	    
        //Instantiate the XPathDocument Class
        XPathDocument doc = new XPathDocument(xmlReader);
        
        //Instantiate the XslTransform Class and XsltArgumentList
        XsltArgumentList args = new XsltArgumentList();
        args.AddParam("golferLastName","","Trainor");

        XslTransform xslDoc = new XslTransform();
        xslDoc.Load(xslPath);
        xslDoc.Transform(doc,args,Response.Output);
		
        //Close Readers
        reader.Close();
        xmlReader.Close();
     }
</script>
