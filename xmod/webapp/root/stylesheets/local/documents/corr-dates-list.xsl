<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">

    <xsl:import href="../default.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 17 November, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p><xd:b>Input:</xd:b> Solr's response to the query
                "q=date%3A*&amp;fq=kind%3Acorrespondence&amp;rows=5000&amp;fl=date,uniqueId,tag&amp;indent=on"</xd:p>
            <xd:p><xd:b>Output:</xd:b> display of years, months, and days for which there are
                correspondence items</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:variable name="xmg:title">
        <xsl:text>Browse Correspondence by Date</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>

    <xsl:template name="xms:content">
        <!-- group by year -->
        <xsl:for-each-group select="/aggregation/response/result/doc/str[@name='date']"
            group-by="substring(.,1,4)">
            <xsl:sort select="current-grouping-key()"/>

            <ul>
                <li>
                    <a>
                        <xsl:value-of select="current-grouping-key()"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="count(current-group())"/>
                    </a>
                    <!-- group by month -->
                    <xsl:for-each-group select="current-group()" group-by="substring(.,6,2)">
                        <xsl:sort select="current-grouping-key()"/>

                        <ul>
                            <li>
                                <a>
                                    <xsl:value-of select="current-grouping-key()"/>
                                    <xsl:text>: </xsl:text>
                                    <xsl:value-of select="count(current-group())"/>
                                </a>
                                <ul>
                                    <!-- group by day (sometimes just one item per day group, sometimes more) -->
                                    <xsl:for-each-group select="current-group()"
                                        group-by="substring(.,9,2)">  <xsl:sort
                                            select="current-grouping-key()"/>
                                        <xsl:variable name="myVal" select="."/> 
                                        <!-- for 'identifier' variable below, because there are sometimes several items on the same day--> 
                                        <!--  we must use subsequence() otherwise we'll sometimes be passing a sequence into -->  <!-- the substring() function for the 'url' variable, which XSLT won't accept. -->
                                        <xsl:variable name="identifier"
                                            select="subsequence(//doc/child::str[text()=$myVal]/following-sibling::str[@name='uniqueId'],1,1)"/>
                                        <!-- <xsl:variable name="url"
                                            select="concat(substring($identifier,7), '/', $myVal)"/> -->
                                        <xsl:variable name="url"
                                                select="concat($myVal, '.date.html')"/>
                                        <li>
                                            <a href="{$url}">
                                                <xsl:value-of select="current-grouping-key()"/>
                                                <xsl:if test="count(current-group()) > 1"><xsl:text> </xsl:text>
                                                  <xsl:value-of select="count(current-group())"
                                                  /><xsl:text> items</xsl:text></xsl:if>
                                            </a>
                                        </li>
                                    </xsl:for-each-group>

                                </ul>
                            </li>
                        </ul>

                    </xsl:for-each-group>
                </li>
            </ul>

        </xsl:for-each-group>

    </xsl:template>

</xsl:stylesheet>
