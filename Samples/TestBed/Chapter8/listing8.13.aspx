<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>

<script language="C#" runat="server">
    public class SqlConnect {
        public DataSet ReturnDataSet(string dbConnectString,string table1,
                               string table2,string key1,string key2) {
            DataSet dsTables = new DataSet();
            SqlConnection dataConn = new SqlConnection(dbConnectString);
            SqlDataAdapter dsCmdCustomers = 
                                  new SqlDataAdapter(table1,dataConn);
            SqlDataAdapter dsCmdOrders = 
                                  new SqlDataAdapter(table2,dataConn);
            dataConn.Open();
            dsCmdCustomers.Fill(dsTables,"Customers");
            dsCmdOrders.Fill(dsTables,"Orders");
            dsTables.Relations.Add("Relation1",
                            dsTables.Tables["Customers"].Columns[key1],
                            dsTables.Tables["Orders"].Columns[key2]);
            return(dsTables);
        }
        public int InsertDataSet(string dbConnectString,DataSet ds) {
            string sql = @"INSERT INTO Customers (CustomerID,
                           CompanyName, ContactName,ContactTitle) 
                           VALUES (@CustomerID,@CompanyName,
                           @ContactName,@ContactTitle)";
            SqlConnection dataConn = null;
            SqlDataAdapter dsAdapter = null;
            try {
                dataConn = new SqlConnection(dbConnectString);
                dsAdapter = new SqlDataAdapter();
                dsAdapter.InsertCommand = new SqlCommand(sql,dataConn);  
                
                dsAdapter.InsertCommand.Parameters.Add(
                  new SqlParameter("@CustomerID",SqlDbType.NChar, 5));
                dsAdapter.InsertCommand.Parameters[0].SourceColumn =
                                                     "CustomerID";
                
                dsAdapter.InsertCommand.Parameters.Add(
                  new SqlParameter("@CompanyName",SqlDbType.NVarChar,40));
                dsAdapter.InsertCommand.Parameters[1].SourceColumn =
                                                      "CompanyName";
                
                dsAdapter.InsertCommand.Parameters.Add(
                  new SqlParameter("@ContactName",SqlDbType.NVarChar,30));
                dsAdapter.InsertCommand.Parameters[2].SourceColumn =
                                                     "ContactName";   

                dsAdapter.InsertCommand.Parameters.Add(
                  new SqlParameter("@ContactTitle",SqlDbType.NVarChar,30));
                dsAdapter.InsertCommand.Parameters[3].SourceColumn =
                                                      "ContactTitle";
                
                dataConn.Open();
                dsAdapter.Update(ds,"Customers");
            }
            catch (Exception exp) {
                return 1;
            }
            return 0;
        }
        
        public int DeleteDataSet(string dbConnectString,DataSet ds,
                                 string key) {
            string sql = "DELETE FROM Customers WHERE CustomerID = '" + 
                          key + "'";
            SqlConnection dataConn = null;
            SqlDataAdapter dsAdapter = null;
            try {
                dataConn = new SqlConnection(dbConnectString);
                dsAdapter = new SqlDataAdapter();
                dsAdapter.DeleteCommand = new SqlCommand(sql,dataConn);
                dsAdapter.Update(ds,"Customers");
            }
            catch (Exception exp) {
                return 1;
            }
            return 0;
        }
    }	
    public void Page_Load(Object Src, EventArgs E) { 
        String connStr = "server=localhost;uid=sa;pwd=;" + 
                          "database=Northwind";
        String customersSql = @"SELECT * FROM Customers 
                                WHERE CustomerID LIKE 'd%'
                                ORDER BY ContactName";
        String ordersSql = "SELECT * FROM Orders WHERE" +
                           " CustomerID LIKE 'd%'";
        String output = "";
        //****** Save Schema to a File/Save XML data to a File
        SqlConnect Sqlconn = new SqlConnect();
        DataSet ds = Sqlconn.ReturnDataSet(connStr,customersSql,ordersSql,
                                           "CustomerID","CustomerID");
        ds.WriteXmlSchema(Server.MapPath("schema.xsd"));
        ds.WriteXml(Server.MapPath("customers.xml"),
                    XmlWriteMode.IgnoreSchema);
        
        //****** Load the schema.xsd file into an empty DataSet object 
        DataSet newDS = new DataSet();
        newDS.ReadXmlSchema(Server.MapPath("schema.xsd"));
        newDS.ReadXml(Server.MapPath("customers.xml"));
        newDS.AcceptChanges();
        XmlDataDocument xmlDataDoc = new XmlDataDocument(newDS);

        //****** Add a new row and fill 4 columns with data
        DataRow row = newDS.Tables["Customers"].NewRow();
        row["CustomerID"] = "DLWID";
        row["CompanyName"] = "Tomorrows Learning";
        row["ContactName"] = "Dan Wahlin";
        row["ContactTitle"] = "Programmer/Author/Speaker";
        
        //****** Let's see how well the schema validates
        try {
            row["test"] = "Testing Schema";
        }
        catch (Exception exc) {
            //column["test"] doesn't really exist
        }
        //****** Add new row to DataSet
        newDS.Tables["Customers"].Rows.Add(row);
        
        //****** Get changes to DataSet
        DataSet changesDS = newDS.GetChanges();
        //divChanges.InnerHtml = "<xmp>" + changesDS.GetXml() + "</xmp>";
        
        //****** Show that the DataSet and XmlDataDocument are synced
        XmlNode node = xmlDataDoc.SelectSingleNode("//CustomerID[.='DLWID']");
        if (node != null) {
            Response.Write("<b>XmlDataDocument Synced with" +
                           " DataSet!</b><br />");
            Response.Write("Newly added CustomerID in XmlDataDocument: " +
                            node.InnerText);
        }
        
        //****** Use the XmlDataDocument's GetElementFromRow() Method
        XmlElement customer = xmlDataDoc.GetElementFromRow(
                                   newDS.Tables["Customers"].Rows[2]);
        Response.Write("<br />CompanyName: " + 
                        customer.SelectSingleNode("CompanyName").InnerText);
        
        BeforeDataGrid.DataSource = newDS.Tables["Customers"].DefaultView;
        BeforeDataGrid.DataBind();
        
        //****** Insert the Record in the Database
        Sqlconn.InsertDataSet(connStr,newDS);
        
        ds = Sqlconn.ReturnDataSet(connStr,customersSql,ordersSql,
                                   "CustomerID","CustomerID");
        AfterDataGrid.DataSource = ds.Tables["Customers"].DefaultView;
        AfterDataGrid.DataBind();
        
        //****** Delete newly added ID from database
        //****** Load DataSet into XmlDataDocument and use it to 
        //****** to delete row and pass the DataSet to the
        //****** DeleteDataSet() method
        //ds.Tables["Customers"].Rows[ds.Tables["Customers"].Rows.Count-1].Delete();
        ds.EnforceConstraints = false;
        xmlDataDoc = new XmlDataDocument(ds);
        XmlNode root = xmlDataDoc.DocumentElement;
        string xpath = "//Customers[CustomerID='DLWID']";
        XmlNode newNode = xmlDataDoc.SelectSingleNode(xpath);
        root.RemoveChild(newNode);
        Sqlconn.DeleteDataSet(connStr,xmlDataDoc.DataSet,"DLWID");
        
        ds = Sqlconn.ReturnDataSet(connStr,customersSql,
                                   ordersSql,"CustomerID","CustomerID");
        AfterDeleteDataGrid.DataSource = ds.Tables["Customers"].DefaultView;
        AfterDeleteDataGrid.DataBind();
        
        
    }
</script>
<html>
    <body bgcolor="#ffffff">
        <div id="divChanges" runat="server" />
        <h2>
            Data Before Submitting Insert to DataBase
        </h2>
        <ASP:DataGrid id="BeforeDataGrid" runat="server" Width="700" BackColor="#E6E6CC" BorderColor="#000000" ShowFooter="false" CellPadding=5 CellSpacing="0" Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#6C0A00" HeaderStyle-ForeColor="#ffffff" MaintainState="false" />
        <br>
        <h2>
            Data After Being Submitted to DataBase
        </h2>
        <ASP:DataGrid id="AfterDataGrid" runat="server" Width="700" BackColor="#E6E6CC" BorderColor="#000000" ShowFooter="false" CellPadding=5 CellSpacing="0" Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#6C0A00" HeaderStyle-ForeColor="#ffffff" MaintainState="false" NAME="AfterDataGrid" />
        <h2>
            Data After Deleting Single Row From DataBase
        </h2>
        <ASP:DataGrid id="AfterDeleteDataGrid" runat="server" Width="700" BackColor="#E6E6CC" BorderColor="#000000" ShowFooter="false" CellPadding=5 CellSpacing="0" Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#6C0A00" HeaderStyle-ForeColor="#ffffff" MaintainState="false" NAME="AfterDeleteDataGrid" />
    </body>
</html>
