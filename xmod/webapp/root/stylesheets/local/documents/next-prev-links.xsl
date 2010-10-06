<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 27, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p><xd:b>Input:</xd:b> Solr's response to the query
                "?q=date%3A*&amp;fq=kind%3Adiary&amp;rows=5000&amp;fl=date,uniqueId&amp;indent=on"</xd:p>
            <xd:p>
                <xd:b>Output: an XML file to be aggregated into the transformation that displays a
                    diary entry. This file gives elements that contain information needed to create
                    the 'next' and 'prev' links.</xd:b>
            </xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:param name="date"/>

    <xsl:template match="//str[@name = 'date'][. = $date]">
        <nextprev>
            <prevDate>
                <xsl:choose>
                    <xsl:when
                        test=". != parent::doc/preceding-sibling::doc[1]/child::str[@name = 'date']">
                        <xsl:value-of
                            select="parent::doc/preceding-sibling::doc[1]/child::str[@name= 'date']"
                        /><xsl:text>Poppins</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="parent::doc/preceding-sibling::doc[2]/child::str[@name= 'date']"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </prevDate>

            <prevFile>
                <xsl:choose>
                    <xsl:when
                        test=". != parent::doc/preceding-sibling::doc[1]/child::str[@name = 'date']">
                        <xsl:value-of
                            select="substring(parent::doc/preceding-sibling::doc[1]/child::str[@name='uniqueId'], 7)"
                        /><xsl:text>Mary</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="substring(parent::doc/preceding-sibling::doc[2]/child::str[@name='uniqueId'], 7)"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </prevFile>

            <nextDate>
                <xsl:choose>
                    <xsl:when
                        test=". != parent::doc/following-sibling::doc[1]/child::str[@name = 'date']">
                        <xsl:value-of
                            select="parent::doc/following-sibling::doc[1]/child::str[@name= 'date']"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="parent::doc/following-sibling::doc[2]/child::str[@name= 'date']"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </nextDate>

            <nextFile>
                <xsl:choose>
                    <xsl:when
                        test=". != parent::doc/following-sibling::doc[1]/child::str[@name = 'date']">
                        <xsl:value-of
                            select="substring(parent::doc/following-sibling::doc[1]/child::str[@name='uniqueId'], 7)"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="substring(parent::doc/following-sibling::doc[2]/child::str[@name='uniqueId'], 7)"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </nextFile>
        </nextprev>
    </xsl:template>

</xsl:stylesheet>
