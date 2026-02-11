<%@ WebService Language="C#" class="DeleteData" %>

using System.Web.Services;
using System.EnterpriseServices;
using System.Data;
using System.Data.SqlClient;

[WebService(Namespace="http://www.TomorrowsLearning.com/Greeting")]
class DeleteData: WebService {
	[WebMethod(TransactionOption=TransactionOption.RequiresNew)]
    public int Delete(string sql) {
        string connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
        SqlConnection dataConn = new SqlConnection(connStr);
        SqlCommand cmd = new SqlCommand(sql,dataConn);
        try {
			cmd.ExecuteNonQuery();
			return 0;
		}
		catch {
			ContextUtil.SetAbort();
			return 1;
		}
		finally {
			if (dataConn != null) dataConn.Close();
		}
    }
}
