<%@ Page %>
<%@ Import Namespace="msxml3Managed" %>
<html>
    <body>
        <script language="C#" runat="Server">
  void Page_Load(Object Src, EventArgs E) {
    DOMDocument30 doc = new DOMDocument30();
    doc.load(Server.MapPath("golfers.xml"));
    IXMLDOMNode node = doc.documentElement;
    Response.Write("Document Element Name: <b>" + node.nodeName + "</b><br>");
    for (int i=0;i<node.childNodes.length;i++) {
	Response.Write("&lt;" + node.childNodes[i].nodeName + "&nbsp;&nbsp;");
        if (node.childNodes[i].attributes.length > 0) {
            for (int j=0;j<node.childNodes[i].attributes.length;j++) {
	        IXMLDOMAttribute att = (IXMLDOMAttribute)node.childNodes[i].attributes[j];
  				Response.Write(att.nodeName + " = \"");
                Response.Write(att.nodeValue + "\"&nbsp;&nbsp;");
            }
        }
        Response.Write("/&gt;<br>");        
    }
  }
        </script>
    </body>
</html>
