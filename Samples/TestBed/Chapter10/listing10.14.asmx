<%@ WebService language="C#" class="ACMEProducts" %>
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

[WebService(Namespace="http://www.ACMEDistribution.com/Products")]
public class ACMEProducts: WebService {
	
    [WebMethod(Description="This method allows access to product stock numbers")]
    public DataSet CheckStock(int productID) {
        string sql = @"SELECT ProductName,UnitsInStock, UnitsOnOrder, 
                       Discontinued FROM Products WHERE ProductID = '" + 
                       productID + "'";
        DataSet dsProductStatus = getDataSet(sql,"ProductQuantity");
        return(dsProductStatus);
    }

    [WebMethod(Description="This method allows access to " +
                           " order status information")]
    public DataSet GetOrders(string CustomerID) {
        string sql = @"SELECT ShipName,ShipAddress,ShipCity,ShippedDate 
                       FROM Orders WHERE CustomerID = '" + CustomerID + "'";
        DataSet dsOrders = getDataSet(sql,"Orders");
        return(dsOrders);
	}
	
    [WebMethod(Description="This method allows selection of " +
                           "products by name")]
    public DataSet GetProductByName(string productName) {
        string sql = @"SELECT ProductID,ProductName,UnitPrice,
                       QuantityPerUnit FROM Products 
		               WHERE ProductName LIKE '" + productName + "%'";
        DataSet dsProducts = getDataSet(sql,"Products");
        return(dsProducts);
    }
    [WebMethod(Description="This method allows selection of " +
                           "products by ID")]
    public DataSet GetProductByID(int id) {
        string sql = @"SELECT ProductID,ProductName,UnitPrice,
                       QuantityPerUnit FROM Products 
		               WHERE ProductID = " + id;
        DataSet dsProducts = getDataSet(sql,"Products");
        return(dsProducts);
    }
    [WebMethod(Description="This method allows selection of " +
                           "all products",CacheDuration=120)]
    public DataSet GetProducts() {
        string sql = "SELECT ProductID,ProductName FROM Products";
        DataSet dsProducts = getDataSet(sql,"Products");
        return(dsProducts);
    }

    private DataSet getDataSet(string sql, string tableName) {
        string SQLconnStr = "server=localhost;uid=sa;" +
                            "pwd=;database=Northwind";
        DataSet ds = new DataSet();
        SqlConnection dataConn = new SqlConnection(SQLconnStr);
        SqlDataAdapter dsAdapter = new SqlDataAdapter(sql,dataConn);
        dsAdapter.Fill(ds, tableName);
        dataConn.Close();
        return(ds);
    }
}
