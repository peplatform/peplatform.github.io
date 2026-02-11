<%@ Page %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.XPath" %>
<%@ Import Namespace="System.Xml.Xsl" %>
<%@ Import Namespace="System.IO" %>
<script language="C#" runat="Server">
     void Page_Load(object sender, EventArgs e) {
         if (!IsPostBack) {
             BindDropDown();
         }
     }
     void SubmitButton_Click(object sender, EventArgs e) {
         string CustID = customers.SelectedItem.Value;
         string url = "http://localhost/northwind/templates/listing9.5.xml?CustomerID=" + CustID;
         StringBuilder sb = new StringBuilder();
         StringWriter sw = new StringWriter(sb);
         XmlTextWriter writer = new XmlTextWriter(sw);
         try {
             XPathDocument xmlDoc = new XPathDocument(url);
             XslTransform xslDoc = new XslTransform();
             xslDoc.Load(Server.MapPath("customers.xsl"));
             xslDoc.Transform(xmlDoc,null,writer);
             transform.InnerHtml = sb.ToString();
         }
         catch (Exception exc) {
	        Response.Write(exc.ToString());
         }
     }
     void BindDropDown() {
		 string url = "http://localhost/northwind/templates/getCustomerID.xml";
         DataSet ds = new DataSet();
         ds.ReadXml(url);
         customers.DataTextField = "CustomerID";
         customers.DataSource = ds.Tables[0].DefaultView;
         customers.DataBind();
     }
</script>
<html>
	<body bgcolor="#ffffff">
		<form runat="server" ID="Form1">
			<b>Select a CustomerID to View:</b>
			<asp:DropDownList id="customers" runat="server" />
			<asp:button id="SubmitButton" text="Submit" OnClick="SubmitButton_Click" runat="server" />
			<p />
			<div id="transform" runat="server">
			</div>
		</form>
	</body>
</html>
