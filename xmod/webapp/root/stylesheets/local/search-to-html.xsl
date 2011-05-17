<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="all" version="2.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl" />

  <xsl:param name="rows" select="10" />

  <xsl:variable name="kw" select="/*/response/lst/lst[@name='params']/str[@name='q']" />
  <xsl:variable name="start" select="number(/*/response/result/@start)" />
  <xsl:variable name="number-results" select="number(/*/response/result/@numFound)" />
  <xsl:variable name="current-page" select="floor($start div $rows)+1" />
  <xsl:variable name="total-pages" select="xs:integer(ceiling($number-results div $rows))" />

  <xsl:template name="xms:content">
    <div>
      <form action="" method="get">
        <p>
          <label>Search: <input name="kw" size="12" type="text" value="{$kw}" /></label>
          <input type="submit" />
        </p>
      </form>
      <xsl:apply-templates select="/*/response" />
    </div>
  </xsl:template>

  <xsl:template match="response">
    <h2>Results for <i><xsl:value-of select="lst/lst[@name='params']/str[@name='q']" /></i></h2>

    <ul>
      <xsl:apply-templates select="result/doc" />
    </ul>

    <p>Pages: <xsl:for-each select="1 to $total-pages">
        <xsl:choose>
          <xsl:when test=". = $current-page">
            <xsl:value-of select="." />
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="?kw={$kw}&amp;p={.}">
              <xsl:value-of select="." />
            </a>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </p>
  </xsl:template>

  <xsl:template match="result/doc">
    <xsl:variable name="kind" select="str[@name='kind']" />
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:text>../documents/</xsl:text>
          <xsl:value-of select="str[@name = 'url']" />
        </xsl:attribute>
        <xsl:value-of select="str[@name='title']" />
        <xsl:if test="$kind = 'diaries'">
          <xsl:text>Diary entry for </xsl:text>
          <xsl:value-of select="str[@name='dateShort']" />
        </xsl:if>
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
