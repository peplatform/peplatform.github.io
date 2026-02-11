<%@ Page %>
<script language="VB" runat="server">
     public sub Page_Load(sender as object, e as EventArgs) 
         xslTransform.DocumentSource = "Listing8.8.2.xml"
         xslTransform.TransformSource = "Listing8.8.1.xsl"
     end sub
</script>
<html>
	<body>
		<asp:Xml ID="xslTransform" Runat="server"></asp:Xml>
	</body>
</html>
