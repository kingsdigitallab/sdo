<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.cch.kcl.ac.uk/xmod/metadata/images/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" />

  <xsl:template match="/">
    <images>
      <xsl:apply-templates />
    </images>
  </xsl:template>

  <xsl:template match="tei:figure">
    <xsl:variable name="title" select="tei:figDesc" />

    <xsl:for-each select="tei:graphic">
      <image height="{@height}" mimeType="{@mimeType}" alt="{$title}" url="{@url}" width="{@width}" type="{@xmt:type}" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="node()">
    <xsl:apply-templates />
  </xsl:template>
</xsl:stylesheet>
