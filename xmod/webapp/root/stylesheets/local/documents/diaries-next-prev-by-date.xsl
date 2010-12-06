<xsl:stylesheet version="2.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Sep 27, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
      <xd:p><xd:b>Input:</xd:b> Solr's response to the query
        "?q=date%3A*&amp;fq=kind%3Adiary&amp;rows=5000&amp;fl=date,uniqueId&amp;indent=on"</xd:p>
      <xd:p>
        <xd:b>Output: an XML file to be aggregated into the transformation that displays a diary
          entry. This file gives elements that contain information needed to create the 'next' and
          'prev' links. Nb! we do not currently make allowance for multiple entries on the same day,
          instead we simply choose the first different date forwards or backwards; if there are
          multiple entries for one day, we display them together. PC 26/11/2010</xd:b>
      </xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:param name="date"/>
  <!-- will be in form yyyy-mm-dd -->
  <xsl:param name="file"/>

  <xsl:template match="/">
    <nextprev>
      <xsl:for-each select="//doc">
        <xsl:choose>
          <!-- test to match the //doc immediately preceding the first //doc with the passed-in date -->
          <xsl:when test="child::str[@name = 'date'][. != $date] and following-sibling::doc[1]/child::str[@name = 'date'][. = $date]">
            <xsl:call-template name="prev"/>
          </xsl:when>
          <!-- test to match the last //doc with the passed-in date -->
          <xsl:when test="child::str[@name = 'date'][. = $date] and last()">
            <xsl:call-template name="next"/>
          </xsl:when>
          <xsl:otherwise><!-- do nothing --></xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </nextprev>
  </xsl:template>

  <xsl:template name="prev">
    <xsl:variable name="prevDate" select="child::str[@name = 'date']"/>
    <xsl:variable name="prevFile" select="child::str[@name = 'fileId']"/>

    <prevLink>
      <xsl:choose>
        <xsl:when test="string($prevFile) = ''">
          <xsl:text>NULL</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('../', $prevDate, '/', $prevFile)"/>
        </xsl:otherwise>
      </xsl:choose>
    </prevLink>
  </xsl:template>

  <xsl:template name="next">
    <xsl:variable name="nextDate" select="following-sibling::doc[1]/child::str[@name = 'date']"/>
    <xsl:variable name="nextFile" select="following-sibling::doc[1]/child::str[@name = 'fileId']"/>

    <nextLink>
      <xsl:choose>
        <xsl:when test="string($nextFile) = ''">
          <xsl:text>NULL</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('../', $nextDate, '/', $nextFile)"/>
        </xsl:otherwise>
      </xsl:choose>
    </nextLink>
  </xsl:template>



</xsl:stylesheet>
