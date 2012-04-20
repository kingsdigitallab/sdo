<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../profiles/profile-to-html.xsl" />

  <xsl:variable name="date">
    <xsl:choose>
      <xsl:when test="contains(substring-after(/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='q'], ':'), '*')"><xsl:value-of select="substring-before(substring-after(/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='q'], ':'), '-*')" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="substring-after(/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='q'], ':')" /></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="xmg:title">
    <xsl:value-of select="$date" />
  </xsl:variable>

  <xsl:template name="xms:content">
    <xsl:choose>
      <xsl:when test="/aggregation/response/result/doc">
        <p>Documents associated with this date:</p>

        <ul>
          <xsl:if test="$correspondence">
            <li>
              <a href="#correspondence">Correspondence</a>
            </li>
          </xsl:if>
          <xsl:if test="$diaries">
            <li>
              <a href="#diaries">Diaries</a>
            </li>
          </xsl:if>
          <xsl:if test="$lessonbooks">
            <li>
              <a href="#lessonbooks">Lessonbooks</a>
            </li>
          </xsl:if>
          <xsl:if test="$other">
            <li>
              <a href="#other">Other material</a>
            </li>
          </xsl:if>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <p>There are no documents associated with this date.</p>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="/aggregation/tei:TEI">
        <xsl:apply-templates select="/aggregation/tei:TEI" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="entity-from-eats" />
      </xsl:otherwise>
    </xsl:choose>
    

      <xsl:variable name="month"><xsl:value-of select="substring-after($date, '-')" /></xsl:variable>
      <xsl:variable name="year"><xsl:value-of select="substring-before($date, '-')" /></xsl:variable>                
     
    <!--<xsl:variable name="prev-month">
        <xsl:choose>
          <xsl:when test="$month = '01'"><xsl:value-of select="number($year) - 1" /></xsl:when>
          <xsl:otherwise><xsl:value-of select="$year" />-<xsl:value-of select="format-number(number($month) - 1, '00')" /></xsl:otherwise>
        </xsl:choose>
      </xsl:variable> -->
    

    <ul>
      <li>
        <xsl:for-each select="/aggregation/dates/response/result/doc[starts-with(str, $date)]"> <!-- -->
          <xsl:if test="position() = 1">
            <xsl:choose>
              <xsl:when test="(preceding-sibling::doc[str != $date][1]) and (string-length($date) > 7)">
                <a href="{preceding-sibling::doc[str != $date][1]/str}.html">Previous</a>
              </xsl:when>
             
              <xsl:when test="preceding-sibling::doc[not(starts-with(str, $date))][1] and (string-length($date) > 5)">                
                <xsl:variable name="prev-date">
                  <xsl:value-of select="substring-before(preceding-sibling::doc[not(starts-with(str, $date))][1]/str, '-')" />-<xsl:value-of select="substring-before(substring-after(preceding-sibling::doc[not(starts-with(str, $date))][1]/str, '-'), '-')" />
                </xsl:variable>
                
                <a href="{$prev-date}-*.html">Previous</a>
              </xsl:when>    

              <xsl:when test="preceding-sibling::doc[not(starts-with(str, $date))][1]">                
                <a href="{substring-before(preceding-sibling::doc[not(starts-with(str, $date))][1]/str, '-')}-*-*.html">Previous</a>
              </xsl:when>  
              
              <xsl:otherwise>
                <xsl:text>Previous</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> and </xsl:text>
            <xsl:choose>
              <xsl:when test="following-sibling::doc[str != $date][1] and (string-length($date) > 7)">
                <a href="{following-sibling::doc[str != $date][1]/str}.html">Next</a>
              </xsl:when>
              <xsl:when test="following-sibling::doc[not(starts-with(str, $date))][1] and (string-length($date) > 5)">
               <xsl:variable name="next-date">
                  <xsl:value-of select="substring-before(following-sibling::doc[not(starts-with(str, $date))][1]/str, '-')" />-<xsl:value-of select="substring-before(substring-after(following-sibling::doc[not(starts-with(str, $date))][1]/str, '-'), '-')" />
                </xsl:variable>
                
                <a href="{$next-date}-*.html">Next</a>
              </xsl:when>
              <xsl:when test="following-sibling::doc[not(starts-with(str, $date))][1]">
                
                <a href="{substring-before(following-sibling::doc[not(starts-with(str, $date))][1]/str, '-')}-*-*.html">Next</a>
              </xsl:when>                     
              <xsl:otherwise>
                <xsl:text>Next</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </li>
    </ul>

    <xsl:if test="/aggregation/response/result/doc">
      <div>
        <form action="/mobile/docs.zip" method="get" id="dlDocForm" onsubmit="return validate()">
          <!-- KFL - it would look nicer if this was replaced by side menu options (see default.xsl) when script was enabled and this is the no-script option -->
          <p>Download all selected files as <input type="submit" name="format" value="pdf" /> or <input type="submit" name="format" value="epub" /> or <input type="submit" name="format" value="both" /> (check files to select/deselect)<br />Where appropriate save: 
            <input type="radio" name="lang" value="all" checked="checked" /> English and German versions <input type="radio" name="lang" value="de" /> German version only <input type="radio" name="lang" value="en" /> English version only
          </p> <!-- <noscript> </noscript>-->
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Correspondence'" />
          <xsl:with-param name="id" select="'correspondence'" />
          <xsl:with-param name="docs" select="$correspondence" />
        </xsl:call-template>
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Diaries'" />
          <xsl:with-param name="id" select="'diaries'" />
          <xsl:with-param name="docs" select="$diaries" />
        </xsl:call-template>
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Lessonbooks'" />
          <xsl:with-param name="id" select="'lessonbooks'" />
          <xsl:with-param name="docs" select="$lessonbooks" />
        </xsl:call-template>
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Other material'" />
          <xsl:with-param name="id" select="'other'" />
          <xsl:with-param name="docs" select="$other" />
        </xsl:call-template>
        </form>  
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
