<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<%@ Import Namespace="System.Xml.Xsl"%>
<%@ Import Namespace="System.IO"%>
<html>
    <script language="C#" runat="server">
public class SqlConnect {	
    public DataSet ReturnDataSet(string dbConnectString,
                                 string table1,string table2) {
        DataSet dsTables = new DataSet();
        SqlConnection dataConn = new SqlConnection(dbConnectString);
        SqlDataAdapter dsCmdCustomers = new SqlDataAdapter(table1,dataConn);
        SqlDataAdapter dsCmdOrders = new SqlDataAdapter(table2,dataConn);
        dsCmdCustomers.Fill(dsTables,"Customers");
        dsCmdOrders.Fill(dsTables,"Orders");
        DataRelation rel = new DataRelation("CustomerOrders",
                           dsTables.Tables["Customers"].Columns["CustomerId"],
                           dsTables.Tables["Orders"].Columns["CustomerId"]);
        rel.Nested = true;
        dsTables.Relations.Add(rel);        
        return(dsTables);
	}
}

public void Page_Load(Object Src, EventArgs E) { 
    string SqlconnStr = "server=CX661569-LAPTOP;uid=sa;pwd=;database=Northwind";
    string customerSql = "SELECT * FROM Customers WHERE CustomerID LIKE 'A%'" +
                         " ORDER BY ContactName";
    string ordersSql = "SELECT * FROM Orders WHERE CustomerID LIKE 'A%'";
    StringBuilder sb = new StringBuilder();
    StringWriter sw = new StringWriter(sb);
    XmlTextWriter writer = new XmlTextWriter(sw);
    //Open Sql Connection
    SqlConnect Sqlconn = new SqlConnect();
    DataSet ds = Sqlconn.ReturnDataSet(SqlconnStr,customerSql,ordersSql);
    XslTransform xsl = new XslTransform();
    xsl.Load(Server.MapPath("customerOrders.xsl"));
    xsl.Transform(new XmlDataDocument(ds),null,writer);
    content.InnerHtml = sb.ToString();
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
            <b>Walking Hierarchical XML in DataSets with XSLT</b>
        </h2>
        <div id="content" runat="server" />
    </body>
</html>
