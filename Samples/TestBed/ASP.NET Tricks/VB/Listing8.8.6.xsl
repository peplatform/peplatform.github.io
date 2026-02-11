<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes" />
	<xsl:param name="golferLastName" />
	<xsl:template match="/">
		<html>
			<body>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="golfers">
		<b>Golfer Information:</b>
		<br />
		<b>Name:</b>
		<xsl:value-of select="golfer[name/lastName=$golferLastName]/name/firstName" />
		&#xa0;<xsl:value-of select="golfer[name/lastName=$golferLastName]/name/lastName" />
	</xsl:template>
</xsl:stylesheet>