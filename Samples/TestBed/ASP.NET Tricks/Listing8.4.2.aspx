<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Text" %>
<script language="C#" runat="server">
     public class ReadXmlFile {
          StringBuilder output = new StringBuilder();
          public string ReadDoc(String doc) {
             string m_Document = doc;
             XmlTextReader xmlReader = null;
             try {
                 xmlReader = new XmlTextReader(m_Document);
                 WriteXml(xmlReader);
             }
             catch (Exception e) {
             output.Append("Error Occured While Reading " + m_Document +
                       " " + e.ToString());
             }    
             finally {
                 if (xmlReader != null)
                     xmlReader.Close();
                 }
                 return output.ToString();
             }
         private void WriteXml(XmlTextReader xmlReader) {
             while (xmlReader.Read()) {
                 if (xmlReader.NodeType == XmlNodeType.Element) {
                     output.Append(indent(xmlReader.Depth*4));
                     output.Append("<b>&lt;" + xmlReader.Name + "</b>");
                     while (xmlReader.MoveToNextAttribute()) {
                             output.Append("&nbsp<i>" + xmlReader.Name + "=\"" +
                                       xmlReader.Value + "\"</i>&nbsp");
                     }
                     if (xmlReader.IsEmptyElement) {
                         output.Append("<b>/&gt;</b><br>");
                     } else {
                         output.Append("<b>&gt;</b><br>");
                     }
                 } else if (xmlReader.NodeType == XmlNodeType.EndElement) {
                     output.Append(indent(xmlReader.Depth*4));
                     output.Append("<b>&lt;/" + xmlReader.Name + "&gt;</b><br>");
                 } else if (xmlReader.NodeType == XmlNodeType.Text) {
                     if (xmlReader.Value.Length != 0) {
                         output.Append(indent(xmlReader.Depth*4));
                         output.Append("<font color=#ff0000>" + xmlReader.Value +
                                   "<br></font>");
                     }
                 }
             }
         }
         private string indent(int number) {
             string spaces = "";
             for (int i=0; i < number; i++) { 
                 spaces += "&nbsp;";
             }
             return spaces;
         }
     } //End Class

     private void Page_Load(Object sender, EventArgs e) {
         ReadXmlFile readXmlFileSample = new ReadXmlFile();
         output.InnerHtml = 
            readXmlFileSample.ReadDoc(Server.MapPath("golfers.xml"));
     }
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
