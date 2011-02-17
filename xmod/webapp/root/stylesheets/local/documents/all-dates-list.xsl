<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    
    <xsl:import href="../default.xsl"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 17 February, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p>
                <xd:b>Input:</xd:b>
            </xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="menutop" select="'true'"/>    
    <xsl:param name="pattern"/>
    
    <xsl:variable name="heading_string">
        <xsl:choose>
            <xsl:when test="$pattern = 'cd'"><xsl:text>Correspondence and Diaries</xsl:text></xsl:when>
            <xsl:when test="$pattern = 'correspondence'"><xsl:text>Correspondence</xsl:text></xsl:when>
            <xsl:when test="$pattern = 'diaries'"><xsl:text>Diaries</xsl:text></xsl:when>
            <xsl:when test="$pattern = 'lb'"><xsl:text>Lessonbooks</xsl:text></xsl:when><!-- But Nb. no lb browse by date yet -->
            <xsl:when test="$pattern = 'other'"><xsl:text>Other Materials</xsl:text></xsl:when>
        </xsl:choose>       
    </xsl:variable>
    
    <xsl:variable name="xmg:title" select="concat('Browse ', $heading_string, ' by Date')"/>
    
    <xsl:variable name="root" select="/"/>
    
    
    <xsl:template name="xms:content">
        <div id="side">
            <ul id="acc3" class="accordion">
                <!-- group by year -->
                <xsl:for-each-group select="/aggregation/response/result/doc/str[@name='dateShort']"
                    group-by="substring(.,1,4)">
                    <xsl:sort select="current-grouping-key()"/>
                    
                    
                    <li class="s7">
                        <a>
                            <span>
                                <xsl:value-of select="current-grouping-key()"/>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="count(current-group())"/>
                            </span>
                        </a>
                        <!-- group by month -->
                        <xsl:for-each-group select="current-group()" group-by="substring(.,6,2)">
                            <xsl:sort select="current-grouping-key()"/>
                            
                            <ul>
                                <li class="s7">
                                    <a>
                                        <span>
                                            <xsl:value-of select="current-grouping-key()"/>
                                            <xsl:text>: </xsl:text>
                                            <xsl:value-of select="count(current-group())"/>
                                        </span>
                                    </a>
                                    <ul id="date">
                                        <!-- group by day (sometimes just one item per day group, sometimes more) -->
                                        <xsl:for-each-group select="current-group()"
                                            group-by="substring(.,9,2)"> <xsl:sort
                                                select="current-grouping-key()"/>
                                            <xsl:variable name="myVal" select="."/> 
                                            <!-- for 'identifier' variable below, because there are sometimes several items on the same day--> 
                                            <!--  we must use subsequence() otherwise we'll sometimes be passing a sequence into -->  <!-- the substring() function for the 'url' variable, which XSLT won't accept. -->
                                            <xsl:variable name="identifier"
                                                select="subsequence(//doc/child::str[text()=$myVal]/following-sibling::str[@name='uniqueId'],1,1)"/>
                                            <!-- <xsl:variable name="url"
                                                select="concat(substring($identifier,7), '/', $myVal)"/> -->
                                            <xsl:variable name="url"
                                                select="concat('../', $pattern, '/dates/summary/', $myVal)"/>
                                            <li>
                                                <a href="{$url}">
                                                    <span>
                                                        <xsl:value-of select="current-grouping-key()"/>
                                                        <xsl:if test="count(current-group()) > 1"><xsl:text> </xsl:text>
                                                            <xsl:value-of select="count(current-group())"
                                                            /><xsl:text> items</xsl:text></xsl:if>
                                                    </span>
                                                </a>
                                            </li>
                                        </xsl:for-each-group>
                                        
                                    </ul>
                                </li>
                            </ul>
                            
                        </xsl:for-each-group>
                    </li>
                    
                </xsl:for-each-group>
            </ul>
            
        </div>
    </xsl:template>
    
</xsl:stylesheet>