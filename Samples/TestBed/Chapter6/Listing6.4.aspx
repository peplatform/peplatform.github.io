<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.IO" %>

<script language="C#" runat="server">
    public void Page_Load(Object Src, EventArgs E) {  
        String masterDoc = Server.MapPath("golfers.xml"); 
        XmlTextWriter writer = null;
        StringBuilder sb = null;
        StringWriter sw = null;		
        try {
                sb = new StringBuilder();
                sw = new StringWriter(sb);
                writer = new XmlTextWriter(sw);
                writer.Formatting = Formatting.Indented;
                    writer.WriteStartElement("golfer", null);
                        writer.WriteAttributeString("skill","moderate");
                        writer.WriteAttributeString("handicap","12");
                        writer.WriteAttributeString("clubs","Taylor Made");
                        writer.WriteAttributeString("id","1111");
                        writer.WriteElementString("firstName",null,"Lin");	
                        writer.WriteElementString("lastName",null,"Thatcher");
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
      	        writer.Flush();
               
                Response.ContentType = "text/xml";				
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(sb.ToString());
                XmlDocumentFragment frag = doc.CreateDocumentFragment();
                foreach (XmlNode node in doc.ChildNodes) {
                    frag.AppendChild(node);
                }
                doc.Load(masterDoc);
                doc.DocumentElement.PrependChild(frag);
                doc.Save(Response.Output);
                writer.Close();
                sw.Close();
        }
        catch (Exception e) {
                Response.Write(e.ToString());				
        }
        finally {
                if (writer != null) {
                        writer.Close();
                }
                if (sw != null) {
                        sw.Close();
                }
        }
    }
</script>