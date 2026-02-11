<%@ Import Namespace="System.Data"%>
<script language="C#" runat="server">
	public void Page_Load(Object Src, EventArgs E) { 
		DataSet ds = new DataSet();
		ds.ReadXml(Server.MapPath("golfers.xml"));
		foreach (DataRow row in ds.Tables["name"].Rows) {
		    Response.Write(row["firstName"].ToString() + "<br />");
		}	
	} 
</script>
