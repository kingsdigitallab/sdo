<xsl:stylesheet version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <indices>
      <xsl:apply-templates select="dir:directory/dir:directory"/>
    </indices>
  </xsl:template>

  <xsl:template match="dir:directory">
    <index name="{@name}">
      <xsl:apply-templates/>
    </index>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:variable name="index" select="ancestor::dir:directory[1]/@name"/>
    <xi:include href="cocoon://internal/profiles/index-entry/{$index}/{@name}"/>
  </xsl:template>

</xsl:stylesheet>