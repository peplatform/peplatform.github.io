<%@ Page %>
<script language="C#" runat="server">
    private void Page_Load(Object sender, EventArgs e) {
        Response.Write("<table>");
        Response.Write("<tr>");
        for (int i=1;i<1001;i++) {
            if (i % 4 == 1) {
                Response.Write("</td></tr><tr><td>");
            } else {
                Response.Write("<td>");
            }
            Response.Write(Server.HtmlEncode("&#" + i + ";") + " = " + 
                           "&#" + i + ";</td>");
        }
        Response.Write("</table>");
    }
</script>





