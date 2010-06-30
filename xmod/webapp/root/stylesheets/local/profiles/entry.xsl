<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:egxml="http://www.tei-c.org/ns/Examples" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"  
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl" />
  
  <!-- override the 'false' value of $menutop from ../default.xsl -->
  <xsl:param name="menutop" select="'true'" />

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />

  <xsl:include href="../../xmod/tei/p5.xsl" />
  <xsl:include href="../sdo-p5.xsl" />
  <xsl:include href="../overrides.xsl" />
  
  <xsl:variable name="xmg:title" select="//tei:titleStmt/tei:title[@type = 'file']" />
  <xsl:variable name="xmg:pathroot" select="$filedir" />
  <xsl:variable name="xmg:path" select="concat($filedir, '/', substring-before($filename, '.'), '.', $fileextension)" />

  <xsl:template match="/">
    <xsl:apply-imports />
  </xsl:template>
  
  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
        </h1>
        
        <xsl:if test="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']">
          <h2>
            <xsl:apply-templates mode="pagehead"
              select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']" />
          </h2>
        </xsl:if>
        
        <xsl:if
          test="not(normalize-space(//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author) = '') or not(normalize-space(//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor) = '')">
          <p>
            <xsl:text>(</xsl:text>
            <xsl:apply-templates mode="pagehead"
              select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/*[self::tei:author or self::tei:editor]" />
            <xsl:text>)</xsl:text>
          </p>
        </xsl:if>
      </div>
    </div>
  </xsl:template>
  
  
  <xsl:template name="xms:content">
    <xsl:apply-templates select="//tei:TEI" />
  </xsl:template>
  
  <xsl:template name="xms:toc1"/>
</xsl:stylesheet>
