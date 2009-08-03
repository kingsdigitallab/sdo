<?xml version="1.0" encoding="UTF-8"?>
<!--
  Displays the navigation menu.
  
  $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="xmm:menu-top">
    <div>
      <ul>
        <xsl:for-each select="//xmm:root/xmm:menu">
          <xsl:call-template name="xmm:menu-item">
            <xsl:with-param name="output-sub-items" select="false()" />
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
  
  <xsl:template name="xmm:menu-top-sub">
    <xsl:for-each select="//xmm:root/xmm:menu">
      <xsl:choose>
        <xsl:when test="@root = $xmg:pathroot">
          <xsl:call-template name="xmm:format-top-sub" />
        </xsl:when>
        <xsl:when test="@root and starts-with($xmg:pathroot, @root) = true()">
          <xsl:call-template name="xmm:format-top-sub" />
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="xmm:format-top-sub">
    <div class="nvl">
      <h5>
        <xsl:value-of select="@label" />
      </h5>
      <ul>
        <xsl:apply-templates />
      </ul>
    </div>
  </xsl:template>
</xsl:stylesheet>
