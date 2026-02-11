<%@ Import Namespace="System.Xml" %>
<script language="C#" runat=server>
    public void Page_Load(Object sender,EventArgs e) {
        string xmlDocPath = Server.MapPath("golfers.xml");
        XmlTextReader xmlReader = new XmlTextReader(xmlDocPath);
        while (xmlReader.Read()) {
           //Process XML tokens found in Stream
           Response.Write(xmlReader.Name);
           Response.Write("<br />");
        }
        xmlReader.Close();
    }
</script>
