<%@ Page %>
<%@ Import Namespace="System.Xml" %>
<script language="C#" runat="Server">
    void Page_Load(Object Src, EventArgs E) {
        string jobCode = "";
        string contactName = "";
        string dateTime = "";
        string options = "";
        string table = "";
        string attID = "";
        int intCount = 0;

        Response.Expires = -1;
        string ID = Request.QueryString["id"];
        XmlDocument doc = new XmlDocument();
        try {
            doc.Load(Server.MapPath("requests.xml"));
        }
        catch (Exception c) {
            Response.Write("There are currently no requests to view.");
            Response.End();
        }
        XmlNodeList requestNodeList = doc.SelectNodes("//request");
        if (requestNodeList != null) {
            int nodeCount = requestNodeList.Count;
            for (int i=0;i<nodeCount;i++) {
                XmlNode requestNode = requestNodeList.Item(i);	 
                XmlElement requestElement = (XmlElement)requestNode; 
                //Get the ID attribute since we're on the request node
                attID = requestElement.GetAttribute("id"); 
                if (requestNode.HasChildNodes) {
                    XmlNode childNode = requestNode.FirstChild;
                    if (childNode.Name.ToUpper() == "DATETIME")
                        dateTime = childNode.InnerText;
                    XmlNodeList requestChildrenNodeList =
                        requestNode.ChildNodes;
                    foreach (XmlNode requestChildNode 
                             in requestChildrenNodeList) {	
                        if (intCount < 1) {
                            table += "<tr><td>" + 
                                     requestChildNode.Name.ToUpper() + 
                                     ":</td>";
                            table += "<td><div id='" + 
                                     requestChildNode.Name + 
                                     "'></div></td></tr>";
                        }

                        switch (requestChildNode.Name.ToUpper()) {
                            case "JOBCODE":
                                jobCode = requestChildNode.InnerText;
                                break;
                            case "CONTACTNAME":
                                contactName = requestChildNode.InnerText;
                                break;
                            case "DATETIME":
                                dateTime = requestChildNode.InnerText;
                                break;   				
                        }
                    }
				
                    options += "<option value=\"" + attID + "\">";
                    options += jobCode + " - Entered By: " + 
                               contactName + " (" + dateTime + ")";
                    options += "</option>";
                }
                intCount++;
            } //foreach
        } //if
        optionsDiv.InnerHtml = options;
        tableRowsDiv.InnerHtml = table;
    }
</script>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;
            charset=windows-1252">
		<SCRIPT LANGUAGE="javascript">
        <!--
        function getRequest() {
            var form = document.forms[0]
            if (form.requestID.selectedIndex == 0) return;
                var index = form.requestID.selectedIndex;
                var id = form.requestID.options[index].value;
                var sURL = "http://localhost/testbed/chapter6/" + 
                           "Listing6.9.aspx?status=getXML&id=" + id;
                var oXMLHttp = new ActiveXObject("MSXML2.XMLHTTP")
                oXMLHttp.open('GET', sURL, false);
                oXMLHttp.send();
                document.all("requestData").XMLDocument = 
                                            oXMLHttp.responseXML;
                updateBindings();
            }
        function updateBindings() {
            var oRoot = requestData.XMLDocument.documentElement;
            for (i=0;i<oRoot.childNodes.length;i++) {
                var node = oRoot.childNodes(i);
                if (node.nodeType == 1) {
                    try {
                        document.all(node.nodeName).innerText = node.text;
                    }
                    catch (e) {
                        alert("Sorry, but the selected Request" +
                              " ID was not found");
                    }
                }
            }
        }
        //-->
		</SCRIPT>
	</head>
	<body bgcolor="#FFFFFF">
		<!-- Create our XML Data Island -->
		<XML id="requestData">
		</XML>
		<form method="post" action"" name="requestform">
			<table border="0" cellspacing="0" cellpadding="5" width="85%" bgcolor="e8e8e8">
				<tr bgcolor="#02027a">
					<td colspan="6" align="center">
						<font face="arial" color="#ffffff" size="4">INFORMATION TECHNOLOGY SPECIALIST REQUEST REVIEW FORM</font>
					</td>
				</tr>
				<tr>
					<td align="left" valign="middle" width="34%">
						<font face="Arial, Helvetica, sans-serif" size="2"><b>Select A Request:</b></font>
					</td>
					<td align="left" valign="top" colspan="2">
						<select name="requestID" onChange="getRequest()">
							<option>
								Select One:
							</option>
							<div id="optionsDiv" runat="server" />
						</select>
					</td>
					<td valign="top" align="left" colspan="3" width="27%">
					</td>
				</tr>
			</table>
			<table ID="dataTable" cellpadding="5">
				<div style="font-family:arial" id="tableRowsDiv" runat="Server" />
			</table>
		</form>
	</body>
</html>
