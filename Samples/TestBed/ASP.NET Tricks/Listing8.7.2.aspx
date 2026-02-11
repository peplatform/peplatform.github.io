<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="server">
    public class XmlDocumentTest {
        StringBuilder output = new StringBuilder();
        int indent = 1;
		
        public string ParseDoc(string xmlFilePath) {
            XmlTextReader xmlReader = null;

            try {
                xmlReader = new XmlTextReader(xmlFilePath);
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(xmlReader);
                XmlNode oNode = xmlDoc.DocumentElement;

                WriteNodeName(oNode,0);
                XmlNodeList oNodeList = oNode.ChildNodes;            
                foreach (XmlNode node in oNodeList) {
                    XmlNode oCurrentNode = node;			 
                    if (oCurrentNode.HasChildNodes) {
                        WriteNodeName(oCurrentNode,indent);
                        WalkTheTree(oCurrentNode);
                        indent--;
                    } else {
                        WriteNodeName(oCurrentNode,indent);
                    }
                }
            }
            catch (Exception e) {
                output.Append(e.ToString());
            }

            finally {
                if (xmlReader != null)
                    xmlReader.Close();
                }
            return output.ToString();
        }
		
        private void WalkTheTree(XmlNode oNodeToWalk) {
            indent++;
            XmlNodeList oNodeList = oNodeToWalk.ChildNodes; 
            for (int j=0;j<oNodeList.Count;j++) {
                XmlNode oCurrentNode = oNodeList[j];          
                if (oCurrentNode.HasChildNodes) {
                    WriteNodeName(oCurrentNode,indent);
                    WalkTheTree(oCurrentNode);
                    indent--;
                } else {
                    WriteNodeName(oCurrentNode,indent);
                }
            }
        }
	    
        private void WriteNodeName(XmlNode node,int iIndent) {
            int h = 0;
            for (int k=0;k<(iIndent * 10);k++) {
                output.Append("&nbsp;");
            }
            if (node.NodeType == XmlNodeType.Text) { // Text node
                output.Append("<font color='#ff0000'>" + node.Value + 
                              "</font><br>");
            } else {
                if (node.Attributes.Count > 0) {
                    XmlNamedNodeMap oNamedNodeMap = node.Attributes;  
                    output.Append("<b>" + node.Name + "</b> (");
                    foreach (XmlAttribute att in oNamedNodeMap) {
                        if (h!=0) output.Append("&nbsp;&nbsp;");
                            h++;
                            output.Append("<i>" + att.Name + "</i>=\"" + 
                                          att.Value + "\"");
                    }    
                    output.Append(")<br>\n\n");
                } else {
                    output.Append("<b>" + node.Name + "</b><br>\n\n");
                }
            } // end if
        } // WriteNodeName
    } 
        
    void Page_Load(Object sender, EventArgs E) {
        string xmlFilePath = Server.MapPath("golfers.xml");
        XmlDocumentTest xmlDocument = new XmlDocumentTest();
        xml.InnerHtml = xmlDocument.ParseDoc(xmlFilePath);
    }
</script>
<html>
	<body>
		<font size="5" color="#02027a">Working with XML Objects</font>
		<p />
		<div id="xml" runat="server" />
	</body>
</html>
