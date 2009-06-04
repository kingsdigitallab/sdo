<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" />

  <xsl:template match="/">
    <files>
      <xsl:apply-templates />
    </files>
  </xsl:template>

  <xsl:template match="fileset">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="file">
    <file xml:id="{tei:TEI/@xml:id}" path="{replace(@path, '.xml', '.html')}"
      title="{tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]}" />
  </xsl:template>
</xsl:stylesheet>
