<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:egxml="http://www.tei-c.org/ns/Examples" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl" />

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />

  <xsl:include href="../tei/p5.xsl" />
  
  <xsl:variable name="xmg:title" select="//tei:titleStmt/tei:title[not(@type)]" />
  <xsl:variable name="xmg:pathroot" select="$filedir" />
  <xsl:variable name="xmg:path" select="concat($filedir, '/', substring-before($filename, '.'), '.', $fileextension)" />

  <xsl:template match="/">
    <xsl:apply-imports />
  </xsl:template>
  
  <xsl:template name="xms:content">
    <xsl:apply-templates select="//tei:TEI" />
  </xsl:template>
</xsl:stylesheet>
