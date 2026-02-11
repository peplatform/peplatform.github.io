<%@ Page %>
<html>
<head>
<script language="c#" runat="server">
    void SubmitButton_Click(Object Src, EventArgs E) {
        String sql = sqlBox.Text;
        String root = txtRoot.Text;
        if (root.Length == 0) root = "root";
        if (sql.Length > 0) {
	    String encodedSql = Server.UrlEncode(sql);
	    if (rdoChoice.SelectedIndex == 0) {
	        lblErrors.Text = encodedSql;
	    } else {
	        lblErrors.Text = "";
	        Response.Redirect(@"http://localhost/northwind?sql="
	                           + encodedSql + "&root=" + root);  
	    }
	} else {
	    lblErrors.Text = "You did not enter a SQL query.";	    
	}
    }
</script>
</head>
<body bgcolor="#ffffff">
  <form runat="server">
    <asp:Label id="lblErrors" style="font-family: arial;font-weight: bold;color: red" runat="server"/>
    <p/>
    <span style="font-family:arial;font-weight:bold;">Root Name: </span><asp:TextBox id="txtRoot" runat="server"/>
    <p/>
    <span style="font-family:arial;font-weight:bold;">SQL Query: </span><br/>
    <asp:TextBox id="sqlBox" Text="" Height="300px" Width="600px" TextMode="MultiLine" Wrap="true" runat="server"/>
    <p/>
    <asp:RadioButtonList style="font-family:arial;" id="rdoChoice" RepeatDirection="Vertical" runat="server">
        <asp:ListItem Selected="true">Return Encoded SQL</asp:ListItem>
        <asp:ListItem>Execute SQL Statement</asp:ListItem>
    </asp:RadioButtonList>
    <p/>
    <asp:Button id="submitbutton" text="Run Query" OnClick="SubmitButton_Click" runat="server"/>  

  </form>
</body>
</html>