<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<script language="c#" runat="server">
    public void Page_Load(Object Src, EventArgs E) { 
        string id = Request.QueryString["id"];
        string order = Request.QueryString["placeOrder"];
        if (!IsPostBack && id==null && order==null) {
            ShowHidePanels("pnlSplash");
        } else {
			ShowHidePanels("");
        }
		if (id != null) {
		    CheckStock(Convert.ToInt32(id));
		}
		if (order != null) {
		    PlaceOrder(order);
		}
    }
    public void GetOrderStatus_Click(Object Src, EventArgs E) { 
        ShowHidePanels("pnlOrderStatus");
        ACME.Distribution.ACMEProducts custOrders = new ACME.Distribution.ACMEProducts();
        DataSet ds = custOrders.GetOrders(customerID.Value);
		OrdersDataGrid.DataSource=ds.Tables[0].DefaultView;
		OrdersDataGrid.DataBind();	
    }
    
    public void PlaceOrder(string order) {
    	ShowHidePanels("pnlPlaceOrder");
		lblPlaceOrder.Text = "<p><b>Your order has been placed for product ID: " + order + "</b>";
    }
    
    public void CheckStock(int productID) { 
        ShowHidePanels("pnlStock");
        ACME.Distribution.ACMEProducts custOrders = new ACME.Distribution.ACMEProducts();
        DataSet ds = custOrders.CheckStock(productID);
		StockDataGrid.DataSource=ds.Tables[0].DefaultView;
		StockDataGrid.DataBind();	
    }
    public void ProductSubmit_Click(Object Src, EventArgs E) { 
        ShowHidePanels("pnlProducts");
        ACME.Distribution.ACMEProducts custOrders = new ACME.Distribution.ACMEProducts();
        DataSet ds = custOrders.GetProductByName(txtProductName.Text);
		ProductsDataGrid.DataSource=ds.Tables[0].DefaultView;
		ProductsDataGrid.DataBind();	
    }
    public void CheckOrderStatusLink_Click(Object Src, EventArgs E) { 
        ShowHidePanels("pnlCheckOrder");
    }
	public void BrowseProductsLink_Click(Object Src, EventArgs E) {
		ShowHidePanels("pnlBrowseProducts");	
		ACME.Distribution.ACMEProducts prods = new ACME.Distribution.ACMEProducts();
		DataSet ds = prods.GetProducts();
		DataView dv = ds.Tables[0].DefaultView;
		lstProducts.DataSource = dv;
		lstProducts.DataBind();
		
	}
	public void lstProducts_Select(Object Src, EventArgs E) {
	    ShowHidePanels("pnlProducts");
        ACME.Distribution.ACMEProducts custOrders = new ACME.Distribution.ACMEProducts();
        DataSet ds = custOrders.GetProductByID(
                     Convert.ToInt32(lstProducts.SelectedItem.Value));
		ProductsDataGrid.DataSource=ds.Tables[0].DefaultView;
		ProductsDataGrid.DataBind();
	}
    public void ShowHidePanels(string panel) {
        Control ctl = null; 
        Control frm = Page.FindControl("frmWidgets");
        int ctlsCount = frm.Controls.Count;
        for (int i=0;i<ctlsCount;i++) {
            ctl = frm.Controls[i];
            if (ctl.Parent == frm) {
				if (ctl.ID == panel) {
					ctl.Visible = true;
				} else {
				    if (ctl.ID != null && ctl.ID.IndexOf("pnl") != -1) {
						ctl.Visible = false;
					}
				}
			}
        }
    }
</script>
<html>
	<head>
		<title>
			Wahlin's Widgets
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<style type="text/css">
			.button { BORDER-RIGHT: #000000 1px solid; BORDER-TOP: #000000 1px solid; 
			FONT-WEIGHT: bold; BACKGROUND: #ff0000; BORDER-LEFT: #000000 1px solid; COLOR: 
			#ffffff; BORDER-BOTTOM: #000000 1px solid; FONT-FAMILY: arial; size: 10px } A { 
			TEXT-DECORATION: none }
		</style>
	</head>
	<body bgcolor="#ffffff">
		<form runat="server" id="frmWidgets">
			<table width="640" border="0" cellpadding="4" cellspacing="0">
				<tr bgcolor="#02027a">
					<td colspan="2" valign="center">
						<table width="640" border="0" height="50">
							<tr align="left" valign="center">
								<td width="55%">
									<b><font size="5" color="#ffff00" face="Arial, Helvetica, sans-serif">Wahlin's Widgets</font></b></td>
								<td width="45%" align="right">
									<b><font face="Arial, Helvetica, sans-serif" color="#ffffff" size="2">Find a Product (e.g. Mozzarella):</font></b>
									<br />
									<asp:TextBox id="txtProductName" name="txtProductName" runat="server" EnableViewState="False" />
									<input type="submit" id="btnProductSubmit" value="Go!" class="button" runat="server" onServerClick="ProductSubmit_Click" />
									&nbsp;&nbsp;
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="136" bgcolor="#02027a">
						&nbsp;
					</td>
					<td width="504" align="left" valign="top">
						<!--<img src="corner.gif" height="11" width="16">
						-->
					</td>
				</tr>
				<tr>
					<td width="136" bgcolor="#02027a" align="left" valign="top">
						<a href="listing10.15.aspx"><b><font face="Arial, Helvetica, sans-serif" size="2" color="#ffffff">Home</font></b></a>
						<br />
						<a runat="server" id="lnkCheckOrderStatus" href="" name="lnkCheckOrderStatus" OnServerClick="CheckOrderStatusLink_Click" title="Check the status of all your orders"><b><font face="Arial, Helvetica, sans-serif" size="2" color="#ffffff">Check Order Status</font></b></a>
						<br />
						<a runat="server" id="lnkBrowseProducts" href="" name="lnkBrowseProducts" OnServerClick="BrowseProductsLink_Click" title="Browse Products"><b><font face="Arial, Helvetica, sans-serif" size="2" color="#ffffff">Browse Products</font></b></a>
						<br />
						<span onClick="alert('Not Implemented')">
							<b><font face="Arial, Helvetica, sans-serif" size="2" color="#ffffff">Contact Us</font></b></span>
						<br />
						<span onClick="alert('Not Implemented')">
							<b><font face="Arial, Helvetica, sans-serif" size="2" color="#ffffff"> About Us</font></b></span>
					</td>
					<td width="504" height="450" valign="top">
						<asp:panel id="pnlSplash" align="center" runat="server">
							<p>
								&nbsp;
							</p>
							<p>
								&nbsp;
							</p>
							<img src="splash.gif">
						</asp:panel>
						<asp:panel id="pnlCheckOrder" align="center" runat="server"><b>Enter your Customer ID:</b>&nbsp;&nbsp;
							<input type="text" name="customerID" id="customerID" value="ALFKI" runat="server" />
							<p>
								<input type="submit" class="button" id="getOrderStatus" value="Retrieve Orders" onServerClick="GetOrderStatus_Click" runat="server" />
							</p>
						</asp:panel>
						<asp:panel id="pnlOrderStatus" align="center" runat="server"><b><font face="Arial, Helvetica, sans-serif" size="4" color="#000000">Customer Orders:</font></b>
							<p>
								<ASP:DataGrid id="OrdersDataGrid" runat="server" BackColor="White" BorderColor="Black" CellPadding=5 Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#efefef" HeaderStyle-ForeColor="#000000" font-names="Arial">
									<HeaderStyle ForeColor="White" BackColor="#02027A">
									</HeaderStyle>
								</ASP:DataGrid>
							</p>
						</asp:panel>
						<asp:panel id="pnlStock" align="center" runat="server"><b><font face="Arial, Helvetica, sans-serif" size="4" color="#000000">Product Status:</font></b>
							<p>
								<ASP:DataGrid id="StockDataGrid" runat="server" BackColor="White" BorderColor="Black" CellPadding=5 Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#efefef" HeaderStyle-ForeColor="#000000" font-names="Arial">
									<HeaderStyle ForeColor="White" BackColor="#02027A">
									</HeaderStyle>
								</ASP:DataGrid>
							</p>
						</asp:panel>
						<asp:panel id="pnlProducts" align="center" runat="server"><font face="Arial, Helvetica, sans-serif" size="4" color="#000000">Products:</font></B>
							<p>
								<asp:DataGrid id="ProductsDataGrid" runat="server" BackColor="White" BorderColor="Black" CellPadding=5 Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#efefef" HeaderStyle-ForeColor="#000000" font-names="Arial">
									<HeaderStyle ForeColor="White" BackColor="#02027A">
									</HeaderStyle>
									<Columns>
										<asp:HyperLinkColumn Text="Buy" DataNavigateUrlField="ProductID" DataNavigateUrlFormatString="listing10.15.aspx?placeOrder={0}">
										</asp:HyperLinkColumn>
										<asp:HyperLinkColumn Text="Check Availability" DataNavigateUrlField="ProductID" DataNavigateUrlFormatString="listing10.15.aspx?id={0}">
										</asp:HyperLinkColumn>
									</Columns>
								</asp:DataGrid>
							</p>
						</asp:panel>
						<asp:panel id="pnlPlaceOrder" align="center" runat="server">
							<asp:Label ID="lblPlaceOrder" Runat="server" />
						</asp:panel>
						<asp:panel id="pnlBrowseProducts" align="center" runat="server"><b>Select a Product:</b>
							<br />
							<asp:DropDownList ID="lstProducts" Runat="server" DataTextField="ProductName" DataValueField="ProductID" OnSelectedIndexChanged="lstProducts_Select" AutoPostBack="True" />
						</asp:panel>
						<p>
							&nbsp;
						</p>
						<p>
							&nbsp;
						</p>
						<p>
							&nbsp;
						</p>
						<p>
							&nbsp;
						</p>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
