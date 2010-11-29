<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    
    <xsl:import href="../default.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 27, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p><xd:b>Input:</xd:b> Solr's response to the query
                "?q=date%3A*&amp;fq=kind%3Alessonbook&amp;rows=5000&amp;fl=date,uniqueId&amp;indent=on"</xd:p>
            <xd:p><xd:b>Output:</xd:b> display of years, months, and days for which there are diary
                entry files</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="menutop" select="'true'"/>
    
    <xsl:variable name="xmg:title">
        <xsl:text>Browse Lessonbooks by Date</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>
    
    <xsl:template name="xms:content">
        <!-- group by year
        <xsl:for-each-group select="/aggregation/response/result/doc/str[@name='date']" group-by="substring(.,1,4)"> -->
            <xsl:for-each-group select="/aggregation/response/result/doc/str[@name='fileId']" group-by="substring-after(.,'_')">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:variable name="url" select="concat('lessonbooks/', current-grouping-key())"></xsl:variable>
            
            <ul>
                <li>
                    <a href="{$url}">
                        <xsl:value-of select="current-grouping-key()"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="count(current-group())"/>
                    </a>
                </li>
            </ul>
            
        </xsl:for-each-group>
        
    </xsl:template>
    
</xsl:stylesheet>
