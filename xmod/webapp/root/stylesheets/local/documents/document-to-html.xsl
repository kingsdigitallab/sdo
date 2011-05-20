<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl" />

  <xsl:param name="filedir" select="'documents/'" />

  <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[1]" />

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$record/sdo:itemDesc/dc:title" />
        </h1>
        <div>
          <p>
            <xsl:value-of select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]" />
          </p>

          <h2>Browse by</h2>

          <xsl:variable name="fileId"
            select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/*[1]/@sdoID" />

          <xsl:call-template name="browsing-nav">
            <xsl:with-param name="current-item" select="/aggregation/response/result/doc[str[@name='fileId']=$fileId]"
             />
          </xsl:call-template>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:content">
    <table class="docDisplayGandE">
      <tr>
        <td id="GermanVersion">
          <!-- German version. -->
          <xsl:apply-templates select="$record/tei:div[@type='transcription']" />
        </td>
        <td id="EnglishVersion">
          <!-- English version. -->
          <xsl:apply-templates select="$record/tei:div[@type='translation']" />
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <div class="ft">
            <h3>Footnotes</h3>
            <xsl:for-each select="$record//tei:note[@place='foot']">
              <xsl:variable name="noteNum" select="substring(substring-after(@xml:id, '-'), 3, 2)" />
              <p>
                <xsl:attribute name="id" select="concat('fn', $noteNum)" />
                <sup>
                  <xsl:choose>
                    <xsl:when test="starts-with($noteNum, '0')">
                      <xsl:value-of select="substring($noteNum, 2, 1)" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$noteNum" />
                    </xsl:otherwise>
                  </xsl:choose>
                </sup>
                <xsl:text> </xsl:text>
                <xsl:value-of select="." />
              </p>
            </xsl:for-each>
          </div>
        </td>
      </tr>
      <xsl:for-each select="/aggregation/commentary/doc[statements/statement]">
        <tr>
          <td colspan="2">
            <div class="ft">
              <h3>Commentary</h3>
              <dl>
                <xsl:for-each select="statements/statement">
                  <dt>
                    <xsl:value-of select="@type" />
                  </dt>
                  <dd>
                    <xsl:value-of select="." />
                  </dd>
                </xsl:for-each>
                <xsl:for-each select="container/statements/statement[@type != current()/statements/statement/@type]">
                  <dt>
                    <xsl:value-of select="@type" />
                  </dt>
                  <dd>
                    <xsl:value-of select="." />
                  </dd>
                </xsl:for-each>
              </dl>
            </div>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="doc" mode="browse-by-date">
    <xsl:call-template name="browse-for-type">
      <xsl:with-param name="type" select="'Date'" />
      <xsl:with-param name="previous" select="preceding-sibling::doc[1]" />
      <xsl:with-param name="next" select="following-sibling::doc[1]" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="browse-for-type">
    <xsl:param name="type" />
    <xsl:param name="previous" />
    <xsl:param name="next" />
    <li>
      <xsl:value-of select="$type" />
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="$previous">
          <a href="{concat($xmg:pathroot, $previous/str[@name='url'])}">Previous</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Previous</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> and </xsl:text>
      <xsl:choose>
        <xsl:when test="$next">
          <a href="{concat($xmg:pathroot, $next/str[@name='url'])}">Next</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Next</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>


</xsl:stylesheet>
