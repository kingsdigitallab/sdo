<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">

    <xsl:import href="../default.xsl"/>
    <xsl:import href="dates-list-template.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 17 November, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p><xd:b>Input:</xd:b> Solr's response to the query **PUT CORRECT QUERY HERE**</xd:p>
            <xd:p><xd:b>Output:</xd:b> display of years, months, and days for which there are
                correspondence items and/or diary entries</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:variable name="xmg:title">
        <xsl:text>Browse Correspondence and Diaries by Date</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>

    <xsl:template name="xms:content">
        <xsl:call-template name="make-dates-list">
            <xsl:with-param name="pattern" select="cd"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
