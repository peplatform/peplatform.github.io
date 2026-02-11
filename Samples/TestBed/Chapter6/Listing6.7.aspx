<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="Server">
    public void Page_Load(Object sender, EventArgs E) { 
		string output = "";
		XmlDocument doc = new XmlDocument();
		doc.Load(Server.MapPath("requests.xml"));
		string xpath = "/root/request[2]/contactName";
		XmlNode contactNode = doc.SelectSingleNode(xpath);
		if (contactNode != null) {
			contactNode.InnerText = "Bill Shaw";
			XmlNode requestNode = contactNode.ParentNode;
			//Acceptance of XmlNode in constructor not yet implemented at time of 
			//writing.  Uncomment the following block to have this
			//code execute.
			XmlNodeReader nodeReader = new XmlNodeReader(requestNode);
			while (nodeReader.Read()) {
				if (nodeReader.NodeType == XmlNodeType.Element) {
					output += indent(nodeReader.Depth*4);
					output += "<b>&lt;" + nodeReader.Name + "</b>";
					while (nodeReader.MoveToNextAttribute()) {
							output += "&nbsp<i>" + nodeReader.Name + "=\"" +
									nodeReader.Value + "\"</i>&nbsp";
					}
					if (nodeReader.IsEmptyElement) {
						output += "<b>/&gt;</b><br>";
					} else {
						output += "<b>&gt;</b><br>";
					}
				} else if (nodeReader.NodeType == XmlNodeType.EndElement) {
					output += indent(nodeReader.Depth*4);
					output += "<b>&lt;/" + nodeReader.Name + "&gt;</b><br>";
				} else if (nodeReader.NodeType == XmlNodeType.Text) {
					if (nodeReader.Value.Length != 0) {
						output += indent(nodeReader.Depth*4);
						output += "<font color=#ff0000>" + nodeReader.Value +
								"<br></font>";
					}
				}
			}
		}
		Response.Write(output);
	}
    private string indent(int number) {
        string spaces = "";
        for (int i=0; i < number; i++) { 
            spaces += "&nbsp;";
        }
        return spaces;
    }
</script>
