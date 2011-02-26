<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="keyword" select="''"/>

  <xsl:template match="/aggregation">
    <xsl:copy>
      <xsl:copy-of select="*"/>
      <xsl:if test="normalize-space($keyword)">
        <xsl:variable name="escaped-keyword">
          <xsl:call-template name="escape-parameter">
            <xsl:with-param name="param" select="normalize-space($keyword)"/>
          </xsl:call-template>
        </xsl:variable>
        <xi:include href="cocoon://_internal/solr/query/q={$escaped-keyword}"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="escape-parameter">
    <xsl:param name="param"/>
    <xsl:value-of select="encode-for-uri(translate($param, ';&amp;*^#@!()', ''))"/>
  </xsl:template>

</xsl:stylesheet>