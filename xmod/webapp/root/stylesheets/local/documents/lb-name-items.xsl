<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- This stylesheet displays a list of the lessonbook records for one pupil, sorted chronologically.
        eg.  Cotta ~ HSchenker
        
        OJ 9/32, [37]: 1918-09-01
        Printed and handwritten letter from Cotta to Schenker, dated September 1, 1918
        Payment advice note for sales 1917.
        
        OJ 12/62, [2] : 1919-09-01T12:00:00
        Stenographically handwritten letter from Cotta to Schenker, dated September 1, 1919
        [NMTP I and II/1:] Cotta encloses sales report for 1918 and a check for M. 346.92.
        
    -->
    
    <xsl:import href="../default.xsl"/>
    
    <xsl:param name="menutop" select="'true'"/>
    
    <xsl:param name="pupil"/>
    
    <xsl:variable name="xmg:title">
        <xsl:text>Browse Lessonbooks By Pupil</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>
    
    <xsl:template name="xms:content">
        <h2><xsl:value-of select="$pupil"></xsl:value-of></h2>
        <ul>
            
            <xsl:for-each select="/aggregation/response/result/doc">
                <!-- <xsl:sort select="child::str[@name='date']"/> -->
                <xsl:variable name="filename" select="child::str[@name='fileId']"/>
                <xsl:variable name="recordId" select="child::str[@name='recordId']"/>
                <li>
                    <h2>
                        <a href="{concat('../', $pupil, '/', $filename, '/', $recordId)}"><xsl:value-of
                            select="child::str[@name='shelfmark']"/>
                            <xsl:text> : </xsl:text>
                            <xsl:value-of select="child::str[@name='dateShort']"/></a>
                    </h2>
                    <p>
                        <xsl:value-of select="child::str[@name='title']"/>
                        <br/>
                        <xsl:value-of select="child::str[@name='description']"/>
                    </p>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
</xsl:stylesheet>