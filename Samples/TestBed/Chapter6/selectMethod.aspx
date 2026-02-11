<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="Server">
    public void Page_Load(Object sender, EventArgs E) { 
        string filePath = Server.MapPath("requests.xml");
		XmlDocument doc = new XmlDocument();
		doc.Load(filePath);
		XmlNodeList contactNodes = doc.SelectNodes("//contactName");
		int count = contactNodes.Count;
		for (int i=0;i<count;i++) {
		    Response.Write(contactNodes.Item(i).Name + " = ");
		    Response.Write(contactNodes.Item(i).InnerText + "<br />");
		}
    }
</script>
