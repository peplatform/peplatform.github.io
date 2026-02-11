<%@ Page %>
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
         writer.WriteStartElement("golfers");
            writer.WriteAttributeString("xmlns","x-schema:golfers.xdr");
            writer.WriteStartElement("golfer", null);
               writer.WriteAttributeString("skill","moderate");
               writer.WriteAttributeString("handicap","12");
               writer.WriteAttributeString("clubs","Taylor Made");
               writer.WriteAttributeString("id","1111");
               writer.WriteElementString("firstName",null,"Paul");	
               writer.WriteElementString("lastName",null,"Allsing");
               writer.WriteStartElement("favoriteCourses", null);
                  writer.WriteStartElement("course",null);
                     writer.WriteAttributeString("city","Phoenix");
                     writer.WriteAttributeString("state","Arizona");
                     writer.WriteAttributeString("name","Ocotillo");
                  writer.WriteEndElement();
                  writer.WriteStartElement("course",null);
                     writer.WriteAttributeString("city","Tempe");
                     writer.WriteAttributeString("state","Arizona");
                     writer.WriteAttributeString("name","Ken McDonald");
                  writer.WriteEndElement();
                  writer.WriteStartElement("course",null);
                     writer.WriteAttributeString("city","Phoenix");
                     writer.WriteAttributeString("state","Arizona");
                     writer.WriteAttributeString("name","Ahwatukee CC");
                  writer.WriteEndElement();
               writer.WriteEndElement(); //favoriteCourses
            writer.WriteEndElement(); //golfer
         writer.WriteEndElement(); //golfers
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