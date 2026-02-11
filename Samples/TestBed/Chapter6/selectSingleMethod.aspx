<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="Server">
    public void Page_Load(Object sender, EventArgs E) { 
        string filePath = Server.MapPath("requests.xml");
		XmlDocument doc = new XmlDocument();
		doc.Load(filePath);
		string xpath = "//request[@id='462001|32633|PM']/contactName";
		XmlNode contactNode = doc.SelectSingleNode(xpath);
		if (contactNode != null) {
			Response.Write(contactNode.Name + " = " + contactNode.InnerText);
		}
    }
</script>
