<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="*"
                version="2.0"
                xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="document-to-html.xsl"/>

  <xsl:param name="recordId"/>

  <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[@ID=$recordId]"/>

  <xsl:template name="browsing-nav">
    <!-- Lessonbooks may be browsed by date and by pupil. -->
    <xsl:param name="current-item"/>

    <xsl:variable name="current-record"
                  select="$current-item[str[@name='recordId']=$recordId]"/>

    <ul>
      <xsl:apply-templates select="$current-record" mode="browse-by-date"/>
      <xsl:apply-templates select="$current-record" mode="browse-by-pupil"/>
    </ul>
  </xsl:template>

  <xsl:template match="doc" mode="browse-by-pupil">
    <xsl:param name="pupil" select="substring-before(str[@name='pupil'], ' ')"/>
    <xsl:call-template name="browse-for-type">
      <xsl:with-param name="type" select="'Pupil'"/>
      <xsl:with-param name="previous" select="preceding-sibling::doc[substring-before(str[@name='pupil'], ' ') = $pupil][1]"/>
      <xsl:with-param name="next" select="following-sibling::doc[substring-before(str[@name='pupil'], ' ') = $pupil][1]"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>

