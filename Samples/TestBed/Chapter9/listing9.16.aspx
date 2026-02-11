<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="server">
    void SubmitButton_Click(Object sender, EventArgs e) {
        Response.ContentType = "text/xml";
        string xmlDoc = "<Northwind><Customers CustomerID=\"" +
                        CustomerID.Text;
        xmlDoc += "\" ContactName=\"" + ContactName.Text;
        xmlDoc += "\" CompanyName=\"" + CompanyName.Text +
                  "\"/></Northwind>";
        string url = "http://localhost/northwind/templates/" +
                     "listing9.15.xml?XmlDoc=" + Server.UrlEncode(xmlDoc);
        XmlDocument doc = new XmlDocument();
        doc.Load(url);
        Response.Write(doc.DocumentElement.OuterXml);
        Response.End();
    }
</script>
<html>
	<body>
		<form runat="server">
			<table cellpadding="4">
				<tr>
					<td>
						<b>CustomerID:</b></td>
					<td>
						<asp:TextBox id="CustomerID" Text="DLWID" runat="server" /></td>
				</tr>
				<tr>
					<td>
						<b>Name:</b></td>
					<td>
						<asp:TextBox id="ContactName" Text="Dan Wahlin" runat="server" /></td>
				</tr>
				<tr>
					<td>
						<b>Company Name:</b></td>
					<td>
						<asp:TextBox id="CompanyName" Text="Tomorrow's Learning" runat="server" /></td>
				</tr>
				<tr>
					<td colspan="2">
						<asp:button text="Submit" id="SubmitButton" runat="server" onClick="SubmitButton_Click" />
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
