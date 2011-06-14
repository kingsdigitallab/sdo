<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
                xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Default stylesheet. Defines the templates that are called from
      the views stylesheets.
      
      It should be imported by other project specific stylesheets,
      where the variables/templates should be overriden as
      needed. Project-wide changes should be made here.
  -->

  <xsl:import href="../xmod/views/screen.xsl"/>
  <xsl:import href="sdo-p5.xsl"/> 
  
  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>
  <xsl:param name="menutop" select="'true'"/>

  <xsl:variable name="xmg:title" select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]"/>
  <xsl:variable name="xmg:pathroot" select="concat($xmp:context-path, '/', $filedir)"/>
  <xsl:variable name="xmg:path" select="concat($xmg:pathroot, '/', substring-before($filename, '.'), '.', $fileextension)"/>
  <xsl:variable name="xmg:menu-top">
    <xsl:choose>
      <xsl:when test="$menutop = 'false'">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="xmv:screen"/>
  </xsl:template>
  
  <xsl:template name="xms:content">
    <xsl:apply-templates select="/*/tei:TEI"/>
  </xsl:template>

  <xsl:template name="xms:toc1">
    <xsl:call-template name="xms:toc"/>
  </xsl:template>

  <xsl:template name="xms:toc2">
    <xsl:call-template name="xms:toc"/>
  </xsl:template>

  <xsl:template name="xms:toc">
    <xsl:if test="/*/tei:TEI/tei:text/tei:*/tei:div/tei:head">
      <div class="toc">
        <div class="t01">
          <h3>Document Contents</h3>
          <ul>
            <xsl:for-each select="/*/tei:TEI/tei:text/tei:*/tei:div/tei:head">
              <li>
                <a href="#{generate-id()}">
                  <span>
                    <xsl:apply-templates mode="toc" select="."/>
                  </span>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="xms:submenu"/>

  <xsl:template name="xms:option"/>

  <xsl:template name="xmm:menu-top">
    <div id="pn">
      <ul class="pn1">
        <xsl:for-each select="/*/xmm:root/xmm:menu">
          <xsl:call-template name="xmm:menu-item">
            <xsl:with-param name="output-sub-items" select="false()"/>
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
  
  <xsl:template name="xmm:format-top-sub">
    <div id="sn">
      <h3>
        <xsl:value-of select="@label"/>
      </h3>
      <ul>
        <xsl:apply-templates/>
      </ul>
    </div>
  </xsl:template>
  
  <xsl:template name="xmv:meta">
    <meta content="text/html; charset=utf-8" http-equiv="content-type"/>
    <meta content="xMod 2.1" name="generator"/>
    <meta content="Centre for Computing in the Humanities, King's College London" name="author"/>
    <meta name="copyright">
      <xsl:attribute name="content">
        <xsl:text>Copyright (c) Schenker Documents Online</xsl:text>
        <xsl:value-of select="format-date(current-date(), '[Y]')"/>
      </xsl:attribute>
    </meta>
    <meta name="date" content="{format-date(current-date(), '[D01]-[M01]-[Y0001]')}"/>
    <meta content="index,follow,archive" name="robots"/>
    <meta content="no" http-equiv="imagetoolbar"/>
    <meta content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" name="SKYPE_TOOLBAR"/>
  </xsl:template>
  
  <xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/print.css" media="print" rel="stylesheet" type="text/css"/>
    <link href="{$xmp:assets-path}/c/default.css" media="screen, projection" rel="stylesheet" type="text/css"/>
    <link href="{$xmp:assets-path}/c/personality.css" media="screen, projection" rel="stylesheet" type="text/css"/>
    <xsl:comment>
      <xsl:text>[if lte IE 6]&gt; &lt;link href="</xsl:text>
      <xsl:value-of select="$xmp:assets-path"/>
      <xsl:text>/c/compat_MSIE_6_0_lte.css" rel="stylesheet" type="text/css" /&gt;&lt;![endif]</xsl:text>
    </xsl:comment>
    <xsl:comment>
      <xsl:text>[if IE 7]&gt; &lt;link href="</xsl:text>
      <xsl:value-of select="$xmp:assets-path"/>
      <xsl:text>/c/compat_MSIE_7_0.css" rel="stylesheet" type="text/css" /&gt;&lt;![endif]</xsl:text>
    </xsl:comment>    
    <xsl:comment>
      <xsl:text>[if IE 8]&gt; &lt;link href="</xsl:text>
      <xsl:value-of select="$xmp:assets-path"/>
      <xsl:text>/c/compat_MSIE_8_0.css" rel="stylesheet" type="text/css" /&gt;&lt;![endif]</xsl:text>
    </xsl:comment>     
  </xsl:template>
  
  <xsl:template name="xmv:script">
    <script src="{$xmp:assets-path}/j/jquery-1.5.min.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/jquery.nestedAccordion.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/jquery.ui.tabs.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/jquery.ui.widget.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/config.js" type="text/javascript">&#160;</script>
  </xsl:template>
  
  <xsl:template name="xmv:body">
    <body class="v1 r3 rc0" id="xmd">
      <div id="wrapper">
        <xsl:call-template name="xmv:banner"/>
        
        <table cellpadding="0" cellspacing="0" id="xlt" summary="">
          <tr class="r01">
            <td colspan="2" id="topnav">
              <xsl:if test="$xmg:menu-top = true()">
                <xsl:call-template name="xmm:menu-top"/>
              </xsl:if>
            </td>
          </tr>
          <tr class="r01">
            <td colspan="2" id="breadcrumb">
              <xsl:call-template name="xmm:breadcrumbs"/>
            </td>
          </tr>
          <tr class="r02">
            <td id="sidenav">
              <xsl:choose>
                <xsl:when test="$xmg:menu-top = true()">
                  <xsl:call-template name="xmm:menu-top-sub"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="xmm:menu"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td id="content">
              <xsl:call-template name="xms:rhcontent"/>
              <div id="mainContent">
                <xsl:call-template name="xms:pagehead"/>
                <xsl:call-template name="xms:toc1"/>
                <xsl:call-template name="xms:content"/>
                <xsl:call-template name="xms:footnotes"/>
              </div>
            </td>
          </tr>
        </table>
        <xsl:call-template name="xmv:footer"/>
      </div>
    </body>
  </xsl:template>

  <xsl:template name="xmv:banner">
    <div id="banner">
      <div id="decalRight"><span class="printOnly">Collage: images of Schenker</span></div>
      <div id="decalLeft"><span class="printOnly">Collage: images of Schenker</span></div>
      <!-- Heading can be shown as text or replaced with images -->
      <h1><span>Schenker Documents Online</span></h1>
    </div>
  </xsl:template>

  <xsl:template name="xmv:footer">
    <div id="footer">
      <div class="utilLinks">
        <div class="s01">
          <ul>
            <li>
              <a href="{$xmp:context-path}/editorial_guide/how_to_cite.html">
                <xsl:text>How to Cite</xsl:text>
              </a>
            </li>
            <li>
              <a href="{$xmp:context-path}/editorial_guide/conditions_of_use.html">
                <xsl:text>Conditions of Use</xsl:text>
              </a>
            </li>
            <li>
              <a href="{$xmp:context-path}/help/comment.html">
                <xsl:text>Comments &amp; Queries</xsl:text>
              </a>
            </li>
          </ul>
        </div>
        <div class="s01">
          <ul>
            <xsl:if test="$xmp:metadata-copyright">
              <li>
                <xsl:text>&#xa9;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="format-date(current-date(), '[Y]')"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="$xmp:metadata-copyright"/>
              </li>
            </xsl:if>
            <xsl:if test="$xmp:footer-resp-message">
              <li>
                <xsl:value-of select="$xmp:footer-resp-message"/>
              </li>
            </xsl:if>
            <li class="s01">
              <xsl:text>Powered by </xsl:text>
              <a href="http://www.cch.kcl.ac.uk/xmod/" title="xMod home page">
                <span>xMod</span>
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="xmv:dynamic-links">
    <xsl:param name="linkToLabel"/>
    <xsl:param name="linkToFile"/>

    <a title="{$linkToLabel}">
      <xsl:attribute name="href">
        <xsl:call-template name="xmm:path-resolver"/>
        <xsl:if test="string($xmp:context-path)">
          <xsl:value-of select="$xmp:context-path"/>
          <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:value-of select="$linkToFile"/>
      </xsl:attribute>
      <span>
        <xsl:value-of select="$linkToLabel"/>
      </span>
    </a>
  </xsl:template>

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$xmg:title"/>
        </h1>
        
        <xsl:for-each select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']">
          <xsl:if test="normalize-space()">
            <h2>
              <xsl:apply-templates mode="pagehead" select="."/>
            </h2>
          </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
          <xsl:if test="normalize-space()">
            <p>
              <xsl:text>(</xsl:text>
              <strong>
                <xsl:apply-templates mode="pagehead" select="."/>
              </strong>
              <xsl:text>)</xsl:text>
            </p>
          </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
          <xsl:if test="normalize-space()">
            <p>
              <xsl:text>(</xsl:text>
              <strong>
                <xsl:apply-templates mode="pagehead" select="."/>
              </strong>
              <xsl:text>)</xsl:text>
            </p>
          </xsl:if>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
