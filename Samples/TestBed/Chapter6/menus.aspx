<%@ Page language="C#" %>
<%@ Import Namespace="XmlHierMenu" %>
<html>
	<head>
		<title>
			XML Hierarchical Menus
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<!-- Following two files must be placed in the appropriate location in your 
			virtual directory for the XML menu system to work correctly -->
		<link rel=STYLESHEET type="text/css" href="menuStyle.css">
		<Script Language="JavaScript" src="XMLMenuScript.js"></Script>
	</head>
	<body id="body" bgcolor="#FFFFFF" style="margin-top:-2 px; margin-left:0 px">
		<table width="640" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
			<tr>
				<td valign="top" align="center" bgcolor="#02027A" colspan="2">
					<table border="0" cellspacing="0" cellpadding="0">
						<tr align="left" valign="middle">
							<td bgcolor="#02027A" nowrap>
								<a id="start" onClick="startIt('menu1',this,0)" style="font: 10pt arial; color: #FFFFFF;text-decoration: none; cursor: hand"><b><font color="#FFFFFF">Sites</font></b>
									<img src="yellow_arrow_down2.gif" width="20" height="11" border=0>
								</a>
							</td>
							<td bgcolor="#02027A" nowrap width="50">
								&nbsp;
							</td>
							<td bgcolor="#02027A" nowrap>
								<a id="start2" onClick="startIt('menu2',this,0)" style="font: 10pt arial; color: #FFFFFF;text-decoration: none; cursor: hand"><b><font color="#FFFFFF">PhoneBook</font></b>
									<img src="yellow_arrow_down2.gif" width="20" height="11" border=0>
								</a>
							</td>
							<td bgcolor="#02027A" nowrap width="50">
								&nbsp;
							</td>
							<td bgcolor="#02027A" nowrap>
								<a id="start3" onClick="startIt('menu3',this,0)" style="font: 10pt arial; color: #FFFFFF;text-decoration: none; cursor: hand"><b><font color="#FFFFFF">Contacts</font></b>
									<img src="yellow_arrow_down2.gif" width="20" height="11" border=0>
								</a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td align="center" bgcolor="efefef">
					<font size="2" face="arial"><b>Click one of the links above to start the menu.</b>
						<br>
							This example is dynamically created from the menuitems.xml, menuitems2.xml and 
							menuitems3.xml files.</font>
				</td>
			</tr>
		</table>
		<%
    // Create paths to xml files
    string filepath = Server.MapPath("menuItems.xml");
    string filepath2 = Server.MapPath("menuItems2.xml");		
    string filepath3 = Server.MapPath("menuItems3.xml");
		
    // Following is constructor used to create a static menu file in cases
    // where the menu does not change often.
    // string saveToFile = Server.MapPath("test.aspx");
    // XmlMenu menuSave = new XmlMenu(true,saveToFile);
    // menuSave.CreateMenu("menu1",filepath);
			
		
    // Instantiate XmlMenu object and call CreateMenu method
    XmlMenu menu = new XmlMenu();
    Response.Write(menu.CreateMenu("menu1",filepath));
    Response.Write(menu.CreateMenu("menu2",filepath2));
    Response.Write(menu.CreateMenu("menu3",filepath3));
		%>
	</body>
</html>
