<?xml version="1.0" encoding="UTF-8"?>
<!--
  Default stylesheet. Defines the templates that are called from the views stylesheets.
  It should be imported by other project specific stylesheets, where the variables/templates should be overriden as needed.
  
  $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />

  <xsl:include href="../views/screen.xsl" />

  <xsl:variable name="xmg:title" select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
  <xsl:variable name="xmg:pathroot" select="$filedir" />
  <xsl:variable name="xmg:path" select="concat($filedir, '/', substring-before($filename, '.'), '.', $fileextension)" />

  <xsl:template match="/">
    <xsl:call-template name="xmv:screen" />
  </xsl:template>

  <xsl:template name="xms:submenu">
    <div class="submenu">
      <div class="t01">
        <ul>
          <li>
            <a href="">Submenu option 01</a>
          </li>
          <li>
            <a href="">Submenu option 02</a>
          </li>
          <li>
            <a href="">Submenu option 03</a>
          </li>
          <li>
            <a href="">Submenu option 04</a>
          </li>
          <li>
            <a href="">Submenu option 05</a>
          </li>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$xmg:title" />
        </h1>

        <xsl:if test="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']">
          <h2>
            <xsl:apply-templates mode="pagehead"
              select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']" />
          </h2>
        </xsl:if>

        <xsl:if
          test="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author or //tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
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

  <xsl:template name="xms:rhcontent"> </xsl:template>

  <xsl:template name="xms:content"> </xsl:template>

  <xsl:template name="xms:toc1">
    <xsl:call-template name="xms:toc" />
  </xsl:template>

  <xsl:template name="xms:toc2">
    <xsl:call-template name="xms:toc" />
  </xsl:template>

  <xsl:template name="xms:toc">
    <xsl:if
      test="//tei:TEI/tei:text/tei:body/tei:div/tei:head or //tei:TEI/tei:text/tei:front/tei:div/tei:head or //tei:TEI/tei:text/tei:back/tei:div/tei:head">
      <div class="toc">
        <div class="t01">
          <h3>Document Contents</h3>
          <ul>
            <xsl:for-each select="//tei:TEI/tei:text/*/tei:div/tei:head">
              <li>
                <a href="#{generate-id()}">
                  <span>
                    <xsl:apply-templates mode="toc" select="." />
                  </span>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="xms:footnotes">
    <xsl:if test="//tei:TEI//tei:note">
      <div class="footnotes">
        <h3>Footnotes</h3>
        <dl>
          <xsl:for-each select="//tei:TEI//tei:note">
            <xsl:variable name="fnnum">
              <xsl:number level="any" />
            </xsl:variable>
            <xsl:variable name="fnnumfull">
              <xsl:number format="01" level="any" />
            </xsl:variable>

            <dt id="fn{$fnnumfull}"><xsl:value-of select="$fnnum" />.</dt>
            <dd>
              <xsl:apply-templates />
              <xsl:text> </xsl:text>
              <a class="back" href="#fnLink{$fnnumfull}">Back to context...</a>
            </dd>
          </xsl:for-each>
        </dl>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="xms:options1">
    <div class="options">
      <div class="t01">
        <xsl:call-template name="xms:option" />
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:options2">
    <div class="options">
      <div class="t02">
        <xsl:call-template name="xms:option" />
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:option">
    <ul>
      <li>
        <a class="s01" href="">
          <span>First Page</span>
        </a>
      </li>
      <li>
        <a class="s02" href="">
          <span>Previous Page</span>
        </a>
      </li>
      <li>
        <a class="s03" href="">
          <span>Next Page</span>
        </a>
      </li>
      <li>
        <a class="s04" href="">
          <span>Last Page</span>
        </a>
      </li>
      <li>
        <a class="s05" href="">
          <span>1</span>
        </a>
      </li>
      <li>
        <a class="s06" href="">
          <span>Previous</span>
        </a>
      </li>
      <li>
        <a class="s07" href="">
          <span>Next</span>
        </a>
      </li>
      <li>
        <a class="s08" href="">
          <span>Search</span>
        </a>
      </li>
      <li>
        <a class="s09" href="">
          <span>Search Again</span>
        </a>
      </li>
      <li>
        <a class="s10" href="">
          <span>Refine Search</span>
        </a>
      </li>
      <li>
        <a class="s11" href="">
          <span>Print this Page</span>
        </a>
      </li>
    </ul>
  </xsl:template>
</xsl:stylesheet>
