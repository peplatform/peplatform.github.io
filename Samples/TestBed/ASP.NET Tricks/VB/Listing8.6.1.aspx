<%@ Import Namespace="System.Xml" %>
<script language="VB" runat="server">
    public sub Page_Load(Src as Object, e as EventArgs) 
      Dim xmlDoc as string = Server.MapPath("xmltextwriter.xml")
      Dim writer as XmlTextWriter
      try   
         writer = new XmlTextWriter(xmlDoc,Encoding.UTF8)
         writer.Formatting = Formatting.Indented
         writer.WriteStartDocument(true)
         writer.WriteComment("XML Nodes added using the XmlTextWriter")
         writer.WriteStartElement("customers")
            writer.WriteStartElement("customer")
               writer.WriteAttributeString("id","123456789")
               writer.WriteStartElement("info")
                  writer.WriteStartElement("name")
                     writer.WriteAttributeString("firstName","John")
                     writer.WriteAttributeString("lastName","Doe")
                  writer.WriteEndElement()
                  writer.WriteStartElement("address")
                     writer.WriteAttributeString("street","1234 Anywhere")
                     writer.WriteAttributeString("city","Tempe")
                     writer.WriteAttributeString("state","Arizona")
                     writer.WriteAttributeString("zip","85255")
                  writer.WriteEndElement()
               writer.WriteEndElement() 'info
            writer.WriteEndElement() 'customer
         writer.WriteEndElement() 'customers
         writer.Flush()
         writer.Close()
         Dim doc as XmlDocument = new XmlDocument()
         doc.Load(xmlDoc)
         Response.ContentType = "text/xml"
         doc.Save(Response.Output)
      
      catch exp as Exception
         Response.Write(exp.ToString())			

      finally 
         if (NOT writer is Nothing) then
            writer.Close()
         end if
      end try
    end sub
</script>
