<?xml version="1.0" encoding="UTF-8"?>
<!--
  Displays the navigation menu.
  
  $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="menu-top.xsl" />

  <xsl:template name="xmm:menu">
    <xsl:apply-templates select="//xmm:root" />
  </xsl:template>

  <xsl:template match="xmm:root">
    <div id="pn">
      <h3>
        <span>
          <xsl:value-of select="@label" />
        </span>
      </h3>

      <ul class="pn1">
        <xsl:apply-templates />
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="xmm:menu">
    <xsl:call-template name="xmm:menu-item" />
  </xsl:template>

  <xsl:template name="xmm:menu-item">
    <xsl:param name="output-sub-items" select="true()" />

    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="@href">
          <xsl:value-of select="@href" />
        </xsl:when>
        <xsl:when test="child::*[1]/@href">
          <xsl:choose>
            <xsl:when test="child::*[1]/@root">
              <xsl:value-of select="concat(child::*[1]/@root, '/', child::*[1]/@href)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="child::*[1]/@href" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="full-path" select="concat(ancestor-or-self::*[1]/@root, '/', $href)" />
    
    <li>
      <xsl:choose>
        <!-- active item with children -->
        <xsl:when test="child::* and ($href = $xmg:path or ends-with($xmg:path, $full-path) = true())">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'s06'" />
            <xsl:with-param name="last" select="'s08'" />
            <xsl:with-param name="norm" select="'s04'" />
          </xsl:call-template>
        </xsl:when>
        <!-- active item -->
        <xsl:when test="$href = $xmg:path or ends-with($xmg:path, $full-path) = true()">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'s06'" />
            <xsl:with-param name="last" select="'s08'" />
            <xsl:with-param name="norm" select="'s04'" />
          </xsl:call-template>
        </xsl:when>
        <!-- ancestor of active item -->
        <xsl:when test="child::* and (@root = $xmg:pathroot or contains($xmg:pathroot, @root))">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'s06'" />
            <xsl:with-param name="last" select="'s08'" />
            <xsl:with-param name="norm" select="'s04'" />
          </xsl:call-template>
        </xsl:when>
        <!-- inactive item with children -->
        <xsl:when test="child::* and @root != $xmg:pathroot">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'s05'" />
            <xsl:with-param name="last" select="'s07'" />
            <xsl:with-param name="norm" select="'s03'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="xmm:menu-item-class" />
        </xsl:otherwise>
      </xsl:choose>
      
      <a>
        <xsl:choose>
          <xsl:when test="@href = $xmg:path or concat(ancestor-or-self::*[1]/@root, '/', @href) = $xmg:path">
            <xsl:attribute name="class">s1</xsl:attribute>
          </xsl:when>
          <xsl:when test="ends-with($xmg:path, concat(ancestor-or-self::*[1]/@root, '/', @href)) = true()">
            <xsl:attribute name="class">s1</xsl:attribute>
          </xsl:when>
        </xsl:choose>
        
        <xsl:attribute name="href">
          <xsl:call-template name="xmm:path-resolver" />
          <xsl:if test="string($xmp:context-path)">
            <xsl:value-of select="$xmp:context-path" />
            <xsl:text>/</xsl:text>
          </xsl:if>
          <xsl:for-each select="ancestor-or-self::xmm:menu/@root">
            <xsl:value-of select="." />
            <xsl:text>/</xsl:text>
          </xsl:for-each>
          <xsl:value-of select="$href" />
        </xsl:attribute>
        
        <xsl:value-of select="@label" />
      </a>
      
      <xsl:if test="$output-sub-items = true()">
        <xsl:if
          test="child::* and ($href = $xmg:path or @root = $xmg:pathroot or contains($xmg:pathroot, @root) or ends-with($xmg:path, $full-path) = true())">
          <ul class="pn{count(ancestor::xmm:menu) + 2}">
            <xsl:apply-templates />
          </ul>
        </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="xmm:menu-item-class">
    <xsl:param name="first" select="'s01'" />
    <xsl:param name="last" select="'s02'" />
    <xsl:param name="norm" />

    <xsl:variable name="cur-item" select="local-name()" />

    <xsl:choose>
      <xsl:when test="not(preceding-sibling::*[name() = $cur-item])">
        <xsl:attribute name="class">
          <xsl:value-of select="$first" />
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="not(following-sibling::*[name() = $cur-item])">
        <xsl:attribute name="class">
          <xsl:value-of select="$last" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="string($norm)">
          <xsl:attribute name="class">
            <xsl:value-of select="$norm" />
          </xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="xmm:path-resolver">
    <xsl:variable name="path-elements">
      <xsl:choose>
        <xsl:when test="string($xmg:pathroot) and $xmg:pathroot != '.'">
          <xsl:value-of select="count(tokenize($xmg:pathroot, '/'))" />
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:for-each select="1 to $path-elements">
      <xsl:text>../</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="xmm:item">
    <xsl:call-template name="xmm:menu-item" />
  </xsl:template>

  <xsl:template match="xmm:external">
    <li>
      <a class="ext" href="{@href}">
        <xsl:value-of select="@label" />
      </a>
    </li>
  </xsl:template>

  <xsl:template name="xmm:breadcrumbs">
    <div class="s01">
      <ul>
        <li>
          <span class="s01">You are here:</span>
        </li>
        <xsl:choose>
          <xsl:when test="//xmm:root//*[@href = $xmg:path]">
            <xsl:for-each select="//xmm:root//*[@href = $xmg:path]">
              <xsl:for-each select="ancestor::*[name() != 'root']">
                <xsl:call-template name="xmm:breadcrumbs-links" />
              </xsl:for-each>

              <li>
                <span class="s02">
                  <xsl:value-of select="$xmg:title" />
                </span>
              </li>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="//xmm:root//*[@root = $xmg:pathroot]">
            <xsl:for-each select="//xmm:root//*[@root = $xmg:pathroot]">
              <xsl:for-each select="ancestor-or-self::*[name() != 'root']">
                <xsl:call-template name="xmm:breadcrumbs-links" />
              </xsl:for-each>

              <li>
                <span class="s02">
                  <xsl:value-of select="$xmg:title" />
                </span>
              </li>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="//xmm:root//*[string(@root)][ends-with($xmg:pathroot, @root)]">
            <xsl:for-each select="//xmm:root//*[string(@root)][ends-with($xmg:pathroot, @root)]">
              <xsl:for-each select="ancestor-or-self::*[name() != 'root']">
                <xsl:call-template name="xmm:breadcrumbs-links" />
              </xsl:for-each>

              <li>
                <span class="s02">
                  <xsl:value-of select="$xmg:title" />
                </span>
              </li>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="xmm:breadcrumbs-links">
    <li>
      <a title="{@label}">
        <xsl:attribute name="href">
          <xsl:call-template name="xmm:path-resolver" />
          <xsl:if test="string($xmp:context-path)">
            <xsl:value-of select="$xmp:context-path" />
            <xsl:text>/</xsl:text>
          </xsl:if>
          <xsl:for-each select="ancestor-or-self::xmm:menu/@root">
            <xsl:value-of select="." />
            <xsl:text>/</xsl:text>
          </xsl:for-each>
          <xsl:value-of select="@href" />
        </xsl:attribute>

        <span>
          <xsl:value-of select="@label" />
        </span>
      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>
