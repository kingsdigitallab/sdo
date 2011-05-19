<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../profiles/profile-to-html.xsl" />

  <xsl:variable name="date"
    select="substring-after(/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='q'], ':')" />

  <xsl:variable name="xmg:title">
    <xsl:value-of select="$date" />
  </xsl:variable>

  <xsl:variable name="correspondence" select="/aggregation/response/result/doc[str[@name='kind']='correspondence']" />
  <xsl:variable name="diaries" select="/aggregation/response/result/doc[str[@name='kind']='diaries']" />
  <xsl:variable name="lessonbooks" select="/aggregation/response/result/doc[str[@name='kind']='lessonbooks']" />
  <xsl:variable name="other" select="/aggregation/response/result/doc[str[@name='kind']='other']" />

  <xsl:template name="xms:content">
    <xsl:apply-templates select="/aggregation/tei:TEI" />

    <ul>
      <li>
        <xsl:for-each select="/aggregation/dates/response/result/doc[str = $date]">
          <xsl:if test="position() = 1"><xsl:choose>
            <xsl:when test="preceding-sibling::doc[str != $date][1]">
              <a href="{preceding-sibling::doc[str != $date][1]/str}.html">Previous</a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Previous</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> and </xsl:text>
          <xsl:choose>
            <xsl:when test="following-sibling::doc[str != $date][1]">
              <a href="{following-sibling::doc[str != $date][1]/str}.html">Next</a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Next</xsl:text>
            </xsl:otherwise>
          </xsl:choose></xsl:if>
        </xsl:for-each>
      </li>
    </ul>

    <div>
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
        </xsl:when>
        <xsl:otherwise>
          <p>There are no documents associated with this date.</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

</xsl:stylesheet>
