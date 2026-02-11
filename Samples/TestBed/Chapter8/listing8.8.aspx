<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.IO"%>
<script language="C#" runat="server">
  public class DSReadXml {	
      public static DataSet ReturnDataSet(string path) {
         DataSet dsTables = new DataSet();
         FileStream fs = null;
         StreamReader reader = null;
         try {
             fs = new FileStream(path,FileMode.Open,FileAccess.Read);
             reader = new StreamReader(fs);
             dsTables.ReadXml(reader);
             return dsTables;
         }
         finally {
             fs.Close();
             reader.Close();
         }
          
     }
 }
 public void Page_Load(Object Src, EventArgs E) { 
     BindIt("CustomerID");

 } 
 public void OrdersDataGrid_Sort(Object Src, DataGridSortCommandEventArgs sort) {
	BindIt(sort.SortExpression);
 }
 public void BindIt(string sortField) {
     DataSet ds = DSReadXml.ReturnDataSet(Server.MapPath("customerList.xml"));
     DataView view = ds.Tables[0].DefaultView;
     view.Sort = sortField;
     OrdersDataGrid.DataSource = view;
     OrdersDataGrid.DataBind();	    
 }
</script>
<html>
    <body bgcolor="#ffffff">
        <form runat="server">
            <ASP:DataGrid id="OrdersDataGrid" runat="server" Width="700" BackColor="#E6E6CC" BorderColor="#000000" ShowFooter="false" CellPadding=5 CellSpacing="0" Font-Name="Arial" Font-Size="8pt" HeaderStyle-BackColor="#6C0A00" HeaderStyle-ForeColor="#ffffff" MaintainState="false" OnSortCommand="OrdersDataGrid_Sort" AllowSorting="true" />
        </form>
    </body>
</html>
