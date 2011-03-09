<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="*"
                version="2.0"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="document-to-html.xsl"/>

  <xsl:param name="date"/>

  <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[substring(.//dcterms:created, 1, 10) = $date]"/>

  <xsl:template name="browsing-nav">
    <!-- Diaries may be browsed only by date. -->
    <xsl:param name="current-item"/>
    <ul>
      <xsl:apply-templates select="$current-item[str[@name='dateShort']=$date]"
                           mode="browse-by-date"/>
    </ul>
  </xsl:template>

  <xsl:template name="browse-for-type">
    <xsl:param name="type"/>
    <xsl:param name="previous"/>
    <xsl:param name="next"/>
    <li>
      <xsl:value-of select="$type"/>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="$previous">
          <a href="{$previous/str[@name='dateShort']}.html">Previous</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Previous</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> and </xsl:text>
      <xsl:choose>
        <xsl:when test="$next">
          <a href="{$next/str[@name='dateShort']}.html">Next</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Next</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

</xsl:stylesheet>


