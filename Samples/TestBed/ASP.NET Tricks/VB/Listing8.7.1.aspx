<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="VB" runat="Server">
   public sub Page_Load(sender as object, e as EventArgs) 
      Dim sXML as string = "<?xml version=""1.0""?><root><testA>"
      sXML += "<testChild>Testing!</testChild></testA></root>"
      Dim oDocument as XmlDocument= new XmlDocument()
      oDocument.LoadXml(sXML)   
      Dim oRoot as XmlNode = oDocument.DocumentElement
      try 
          Dim oElement1 as XmlElement = oDocument.CreateElement("testB")
          oElement1.SetAttribute("testBAtt","Testing B")
          Dim oElement2 as XmlElement = oDocument.CreateElement("testC")
          oElement2.AppendChild(oDocument.CreateTextNode("Text Node"))
		  oElement2.SetAttribute("testCAtt","Testing C")
          oRoot.AppendChild(oElement1)
          oRoot.AppendChild(oElement2)
      
      catch exc as Exception 
          Response.Write(exc.ToString())
      end try                  
      Response.ContentType ="text/xml"
      oDocument.Save(Response.Output)	
   end sub
</script>
