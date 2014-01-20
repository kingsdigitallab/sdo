<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  
  <xsl:import href="document-to-html.xsl" />
  
  <xsl:template name="browsing-nav">
    <!-- Other items may be browsed only by date. -->
    <!-- Other items may also be browsed title and author - KFL. -->
    <xsl:param name="current-item" />
    <ul>
      <xsl:apply-templates mode="browse-by-title" select="$current-item" />
      <xsl:apply-templates mode="browse-by-date" select="$current-item" />     
      <xsl:apply-templates mode="browse-by-author" select="$current-item" /> 
    </ul>
  </xsl:template>
 

  <xsl:template match="doc" mode="browse-by-title">
    <xsl:param name="title" select="str[@name='title']" />
    <xsl:variable name="key" select="str[@name='fileId']" />
    
    <xsl:call-template name="browse-for-type">
      <xsl:with-param name="type" select="'Title'" />
      <xsl:with-param name="previous" select="preceding-sibling::doc[1]" />
      <xsl:with-param name="next" select="following-sibling::doc[1]" />
    </xsl:call-template>
  </xsl:template>

  
  <xsl:template match="doc" mode="browse-by-author">
    <li>
      <xsl:text>Author:</xsl:text>
      <ul>
        <xsl:for-each select="arr[@name='author_key']/str">
          <xsl:variable name="key" select="." />
          <xsl:variable name="pos" select="position()"/>
          <xsl:variable name="name" select="parent::arr/preceding-sibling::arr[@name='author']/child::str[position()=$pos]"/>
          <xsl:call-template name="browse-for-type">
            <xsl:with-param name="type" select="$name" />
            <xsl:with-param name="previous"
              select="../../preceding-sibling::doc[arr[@name='author_key']/str[.=$key]][1]" />
            <xsl:with-param name="next"
              select="../../following-sibling::doc[arr[@name='author_key']/str[.=$key]][1]" />
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </li>
  </xsl:template>

</xsl:stylesheet>
