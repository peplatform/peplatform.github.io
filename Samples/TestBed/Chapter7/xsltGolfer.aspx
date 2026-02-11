<%@ Page language="c#" Codebehind="xsltGolfer.aspx.cs" AutoEventWireup="false" Inherits="TestBed.Chapter7.XsltGolfer" %>

<HTML>
	<HEAD>
		<style type="text/css">
			.blackText {font-family:arial;color:#000000;} .largeYellowText 
			{font-family:arial;font-size:18pt;color:#ffff00;} .largeBlackText 
			{font-family:arial;font-size:14pt;color:#000000;} .borders {border-left:1px 
			solid #000000;border-right:1px solid #000000; border-top:1px solid 
			#000000;border-bottom:1px solid #000000;}
		</style>
	</HEAD>
	<body>
		<form method="post" runat="server">
			<asp:Panel ID="pnlSelectGolfer" Runat="server">
				<TABLE width=400 bgColor=#efefef border=0 class="borders">
					<TR>
						<TD bgColor=#02027a>
							<SPAN style="FONT-SIZE: 14pt; COLOR: #ffffff; FONT-FAMILY: arial">
								Select a Golfer by Name:
							</SPAN>
						</TD>
					</TR>
					<TR>
						<TD>
							<asp:DropDownList id=ddGolferName runat="server">
							</asp:DropDownList>
						</TD>
					</TR>
					<TR>
						<TD>
							&nbsp;
						</TD>
					</TR>
					<TR>
						<TD>
							<asp:Button id=btnSubmit runat="server" Text="Get Golfer!">
							</asp:Button>
						</TD>
					</TR>
				</TABLE>
			</asp:Panel>
			<asp:Panel ID="pnlTransformation" Runat="server" Visible="False">
				<DIV id=divTransformation runat="server">
				</DIV>
				<P>
					<asp:LinkButton id=lnkBack Runat="server" Text="Back"> Back</asp:LinkButton></P>
			</asp:Panel>
		</form>
	</body>
</HTML>
