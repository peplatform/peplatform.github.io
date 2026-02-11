<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.IO"%>
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
        string sqlConnStr = "server=localhost;uid=sa;pwd=;database=Northwind";
        string sqlCustomers = "SELECT * FROM Customers";
        string sqlOrders = "SELECT * FROM Orders";
        SqlConnect sqlConnect = new SqlConnect();
        DataSet ds = sqlConnect.ReturnDataSet(sqlConnStr,sqlCustomers,sqlOrders);
        
        //Save data and schema information to a file
        ds.WriteXml(Server.MapPath("Listing8.10.xml"),
                         XmlWriteMode.IgnoreSchema);
        ds.WriteXmlSchema(Server.MapPath("Listing8.11.xsd"));
        Response.Write("DataSet XML data and schema information saved.");
     } 
</script>