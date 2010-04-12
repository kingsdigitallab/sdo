<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" />
  
  <xsl:param name="fileset" />
  
  <xsl:template match="/">
    <fileset xmlns:xi="http://www.w3.org/2001/XInclude">
      <xsl:for-each select="tokenize($fileset, ':')[not(contains(., '_xinclude.xml'))]">
        <file path="{normalize-space(.)}">
          <xi:include href="{normalize-space(.)}" />
        </file>
      </xsl:for-each>
    </fileset>
  </xsl:template>
</xsl:stylesheet>
