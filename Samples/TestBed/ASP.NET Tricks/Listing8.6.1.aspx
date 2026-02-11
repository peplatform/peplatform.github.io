<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="server">
    public void Page_Load(Object Src, EventArgs E) {   
      string xmlDoc = Server.MapPath("xmltextwriter.xml");
      XmlTextWriter writer = null;
      try   {
         writer = new XmlTextWriter(xmlDoc,Encoding.UTF8);
         writer.Formatting = Formatting.Indented;
         writer.WriteStartDocument(true);
         writer.WriteComment("XML Nodes added using the XmlTextWriter");
         writer.WriteStartElement("customers");
            writer.WriteStartElement("customer", null);
               writer.WriteAttributeString("id","123456789");
               writer.WriteStartElement("info", null);
                  writer.WriteStartElement("name",null);
                     writer.WriteAttributeString("firstName","John");
                     writer.WriteAttributeString("lastName","Doe");
                  writer.WriteEndElement();
                  writer.WriteStartElement("address",null);
                     writer.WriteAttributeString("street","1234 Anywhere");
                     writer.WriteAttributeString("city","Tempe");
                     writer.WriteAttributeString("state","Arizona");
                     writer.WriteAttributeString("zip","85255");
                  writer.WriteEndElement();
               writer.WriteEndElement(); //info
            writer.WriteEndElement(); //customer
         writer.WriteEndElement(); //customers
         writer.Flush();
         writer.Close();
         XmlDocument doc = new XmlDocument();
         doc.Load(xmlDoc);
         Response.ContentType = "text/xml";
         doc.Save(Response.Output);
      }
      catch (Exception e) {
         Response.Write(e.ToString());				
      }
      finally {
         if (writer != null) {
            writer.Close();
         }
      }
    }
</script>
