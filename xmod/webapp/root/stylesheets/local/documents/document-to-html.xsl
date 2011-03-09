<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[1]"/>

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of select="$record/sdo:itemDesc/dc:title"/>
        </h1>
        <div>
          <p>
            <xsl:value-of select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]"/>
          </p>

          <h2>Browse by</h2>

          <xsl:variable name="fileId" select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/*[1]/@sdoID"/>

          <xsl:call-template name="browsing-nav">
            <xsl:with-param name="current-item" select="/aggregation/response/result/doc[str[@name='fileId']=$fileId]"/>
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
          <xsl:apply-templates select="$record/tei:div[@type='transcription']"/>
        </td>
        <td id="EnglishVersion">
          <!-- English version. -->
          <xsl:apply-templates select="$record/tei:div[@type='translation']"/>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <div class="ft">
            <h3>Footnotes</h3>
            <xsl:for-each select="$record/tei:note[@place='foot']">
              <xsl:variable name="noteNum"
                            select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
              <p>
                <xsl:attribute name="id" select="concat('fn', $noteNum)"/>
                <sup>
                  <xsl:choose>
                    <xsl:when test="starts-with($noteNum, '0')">
                      <xsl:value-of select="substring($noteNum, 2, 1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$noteNum"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </sup>
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/>
              </p>
            </xsl:for-each>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="doc" mode="browse-by-date">
    <xsl:call-template name="browse-for-type">
      <xsl:with-param name="type" select="'Date'"/>
      <xsl:with-param name="previous" select="preceding-sibling::doc[1]"/>
      <xsl:with-param name="next" select="following-sibling::doc[1]"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="browse-for-type">
    <xsl:param name="type"/>
    <xsl:param name="previous"/>
    <xsl:param name="next"/>
    <li>
      <xsl:value-of select="$type"/>
      <xsl:text>: </xsl:text>
      <xsl:choose>
        <xsl:when test="$previous">
          <a href="{$previous/str[@name='fileId']}.html">Previous</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Previous</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> and </xsl:text>
      <xsl:choose>
        <xsl:when test="$next">
          <a href="{$next/str[@name='fileId']}.html">Next</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Next</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="tei:opener | tei:closer">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:fw[@type='envelope']"/>

  <xsl:template match="tei:note">
    <xsl:choose>
      <xsl:when test="@place='foot'">
        <xsl:variable name="fnNum"
                      select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
        <sup>
          <a class="fnLink">
            <xsl:attribute name="href">
              <xsl:text>#fn</xsl:text>
              <xsl:value-of select="$fnNum"/>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:text>fnLink</xsl:text>
              <xsl:value-of select="$fnNum"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="starts-with($fnNum, '0')">
                <xsl:value-of select="substring($fnNum, 2, 1)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$fnNum"/>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:pb">
    <xsl:if test="number(@n) > 1">
      <xsl:text> {</xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>} </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:ptr">
    <xsl:variable name="ptrNum"
                  select="substring(substring-after(@corresp, '-'), 3, 2)"/>
    <sup>
      <a>
        <xsl:attribute name="href">
          <xsl:text>#fn</xsl:text>
          <xsl:value-of select="$ptrNum"/>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="starts-with(@corresp, 'http://')">
            <xsl:call-template name="external-link"/>
          </xsl:when>
          <xsl:when test="starts-with(@corresp, '#')">
            <xsl:attribute name="title">
              <xsl:text>Link internal to this page</xsl:text>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="title">
              <xsl:text>Encoding error: @corresp does not start with 'http://' and not internal link</xsl:text>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="starts-with($ptrNum, '0')">
            <xsl:value-of select="substring($ptrNum, 2, 1)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$ptrNum"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </sup>
  </xsl:template>

  <xsl:template match="tei:salute">
    <br/>
    <xsl:if test="parent::tei:opener">
      <br/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:signed">
    <br/>
    <xsl:text>[</xsl:text>
    <em>signed:</em>
    <xsl:text>] </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>