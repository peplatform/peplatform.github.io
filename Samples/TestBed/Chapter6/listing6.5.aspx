<%@ Page %>
<%@ Import Namespace="System.Xml" %>

<script language="C#" runat="server">
    public void Page_Load(Object Src, EventArgs E) {   
        Response.Write("<font size=\"5\" color=\"#02027a\">Working with the XmlNamedNodeMap and XmlAttributeCollection Objects</font><p>");

        XmlDocument oDocument = new XmlDocument();
        oDocument.Load(Server.MapPath("golfers.xml"));     

        XmlNode oNode = oDocument.DocumentElement.FirstChild;
        XmlNamedNodeMap oNamedNodeMap = oNode.Attributes;
        Response.Write("<p><b>XmlNamedNodeMap For/Each Loop</b><br>");
        foreach (XmlAttribute att in oNamedNodeMap) {
            Response.Write(att.Name + " = " + att.Value + "<br>");
        }
        Response.Write("<p><b>XmlAttributeCollection For/Next Loop</b><br>");
        XmlAttributeCollection oAttCol = oNode.Attributes;
        for (int i=0;i<oAttCol.Count;i++) {
            Response.Write(oAttCol[i].Name + " = " + oAttCol[i].Value + "<br>");
        }
			
        Response.Write("<p><b>XmlAttributeCollection <i>SetNamedItem()</i> using XmlDocument: test</b><br>");
        XmlAttribute oNewAtt = oDocument.CreateAttribute("test");
        oNewAtt.Value = "Hi!";
        oNode.Attributes.SetNamedItem(oNewAtt);
        XmlAttributeCollection oAttCol2 = oNode.Attributes;
        for (int i=0;i<oAttCol2.Count;i++) {
            Response.Write(oAttCol2[i].Name + " = " + oAttCol2[i].Value + "<br>");
        }

        Response.Write("<p><b>XmlAttributeCollection <i>RemoveNamedItem()</i>: skill</b><br>");
        oAttCol2.RemoveNamedItem("skill");
        for(int i=0;i<oAttCol2.Count;i++) {
            Response.Write(oAttCol2[i].Name + " = " + oAttCol2[i].Value + "<br>");
        }
	
        Response.Write("<p><b>XmlAttributeCollection <i>getNamedItem()</i>: skill</b><br>");
        try {
            Response.Write(oAttCol2.GetNamedItem("skill").Value);
        }
        catch (Exception e) {
            Response.Write("<font color=\"#ff0000\">" + e.GetBaseException() + "</font>");
            Response.Write("<br>The above error occurred because the skill attribute no longer exists.");
        }
		
    }
</script>