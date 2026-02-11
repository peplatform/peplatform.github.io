<%@ Page %>
<script language="C#" runat="server">
    void Page_Load(object sender, System.EventArgs e) {
        xslTransform.DocumentSource = "Listing7.1.xml";
        xslTransform.TransformSource = "Listing7.2.xsl";
    }
</script>
<html>
    <body>
        <asp:Xml ID="xslTransform" Runat="server">
        </asp:Xml>
    </body>
</html>
