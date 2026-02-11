<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.IO" %>
<script language="VB" runat="server">
    public sub Page_Load(sender as Object, e as EventArgs) 		
        Dim xmlPath as string = Server.MapPath("listing8.8.2.xml")
        Dim xslPath as string = Server.MapPath("listing8.8.1.xsl")

        Dim fs as FileStream = new FileStream(xmlPath,FileMode.Open, FileAccess.Read)
        Dim reader as StreamReader = new StreamReader(fs,Encoding.UTF8)
        Dim xmlReader as XmlTextReader = new XmlTextReader(reader)
	    
        'Instantiate the XPathDocument Class
        Dim doc as XPathDocument = new XPathDocument(xmlReader)
        
        'Instantiate the XslTransform Class
        Dim xslDoc as XslTransform = new XslTransform()
        xslDoc.Load(xslPath)
        xslDoc.Transform(doc,Nothing,Response.Output)
		
        'Close Readers
        reader.Close()
        xmlReader.Close()
     end sub
</script>
