<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:variable name="xmg:title">
    <xsl:text>Browse Correspondence by Item Type</xsl:text>
  </xsl:variable>

  <xsl:template name="xms:content">
    <!-- Group by item type. -->
    <xsl:for-each-group select="/aggregation/response/result/doc/str[@name='type']" group-by=".">
      <xsl:sort select="current-grouping-key()"/>
      <ul>
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:text>../../profiles/correspondence-types/</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="replace(current-grouping-key(), '_', ' ')"/>
          </a>
          <xsl:call-template name="add-item-count"/>
        </li>
      </ul>
    </xsl:for-each-group>
  </xsl:template>
            
  <xsl:template name="add-item-count">
    <xsl:text>: </xsl:text>
    <xsl:value-of select="count(current-group())"/>
    <xsl:text> item</xsl:text>
    <xsl:if test="count(current-group()) &gt; 1">
      <xsl:text>s</xsl:text>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>