<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" />

  <xsl:param name="properties" />
  <xsl:param name="menu" />
  <xsl:param name="files" />
  <xsl:param name="images" />
  <xsl:param name="sourcedir" />
  <xsl:param name="filedir" />
  <xsl:param name="filename" />

  <xsl:template match="/">
    <aggregation xmlns:xi="http://www.w3.org/2001/XInclude">
      <xi:include href="{$properties}" />
      <xi:include href="{$menu}" />
      <xi:include href="{$files}" />
      <!--<xi:include href="{$images}" />-->
      <xi:include href="{$sourcedir}/{$filedir}/{$filename}" />
    </aggregation>
  </xsl:template>
</xsl:stylesheet>
