<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>
<script language="VB" runat="server">
     public class ReadXmlFileVB 
          Dim output as StringBuilder = new StringBuilder()
          public function ReadDoc(doc as string) as string
             Dim m_Document as string = doc
             Dim xmlReader as XmlTextReader
             try 
                 xmlReader = new XmlTextReader(m_Document)
                 Call WriteXml(xmlReader)
             catch e as Exception
             output.Append("Error Occured While Reading " & m_Document & _
                       " " & e.ToString())
             finally 
                 if (NOT xmlReader Is Nothing) then
                     xmlReader.Close()
                 end if
             end try    
             return output.ToString()
          end function
          private sub WriteXml(xmlReader as XmlTextReader) 
             do while (xmlReader.Read()) 
                 if (xmlReader.NodeType = XmlNodeType.Element) then
                     output.Append(indent(xmlReader.Depth*4))
                     output.Append("<b>&lt;" & xmlReader.Name & "</b>")
                     do while (xmlReader.MoveToNextAttribute()) 
                             output.Append("&nbsp<i>" & xmlReader.Name & "=""" & _
                                       xmlReader.Value & """</i>&nbsp")
                     loop
                     if (xmlReader.IsEmptyElement) then
                         output.Append("<b>/&gt;</b><br>")
                     else
                         output.Append("<b>&gt;</b><br>")
                     end if
                 else if (xmlReader.NodeType = XmlNodeType.EndElement) then
                     output.Append(indent(xmlReader.Depth*4))
                     output.Append("<b>&lt;/" & xmlReader.Name & "&gt;</b><br>")
                 else if (xmlReader.NodeType = XmlNodeType.Text) 
                     if (xmlReader.Value.Length <> 0) then
                         output.Append(indent(xmlReader.Depth*4))
                         output.Append("<font color=#ff0000>" & xmlReader.Value & _
                                   "<br></font>")
                     end if
                 end if
             loop
         end sub 
         private function indent(number as integer) as string
             Dim spaces as string = ""
             Dim i as integer
             for i=0 to number
                 spaces = spaces & "&nbsp;"
             next
             return spaces
         end function
     end class

     private sub Page_Load(sender as Object, e as EventArgs) 
         Dim readXmlFileSample as ReadXmlFileVB = new ReadXmlFileVB()
         output.InnerHtml = _
            readXmlFileSample.ReadDoc(Server.MapPath("golfers.xml"))
     end sub
</script>
<html>
	<head>
	</head>
	<body>
		<font size="5" color="#02027a">Reading XML Documents with the XmlTextReader Class</font>
		<p />
		<div id="output" runat="server" />
	</body>
</html>
