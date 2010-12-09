<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">

    <xsl:import href="../default.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 17 November, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p><xd:b>Input:</xd:b> Solr's response to the query
                "q=type%3A*&amp;fq=kind%3Acorrespondence&amp;rows=5000&amp;fl=type,uniqueId,tag&amp;indent=on"</xd:p>
            <xd:p><xd:b>Output:</xd:b> display of categories (letter, telegraph, etc.) for which
                there are correspondence items</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:variable name="xmg:title">
        <xsl:text>Browse Correspondence by Category</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>

    <xsl:template name="xms:content">
        <!-- group by type -->
            <xsl:for-each-group select="/aggregation/response/result/doc/str[@name='type']" group-by=".">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:variable name="url" select="concat('../correspondence/categories/summary/', current-grouping-key())"/>
            <ul>
                <a href="{$url}">
                    <xsl:value-of select="replace(current-grouping-key(), '_', ' ')"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="count(current-group())"/>
                    <xsl:choose>
                        <xsl:when test="count(current-group()) > 1">
                            <xsl:text> items</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> item</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </ul>

        </xsl:for-each-group>

    </xsl:template>

</xsl:stylesheet>
