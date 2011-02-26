<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="all"
                version="2.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl"/>

  <xsl:variable name="kw" select="/*/response/lst/lst[@name='params']/str[@name='q']"/>

  <xsl:template name="xms:content">
    <div>
      <form action="" method="get">
        <p><label>Search: <input type="text" name="kw" size="12" value="{$kw}"/></label> <input type="submit"/></p>
      </form>
      <xsl:apply-templates select="/*/response"/>
    </div>
  </xsl:template>

  <xsl:template match="response">
    <h2>Results for <i><xsl:value-of select="lst/lst[@name='params']/str[@name='q']"/></i></h2>

    <ul>
      <xsl:apply-templates select="result/doc"/>
    </ul>
  </xsl:template>

  <xsl:template match="result/doc">
    <li>
      <xsl:value-of select="str[@name='title']"/>
    </li>
  </xsl:template>

</xsl:stylesheet>