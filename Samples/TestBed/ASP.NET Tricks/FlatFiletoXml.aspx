<%@ Import Namespace="System.Xml"%>
<%@ Import Namespace="FlatFile.Converter"%>
<script language="c#" runat="server">
	void Page_Load(object sender, System.EventArgs e) {
			string ediPath = Server.MapPath("supplies.csv");
			string xmlPath = Server.MapPath("supplies.xml");

			PartsCSVToXml converter = new PartsCSVToXml(ediPath,xmlPath);
			if (converter.Convert()) {
				Response.ContentType = "text/xml";
				XmlDocument doc = new XmlDocument();
				doc.Load(xmlPath);
				doc.Save(Response.Output);
			} else {
				Response.Write("Creation of the XML document failed.");
			}
	}
</script>
