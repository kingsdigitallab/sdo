<xsl:stylesheet version="2.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 01 December, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p><xd:b>Input:</xd:b> Solr's response to the query
                "?q=date%3A*&amp;fq=kind%3Acorrespondence&amp;rows=5000&amp;fl=date,uniqueId&amp;indent=on"</xd:p>
            <xd:p>
                <xd:b>Output: an XML file to be aggregated into the transformation that displays an
                    item of correspondence. This file gives elements that contain information needed
                    to create the 'next' and 'prev' links. Nb! we do not currently make allowance
                    for multiple items on the same day, instead we simply choose the first different
                    date forwards or backwards; if there are multiple items for one day, we display
                    them together. PC 01/12/2010</xd:b>
            </xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:param name="file"/>
    <xsl:param name="tag"/>

    <xsl:template match="/">
        <nextprev>
            <xsl:for-each select="//doc">
                <xsl:variable name="filename" select="child::str[@name='fileId']"/>
                <xsl:choose>
                    <xsl:when test="$filename = $file">

                        <xsl:variable name="prevFile"
                            select="preceding-sibling::doc[1]/child::str[@name = 'fileId']"/>

                        <prevLink>
                            <xsl:choose>
                                <xsl:when test="string($prevFile) = ''">
                                    <xsl:text>NULL</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat('../', $tag, '/', $prevFile)"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </prevLink>

                        <xsl:variable name="nextFile"
                            select="following-sibling::doc[1]/child::str[@name = 'fileId']"/>

                        <nextLink>
                            <xsl:choose>
                                <xsl:when test="string($nextFile) = ''">
                                    <xsl:text>NULL</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat('../', $tag, '/', $nextFile)"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </nextLink>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </nextprev>
    </xsl:template>
</xsl:stylesheet>
