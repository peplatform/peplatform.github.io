<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css">
					.whiteText {font-family:arial;color:#ffffff;}
					.largeYellowText {font-family:arial;font-size:18pt;color:#ffff00;}
					.largeWhiteText {font-family:arial;font-size:14pt;color:#ffffff;}
					.borders {border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;}
				</style>
			</head>
			<body bgcolor="#ffffff">
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="golfers">
	    <xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="golfer">
	    <table class="borders" border="0" width="640" cellpadding="4" cellspacing="0" bgcolor="#009933">
	        <xsl:apply-templates select="name"/>
			<tr class="whiteText">
				<td width="12%" align="left"><b>Skill: </b></td>
				<td width="12%" align="left"><xsl:value-of select="@skill"/></td>
				<td width="12%" align="left"><b>Handicap: </b></td>
				<td width="12%" align="left"><xsl:value-of select="@handicap"/></td>
				<td width="12%" align="left"><b>Clubs: </b></td>
				<td width="40%" align="left"><xsl:value-of select="@clubs"/></td>
			</tr>    
			<tr>
				<td colspan="6">&#xa0;</td>
			</tr>
			<tr class="whiteText">
				<td colspan="6" class="largeWhiteText">Favorite Courses </td>
			</tr>
			<tr>
				<td colspan="2"><b>City: </b></td>
				<td colspan="2"><b>State: </b></td>
				<td colspan="2"><b>Course: </b></td>
			</tr>
			<xsl:apply-templates select="favoriteCourses"/>
	    </table>
	    <p/>
	</xsl:template>
	<xsl:template match="name">
		<tr>
			<td colspan="6" class="largeYellowText">
				<xsl:value-of select="firstName"/>
				<xsl:value-of select="lastName"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="favoriteCourses">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="course">
		<tr class="whiteText">
			<td colspan="2" align="left"><xsl:value-of select="@city"/></td>
			<td colspan="2" align="left"><xsl:value-of select="@state"/></td>
			<td colspan="2" align="left"><xsl:value-of select="@name"/></td>
		</tr>
	</xsl:template>
</xsl:stylesheet>  