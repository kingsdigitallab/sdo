<?xml version="1.0"?>
<!--  $Id$ -->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- This file overrides TEI P5 templates -->
  
  
  <xsl:template match="tei:lb">
    <br/>
  </xsl:template>
  
  <xsl:template match="tei:author">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:title">
    
    <xsl:choose>
      <xsl:when test="@level = 'j' or level='m'">
        <em>
            <xsl:apply-templates/>
        </em>
     </xsl:when>
    <xsl:when test="@level ='a'">
      <xsl:text>"</xsl:text><xsl:apply-templates/><xsl:text>"</xsl:text>
    </xsl:when>
    <xsl:when test="@level ='s'">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <em>
        <xsl:apply-templates/>
      </em>
    </xsl:otherwise>  
   </xsl:choose>
        
  </xsl:template>
  
</xsl:stylesheet>
