<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<%@ Import Namespace="System.Text"%>
<html>
    <script language="C#" runat="server">
    public class SqlConnect {	
    public DataSet ReturnDataSet(string dbConnectString,
                                 string table1,string table2) {
        DataSet dsTables = new DataSet();
        dsTables.DataSetName = "CustomersData";
        SqlConnection dataConn = new SqlConnection(dbConnectString);
        SqlDataAdapter customersAdapter = 
                                      new SqlDataAdapter(table1,dataConn);
        SqlDataAdapter ordersAdapter = 
                                      new SqlDataAdapter(table2,dataConn);
        customersAdapter.Fill(dsTables,"Customers");
        ordersAdapter.Fill(dsTables,"Orders");
        dsTables.Relations.Add("CustomerOrders",
                      dsTables.Tables["Customers"].Columns["CustomerId"],
                      dsTables.Tables["Orders"].Columns["CustomerId"]);
        return(dsTables);
	}
}
public void Page_Load(Object Src, EventArgs E) { 
    string SqlconnStr = "server=localhost;uid=sa;pwd=;database=Northwind";
    string table1 = @"SELECT * FROM Customers WHERE CustomerID LIKE 'h%' 
                      ORDER BY ContactName";
    string table2 = "SELECT * FROM Orders WHERE CustomerID LIKE 'h%'";
    StringBuilder output = new StringBuilder();
    DataRow[] rows;
    //Open Sql Connection
    SqlConnect Sqlconn = new SqlConnect();
    DataSet TablesDataSet = Sqlconn.ReturnDataSet(SqlconnStr,
                                                  table1,table2);
    
    foreach (DataRow Customer in TablesDataSet.Tables["Customers"].Rows) {
        output.Append("<div onClick=\"showDetails('" + 
                       Customer["CustomerID"].ToString() + "')\">");
        output.Append("<br><span style=\"background: #02027a;" +
                      "width: 500px;");
        output.Append("cursor: hand;\">");
        output.Append("<table width=\"100%\"><tr><td width=\"90%\"" +
                      " style=\"color:#ffffff;font-weight:bold\">" +
                      "Customer Name: ");
        output.Append(Customer["ContactName"].ToString() + "</td><td>");
        output.Append("<img src=\"yellow_arrow_down2.gif\"></td>" +
                      "</tr></table></span>");
        output.Append("</div>");
        output.Append("<div style=\"width: 500px;display:none;" + 
                      "background:#efefef\" id='");
        output.Append(Customer["CustomerID"].ToString() + "'>");
        // Iterate over orders data
        rows = Customer.GetChildRows(
                        TablesDataSet.Relations["CustomerOrders"]);
        if (rows.Length > 0) {
            foreach (DataRow Order in rows) {
                output.Append("<br><b>Order:</b> #" +
                              Order["OrderId"].ToString());
                output.Append("&nbsp;&nbsp;<b>Shipping Address:</b>" +
                               Order["ShipAddress"].ToString());
            }
        } else {
            output.Append("<b>No Records</b>");
        }
        output.Append("</div>");
    }
    content.InnerHtml = output.ToString();
    XmlDataDocument dataDoc = new XmlDataDocument(TablesDataSet);
    xml.Text = dataDoc.OuterXml;
} 
    </script>
    <head>
        <script language="JavaScript">
    function showDetails(id) {
        var loc = document.all(id);
        if (loc.style.display == 'none') {
            loc.style.display = 'block';	
        } else {
            loc.style.display = 'none';
        }
	
    }
        </script>
    </head>
    <body bgcolor="#ffffff">
        <h2>
            <b>Walking Multiple DataSet Tables</b>
        </h2>
        <div id="content" runat="server" />
        <p>
            &nbsp;
        </p>
        <b>XML Data:</b>
        <br />
        <form runat="server">
			<asp:TextBox ID="xml" Runat="server" Columns="75" Rows="15" TextMode="MultiLine" NAME="xml" />
		</form>
    </body>
</html>
