<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 16, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="menutop" select="'true'"/>
    
    <xsl:variable name="xmg:title">
        <xsl:text>Browse Correspondence by Date</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>
    
    <xsl:template name="xms:content">
        <!-- group by year -->
        <xsl:for-each-group select="//str[@name='date']" group-by="substring(.,1,4)">
            
            <ul>
                <li>
                    <a>
                        <xsl:value-of select="current-grouping-key()"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="count(current-group())"/>
                    </a>
                    <!-- group by month -->
                    <xsl:for-each-group select="current-group()" group-by="substring(.,6,2)">
                        
                        <ul>
                            <li>
                                <a>
                                    <xsl:value-of select="current-grouping-key()"/>
                                    <xsl:text>: </xsl:text>
                                    <xsl:value-of select="count(current-group())"/>
                                </a>
                                <ul>
                                    <!-- group by day (usually just one item per day group, but occasionally there are two) -->
                                    <xsl:for-each-group select="current-group()"
                                        group-by="substring(.,9,2)">  <xsl:variable name="myVal"
                                            select="."/> 
                                        <!-- for 'identifier' variable below, because there are sometimes several diary entries on the same day--> 
                                        <!--  we must use subsequence() otherwise we'll sometimes be passing a sequence into --> 
                                        <!-- the substring() function for the 'url' variable, which XSLT won't accept. -->
                                        <xsl:variable name="identifier"
                                            select="subsequence(//doc/child::str[text()=$myVal]/following-sibling::str[@name='uniqueId'],1,1)"/>
                                        <xsl:variable name="url"
                                            select="concat(substring($identifier,7), '/', $myVal)"/>
                                        <li>
                                            <a href="{$url}">
                                                <xsl:value-of select="current-grouping-key()"/>
                                                <xsl:if test="count(current-group()) > 1"><xsl:text> </xsl:text>
                                                    <xsl:value-of select="count(current-group())"
                                                    /><xsl:text> entries</xsl:text></xsl:if>
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
