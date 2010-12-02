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
    
    <xsl:param name="type"/>
    <xsl:param name="date"/>
    
    <xsl:template match="/response/result/doc[str[@name = 'date'][. = $date]][1]"><!-- match the item currently being displayed -->
        <nextprev>
            
            <xsl:variable name="prevDate"
                select="preceding-sibling::doc[child::str[@name = 'date'] != $date][1]/str[@name = 'date']"/>
            
            <xsl:variable name="prevFile"
                select="substring(preceding-sibling::doc[child::str[@name = 'date'] != $date][1]/str[@name = 'uniqueId'], 7)"/>
            
            <prevLink>
                <xsl:value-of select="concat('../category/', $prevFile, '.', $type, '.', $prevDate)"/>
            </prevLink>
            
            <xsl:variable name="nextDate"
                select="following-sibling::doc[child::str[@name = 'date'] != $date][1]/child::str[@name = 'date'][1]"/>
            
            <xsl:variable name="nextFile"
                select="substring(following-sibling::doc[child::str[@name = 'date'] != $date][1]/child::str[@name = 'uniqueId'], 7)"/>
            
            <nextLink>
                <xsl:value-of select="concat('../category/', $nextFile, '.', $type, '.', $nextDate)"/>
            </nextLink>
            
        </nextprev>
    </xsl:template>
</xsl:stylesheet>
