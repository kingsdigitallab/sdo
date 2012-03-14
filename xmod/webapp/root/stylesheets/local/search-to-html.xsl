<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl" />

  <xsl:param name="rows" select="10" />

  <xsl:variable name="kw" select="/*/response/lst/lst[@name='params']/str[@name='q']" />
  <xsl:variable name="filter" select="/*/response/lst/lst[@name='params']/str[@name='fq']" />
  <xsl:variable name="fq" select="substring-after($filter, 'kind:')" />
  <xsl:variable name="start" select="number(/*/response/result/@start)" />
  <xsl:variable name="number-results" select="number(/*/response/result/@numFound)" />
  <xsl:variable name="current-page" select="floor($start div $rows)+1" />
  <xsl:variable name="total-pages" select="xs:integer(ceiling($number-results div $rows))" />

  <xsl:template name="xms:content">
    <div>
      
      <h2>Full text search of German original and English translation</h2>
      <p>About searching:</p>
      <ul>
        <li>searches are case-insensitive - <strong>bakery</strong> finds <strong>bakery</strong> and <strong>Bakery</strong></li>
        <li>searches find closely related words - <strong>bakery</strong> finds <strong>bakery</strong> and <strong>bakeries</strong></li>
        <li>use quote marks to find words together - <strong>"railway station"</strong> finds just <strong>railway station</strong></li>
      </ul>
      <form action="" method="get">
        <p>
          <label class="search">Search  <select name="fq">
              <option value="all">
                <xsl:if test="$fq='all' or $fq = ''">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>Entire Site</option>
            <option value="diaries">
              <xsl:if test="$fq='diaries'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Diaries</option>
            <option value="correspondence">
              <xsl:if test="$fq='correspondence'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Correspondence</option>
            <option value="lessonbooks">
              <xsl:if test="$fq='lessonbooks'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Lessonbooks</option>
            <option value="work">
              <xsl:if test="$fq='work'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Works</option>
            <option value="journal">
              <xsl:if test="$fq='journal'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Journals</option>
            <option value="other">
              <xsl:if test="$fq='other'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Other Documents</option>            
            <option value="person">
                <xsl:if test="$fq='person'">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>People</option>
              <option value="place">
                <xsl:if test="$fq='place'">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>Places</option>
            <option value="organization">
              <xsl:if test="$fq='organization'">
              <xsl:attribute name="selected">true</xsl:attribute>
            </xsl:if>Organizations</option>
            </select></label>
          <label class="search"> for 
          <input name="kw" size="20" type="text" value="{$kw}" /></label><br/>
          <input type="submit" />
        </p>
      </form>
      <xsl:apply-templates select="/*/response" />
    </div>
  </xsl:template>

  <xsl:template match="response">
    <h2>Searched for <em><xsl:value-of select="lst/lst[@name='params']/str[@name='q']" /></em><xsl:if test="$fq"><xsl:text> in </xsl:text><xsl:value-of select="upper-case(substring($fq, 1, 1))" /><xsl:value-of select="substring($fq, 2)"></xsl:value-of></xsl:if><xsl:if test="$number-results > 0"><xsl:text> (</xsl:text><xsl:value-of select="$number-results"/><xsl:text> result</xsl:text><xsl:if test="$number-results > 1">s</xsl:if><xsl:text> found)</xsl:text></xsl:if></h2>
  <xsl:if test="not($fq)">
    <p>Filter: <xsl:for-each select="lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='kind']/int[. > 0]">
      <a>
        <xsl:attribute name="href"><xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/><xsl:text>&amp;fq=</xsl:text><xsl:value-of select="@name" /></xsl:attribute>
      <xsl:value-of select="@name" /><xsl:text>: </xsl:text><xsl:value-of select="." />
      </a>
      <xsl:if test="not(position() = last())">,</xsl:if><xsl:text> </xsl:text>
    </xsl:for-each></p>
  </xsl:if>
    <xsl:choose>
      <xsl:when test="$number-results = 0">
        <h3>No results found</h3>
       </xsl:when> 
       <xsl:otherwise> 
        <ul>
      <xsl:for-each select="result/doc">
        <xsl:variable name="hl-pos" select="position()" />
        <xsl:variable name="kind" select="str[@name='kind']" />
        
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="$kind = 'diaries' or $kind = 'correspondence' or $kind = 'lessonbooks' or $kind = 'other'"><xsl:text>../documents/</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>../profiles/</xsl:text></xsl:otherwise>
              </xsl:choose>              
              <xsl:value-of select="str[@name = 'url']" />
            </xsl:attribute>
            <xsl:value-of select="str[@name='title']" />
            <xsl:if test="$kind = 'diaries'">
              <xsl:text>Diary entry for </xsl:text>
              <xsl:value-of select="str[@name='dateShort']" />
            </xsl:if>
          </a>
          
          <xsl:for-each select="../../lst[@name = 'highlighting']/lst[$hl-pos]">
            <p>
              <xsl:text>... </xsl:text>
              <xsl:call-template name="unescape-highlight">
                <xsl:with-param name="text" select="arr/str" />
              </xsl:call-template>
              <xsl:text> ...</xsl:text>
            </p>
          </xsl:for-each>
        </li>
      </xsl:for-each>
    </ul>



    <p>Pages: <xsl:for-each select="1 to $total-pages">
        <xsl:choose>
          <xsl:when test=". = $current-page">
            <xsl:value-of select="." />
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a href="?kw={$kw}&amp;fq={$fq}&amp;p={.}">
              <xsl:value-of select="." />
            </a>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="unescape-highlight">
    <xsl:param name="text" select="''" />

    <xsl:variable name="gt" select="'&gt;'" />
    <xsl:variable name="open-tag" select="'&lt;'" />
    <xsl:variable name="close-tag" select="'&lt;/'" />
    <xsl:variable name="pre-hl" select="substring-before($text, $open-tag)" />

    <xsl:choose>
      <xsl:when test="$pre-hl or starts-with($text, $open-tag)">
        <xsl:value-of select="$pre-hl" />
        <b>
          <xsl:value-of select="substring-after(substring-before($text, $close-tag), $gt)" />
        </b>

        <xsl:variable name="remainder" select="substring-after(substring-after($text, $gt), $gt)" />

        <xsl:if test="$remainder">
          <xsl:call-template name="unescape-highlight">
            <xsl:with-param name="text" select="$remainder" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
