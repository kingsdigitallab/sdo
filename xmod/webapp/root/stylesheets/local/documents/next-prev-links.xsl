<xsl:stylesheet version="2.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Sep 27, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
      <xd:p><xd:b>Input:</xd:b> Solr's response to the query
        "?q=date%3A*&amp;fq=kind%3Adiary&amp;rows=5000&amp;fl=date,uniqueId&amp;indent=on"</xd:p>
      <xd:p>
        <xd:b>Output: an XML file to be aggregated into the transformation that displays a diary entry. This file gives
          elements that contain information needed to create the 'next' and 'prev' links.</xd:b>
      </xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:param name="date" />

  <xsl:template match="//doc[str[@name = 'date'][. = $date]]">
    <nextprev>
      <xsl:choose>
        <xsl:when test="preceding-sibling::doc[1]/str[@name = 'date'] != str[@name = 'date']">
          <prevDate>
            <xsl:value-of select="preceding-sibling::doc[1]/str[@name = 'date']" />
          </prevDate>
          <prevFile>
            <xsl:value-of select="substring(preceding-sibling::doc[1]/str[@name = 'uniqueId'], 7)" />
          </prevFile>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="preceding-sibling::doc[2]">
            <prevDate>
              <xsl:value-of select="preceding-sibling::doc[2]/str[@name = 'date']" />
            </prevDate>
            <prevFile>
              <xsl:value-of select="substring(preceding-sibling::doc[2]/str[@name = 'uniqueId'], 7)" />
            </prevFile>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="following-sibling::doc[1]/child::str[@name = 'date'] = str[@name = 'date']">
          <nextDate>
            <xsl:value-of select="following-sibling::doc[1]/child::str[@name = 'date']" />
          </nextDate>
          <nextFile>
            <xsl:value-of select="substring(following-sibling::doc[1]/child::str[@name = 'uniqueId'], 7)" />
          </nextFile>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="following-sibling::doc[2]">
            <nextDate>
              <xsl:value-of select="following-sibling::doc[2]/child::str[@name= 'date']" />
            </nextDate>
            <nextFile>
              <xsl:value-of select="substring(following-sibling::doc[2]/child::str[@name = 'uniqueId'], 7)" />
            </nextFile>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </nextprev>
  </xsl:template>
</xsl:stylesheet>
