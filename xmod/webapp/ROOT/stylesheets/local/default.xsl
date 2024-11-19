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
  <xsl:include href="cocoon://_internal/properties/properties.xsl" />
  <xsl:import href="sdo-p5.xsl"/> 
  
  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>
  <xsl:param name="menutop" select="'true'"/>
  <xsl:param name="print" select="'false'"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="printable" />

  <xsl:variable name="xmg:title" select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]"/>
  <xsl:variable name="xmg:pathroot" select="concat($xmp:context-path, '/', $filedir)"/>
  <xsl:variable name="xmg:path" select="concat($xmg:pathroot, '/', substring-before($filename, '.xml'), '.', $fileextension)"/>
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
  <xsl:variable name="xmg:printpreview">
    <xsl:choose>
      <xsl:when test="$print = 'true'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="xmg:minimal">
    <xsl:choose>
      <xsl:when test="$type = 'epub'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="xmg:printable">
    <xsl:choose>
      <xsl:when test="$printable = 'true'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="xmg:error">
    <xsl:choose>
      <xsl:when test="$type = 'error'">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> 
    <xsl:variable name="mobile-path">
      <xsl:choose>
        <xsl:when test="contains($filedir, 'profiles') and not(contains($filedir, 'mobile'))"><xsl:text>mobile/</xsl:text><xsl:value-of select="$filedir" /><xsl:text>/</xsl:text></xsl:when>
        <xsl:when test="contains($filedir, 'profiles') and contains($filedir, 'mobile')"><xsl:value-of select="$filedir" /><xsl:text>/</xsl:text></xsl:when>
        <xsl:otherwise><xsl:value-of select="replace($filedir, 'documents', 'mobile')" /><xsl:text>/</xsl:text></xsl:otherwise>
      </xsl:choose>                  
    </xsl:variable>
  
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$xmg:minimal = false()"><xsl:call-template name="xmv:screen"/></xsl:when>
      <xsl:otherwise>
        <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
            <xsl:call-template name="xmv:metadata" />          
            <title>
              <xsl:value-of select="$xmp:title" />
              <xsl:if test="string($xmg:title)">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$xmg:title" />
              </xsl:if>
            </title>
            <link href="../Style/default.css" media="screen, projection" rel="stylesheet" type="text/css"/>
            <link href="../Style/personality.css" media="screen, projection" rel="stylesheet" type="text/css"/>
          </head>
          <xsl:call-template name="xmv:body" />
        </html>
      </xsl:otherwise>
    </xsl:choose>
    
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

  <xsl:template name="xms:submenu" />

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
  
  <xsl:template name="xmm:menu-print">
    <xsl:choose>
      <xsl:when test="contains($filedir, 'profile')">
        <div id="sn" class="tabs">
          <h3>
            Profile
          </h3>  
          <ul>
            <ul>
              <li><a>
                <xsl:attribute name="href">
                  <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.pdf?all=false</xsl:text>
                </xsl:attribute>
                Save PDF</a></li>
              <li><a>
                <xsl:attribute name="href">
                  <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.epub?all=false</xsl:text>
                </xsl:attribute>
                Save EPub</a></li>
              <li><a>
                <xsl:attribute name="href">
                  <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.zip?all=false</xsl:text>
                </xsl:attribute>             
                Save All Formats</a></li>
            </ul>
          </ul>
          <h3>
            Profile Bundle
          </h3>  
            <ul>
              <li class="s04"><span>Save PDF</span>
                <ul class="pn3">
                  <li class="s01">
                    <a>
                      <xsl:attribute name="href">
                  <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:_bundle.zip</xsl:text>
                </xsl:attribute>All Languages</a>
                </li>  
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:de.pdf</xsl:text>
                      </xsl:attribute>German Only</a>
                  </li>
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:en.pdf</xsl:text>
                      </xsl:attribute>English Only</a>
                  </li>
                </ul>
                </li>
              <li><span>Save EPub</span>
                <ul>
                <li>
                <a>
                <xsl:attribute name="href">
                  <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.epub</xsl:text>
                </xsl:attribute>
                All Languages</a>
                </li>
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:de.epub</xsl:text>
                      </xsl:attribute>
                      German Only</a>
                  </li>
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:en.epub</xsl:text>
                      </xsl:attribute>
                      English Only</a>
                  </li>
              </ul>
                </li>
              <li><span>Save All Formats</span>
                <ul>
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.zip</xsl:text>
                      </xsl:attribute>             
                    All Languages</a>
                  </li>
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:de.zip</xsl:text>
                      </xsl:attribute>             
                    German Only</a>
                  </li>
                  <li>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:en.zip</xsl:text>
                      </xsl:attribute>             
                      English Only</a>
                  </li>
                </ul>
              </li>
            </ul>
                    
        </div>  
      </xsl:when>
      <xsl:otherwise>
        <div id="sn" class="tabs">
          <h3>
            German and English 
          </h3>
          <ul class="tabNavigation">
            <li><a href="#facingtexts">Preview</a></li>
          </ul>
          <ul>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.pdf</xsl:text>
              </xsl:attribute>
              Save PDF</a></li>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.epub</xsl:text>
              </xsl:attribute>
              Save EPub</a></li>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.zip</xsl:text>
              </xsl:attribute>             
              Save All Formats</a></li>
          </ul>
          <h3>
            German Only
          </h3>
          <ul class="tabNavigation">
            <li><a href="#german">Preview</a></li>
          </ul>
          <ul>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:de.pdf?lang=de</xsl:text>
              </xsl:attribute>
              Save PDF</a></li>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:de.epub?lang=de</xsl:text>
              </xsl:attribute>
              Save EPub</a></li>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:de.zip?lang=de</xsl:text>
              </xsl:attribute>             
              Save All Formats</a></li>
          </ul>
          <h3>
            English Only
          </h3>
          <ul class="tabNavigation">
            <li><a href="#english">Preview</a></li>
          </ul>
          <ul>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:en.pdf?lang=en</xsl:text>
              </xsl:attribute>
              Save PDF</a></li>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:en.epub?lang=en</xsl:text>
              </xsl:attribute>
              Save EPub</a></li>
            <li><a>
              <xsl:attribute name="href">
                <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:en.zip?lang=en</xsl:text>
              </xsl:attribute>             
              Save All Formats</a></li>
          </ul>      
        </div>       
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  
  
  <xsl:template name="xmv:meta">
    <meta content="text/html; charset=utf-8" http-equiv="content-type"/>
    <meta content="xMod 2.1" name="generator"/>
    <meta content="Departnent of Digital Humanities, King's College London" name="author"/>
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
    <link href="{$xmp:assets-path}/c/jquery.fancybox-1.3.4.css" media="screen, projection" rel="stylesheet" type="text/css"/>
    <link href="{$xmp:assets-path}/c/d3_styles.css" media="screen, projection" rel="stylesheet" type="text/css"/>
    <link href="{$xmp:assets-path}/c/d3_dc.css" media="screen, projection" rel="stylesheet" type="text/css"/>
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
    <!-- Google Analytics tracking code -->
    <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-40132787-1', 'schenkerdocumentsonline.org');
  ga('send', 'pageview');

</script>
 
    <script src="{$xmp:assets-path}/j/jquery-1.6.4.min.js" type="text/javascript">&#160;</script>  
      <script src="{$xmp:assets-path}/s/jquery.nestedAccordion.js" type="text/javascript">&#160;</script> 
    <script src="{$xmp:assets-path}/s/jquery.fancybox-1.3.4.js" type="text/javascript">&#160;</script>  
    <script src="{$xmp:assets-path}/j/jquery.mb.zoomify.js" type="text/javascript">&#160;</script> 
    <script src="{$xmp:assets-path}/s/jquery.ui.tabs.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/jquery.ui.widget.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/jquery.ui.datepicker.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/r/d3.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/config.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/sdo.js" type="text/javascript">&#160;</script>
    <!--<script src="{$xmp:assets-path}/s/visualization_test2.js" type="text/javascript">&#160;</script>-->
    <!--<script src="{$xmp:assets-path}/s/visualization_test3.js" type="text/javascript">&#160;</script>-->
    <script src="{$xmp:assets-path}/s/visualization_test4.js" type="text/javascript">&#160;</script>
  </xsl:template>
  
  <xsl:template name="xmv:body">
    <body class="v1 r3 rc0" id="xmd">
      
      <div id="wrapper">
        <xsl:if test="$xmg:printpreview = false()"><xsl:call-template name="xmv:banner"/></xsl:if>
        
        <table cellpadding="0" cellspacing="0" id="xlt" summary="">
          <tr class="r01">
            <td colspan="2" id="topnav">
              <xsl:if test="$xmg:menu-top = true()">
                <xsl:call-template name="xmm:menu-top"/>
              </xsl:if>
            </td>
          </tr>
          <xsl:if test="$xmg:printpreview = false()">
          <tr class="r01">
            <td colspan="2" id="breadcrumb">
              <xsl:call-template name="xmm:breadcrumbs"/>
            </td>
          </tr>
          </xsl:if>  
          <tr class="r02">
          <xsl:if test="$xmg:minimal = false()"> 
            <td id="sidenav">
              <xsl:choose>
                <xsl:when test="$xmg:printpreview = true()">
                  <xsl:call-template name="xmm:menu-print"/>
                </xsl:when>
                <xsl:when test="$xmg:menu-top = true()">
                  <xsl:call-template name="xmm:menu-top-sub"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="xmm:menu"/>
                </xsl:otherwise>
              </xsl:choose>
              <!-- 
              <xsl:if test="$xmg:printable = true()">
                                <div id="sn" class="tabs">
                  <h3>
                    Downloads
                  </h3>  
                  <ul>
                    <li class="s06">
                      <ul> 
                      <li><a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>.html</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                      Print Preview</a></li>
                                       
                    <li><a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.pdf</xsl:text>
                      </xsl:attribute>
                      Save Page (PDF)</a></li>
                    <li><a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.epub</xsl:text>
                      </xsl:attribute>
                      Save Page (EPub)</a></li>
                    <li><a>
                      <xsl:attribute name="href">
                        <xsl:text>/</xsl:text><xsl:value-of select="$mobile-path" /><xsl:value-of select="substring-before($filename, '.xml')" /><xsl:text>:.zip</xsl:text>
                      </xsl:attribute>
                      Save Page (All Formats)</a></li> 
                      -->
                     <!--   
                       KFL - NB. Needs to be changed so these display when javascript is enabled so it can replace the buttons int the page
                     <li><a href="">
                       <xsl:attribute name="onclick">$('form#dlDocForm').submit(); return false;</xsl:attribute>
                          Save Selected (PDF)</a> </li>
                     <li><a href="">
                       <xsl:attribute name="onclick">$('form#dlDocForm').submit(); return false;</xsl:attribute>
                          Save Selected (EPub)</a></li>
                     <li><a href="">
                       <xsl:attribute name="onclick">$('form#dlDocForm').submit(); return false;</xsl:attribute>
                          Save Selected (All Formats)</a></li> 
                      -->  
              
                      <!--</ul>  
                    </li>
                  </ul>
                </div>  
              </xsl:if> -->               
            </td>
            </xsl:if>
            <td id="content">
              <xsl:call-template name="xms:rhcontent"/>
              <div id="mainContent">
                <xsl:call-template name="xms:pagehead"/>
                <xsl:if test="$xmg:error = true()">
                  <xsl:call-template name="xms:toc1"/>
                </xsl:if>  
                <xsl:call-template name="xms:content"/>
                <xsl:call-template name="xms:footnotes"/>
              </div>
            </td>
          </tr>
        </table>
        <xsl:choose>
          <xsl:when test="$xmg:printpreview = true()"><xsl:call-template name="xmv:print-footer"/></xsl:when>
          <xsl:otherwise><xsl:call-template name="xmv:footer"/></xsl:otherwise>
        </xsl:choose>        
      </div>
    <script defer="defer" src="https://kdl.kcl.ac.uk/sla-acpp/js/sla.js" type="text/javascript">&#160;</script>
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
 

  <xsl:template name="xmv:print-footer">
    <div id="footer">
      <div class="s01"><xsl:text>Document URL: http://www.schenkerdocumentsonline.org/</xsl:text>
        <xsl:choose>
          <xsl:when test="contains($filedir, 'profiles')"><xsl:value-of select="replace($filedir, 'mobile/', '')"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="replace($filedir, 'mobile', 'documents')" /></xsl:otherwise>
        </xsl:choose>        
        <xsl:text>/</xsl:text><xsl:value-of select="substring-before($filename, '.xml')" />.html<br/>Referenced: <xsl:value-of select="format-date(current-date(), '[D01]-[M01]-[Y0001]')" /></div>
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
              <xsl:text>Powered by xMod</xsl:text>
            </li>
          </ul>
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
