<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="*"
                version="2.0"
                xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="document-to-html.xsl"/>

  <xsl:param name="recordId"/>

  <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[@ID=$recordId]"/>

  <xsl:template name="browsing-nav">
    <!-- Diaries may be browsed only by date. -->
    <xsl:param name="current-item"/>

    <ul>
      <xsl:apply-templates select="$current-item[str[@name='recordId']=$recordId]"
                           mode="browse-by-date"/>
    </ul>
  </xsl:template>

</xsl:stylesheet>
