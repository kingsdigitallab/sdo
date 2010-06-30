<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.cch.kcl.ac.uk/xmod/metadata/indexes/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" />

  <xsl:template match="/">
    <index>
      <xsl:apply-templates />
    </index>
  </xsl:template>

  <xsl:template match="fileset">
    <xsl:apply-templates select="file[contains(@path,'profiles')]"/>
  </xsl:template>

  <xsl:template match="file">
    <xsl:variable name="fileName">
    <xsl:choose>
     <xsl:when test="contains(@path,'/')"><!--  this is a *ix OS -->
       <xsl:value-of select="replace(tokenize(@path, '/')[last()], '.xml', '.html')"/>
     </xsl:when>
     <xsl:when test="contains(@path,'\')"><!-- this is the *best* designed OS in.the.world.  So clean, so scalable, so in tune with the rest of the planet.  -->
       <xsl:value-of select="replace(tokenize(@path, '\\')[last()], '.xml', '.html')"/>
     </xsl:when> 
      
    </xsl:choose>
      </xsl:variable>
       
     
    <entry xml:id="{tei:TEI/@xml:id}" filename="{$fileName}" index="{lower-case(tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords[@scheme='MT']/tei:term[@subtype='category'])}"
      title="{tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]}" 
      filingTitle="{tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'file']/tei:term}"
      sortkey="{tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'file']/tei:term/@sortKey}" 
      key="{tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords[@scheme='EATS']/tei:term/@key}"/>
  </xsl:template>
</xsl:stylesheet>
