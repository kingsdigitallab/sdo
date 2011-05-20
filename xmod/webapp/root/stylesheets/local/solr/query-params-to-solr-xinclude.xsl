<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:h="http://apache.org/cocoon/request/2.0" xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="keyword" select="''" />
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
          </xsl:call-template>
        </xsl:variable>
        <xi:include>
          <xsl:attribute name="href">
            <xsl:text>cocoon://_internal/solr/query/q=</xsl:text>
            <xsl:value-of select="$escaped-keyword" />
            <xsl:if test="number($start)">
              <xsl:text>&amp;start=</xsl:text>
              <xsl:value-of select="xs:integer($start)" />
            </xsl:if>
            <xsl:text>&amp;hl=true&amp;hl.fl=text&amp;hl.fragsize=250</xsl:text>
          </xsl:attribute>
        </xi:include>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="escape-parameter">
    <xsl:param name="param" />
    <xsl:value-of select="translate($param, ';&amp;*^#@!()', '')" />
  </xsl:template>
</xsl:stylesheet>
