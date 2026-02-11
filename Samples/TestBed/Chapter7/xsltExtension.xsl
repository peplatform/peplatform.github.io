<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dateTimeObj="urn:xsltExtension-DateTime" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:param name="golferName" select="'Dan'"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//golfer[name/firstName=$golferName]"/>
	</xsl:template>
	<xsl:template match="golfers">
		<xsl:apply-templates select="golfer"/>
	</xsl:template>
	<xsl:template match="golfer">
		<table class="borders" border="0" width="640" cellpadding="4" cellspacing="0" bgcolor="#efefef">
			<xsl:apply-templates select="name"/>
			<tr class="blackText">
				<td width="12%" align="left">
					<b>Skill: </b>
				</td>
				<td width="12%" align="left">
					<xsl:attribute name="style"><xsl:choose><xsl:when test="@skill='excellent'">
                                 color:#ff0000;font-weight:bold;
                            </xsl:when><xsl:when test="@skill='moderate'">
                               color:#005300;
                            </xsl:when><xsl:when test="@skill='poor'">
                                 color:#000000;
                            </xsl:when><xsl:otherwise>
                                color:#000000;
                             </xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:value-of select="@skill"/>
				</td>
				<td width="12%" align="left">
					<b>Handicap: </b>
				</td>
				<td width="12%" align="left">
					<xsl:value-of select="@handicap"/>
				</td>
				<td width="12%" align="left">
					<b>Clubs: </b>
				</td>
				<td width="40%" align="left">
					<xsl:value-of select="@clubs"/>
				</td>
			</tr>
			<tr>
				<td colspan="6">&#xa0;</td>
			</tr>
			<tr class="blackText">
				<td colspan="6" class="largeBlackText">Favorite Courses </td>
			</tr>
			<tr>
				<td colspan="2">
					<b>City: </b>
				</td>
				<td colspan="2">
					<b>State: </b>
				</td>
				<td colspan="2">
					<b>Course: </b>
				</td>
			</tr>
			<xsl:apply-templates select="favoriteCourses"/>
		</table>
		<p/>
		<xsl:value-of select="dateTimeObj:GetDateTime()"/>
	</xsl:template>
	<xsl:template match="name">
		<tr>
			<td colspan="6" class="largeYellowText" bgcolor="#02027a">
				<xsl:value-of select="firstName"/>&#xa0;<xsl:value-of select="lastName"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="favoriteCourses">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="course">
		<xsl:call-template name="writeComment"/>
		<tr class="blackText">
			<td colspan="2" align="left">
				<xsl:value-of select="@city"/>
			</td>
			<td colspan="2" align="left">
				<xsl:value-of select="@state"/>
			</td>
			<td colspan="2" align="left">
				<xsl:value-of select="@name"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="writeComment">
		<xsl:comment>List Course Information</xsl:comment>
	</xsl:template>
</xsl:stylesheet>
