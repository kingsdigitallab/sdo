<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    
    <xsl:import href="../default.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 27, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:param name="filedir"/>
    <xsl:param name="filename"/>
    <xsl:param name="fileextension"/>

    <xsl:variable name="xmg:title">
        <xsl:text>Browse Diaries by Date</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>

    <xsl:template name="xms:content">

            <xsl:for-each select="//doc">
                <xsl:variable name="file" select="concat(child::str[@name='id'], '.html')"></xsl:variable>
                <h3>
                    <a href="{$file}"><xsl:value-of select="child::arr[@name='date']/child::str[1]"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="child::arr[@name='date']/child::str[position()=last()]"/></a>
                </h3>
            </xsl:for-each>
        
    </xsl:template>

</xsl:stylesheet>
