<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  
  <xsl:import href="default.xsl" />

  <xsl:variable name="xmg:title" select=".//tei:TEI/tei:text/tei:body/tei:div/tei:head" />

  <xsl:template name="xms:content">
    <xsl:apply-templates select=".//tei:TEI/tei:text/tei:body/tei:div/tei:p" />
  </xsl:template>

</xsl:stylesheet>
