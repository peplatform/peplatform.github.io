<%@ Page %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Schema" %>
<%@ Import Namespace="XmlParsers.Validation" %>

<script language="C#" runat="server">
    public class XmlDocumentTest {
        StringBuilder output = new StringBuilder();
        int indent = 1;
		
        public string ParseDoc(string xmlFilePath, string valFilePath,string logFile) {
            XmlTextReader xmlReader = null;

            try {
				XmlSchemaCollection schemaCol = new XmlSchemaCollection();
				schemaCol.Add("http://www.golfExample.com",valFilePath);
				Validator validator = new Validator();
				bool status = validator.Validate(xmlFilePath,schemaCol,true,logFile);
				if (status) {
					output.Append("<b>Document is Valid!</b><p />");
					xmlReader = new XmlTextReader(xmlFilePath);
					XmlDocument xmlDoc = new XmlDocument();
					xmlDoc.Load(xmlReader);
					XmlNode oNode = xmlDoc.DocumentElement;

					writeNodeName(oNode,0);
					XmlNodeList oNodeList = oNode.ChildNodes;            
					foreach (XmlNode node in oNodeList) {
						XmlNode oCurrentNode = node;			 
						if (oCurrentNode.HasChildNodes) {
							writeNodeName(oCurrentNode,indent);
							walkTheTree(oCurrentNode);
							indent--;
						} else {
							writeNodeName(oCurrentNode,indent);
						}
					}

				} else {
					output.Append("Validation of golfers.xml failed! Check the " +
								   "log file for information on the failure.");
				}

	 
            }
            catch (Exception e) {
                Console.WriteLine  ("Exception: {0}", e.ToString());
            }

            finally {
                if (xmlReader != null)
                    xmlReader.Close();
                }

                return output.ToString();
            }
		
            private void walkTheTree(XmlNode oNodeToWalk) {
                indent++;
                XmlNodeList oNodeList = oNodeToWalk.ChildNodes; 
                for (int j=0;j<oNodeList.Count;j++) {
                    XmlNode oCurrentNode = oNodeList[j];          
                    if (oCurrentNode.HasChildNodes) {
                        writeNodeName(oCurrentNode,indent);
                        walkTheTree(oCurrentNode);
                        indent--;
                    } else {
                        writeNodeName(oCurrentNode,indent);
                    }
                }
            }
	    
            private void writeNodeName(XmlNode node,int iIndent) {
                int h = 0;
                for (int k=0;k<(iIndent * 10);k++) {
                    output.Append("&nbsp;");
                }
                if (node.NodeType == XmlNodeType.Text) { // Text node
                    output.Append("<font color='#ff0000'>" + node.Value + "</font><br>");
                } else {
                    if (node.Attributes.Count > 0) {
                        XmlNamedNodeMap oNamedNodeMap = node.Attributes;  
                        output.Append("<b>" + node.Name + "</b> (");
                        foreach (XmlAttribute att in oNamedNodeMap) {
                            if (h!=0) output.Append("&nbsp;&nbsp;");
                                h++;
                                output.Append("<i>" + att.Name + "</i>=\"" + att.Value + "\"");
                        }
                        output.Append(")<br>\n\n");
                    } else {
                        output.Append("<b>" + node.Name + "</b><br>\n\n");
                    }
                } // end if
            } // writeNodeName
        } 
        
    void Page_Load(Object sender, EventArgs E) {
		string xmlFilePath = Server.MapPath("golfers.xml");
		string valFilePath = Server.MapPath("golfers.xsd");
		string logFile = Server.MapPath("validationErrors.log");
        XmlDocumentTest xmlDocument = new XmlDocumentTest();
        xml.InnerHtml = xmlDocument.ParseDoc(xmlFilePath,valFilePath,logFile);
    }
</script>
<html>
	<head>
	</head>
	<body>
		<font size="5" color="#02027a">Working with XML Objects</font>
		<p />
		<div id="xml" runat="server" />
	</body>
</html>
<script language="C#" runat=server>

</script>