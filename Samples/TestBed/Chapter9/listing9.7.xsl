<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="/">
    <div>
        <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="Northwind">    
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="Customers">
  <table bgcolor="efefef" cellpadding="5" width="400">
    <tr>
        <td><font size="5"><b><xsl:value-of select="@ContactName"/></b></font></td>
        <td><b>Contact Name:</b> <xsl:value-of select="@CustomerID"/></td>
    </tr>
    <xsl:for-each select="Orders">
        <tr>
            <td colspan="2"><b>OrderID: </b><xsl:value-of select="@OrderID"/></td>
        </tr>
    </xsl:for-each>
  </table>
  <p>&#xa0;</p>
</xsl:template>

</xsl:stylesheet>