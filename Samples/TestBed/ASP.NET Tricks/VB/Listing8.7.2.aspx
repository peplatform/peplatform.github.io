<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Xml" %>
<script language="VB" runat="server">
    public class XmlDocumentTestVB
        Dim output as StringBuilder = new StringBuilder()
        Dim indent as integer = 1
		
        public function ParseDoc(xmlFilePath as string) as string
            Dim xmlReader as XmlTextReader

            try 
                xmlReader = new XmlTextReader(xmlFilePath)
                Dim xmlDoc as XmlDocument = new XmlDocument()
                xmlDoc.Load(xmlReader)
                Dim oNode as XmlNode = xmlDoc.DocumentElement

                Call WriteNodeName(oNode,0)
                Dim oNodeList as XmlNodeList = oNode.ChildNodes 
                Dim node as XmlNode     
		    Dim oCurrentNode as XmlNode
	          for each node in oNodeList
                    oCurrentNode = node			 
                    if (oCurrentNode.HasChildNodes) then
                        WriteNodeName(oCurrentNode,indent)
                        WalkTheTree(oCurrentNode)
                        indent = indent - 1
                    else
                        WriteNodeName(oCurrentNode,indent)
                    end if
                next
            
            catch exp as Exception
                output.Append(exp.ToString())
            finally 
                if (NOT xmlReader Is Nothing) then
                    xmlReader.Close()
                end if
            end try
            return output.ToString()
        end function
		
        private sub WalkTheTree(oNodeToWalk as XmlNode)
            indent = indent + 1
            Dim j as integer
            Dim oNodeList as XmlNodeList = oNodeToWalk.ChildNodes
            Dim oCurrentNode as XmlNode
            for j=0 to oNodeList.Count -1
                oCurrentNode = oNodeList(j)
                if (oCurrentNode.HasChildNodes) then
                    Call WriteNodeName(oCurrentNode,indent)
                    Call WalkTheTree(oCurrentNode)
                    indent = indent - 1
                else
                    Call WriteNodeName(oCurrentNode,indent)
                end if
            next
        end sub
	    
        private sub WriteNodeName(node as XmlNode,iIndent as integer) 
            Dim h as integer= 0
            Dim k as integer
            for k=0 to (iIndent * 10)
                output.Append("&nbsp;")
            next
            if (node.NodeType = XmlNodeType.Text) then ' Text node
                output.Append("<font color='#ff0000'>" & node.Value & _ 
                              "</font><br>")
            else
                if (node.Attributes.Count > 0) then
                    Dim oNamedNodeMap as XmlNamedNodeMap = node.Attributes 
                    output.Append("<b>" & node.Name & "</b> (")
                    Dim att as XmlAttribute 
                    for each att in oNamedNodeMap
                        if (h<>0) then output.Append("&nbsp;&nbsp;")
                            h = h + 1
                            output.Append("<i>" & att.Name & "</i>=""" & _ 
                                          att.Value & """")
                    next    
                    output.Append(")<br>")
                else
                    output.Append("<b>" & node.Name & "</b><br>")
                end if
            end if ' end if
        end sub ' WriteNodeName
    end class 
        
    public sub Page_Load(sender as Object, e as EventArgs) 
        Dim xmlFilePath as string = Server.MapPath("golfers.xml")
        Dim xmlDocument as XmlDocumentTestVB = new XmlDocumentTestVB()
        xml.InnerHtml = xmlDocument.ParseDoc(xmlFilePath)
    end sub
</script>
<html>
	<body>
		<font size="5" color="#02027a">Working with XML Objects</font>
		<p />
		<div id="xml" runat="server" />
	</body>
</html>
