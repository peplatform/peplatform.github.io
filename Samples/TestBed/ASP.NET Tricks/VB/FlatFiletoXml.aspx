<%@ Page %>
<%@ Import Namespace="System.Xml"%>
<%@ Import Namespace="FlatFile.Converter"%>
<script language="VB" runat="server">
    public sub Page_Load(sender as Object, e as EventArgs) 
			Dim ediPath as string = Server.MapPath("supplies.csv")
			Dim xmlPath as string = Server.MapPath("supplies.xml")

			Dim converter as PartsCSVToXml = new PartsCSVToXml(ediPath,xmlPath)
			if (converter.Convert()) then
				Response.ContentType = "text/xml"
				Dim doc as XmlDocument = new XmlDocument()
				doc.Load(xmlPath)
				doc.Save(Response.Output)
			else
				Response.Write("Creation of the XML document failed.")
			end if
	end sub
</script>
