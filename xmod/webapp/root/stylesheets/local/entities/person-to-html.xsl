<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../profiles/profile-to-html.xsl" />

  <xsl:template name="xms:content">
    <div>
          <p><a href="#eats">Information about this person</a></p>
      <xsl:choose>
        <xsl:when test="/aggregation/response/result/doc">
          <p>Documents associated with this person:</p>

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
          <p>There are no documents associated with this person.</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
    <xsl:choose>
      <xsl:when test="/aggregation/tei:TEI">
        <div id="eats"><h2>About this person</h2><xsl:apply-templates select="/aggregation/tei:TEI" /></div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="entity-from-eats" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
