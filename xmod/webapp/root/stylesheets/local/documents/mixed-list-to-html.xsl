<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl" />

  <xsl:variable name="xmg:title">
    <xsl:text>Browse Mixed Material by Document</xsl:text>
  </xsl:variable>

  <xsl:template name="xms:content">
    <!-- Group by item type. -->
    
    <xsl:choose>
      <xsl:when test="/aggregation/response/result/@numFound = 0">
        <ul>
          <li>No Documents Available.
          </li>
         </ul>
      </xsl:when>
    <xsl:otherwise>
    <xsl:for-each-group group-by="substring-before(., ' ')"
      select="/aggregation/response/result/doc/arr[@name='mixed']/str">
      <xsl:sort select="substring-after(., ' ')" />
      <ul>
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:text>../../documents/mixed/</xsl:text>
              <xsl:value-of select="current-grouping-key()" />
              <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="replace(substring-after(., ' '), '_', ' ~ ')" />
          </a>
        </li>
      </ul>
    </xsl:for-each-group>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
