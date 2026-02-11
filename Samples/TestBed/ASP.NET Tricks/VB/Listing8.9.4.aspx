<%@ Page %>
<%@ Import Namespace="System.Data"%>
<script language="VB" runat="server">
    public sub Page_Load(sender as Object, e as EventArgs) 
		Dim ds as DataSet = new DataSet()
		ds.ReadXml(Server.MapPath("golfers.xml"))
		Dim row as DataRow
		for each row in ds.Tables("name").Rows
		    Response.Write(row("firstName").ToString() & "<br />")
		next	
	end sub 
</script>
