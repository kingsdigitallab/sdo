<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl" />

  <xsl:variable name="xmg:title" select="'Browse Lessonbooks by Saison'" />

  <xsl:template name="xms:content">
    <ul>
      <!-- Group by year. -->
      <xsl:for-each-group group-by="." select="/aggregation/response/result/doc/str[@name='dateYear']">
        <xsl:sort select="current-grouping-key()" />

        <xsl:variable name="saison">
          <xsl:value-of select="xs:integer(current-grouping-key()) - 1" />
          <xsl:text>-</xsl:text>
          <xsl:value-of select="current-grouping-key()" />
        </xsl:variable>

        <li>
          <a href="pupil/{$saison}.html">
            <xsl:text>Saison </xsl:text>
            <xsl:value-of select="substring-before($saison, '-')" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="substring-after($saison, '-19')" />
          </a>
        </li>
      </xsl:for-each-group>
    </ul>
  </xsl:template>
</xsl:stylesheet>
