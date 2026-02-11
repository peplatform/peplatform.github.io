<%@ Page %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<script language="C#" runat="server">
	string rootTag = "root";
	public class CreateXmlFile {
		HttpRequest Request = null;
		
		public CreateXmlFile(HttpRequest ServerRequest) { //Overload Constructor when request object is needed
			Request = ServerRequest;
		}
		public CreateXmlFile() {}
		
		public string writeXML(string root,string node,string recordID,string version,string fileName,bool writeEndRoot,bool writeAtts) {
			bool blnExists = false;
			StreamWriter writer = null;
			string pathFile = getPath(fileName);
			
			//See if the XML file already exists
			blnExists = File.Exists(pathFile);
				
			if (!blnExists) {	//Create the file since it doesn't exist
			    writer = new StreamWriter(File.Open(pathFile,
				                      FileMode.Create, FileAccess.Write));
			    writer.WriteLine("<?xml version=\"" + version + "\"?>");
			    writer.WriteLine("<" + root + ">");
			} else {
			    writer = new StreamWriter(File.Open(pathFile, FileMode.Append, FileAccess.Write));
			}
				
			writer.WriteLine("<" + node + " id=\"" + recordID);
			if (!writeAtts) {
			    writer.Write("\">");
			} else {
			    writer.Write("\" ");
			}			
			foreach (string x in Request.Form) {
				if (x.ToUpper() != "SUBMITBUTTON" && x.IndexOf("_") != 0) {
					if (!writeAtts) {
					    writer.WriteLine("<" + x + ">" + Request.Form[x] +
					                      "</" + x + ">");
					} else {  //Write out as attributes
					    writer.WriteLine(x + "=\"" + Request.Form[x] + "\" ");
					}
				}
			}
			if (!writeAtts) {
			    writer.WriteLine("</" + node + ">");
			} else {
			    writer.WriteLine("/>");
			}
			if (writeEndRoot) {
				writer.WriteLine("</" + root + ">");
			}
			writer.WriteLine();
			writer.Flush();		
			writer.Close();	
			return "";	
		}
		public string ReadFile(string file,bool bGetPath) {
				
			//Create the File System Object and txtfile
			string filePath = "";
			string fileOut = "";
			StreamReader reader = null;
			filePath = bGetPath?getPath(file):file;
			try {
				reader = new StreamReader(File.OpenRead(filePath));
				fileOut = reader.ReadToEnd(); //Can be expensive depending on size of file
			}
			catch (Exception e) {
				fileOut = "There was an error: " + e.ToString();
			}
			finally {
				if (reader != null) reader.Close();
			}
			return fileOut;
			
		}
				
		private string getPath(string file) {
			string path = Request.ServerVariables["PATH_TRANSLATED"];
			path = path.Substring(0,path.LastIndexOf("\\")+1) + file;
			return path;
		}
		

	} //End Class
	
	public void submitButton_Click(Object Sender, EventArgs E) {
		string output = "";
		string ID = Request.Form["dateTime"];
		ID = ID.Replace('/','-');
		ID = ID.Replace(':','-');
		ID = ID.Replace(' ','-');

		CreateXmlFile file = new CreateXmlFile(Request);
		string sStatus = file.writeXML(rootTag,"request",ID,"1.0",
		                               "request.xml",false,false);
		if (sStatus.Length != 0) {												
			output += "Error: " + sStatus;
			content2.InnerHtml = output;
		} else {
			content.Visible = false;
			content2.Visible = true;
		}
	}
	public void viewXML_Click(Object Sender, EventArgs E) {
			CreateXmlFile file = new CreateXmlFile(Request);
			Response.ContentType = "text/xml";
			Response.Write(file.ReadFile("request.xml",true) +
			               "</" + rootTag + ">");
			Response.End();
	}

	public void Page_Load(Object sender, EventArgs E) { 
		content.Visible = false;
		content2.Visible = false;
		if (!Page.IsPostBack) {
			content.Visible = true;
		}
	}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
</head>
<body bgcolor="#FFFFFF" style="margin-top:0 px; margin-left:17 px" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" background="/images/bg1.gif">
<form runat="server">

<!-- Start Content2 section to be displayed after form is posted-->
<div id="content2" runat="server">
			Your information was successfully stored!<p>
			<asp:button id="viewXML" text="View XML File" OnClick="viewXML_Click" runat="server"/>
</div>
<!-- Start Content section to be displayed when page is first loaded-->
<div id="content" runat="server">
  <table border="0" cellspacing="0" cellpadding="5" width="603" bgcolor="e8e8e8">
    <tr bgcolor="#FFFFFF"> 
      <td colspan=6 align=center> 
	<font face="Arial, Helvetica, sans-serif">INFORMATION TECHNOLOGY SPECIALIST 
    REQUEST FORM
	</td>
</tr>
    <tr> 
      <td align="left" valign="middle" width="34%"> <b> <font face="Arial, Helvetica, sans-serif"> 
        Today's Date: </font> </b> </td>
      <td align="left" valign="top" colspan="2"><%=DateTime.Now%>
        <input type="hidden" id="dateTime" name="dateTime" value="<%=DateTime.Now%>"/>
      </td>
      <td valign="top" align="left" colspan="3" width="27%">&nbsp; </td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td  align="left" valign="middle" width="34%"><font size=1>&nbsp;</font></td>
      <td  align="left" valign="top" colspan="2"><font size=1>&nbsp;</font></td>
      <td align="left" valign="top" colspan="3" width="27%"><font size=1>&nbsp;</font></td>
    </tr>
    <tr> 
      <td  align="left" valign="middle" width="34%"> <b> <font face="Arial, Helvetica, sans-serif"> 
        Project Dates: </font> </b> </td>
      <td  align="left" valign="top" colspan="5"> 
        <table border="0" cellpadding="0" cellspacing="0">
          <tr> 
            <td>Start Date:&nbsp;</td>
            <td>
              <input type="text" id="startDate" name="startDate" size="10" maxlength="10" value=""/>
            </td>
            <td width="10">&nbsp;</td>
            <td>End Date:&nbsp;</td>
            <td>
              <input type="text" id="endDate" name="endDate" size="10" maxlength="10" value=""/>
            </td>
          </tr>
        </table>
</td>
    </tr>
   <tr bgcolor="#FFFFFF"> 
      <td  align="left" valign="middle" width="34%"><font size=1>&nbsp;</font></td>
      <td  align="left" valign="top" colspan="2"><font size=1>&nbsp;</font></td>
      <td align="left" valign="top" colspan="3" width="27%"><font size=1>&nbsp;</font></td>
    </tr>
    <tr> 
      <td  align="left" valign="middle" width="34%"> <b> <font face="Arial, Helvetica, sans-serif"> 
        Response Due Date:</font> 
        </b> </td>
      <td  align="left" valign="top" colspan="2"> 
        <input type="text" id="dueDate" name="dueDate" size="10" maxlength="10" value=""/>
      </td>
      <td align="left" valign="top" colspan="3" width="27%">&nbsp; </td>
    </tr>
   <tr bgcolor="#FFFFFF"> 
      <td  align="left" valign="middle" width="34%"><font size=1>&nbsp;</font></td>
      <td  align="left" valign="top" colspan="2"><font size=1>&nbsp;</font></td>
      <td align="left" valign="top" colspan="3" width="27%"><font size=1>&nbsp;</font></td>
    </tr>
     
    <tr><font face="Arial, Helvetica, sans-serif" size=2> <!-- Row 3A Column 1 --> 
      <td  align="left" valign="middle" width="34%"> <b> <font face="Arial, Helvetica, sans-serif"> 
        Est. Total Project Time:</font></b> </td>
      <td  align="left" valign="top" colspan="5"> 
        <input type="text" id="projectTime" name="projectTime" size="3" maxlength="3" value=""/>
        <b>&nbsp;&nbsp;&nbsp;&nbsp;Select One:</b> <font face="Arial, Helvetica, sans-serif">Hours 
        <input type="radio" id="projectLengthHours" name="projectLength" value="hours"/>
        &nbsp;&nbsp;Days 
        <input type="radio" id="projectLengthDays" name="projectLength" value="days"/>
        &nbsp;&nbsp; Weeks 
        <input type="radio" id="projectLengthWeeks" name="projectLength" value="weeks"/>
        </font> </td>
      </font> </tr>
   <tr bgcolor="#FFFFFF"> 
      <td  align="left" valign="middle" width="34%"><font size=1>&nbsp;</font></td>
      <td  align="left" valign="top" colspan="2"><font size=1>&nbsp;</font></td>
      <td align="left" valign="top" colspan="3" width="27%"><font size=1>&nbsp;</font></td>
    </tr>
    <tr> 
      <td align="left" valign="middle" width="34%"> <b> <font face="Arial, Helvetica, sans-serif"> 
        Budgeted Cost:</font><font size="2" color="#FF0000"></font><font face="Arial, Helvetica, sans-serif"> 
        </font> </b> </td>
      <td align="left" valign="top" colspan="2">$ 
        <input type="text" id="cost" name="cost" size="8" maxlength="8" value=""/>
      </td>
      <td colspan="3" valign="top" align="left" width="27%">&nbsp; </td>
    </tr>
   <tr bgcolor="#FFFFFF"> 
      <td  align="left" valign="middle" width="34%"><font size=1>&nbsp;</font></td>
      <td  align="left" valign="top" colspan="2"><font size=1>&nbsp;</font></td>
      <td align="left" valign="top" colspan="3" width="27%"><font size=1>&nbsp;</font></td>
    </tr>
    <tr> 
      <td align="left" valign="middle" width="34%"> <b> <font face="Arial, Helvetica, sans-serif"> 
        Job Code:</font></b> </td>
      <td align="left" valign="top" colspan="2"> 
        <select name="jobCode">
          <option>Select One:</option>
          <option value="ITV1000">Manager/Director</option>
          <option value="ITV1100">Capacity Planner</option>
          <option value="ITV1200">Communications/Network Operator</option>
          <option value="ITV1300">Computer Operator - All</option>
          <option value="ITV1301">Computer Operator - Bull</option>
          <option value="ITV1302">Computer Operator - DEC</option>
          <option value="ITV1303">Computer Operator - IBM</option>
          <option value="ITV1400">Consultant/EIS Analyst</option>
          <option value="ITV1500">Custom Cartography</option>
          <option value="ITV1600">Data Center Manager</option>
          <option value="ITV1700">Database Administrator - All</option>
          <option value="ITV1701">Database Administrator - DB2</option>
          <option value="ITV1702">Database Administrator - Informix</option>
          <option value="ITV1703">Database Administrator - MS SQL Server</option>
          <option value="ITV1704">Database Administrator - Oracle</option>
          <option value="ITV1705">Database Administrator - Sybase</option>
          <option value="ITV1800">Database Analyst - All</option>
          <option value="ITV1801">Database Analyst - DB2</option>
          <option value="ITV1802">Database Analyst - Informix</option>
          <option value="ITV1803">Database Analyst - MS SQL Server</option>
          <option value="ITV1804">Database Analyst - Oracle</option>
          <option value="ITV1805">Database Analyst - Sybase</option>
          <option value="ITV1900">EDP Auditor</option>
          <option value="ITV2000">End User Support</option>
          <option value="ITV2100">Financial Application Programmer</option>
          <option value="ITV2200">GIS Analyst</option>
          <option value="ITV2300">GIS Consulting</option>
          <option value="ITV2400">GIS Database Developer</option>
          <option value="ITV2500">GIS Graphic Designer</option>
          <option value="ITV2600">GIS Programmer</option>
          <option value="ITV2700">GIS Technician</option>
          <option value="ITV2800">Help Desk Coordinator</option>
          <option value="ITV2900">Internet Content Developer</option>
          <option value="ITV3000">LAN Administrator - All</option>
          <option value="ITV3001">LAN Administrator - Banyan Vines</option>
          <option value="ITV3002">LAN Administrator - Microsoft NT</option>
          <option value="ITV3003">LAN Administrator - Novell</option>
          <option value="ITV3100">Operations Support Technician</option>
          <option value="ITV3200">PC/LAN Technician - All</option>
          <option value="ITV3201">PC/LAN Technician - Banyan Vines</option>
          <option value="ITV3202">PC/LAN Technician - Microsoft NT</option>
          <option value="ITV3203">PC/LAN Technician - Novell</option>
          <option value="ITV3300">Programmer - Mainframe - All</option>
          <option value="ITV3301">Programmer - Mainframe - Cobol</option>
          <option value="ITV3302">Programmer - Mainframe - DB2</option>
          <option value="ITV3303">Programmer - Mainframe - Oracle</option>
          <option value="ITV3304">Programmer - Mainframe - PacBase</option>
          <option value="ITV3400">Programmer - Microcomputer - All</option>
          <option value="ITV3401">Programmer - Microcomputer - Access</option>
          <option value="ITV3402">Programmer - Microcomputer - C</option>
          <option value="ITV3403">Programmer - Microcomputer - Dbase</option>
          <option value="ITV3404">Programmer - Microcomputer - Delphi</option>
          <option value="ITV3405">Programmer - Microcomputer - FoxPro</option>
          <option value="ITV3406">Programmer - Microcomputer - Informix</option>
          <option value="ITV3407">Programmer - Microcomputer - Java</option>
          <option value="ITV3408">Programmer - Microcomputer - Oracle</option>
          <option value="ITV3409">Programmer - Microcomputer - PAL</option>
          <option value="ITV3410">Programmer - Microcomputer - PASCAL</option>
          <option value="ITV3411">Programmer - Microcomputer - Powerbuilder</option>
          <option value="ITV3412">Programmer - Microcomputer - SQL Server</option>
          <option value="ITV3413">Programmer - Microcomputer - Visual Basic</option>
          <option value="ITV3414">Programmer - Microcomputer - Visual C++</option>
          <option value="ITV3415">Programmer - Microcomputer - XBase</option>
          <option value="ITV3500">Programmer - Midrange - All</option>
          <option value="ITV3501">Programmer - Midrange - C</option>
          <option value="ITV3502">Programmer - Midrange - C++</option>
          <option value="ITV3503">Programmer - Midrange - COBOL</option>
          <option value="ITV3504">Programmer - Midrange - Informix</option>
          <option value="ITV3505">Programmer - Midrange - Oracle</option>
          <option value="ITV3506">Programmer - Midrange - PASCAL</option>
          <option value="ITV3507">Programmer - Midrange - SMALLTALK</option>
          <option value="ITV3508">Programmer - Midrange - SQL Server</option>
          <option value="ITV3600">Project Manager/Leader</option>
          <option value="ITV3700">Software Engineer - All</option>
          <option value="ITV3701">Software Engineer - Assembly</option>
          <option value="ITV3702">Software Engineer - C</option>
          <option value="ITV3703">Software Engineer - C++</option>
          <option value="ITV3704">Software Engineer - PL/1</option>
          <option value="ITV3705">Software Engineer - SMALLTALK</option>
          <option value="ITV3800">System Administrator/Manager - All</option>
          <option value="ITV3801">System Administrator/Manager - AIX</option>
          <option value="ITV3802">System Administrator/Manager - IBM</option>
          <option value="ITV3803">System Administrator/Manager - DG/UX</option>
          <option value="ITV3804">System Administrator/Manager - Sun</option>
          <option value="ITV3805">System Administrator/Manager - Unix</option>
          <option value="ITV3806">System Administrator/Manager - VMS</option>
          <option value="ITV3900">Systems Analyst </option>
          <option value="ITV4000">System Backup Process Engineer - All</option>
          <option value="ITV4001">System Backup Process Engineer - Legato</option>
          <option value="ITV4100">Systems Integrator</option>
          <option value="ITV4200">Systems Programmer - All</option>
          <option value="ITV4201">Systems Programmer - CICS</option>
          <option value="ITV4202">Systems Programmer - DG/US</option>
          <option value="ITV4203">Systems Programmer - MVS/ESA OS390</option>
          <option value="ITV4204">Systems Programmer - Open VMS and DCL</option>
          <option value="ITV4205">Systems Programmer - PACBASE</option>
          <option value="ITV4206">Systems Programmer - RACF</option>
          <option value="ITV4207">Systems Programmer - VTAM</option>
          <option value="ITV4300">Technical Services Director</option>
          <option value="ITV4400">Technical Writer/Editor</option>
          <option value="ITV4500">Telecomm Analyst</option>
          <option value="ITV4600">Topographic Mapping</option>
          <option value="ITVTest"> </option>
        </select>
      </td>
      <td colspan="3" valign="top" align="left" width="27%">&nbsp; </td>
    </tr>
 </table>

  <table border="0" cellspacing="0" cellpadding="5" width="603" bgcolor="e8e8e8">
    <tr bgcolor="#FFFFFF"> 
      <td align="left" valign="top" width="27%"><font size=1>&nbsp;</font></td>
      <td colspan=2 align="left"><font size=1>&nbsp;</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle"> <b> <font face="Arial, Helvetica, sans-serif">Contact: 
        </font></b> </td>
      <td width="14%" > <font face="Arial, Helvetica, sans-serif"> Name:</font></td>
      <td width="59%" ><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="contactName" name="contactName" size="30" maxlength="30" value=""/>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle">&nbsp;</td>
      <td width="14%"><font face="Arial, Helvetica, sans-serif">Department:</font>
      </td>
      <td width="59%"><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="contactDepartment" name="contactDepartment" size="30" maxlength="30" value=""/>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle"> <font face="Arial, Helvetica, sans-serif"> 
        &nbsp; </font> </td>
      <td width="14%"> <font face="Arial, Helvetica, sans-serif"> Street: </font> 
      </td>
      <td width="59%"><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="contactStreet" name="contactStreet" size="30" maxlength="80" value=""/>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle" >&nbsp; </td>
      <td width="14%" > <font face="Arial, Helvetica, sans-serif"> City: </font> 
      </td>
      <td width="59%" ><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="contactCity" name="contactCity" size="15" maxlength="25" value=""/>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle">&nbsp;</td>
      <td width="14%"><font face="Arial, Helvetica, sans-serif">State: </font></td>
      <td width="59%"><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="contactState" name="contactState" size="2" maxlength="2" value=""/>
        &nbsp;&nbsp;&nbsp; Zip:</font> 
        <input type="text" id="contactZip" name="contactZip" size="10" maxlength="10" value=""/>
      </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle">&nbsp; </td>
      <td width="14%"> <font face="Arial, Helvetica, sans-serif"> Phone: </font> 
      </td>
      <td width="59%"><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="contactPhone" name="contactPhone" size="14" maxlength="35" value=""/>
        &nbsp;&nbsp;FAX: 
        <input type="text" id="contactFax" name="contactFax" size="14" maxlength="18" value=""/>
        </font> </td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle">&nbsp; </td>
      <td width="14%" > <font face="Arial, Helvetica, sans-serif"> Email:</font></td>
      <td width="59%" ><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="contactEmail" name="contactEmail" size="30" maxlength="35" value=""/>
        </font></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td align="left" valign="middle" width="27%"><font size=1>&nbsp;</font></td>
      <td colspan=2 align="left"><font size=1>&nbsp;</font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td colspan="" width="27%" valign="middle"> <b> <font face="Arial, Helvetica, sans-serif"> 
        Job Site: </font> </b> </td>
      <td width="14%"> <font face="Arial, Helvetica, sans-serif"> Street: </font> 
      </td>
      <td width="59%"><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="jobStreet" name="jobStreet" size="30" maxlength="80" value=""/>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle"> </td>
      <td width="14%"> <font face="Arial, Helvetica, sans-serif"> City: </font> 
      </td>
      <td width="59%"><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="jobCity" name="jobCity" size="15" maxlength="25" value=""/>
        </font></td>
    </tr>
    <tr align="left" valign="top"> 
      <td width="27%" valign="middle"></td>
      <td width="14%"><font face="Arial, Helvetica, sans-serif">State </font></td>
      <td width="59%"><font face="Arial, Helvetica, sans-serif"> 
        <input type="text" id="jobState" name="jobState" size="2" maxlength="2" value=""/>
        &nbsp;&nbsp;&nbsp;Zip: 
        <input type="text" id="jobZip" name="jobZip" size="10" maxlength="10" value=""/>
        </font></td>
    </tr>
  </table>
  <p>
      </td>
	<asp:button id="submitButton" text="Submit Request" OnClick="submitButton_Click" runat="server"/>
  </p>
  </div>
  </form>
 </body>
 </html>

