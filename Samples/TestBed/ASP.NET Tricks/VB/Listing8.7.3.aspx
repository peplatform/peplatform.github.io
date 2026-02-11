<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="VB" runat="Server">
    public sub Page_Load(sender as Object, e as EventArgs)  
        Dim filePath as string = Server.MapPath("requests.xml")
        Dim i as integer
		Dim doc as XmlDocument = new XmlDocument()
		doc.Load(filePath)
		Dim xpath as string = "//contactName"
		Dim contactNodes as XmlNodeList = doc.SelectNodes(xpath)
		Dim count as integer = contactNodes.Count
		Response.Write("<b>Using SelectNodes()</b><br />")
		for i=0 to count -1 
		    Response.Write(contactNodes.Item(i).Name & " = ")
		    Response.Write(contactNodes.Item(i).InnerText & "<br />")
		next
		
		xpath = "//request[@id='462001|32633|PM']/contactName"
		Response.Write("<p /><b>Using SelectSingleNode()</b><br />")
		Dim contactNode as XmlNode = doc.SelectSingleNode(xpath)
		if (NOT contactNode Is Nothing) then
			Response.Write(contactNode.Name & " = " & contactNode.InnerText)
		end if
    end sub
</script>
