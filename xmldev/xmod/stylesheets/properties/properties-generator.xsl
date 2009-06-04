<?xml version="1.0" encoding="UTF-8"?>
<!--
  Creates variables for the properties defined in the properties.xml file. 
  
  $Id$
-->
<xsl:stylesheet xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="#all"
      version="2.0">
  <xsl:output method="xml" indent="yes" />
  
  <xsl:template match="//xmp:properties">
    <xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
      <xsl:attribute name="exclude-result-prefixes">#all</xsl:attribute>
      <xsl:attribute name="version">2.0</xsl:attribute>
      <xsl:namespace name="xmp">http://www.cch.kcl.ac.uk/xmod/properties/1.0</xsl:namespace>
      <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>
      
      <xsl:for-each select="xmp:property">
        <xsl:element name="xsl:variable">
          <xsl:attribute name="name">
            <xsl:text>xmp:</xsl:text>
            <xsl:value-of select="@name" />
          </xsl:attribute>
          <xsl:attribute name="select">
            <xsl:text>'</xsl:text>
            <xsl:value-of select="@value" />
            <xsl:text>'</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
