<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="c#" runat="Server">
 void Page_Load(object sender, EventArgs e) {
    XmlDocument oDocument = new XmlDocument();
    oDocument.Load(Server.MapPath("golfers.xml"));
    XmlNode oNode = oDocument.DocumentElement.ChildNodes[0].ChildNodes[0].ChildNodes[1];
    Response.Write("<b>nodeName:</b> " + oNode.Name + "<br>");
    if (oNode.NodeType == XmlNodeType.Element) {  // Element type node
       Response.Write("<b>Element's text node's nodeValue:</b> ");
       Response.Write(oNode.ChildNodes[0].Value + "<br>");
       Response.Write("<b>Element's InnerText:</b> " + oNode.InnerText + "<br>");
    }
 }
</script>
