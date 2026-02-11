<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="Server">
    public void Page_Load(Object sender, EventArgs E) { 
        string filePath = Server.MapPath("requests.xml");
		XmlDocument doc = new XmlDocument();
		doc.Load(filePath);
		string xpath = "//contactName";
		XmlNodeList contactNodes = doc.SelectNodes(xpath);
		int count = contactNodes.Count;
		Response.Write("<b>Using SelectNodes()</b><br />");
		for (int i=0;i<count;i++) {
		    Response.Write(contactNodes.Item(i).Name + " = ");
		    Response.Write(contactNodes.Item(i).InnerText + "<br />");
		}
		
		xpath = "//request[@id='462001|32633|PM']/contactName";
		Response.Write("<p /><b>Using SelectSingleNode()</b><br />");
		XmlNode contactNode = doc.SelectSingleNode(xpath);
		if (contactNode != null) {
			Response.Write(contactNode.Name + " = " + contactNode.InnerText);
		}

    }
</script>
