<script language="C#" runat="server">
     void Page_Load(object sender, System.EventArgs e) {
         xslTransform.DocumentSource = "Listing8.8.2.xml";
         xslTransform.TransformSource = "Listing8.8.1.xsl";
     }
</script>
<html>
	<body>
		<asp:Xml ID="xslTransform" Runat="server"></asp:Xml>
	</body>
</html>
