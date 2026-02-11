<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/">
    <div align="left">
            <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="DocumentElement">    
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="Customers">
     <div onClick="showDetails('{./CustomerID}')">
        <br/>
        <span style="background: #02027a;width: 500px;cursor: hand;">
	    <table width="100%">
	        <tr>
		    <td width="90%" style="color:#ffffff;font-weight:bold">Customer Name: 
		         <xsl:value-of select="./ContactName"/>
		    </td>
		    <td>
		       <img src="yellow_arrow_down2.gif"/>
		    </td>
	         </tr>
	     </table>
         </span>
      </div>
      <div style="width: 500px;display:none;background:#efefef" id="{./CustomerID}">
         <br/>
          <xsl:for-each select="Orders">
             <b>Order#: </b><xsl:value-of select="./OrderID"/>&#xa0;&#xa0;
             <b>Shipping Address: </b><xsl:value-of select="./ShipAddress"/>
             <br/>
          </xsl:for-each>
      </div>

</xsl:template>

</xsl:stylesheet>