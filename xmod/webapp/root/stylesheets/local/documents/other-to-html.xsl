<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="document-to-html.xsl" />

  <xsl:template name="browsing-nav">
    <!-- Other items may be browsed only by date. -->
    <xsl:param name="current-item" />
    <ul>
      <xsl:apply-templates mode="browse-by-date" select="$current-item" />
    </ul>
  </xsl:template>

</xsl:stylesheet>
