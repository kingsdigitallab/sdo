<?xml version="1.0" encoding="UTF-8"?>
<!--
  Defines the display structure for a page.
  Calls templates (namespace xms) that are defined in spec/default.xsl.
  
  $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="../menu/menu.xsl" />
  <xsl:include href="../properties/properties.xsl" />
  <xsl:template name="xmv:screen">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <xsl:call-template name="xmv:header" />
    <xsl:call-template name="xmv:body" />
    </html>
  </xsl:template>
  
  <xsl:template name="xmv:header">
    <head>
    <title><xsl:text>Schenker Documents Online</xsl:text>
    <xsl:if test="string($xmg:title)">
      <xsl:text>:</xsl:text><xsl:value-of select="$xmg:title" />
    </xsl:if>
    </title>
    <xsl:call-template name="xmv:meta" />
    <xsl:call-template name="xmv:css" />
    <xsl:call-template name="xmv:script" />
    </head>
  </xsl:template>
  
  <xsl:template name="xmv:meta">
    <meta content="text/html; charset=utf-8" http-equiv="content-type" />
    <meta content="xMod 2.0" name="generator" />
    <meta content="Centre for Computing in the Humanities, King's College London" name="author" />
    <meta>
    <xsl:attribute name="content"><xsl:text>Copyright (c) Schenker Documents Online</xsl:text><xsl:value-of select="format-date(current-date(), '[Y]')" /></xsl:attribute>
    <xsl:attribute name="name"><xsl:text>copyright</xsl:text></xsl:attribute>
    </meta>
    <meta>
    <xsl:attribute name="content"><xsl:value-of select="format-date(current-date(), '[D01]-[M01]-[Y0001]')" /></xsl:attribute>
    <xsl:attribute name="name"><xsl:text>date</xsl:text></xsl:attribute>
    </meta>
    <meta
      content="POPULATE ME"
      name="abstract" />
    <meta
      content="POPULATE ME"
      name="description" />
    <meta
      content="POPULATE ME"
      name="keywords" />
    <meta content="index,follow,archive" name="robots" />
    <meta content="no" http-equiv="imagetoolbar" />
    <meta content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" name="SKYPE_TOOLBAR" />
  </xsl:template>
  
  <xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/print.css" media="print" rel="stylesheet" type="text/css" />
    <link href="{$xmp:assets-path}/c/default.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <link href="{$xmp:assets-path}/c/personality.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <xsl:comment>
      <xsl:text>[if lte IE 6]&gt; &lt;link href="</xsl:text>
      <xsl:value-of select="$xmp:assets-path" />
      <xsl:text>/c/compat_MSIE_6_0_lte.css" rel="stylesheet" type="text/css" /&gt;&lt;![endif]</xsl:text>
    </xsl:comment>
    <xsl:comment>
      <xsl:text>[if IE 7]&gt; &lt;link href="</xsl:text>
      <xsl:value-of select="$xmp:assets-path" />
      <xsl:text>/c/compat_MSIE_7_0.css" rel="stylesheet" type="text/css" /&gt;&lt;![endif]</xsl:text>
    </xsl:comment>    
    <xsl:comment>
      <xsl:text>[if IE 8]&gt; &lt;link href="</xsl:text>
      <xsl:value-of select="$xmp:assets-path" />
      <xsl:text>/c/compat_MSIE_8_0.css" rel="stylesheet" type="text/css" /&gt;&lt;![endif]</xsl:text>
    </xsl:comment>     
  </xsl:template>
  
  <xsl:template name="xmv:script">
    <script src="{$xmp:assets-path}/j/jquery-1.3.2.min.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/config.js" type="text/javascript">&#160;</script>
  </xsl:template>
  
  <xsl:template name="xmv:body">
    <body class="v1 r3 rc0" id="xmd">
    <div id="wrapper">
      <xsl:call-template name="xmv:banner" />
      
      <table cellpadding="0" cellspacing="0" id="xlt" summary="">
        <tr class="r01">
          <td colspan="2" id="topnav"><xsl:call-template name="xmm:menu-top" /></td>
        </tr>
        <tr class="r01">
          <td colspan="2" id="breadcrumb"><xsl:call-template name="xmm:breadcrumbs" />
          </td>
        </tr>
        <tr class="r02">
          <td id="sidenav"><xsl:call-template name="xmm:menu-top-sub" />
          </td>
          <td id="content"><xsl:call-template name="xms:rhcontent" />
            
            <div id="mainContent">
             <!-- <xsl:call-template name="xms:options1" />-->
              
            <!-- <xsl:call-template name="xms:submenu" />-->
              
              <xsl:call-template name="xms:pagehead" />
              
              <xsl:call-template name="xms:toc1" />
              
              <xsl:call-template name="xms:content" />
              
              <xsl:call-template name="xms:footnotes" />
              
<!--  <xsl:call-template name="xms:toc2" />-->
              
<!--  <xsl:call-template name="xms:options2" />-->
              
            </div></td>
        </tr>
      </table>
      <xsl:call-template name="xmv:footer" />
      
    </div>
    </body>
  </xsl:template>
  
  <xsl:template name="xmv:banner">
    <div id="banner">
    <!--  <div class="utilLinks">
        
        <ul>
         
          <li>
            <xsl:call-template name="xmv:dynamic-links">
            <xsl:with-param name="linkToLabel" select="'help'"/>
            <xsl:with-param name="linkToFile" select="'help/contact.html'"/>
          </xsl:call-template></li>
          
        </ul>
        </div>-->
     
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
            <li><xsl:call-template name="xmv:dynamic-links">
              <xsl:with-param name="linkToLabel" select="'How to Cite'"/>
              <xsl:with-param name="linkToFile" select="'editorial_guide/how_to_cite.html'"/>
            </xsl:call-template>
            </li> 
            <li>
              <xsl:call-template name="xmv:dynamic-links">
                <xsl:with-param name="linkToLabel" select="'Conditions of Use'"/>
                <xsl:with-param name="linkToFile" select="'editorial_guide/conditions_of_use.html'"/>
              </xsl:call-template>
             </li>
            <li>
              <xsl:call-template name="xmv:dynamic-links">
                <xsl:with-param name="linkToLabel" select="'Comments &amp; Queries'"/>
                <xsl:with-param name="linkToFile" select="'help/comment.html'"/>
              </xsl:call-template>
            </li>
           
          </ul>
        </div>
        <div class="s02">
          <xsl:text>&#xa9;</xsl:text><xsl:value-of select="format-date(current-date(), '[Y]')" /><xsl:text>, </xsl:text>Schenker Documents Online.
          <xsl:text>  </xsl:text><xsl:text>In collaboration with the </xsl:text><a href="http://www.kcl.ac.uk/cch">Centre for Computing in the Humanities</a>, King's College London.
          <xsl:text>  </xsl:text><xsl:text>Powered by </xsl:text><a href="http://www.cch.kcl.ac.uk/xmod/" title="link to the xMod home page"><span>xMod 2.0</span></a>
         </div>        
      </div>
    </div>
  </xsl:template>
  
  
  <xsl:template name="xmv:dynamic-links">
    <xsl:param name="linkToLabel"/>
    <xsl:param name="linkToFile"/>
    
      <a title="{$linkToLabel}">
        <xsl:attribute name="href">
          <xsl:call-template name="xmm:path-resolver" />
          <xsl:if test="string($xmp:context-path)">
            <xsl:value-of select="$xmp:context-path" />
            <xsl:text>/</xsl:text>
          </xsl:if>
         <xsl:value-of select="$linkToFile" />
        </xsl:attribute>
        
        <span>
          <xsl:value-of select="$linkToLabel" />
        </span>
      </a>
   
  </xsl:template> 
</xsl:stylesheet>
