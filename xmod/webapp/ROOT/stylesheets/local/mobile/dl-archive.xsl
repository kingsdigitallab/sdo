<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:param name="filename" />
  <xsl:param name="filedir" />
  <xsl:param name="qualifier" />
  <xsl:param name="lang" />
  <xsl:param name="inc" />
  <xsl:param name="format" />

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$inc">
        <zip:archive>
          <xsl:for-each select="tokenize($inc, '&amp;')">
            <xsl:variable name="filepath">
              <xsl:choose>
                <xsl:when test="substring-before(.,'=') = 'fq'" />
                <xsl:when test="substring-before(.,'=') = 'kw'" />
                <xsl:when test="substring-before(.,'=') = 'p'" />
                <xsl:when test="substring-before(.,'=') = 'lang'" />
                <xsl:when test="substring-before(.,'=') = 'format'" />
                <xsl:otherwise>
                  <xsl:for-each select="tokenize(substring-before(., '='), '\*')">
                    <xsl:choose>
                      <xsl:when test="position() = 1 and . = 'do'"><xsl:text>mobile/</xsl:text></xsl:when>
                      <xsl:when test="position() = 1 and . = 'pr'"><xsl:text>mobile/profiles/</xsl:text></xsl:when>
                      <xsl:when test="position() = last()"><xsl:value-of select="." /></xsl:when>
                      <xsl:when test=". = 'co'"><xsl:text>correspondence/</xsl:text></xsl:when>
                      <xsl:when test=". = 'di'"><xsl:text>diaries/</xsl:text></xsl:when>
                      <xsl:when test=". = 'pe'"><xsl:text>person/</xsl:text></xsl:when>
                      <xsl:when test=". = 'pl'"><xsl:text>place/</xsl:text></xsl:when>
                      <xsl:when test=". = 'or'"><xsl:text>organization/</xsl:text></xsl:when>
                      <xsl:when test=". = 'wo'"><xsl:text>work/</xsl:text></xsl:when>
                      <xsl:when test=". = 'ot'"><xsl:text>other/</xsl:text></xsl:when>
                      <xsl:when test=". = 'jo'"><xsl:text>journal/</xsl:text></xsl:when>
                      <xsl:when test=". = 'le'"><xsl:text>lessonbooks/</xsl:text></xsl:when>
                      <xsl:otherwise><xsl:value-of select="." />/</xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
                 
            <xsl:if test="string-length(normalize-space($filepath)) > 0">
              <xsl:variable name="fname">
                <xsl:choose>
                  <xsl:when test="substring(tokenize($filepath, '/')[last()], 1, 1) = 'r'"><xsl:value-of select="tokenize($filepath, '/')[last() - 1]" />_<xsl:value-of select="tokenize($filepath, '/')[last()]" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="tokenize($filepath, '/')[last()]" /></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <xsl:call-template name="addFiles">
                <xsl:with-param name="file">
                  <xsl:value-of select="$filepath" /><xsl:text>:</xsl:text><xsl:value-of select="$lang" />
                </xsl:with-param>
                <xsl:with-param name="name" select="$fname" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </zip:archive>
      </xsl:when>

      <xsl:otherwise>
        <zip:archive>

          <xsl:call-template name="addFiles">
            <xsl:with-param name="file">
              <xsl:text>mobile/</xsl:text><xsl:value-of select="$filedir" /><xsl:text>/</xsl:text><xsl:value-of select="$filename" /><xsl:text>:</xsl:text><xsl:value-of select="$qualifier" />
            </xsl:with-param>
            <xsl:with-param name="name" select="$filename" />
          </xsl:call-template>

        </zip:archive>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

  <xsl:template name="addFiles">
    <xsl:param name="file" />
    <xsl:param name="name" />
    <xsl:choose>
      <xsl:when test="$lang">
        <!-- PDF -->
        <xsl:if test="$format and ($format = 'pdf' or $format = 'both')">
          <zip:entry name="{$name}_{$lang}.pdf" src="cocoon://{$file}.pdf?lang={$lang}" />
        </xsl:if>
        <!-- EPUB -->
        <xsl:if test="$format and ($format = 'epub' or $format = 'both')">
          <zip:entry name="{$name}_{$lang}.epub" src="cocoon://{$file}.epub?lang={$lang}" />
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- PDF -->
        <xsl:if test="$format and ($format = 'pdf' or $format = 'both')">
          <zip:entry name="{$name}.pdf" src="cocoon://{$file}.pdf" />
        </xsl:if>
        <!-- EPUB -->
        <xsl:if test="$format and ($format = 'epub' or $format = 'both')">
          <zip:entry name="{$name}.epub" src="cocoon://{$file}.epub" />
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>