<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes" encoding="utf-8" omit-xml-declaration="no"/>
	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>
	<xsl:template match="row">
		<row>
			<xsl:attribute name="id"><xsl:value-of select="id"/></xsl:attribute>
			<xsl:attribute name="fname"><xsl:value-of select="name/fname"/></xsl:attribute>
			<xsl:attribute name="lname"><xsl:value-of select="name/lname"/></xsl:attribute>
			<xsl:for-each select="address">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</row>
	</xsl:template>
</xsl:stylesheet>
