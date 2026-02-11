<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/">
	    <html>	
		    <body>
		        <xsl:apply-templates />
		    </body>
	     </html>
	</xsl:template>
	<xsl:template match="golfers">
	    <b>Golfer Names:</b>
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="golfer">
		<br />
		<xsl:number format="1" />.		
		<xsl:value-of select="name/firstName" />
	</xsl:template>
</xsl:stylesheet>