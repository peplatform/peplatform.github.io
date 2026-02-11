<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="Server">

  void Page_Load(Object Src, EventArgs E) {
		Response.ContentType = "text/xml";
		Response.Expires = -1;
		
		string ID = Request.QueryString["id"];
		string status = Request.QueryString["status"];
		
		switch (status.ToUpper()) {
			case "GETXML":
				GetRequestXML(ID);
				break;
			default:
				break;
		}
    }
    
    private void GetRequestXML(string requestID) {
    	XmlDocument doc = new XmlDocument();	
		try {
			doc.Load(Server.MapPath("requests.xml"));
		}
		catch (Exception c) {
			Response.Write("<root>There are currently no" +
			               " requests to view.<root>");
		}
		//Perform XPath query using SelectSingleNode() method
		string xpath = "//request[@id='" + requestID + "']";
		XmlNode requestNode = doc.SelectSingleNode(xpath);
		if (requestNode != null) {
			Response.Write(requestNode.OuterXml);
		} else {
			Response.Write("<root><request>NO ID</request></root>");
		}

    }	
</script>
