<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 19, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p />
    </xd:desc>
  </xd:doc>

  <xsl:param name="data-server" />
  <xsl:param name="document-url" />

  <xsl:template match="/">
    <xsl:variable name="mfid" select="/sdo:recordCollection/sdo:collectionDesc/sdo:source/sdo:correspondence/@mfID" />
    
    <xsl:if test="$mfid">
      <xi:include href="{$data-server}{$document-url}{$mfid}" />
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
