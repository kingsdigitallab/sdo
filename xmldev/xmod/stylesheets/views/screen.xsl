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
      <title>
        <xsl:text>xMod 2.0</xsl:text>
        <xsl:if test="string($xmg:title)">
          <xsl:text>: </xsl:text>
          <xsl:value-of select="$xmg:title" />
        </xsl:if>
      </title>

      <xsl:call-template name="xmv:css" />
      <xsl:call-template name="xmv:script" />
    </head>
  </xsl:template>

  <xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/default.css" media="screen, projection" rel="stylesheet" type="text/css" />
  </xsl:template>

  <xsl:template name="xmv:script">
    <xsl:comment>
      <xsl:text>[if IE]&gt; &lt;script src="</xsl:text>
      <xsl:value-of select="$xmp:assets-path" />
      <xsl:text>/s/compat.js" type="text/javascript"&gt;&#160;&lt;/script&gt; &lt;![endif]</xsl:text>
    </xsl:comment>
    <xsl:text><!-- to add a line break -->
</xsl:text>
    <script src="{$xmp:assets-path}/s/corelib.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/config.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/init.js" type="text/javascript">&#160;</script>
  </xsl:template>

  <xsl:template name="xmv:body">
    <body class="v1 r3 rc0" id="xmd">
      <div id="wrapper">
        <xsl:call-template name="xmv:banner" />

        <table cellpadding="0" cellspacing="0" id="xlt" summary="">
          <tr class="r01">
            <td colspan="2" id="topnav"> </td>
          </tr>

          <tr class="r01">
            <td colspan="2" id="breadcrumb">
              <xsl:call-template name="xmm:breadcrumbs" />
            </td>
          </tr>

          <tr class="r02">
            <td id="sidenav">
              <xsl:call-template name="xmm:menu" />
            </td>

            <td id="content">
              <xsl:call-template name="xms:rhcontent" />

              <div id="mainContent">
                <xsl:call-template name="xms:options1" />

                <xsl:call-template name="xms:submenu" />

                <xsl:call-template name="xms:pagehead" />

                <xsl:call-template name="xms:toc1" />

                <xsl:call-template name="xms:content" />

                <xsl:call-template name="xms:footnotes" />

                <xsl:call-template name="xms:toc2" />

                <xsl:call-template name="xms:options2" />
              </div>
            </td>
          </tr>
        </table>

        <xsl:call-template name="xmv:footer" />
      </div>
    </body>
  </xsl:template>

  <xsl:template name="xmv:banner">
    <div id="banner">
      <div class="w01">
        <div class="w02">
          <div class="utilLinks">
            <div class="s01">&#160;</div>
            <div class="s02">
              <a href="">
                <span>Text Only</span>
              </a>
              <a href="#content">
                <span>Skip Navigation</span>
              </a>
              <a accesskey="c" href="" title="Link to contact information">
                <span>Contact Info</span>
              </a>
            </div>
          </div>
          <div id="decalRight">
            <span class="printOnly">Right Hand Decal</span>
          </div>
          <div id="decalLeft">
            <span class="printOnly">Left Hand Decal</span>
          </div>

          <!-- Heading can be shown as text or replaced with images -->
          <h1>
            <span>Banner title</span>
          </h1>
          <h2>
            <span>Banner subtitle</span>
          </h2>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xmv:footer">
    <div id="footer">
      <div class="utilLinks">
        <div class="s01">
          <ul>
            <li>
              <xsl:text>&#xa9;</xsl:text>
              <xsl:value-of select="format-date(current-date(), '[Y]')" />
            </li>
            <li>
              <xsl:text>Resp: </xsl:text>
              <a href="http://www.kcl.ac.uk/cch">CCH</a>
            </li>
            <li class="s01">
              <xsl:text>Powered by </xsl:text>
              <a href="http://www.kcl.ac.uk/cch/xmod/" title="link to the xMod home page">xMod 2.0</a>
            </li>
          </ul>
        </div>
        <div class="s02">
          <xsl:text>&#xa9;</xsl:text>
          <strong>
            <xsl:value-of select="format-date(current-date(), '[Y]')" />
          </strong>
          <xsl:text> King's College London, Strand, London WC2R 2LS, England, United Kingdom. Tel +44 (0)20 7836 5454</xsl:text>
        </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
