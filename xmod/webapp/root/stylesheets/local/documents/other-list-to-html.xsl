<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- adding comment for a test; PC 20March2012 -->

  <xsl:import href="../default.xsl" />

  <xsl:variable name="xmg:title">
    <xsl:text>Browse Other Material by Author</xsl:text>
  </xsl:variable>

  <xsl:template name="xms:content">
    <!-- Group by author -->
    
    <xsl:for-each-group group-by="."
      select="/aggregation/response/result/doc/arr[@name='author_key']/str">
      
      <!-- split author string and sort on last word -->
      <xsl:sort select="tokenize(../../arr[@name='author']/str[1], ' ')[last()]" />

      <ul>
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:text>../../profiles/other/</xsl:text>
              <xsl:value-of select="current-grouping-key()" />
              <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <!-- <xsl:value-of select="/aggregation/response/result/doc/arr[@name='author_key']/str[text() = current-grouping-key()]/../../arr[@name='author']" /> -->
             <xsl:call-template name="get-author-name" >
              <xsl:with-param name="author-id"><xsl:value-of select="current-grouping-key()" /></xsl:with-param>
            </xsl:call-template>
          </a>
          <xsl:call-template name="add-item-count" />
        </li>
      </ul>
    </xsl:for-each-group>

  </xsl:template>

  <xsl:template name="add-item-count">
    <xsl:text>: </xsl:text>
    <xsl:value-of select="count(current-group())" />
    <xsl:text> item</xsl:text>
    <xsl:if test="count(current-group()) &gt; 1">
      <xsl:text>s</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="get-author-name">
    <xsl:param name="author-id" />
    
   <!--  <xsl:value-of select="/aggregation/response/result/doc/arr[@name='author_key']/str[text() = $author-id]/../../arr[@name='author']" /> -->
    
    <xsl:for-each select="/aggregation/response/result/doc/arr[@name='author_key']/str[text() = $author-id]">
      <xsl:if test="position() = 1">
      <xsl:value-of select="../../arr[@name='author'][1]"></xsl:value-of></xsl:if>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
