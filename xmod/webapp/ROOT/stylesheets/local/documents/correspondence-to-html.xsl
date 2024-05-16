<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="document-to-html.xsl" />

  <xsl:template name="browsing-nav">
    <!--
        Correspondence items have many navigation axes:
        
        * by date
        * by correspondent (author)
        * by recipient
        * by item type
        * by correspondence

    -->
    <xsl:param name="current-item" />
    <ul>
      <xsl:apply-templates mode="browse-by-date" select="$current-item" />
      <xsl:apply-templates mode="browse-by-item-type" select="$current-item" />
      <xsl:apply-templates mode="browse-by-correspondence" select="$current-item" />
      <!--<xsl:apply-templates select="$current-item" mode="browse-by-correspondent"/>
      <xsl:apply-templates select="$current-item" mode="browse-by-recipient"/>-->
    </ul>
  </xsl:template>

  <xsl:template match="doc" mode="browse-by-item-type">
    <xsl:variable name="item-type" select="str[@name='type']" />
    <xsl:call-template name="browse-for-type">
      <xsl:with-param name="type" select="'Item type'" />
      <xsl:with-param name="previous" select="preceding-sibling::doc[str[@name='type']=$item-type][1]" />
      <xsl:with-param name="next" select="following-sibling::doc[str[@name='type']=$item-type][1]" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="doc" mode="browse-by-correspondence">
    <li>
      <xsl:text>Correspondents:</xsl:text>
      <ul>
        <xsl:for-each select="arr[@name='correspondence']/str">
          <xsl:sort select="substring-after(., ' ')" />
          <xsl:variable name="key" select="substring-before(., ' ')" />
          <xsl:call-template name="browse-for-type">
            <xsl:with-param name="type" select="replace(substring-after(., ' '), '_', ' ')" />
            <xsl:with-param name="previous"
              select="../../preceding-sibling::doc[arr[@name='correspondence']/str[substring-before(., ' ')=$key]][1]" />
            <xsl:with-param name="next"
              select="../../following-sibling::doc[arr[@name='correspondence']/str[substring-before(., ' ')=$key]][1]"
             />
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="doc" mode="browse-by-correspondent">
    <li>
      <xsl:text>Author:</xsl:text>
      <ul>
        <xsl:for-each select="arr[@name='correspondent']/str">
          <xsl:variable name="key" select="substring-before(., ' ')" />
          <xsl:call-template name="browse-for-type">
            <xsl:with-param name="type" select="substring-after(., ' ')" />
            <xsl:with-param name="previous"
              select="../../preceding-sibling::doc[arr[@name='correspondent']/str[substring-before(., ' ')=$key]][1]" />
            <xsl:with-param name="next"
              select="../../following-sibling::doc[arr[@name='correspondent']/str[substring-before(., ' ')=$key]][1]" />
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="doc" mode="browse-by-recipient">
    <li>
      <xsl:text>Recipient:</xsl:text>
      <ul>
        <xsl:for-each select="arr[@name='recipient']/str">
          <xsl:variable name="key" select="substring-before(., ' ')" />
          <xsl:call-template name="browse-for-type">
            <xsl:with-param name="type" select="substring-after(., ' ')" />
            <xsl:with-param name="previous"
              select="../../preceding-sibling::doc[arr[@name='recipient']/str[substring-before(., ' ')=$key]][1]" />
            <xsl:with-param name="next"
              select="../../following-sibling::doc[arr[@name='recipient']/str[substring-before(., ' ')=$key]][1]" />
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </li>
  </xsl:template>

</xsl:stylesheet>
