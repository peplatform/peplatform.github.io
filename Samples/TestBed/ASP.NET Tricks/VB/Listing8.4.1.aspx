<%@ Import Namespace="System.Xml" %>
<script language="VB" runat="server">
	public sub Page_Load(sender as Object,e as EventArgs)
		Dim xmlDocPath as string = Server.MapPath("golfers.xml")
		Dim xmlReader as XmlTextReader = new XmlTextReader(xmlDocPath)
		while (xmlReader.Read()) 
			'Process XML tokens found in Stream 
			Response.Write(xmlReader.Name) 
			Response.Write("<br />") 
		end while 
		xmlReader.Close() 
	end sub 
</script>