<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:h="http://apache.org/cocoon/request/2.0" xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="keyword" select="''" />
  <xsl:param name="filter" select="''" />
  <xsl:param name="filter2" select="''" />
  <xsl:param name="page" select="1" />
  <xsl:param name="rows" select="10" />

  <xsl:variable name="start" select="(number($page)-1) * number($rows)" />

  <xsl:template match="/aggregation">  
    
    <xsl:copy>
      <xsl:copy-of select="*" />
      <xsl:if test="normalize-space($keyword)">
        <xsl:variable name="escaped-keyword">
          <xsl:call-template name="escape-parameter">
            <xsl:with-param name="param" select="normalize-space($keyword)" />
            <xsl:with-param name="quote">
              <xsl:choose>
                <xsl:when test="$filter2 != '' and contains(normalize-space($keyword), ' ')"><xsl:value-of select="true()"/></xsl:when>
                <xsl:when test="contains($filter, 'foreign_word') or contains($filter, 'term') and contains(normalize-space($keyword), ' ')"><xsl:value-of select="true()"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="fq2">
          <xsl:choose>
            <xsl:when test="$filter2 != ''"><xsl:value-of select="$filter2" /></xsl:when>
            <xsl:when test="contains($filter, 'foreign_word') or contains($filter, 'term')"><xsl:value-of select="$filter" /></xsl:when>
            <xsl:otherwise />
          </xsl:choose>  
        </xsl:variable>
        
        <xi:include>
          <xsl:attribute name="href">
            <xsl:text>cocoon://_internal/solr/query/q=</xsl:text><xsl:value-of select="$escaped-keyword" />
            <xsl:choose>
              <xsl:when test="$filter = 'all' or $filter = ''" />
              <xsl:when test="(contains($filter, 'foreign_word') or contains($filter, 'term')) and $fq2 != ''"/>
              <xsl:otherwise>&amp;fq=kind:<xsl:value-of select="$filter" /></xsl:otherwise>
            </xsl:choose>
            <!-- <xsl:if test="$filter != 'all' and $filter != ''">&amp;fq=kind:<xsl:value-of select="$filter" /></xsl:if> -->
            <!-- <xsl:if test="$filter != 'all' and $filter != ''">&amp;fq=<xsl:value-of select="$filter" /></xsl:if> -->
            <xsl:if test="$fq2 != ''">&amp;fq=<xsl:value-of select="$fq2" />:<xsl:value-of select="$escaped-keyword" /></xsl:if>
            <xsl:if test="number($start)">
              <xsl:text>&amp;start=</xsl:text>
              <xsl:value-of select="xs:integer($start)" />
            </xsl:if>
            <xsl:text>&amp;hl=true&amp;hl.fl=text&amp;hl.fragsize=250&amp;facet=true&amp;facet.field=kind</xsl:text>
          </xsl:attribute>
        </xi:include>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="escape-parameter">
    <!-- terms and forign words surrounded by speech marks if they aren't already because otherwise solr doesn't give the expected results -->
    <xsl:param name="param" />
    <xsl:param name="quote" />
    <xsl:choose>
      <xsl:when test="$quote = true() and not(contains($param, '&quot;'))">
        <xsl:text>"</xsl:text><xsl:value-of select="encode-for-uri(translate($param, ';&amp;*^#@!()', ''))" /><xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="encode-for-uri(translate($param, ';&amp;*^#@!()', ''))" /></xsl:otherwise>
    </xsl:choose>   
  </xsl:template>
</xsl:stylesheet>
