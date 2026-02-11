<%@ Page %>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ Import Namespace="System.Xml"%>
<script language="C#" runat="server">
    string output = "";
    int indent = 1;
    public class SqlConnect {
	
    public DataSet ReturnDataSet(string dbConnectString,string table1,
                                 string table2,string key1,string key2) {
        DataSet dsTables = new DataSet();
        SqlConnection dataConn = new SqlConnection(dbConnectString);
        SqlDataAdapter dsCmdCustomers = new SqlDataAdapter(table1,dataConn);
        SqlDataAdapter dsCmdOrders = new SqlDataAdapter(table2,dataConn);
        dsCmdCustomers.Fill(dsTables,"Table1");
        dsCmdOrders.Fill(dsTables,"Table2");
        dsTables.Relations.Add("Relation1",dsTables.Tables["Table1"].Columns[key1],
                               dsTables.Tables["table2"].Columns[key2]);
        return dsTables;
    }
}	
    public class WriteXmlText {
        private string m_Document = "";
        string output = "";
        int indent = 1;
		
        public string ParseDoc(XmlDataDocument document) {
                XmlNode oNode = document.DocumentElement;
                writeNodeName(oNode,0);
                XmlNodeList oNodeList = oNode.ChildNodes;            
                for (int i=0;i<oNodeList.Count;i++) {
                    XmlNode oCurrentNode = oNodeList[i];			 
                    if (oCurrentNode.HasChildNodes) {
                        writeNodeName(oCurrentNode,indent);
                        walkTheTree(oCurrentNode);
                        indent--;
                    } else {
                        writeNodeName(oCurrentNode,indent);
                    }
                }
	 
                return output;
         }
		
            private void walkTheTree(XmlNode oNodeToWalk) {
                indent++;
                XmlNodeList oNodeList = oNodeToWalk.ChildNodes; 
                for (int j=0;j<oNodeList.Count;j++) {
                    XmlNode oCurrentNode = oNodeList[j];     

                    if (oCurrentNode.HasChildNodes) {
                        writeNodeName(oCurrentNode,indent);
                        walkTheTree(oCurrentNode);
                        indent--;
                    } else {
                        writeNodeName(oCurrentNode,indent);
                    }
                }
            }
	    
            private void writeNodeName(XmlNode node,int iIndent) {
                int h = 0;
                for (int k=0;k<(iIndent * 10);k++) {
                    output += "&nbsp;";
                }
                if (node.NodeType == XmlNodeType.Text) { // Text node
                    output += "<font color='#ff0000'>" + node.Value +
                              "</font><br>";
                } else {
                    if (node.Attributes.Count > 0) {
                        XmlNamedNodeMap oNamedNodeMap = node.Attributes;  
                        output += "<b>" + node.Name + "</b> (";
                        foreach (XmlAttribute att in oNamedNodeMap) {
                            if (h!=0) output += "&nbsp;&nbsp;";
                                h++;
                                output += "<i>" + att.Name + "</i>=\"" +
                                          att.Value + "\"";
                        }
                        output += ")<br>\n\n";
                    } else {
                        output += "<b>" + node.Name + "</b><br>\n\n";
                    }
                } // end if
            } // writeNodeName
        } //WriteXmlText

public void Page_Load(Object Src, EventArgs E) { 
    String connStr = "server=localhost;uid=sa;pwd=;database=Northwind";
    String table1 = @"SELECT * FROM Customers WHERE CustomerID LIKE 'd%'
                      ORDER BY ContactName";
    String table2 = "SELECT * FROM Orders WHERE CustomerID LIKE 'd%'";
    String output = "";
    //Open Sql Connection
    SqlConnect Sqlconn = new SqlConnect();
    DataSet ds = Sqlconn.ReturnDataSet(connStr,table1,table2,
                                       "CustomerID","CustomerID");
    ds.EnforceConstraints = false;
    XmlDataDocument xmlDataDoc = new XmlDataDocument(ds);
    xmlDataDoc.Normalize();
    WriteXmlText writer = new WriteXmlText();
    Response.Write(writer.ParseDoc(xmlDataDoc));
}
</script>
