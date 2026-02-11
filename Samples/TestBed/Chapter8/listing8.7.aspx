<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<script language="C#" runat="server">
public class SqlConnect {	
    public DataSet ReturnDataSet(string dbConnectString,string table1,
                                 string table2,string key1, string key2) {
            DataSet dsTables = new DataSet();
            SqlConnection dataConn = new SqlConnection(dbConnectString);
            SqlDataAdapter dsCmdCustomers = new SqlDataAdapter(table1,dataConn);
            SqlDataAdapter dsCmdOrders = new SqlDataAdapter(table2,dataConn);
            dsCmdCustomers.Fill(dsTables,"Table1");
            dsCmdOrders.Fill(dsTables,"Table2");
            dsTables.Relations.Add("Relation1",dsTables.Tables["table1"].Columns[key1],
                                   dsTables.Tables["table2"].Columns[key2]);
            return(dsTables);
        }
    }

public void Page_Load(Object Src, EventArgs E) { 
    string xmlString;
    string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
    string sCustomers = "SELECT * FROM Customers WHERE CustomerID" +
                        " LIKE 'f%' ORDER BY ContactName";
    string sOrders = "SELECT * FROM Orders WHERE CustomerID LIKE 'f%'";
    
    SqlConnect Sqlconn = new SqlConnect();
    DataSet TablesDataSet = Sqlconn.ReturnDataSet(connStr,sCustomers,
                                sOrders,"CustomerID","CustomerID");
    xmlString = TablesDataSet.GetXml();
    XmlContents.InnerHtml = xmlString;
    stats.InnerHtml = "<font color=\"#02027a\"><b>XML Data Island Filled with" +
                      " DataSet Records</b></font>";
    xml.Text = xmlString;
} 
</script>
<html>
    <head>
        <script language="JavaScript">
        function showXml() {
            var doc = document.all("XmlContents").XMLDocument; 
            output = "<p>Starting to gather information on client-side....";
            var node1 = doc.documentElement.selectNodes("//Table1");
            var node2 = doc.documentElement.selectNodes("//Table2");
            var stats = document.all("stats");
            output += "<br>Information gathered!  Totals follow:<br><hr>";
            output += "<br><b>Number of Customers: " + node1.length;
            output += "<br>Number of Orders: " + node2.length; + "</b>";
            stats.innerHTML = stats.innerHTML + "<br>" + output;
        }
        </script>
    </head>
    <body onLoad="showXml()">
        <XML id="XmlContents" runat="server" />
        <div id="stats" style="width: 400px;" runat="server" />
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
