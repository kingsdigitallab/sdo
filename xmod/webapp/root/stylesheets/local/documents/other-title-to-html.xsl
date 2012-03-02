<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl" />

  <xsl:variable name="xmg:title">
    <xsl:text>Browse Other by Title</xsl:text>
  </xsl:variable>

  <xsl:template name="xms:content">

    
    <xsl:for-each select="/aggregation/response/result/doc/str[@name='title']">
      <ul>
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:text>../../documents/other/</xsl:text>
              <xsl:value-of select="parent::doc/str[@name='fileId']" />
              <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="." />
          </a>
        </li>
      </ul>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
