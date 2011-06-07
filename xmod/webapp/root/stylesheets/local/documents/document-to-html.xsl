<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:import href="../sdo-p5.xsl"/> 
  <xsl:import href="../default.xsl"/>

  <xsl:param name="filedir" select="'documents/'"/>

  <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[1]"/>

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div>

        <h2>Browse by</h2>

        <xsl:variable name="fileId"
          select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/*[1]/@sdoID"/>

        <xsl:call-template name="browsing-nav">
          <xsl:with-param name="current-item"
            select="/aggregation/response/result/doc[str[@name='fileId']=$fileId]"/>
        </xsl:call-template>
      </div>
      <div class="t01">
        <h1>
          <xsl:if
            test="string-length(/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]/text()) != 0">
            <strong>
              <xsl:value-of
                select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]"
              />
            </strong>
            <xsl:text> - </xsl:text>
          </xsl:if>
          <xsl:value-of select="$record/sdo:itemDesc/dc:title"/>
        </h1>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:content">
    <div class="tabs">

      <ul class="tabNavigation">
        <li>
          <a href="#facingtexts">German and English</a>
        </li>
        <li>
          <a href="#german">German only</a>
        </li>
        <li>
          <a href="#english">English only</a>
        </li>
      </ul>

      <div id="facingtexts">
        <table class="docDisplayGandE">
          <tr>
            <td id="GermanVersion">
              <!-- German version. -->
              <xsl:apply-templates select="$record/tei:div[@type='transcription']"/>
              <div id="transcCopyright">
                <p>&#x00A9; Transcription <xsl:value-of
                    select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt[contains(., 'Transcription')]/tei:persName"
                      /><xsl:choose><xsl:when
                      test="contains(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Transcription')], ',')"
                      >, <xsl:value-of
                        select="substring-after(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Transcription')], ',')"
                      /></xsl:when><xsl:otherwise>.</xsl:otherwise></xsl:choose>
                </p>
              </div>
            </td>
            <td id="EnglishVersion">
              <!-- English version. -->
              <xsl:apply-templates select="$record/tei:div[@type='translation']"/>
              <div id="translCopyright">
                <p>&#x00A9; Translation <xsl:value-of
                    select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt[contains(., 'Translation')]/tei:persName"
                      /><xsl:choose><xsl:when
                      test="contains(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Translation')], ',')"
                      >, <xsl:value-of
                        select="substring-after(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Translation')], ',')"
                      /></xsl:when><xsl:otherwise>.</xsl:otherwise></xsl:choose>
                </p>
              </div>
            </td>
          </tr>
        </table>
      </div>
      <div id="german">
        <table class="docDisplayGandE">
          <tr>
            <td id="GermanVersion">
              <!-- German version. -->
              <xsl:apply-templates select="$record/tei:div[@type='transcription']"/>
              <div id="transcCopyright">
                <p>&#x00A9; Transcription <xsl:value-of
                    select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt[contains(., 'Transcription')]/tei:persName"
                      /><xsl:choose><xsl:when
                      test="contains(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Transcription')], ',')"
                      >, <xsl:value-of
                        select="substring-after(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Transcription')], ',')"
                      /></xsl:when><xsl:otherwise>.</xsl:otherwise></xsl:choose>
                </p>
              </div>
            </td>
          </tr>
        </table>
      </div>
      <div id="english">
        <table class="docDisplayGandE">
          <tr>
            <td id="EnglishVersion">
              <!-- English version. -->
              <xsl:apply-templates select="$record/tei:div[@type='translation']"/>
              <div id="translCopyright">
                <p>&#x00A9; Translation <xsl:value-of
                    select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt[contains(., 'Translation')]/tei:persName"
                      /><xsl:choose><xsl:when
                      test="contains(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Translation')], ',')"
                      >, <xsl:value-of
                        select="substring-after(/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt/tei:resp[contains(., 'Translation')], ',')"
                      /></xsl:when><xsl:otherwise>.</xsl:otherwise></xsl:choose>
                </p>
              </div>
            </td>
          </tr>
        </table>
      </div>
    </div>
    <table class="docDisplayGandE">
      <xsl:if test="$record//tei:note[@place='foot']">
        <tr>
          <td colspan="2">
            <div class="ft">
              <h3>Footnotes</h3>
              <xsl:for-each select="$record//tei:note[@place='foot']">
                <xsl:variable name="noteNum" select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
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
      </xsl:if>
      <xsl:for-each select="/aggregation/commentary/doc[statements/statement]">
        <tr>
          <td colspan="2">
            <div class="ft">
              <h3>Commentary</h3>
              <dl>
                <xsl:for-each select="statements/statement">
                  <dt>
                    <xsl:value-of select="@type"/>
                  </dt>
                  <dd>
                    <xsl:value-of select="."/>
                  </dd>
                </xsl:for-each>
                <xsl:for-each
                  select="container/statements/statement[@type != current()/statements/statement/@type]">
                  <dt>
                    <xsl:value-of select="@type"/>
                  </dt>
                  <dd>
                    <xsl:value-of select="."/>
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
          <a
            href="{concat($xmg:pathroot, xms:path-separator($previous/str[@name='url']), $previous/str[@name='url'])}"
            >Previous</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Previous</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> and </xsl:text>
      <xsl:choose>
        <xsl:when test="$next">
          <a
            href="{concat($xmg:pathroot, xms:path-separator($next/str[@name='url']), $next/str[@name='url'])}"
            >Next</a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Next</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:function name="xms:path-separator" as="xs:string">
    <xsl:param name="path" required="yes"/>

    <xsl:variable name="ps">
      <xsl:for-each select="tokenize($path, '/')">
        <xsl:if test="position() = 1">
          <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:if test="position() != last()">
          <xsl:text>../</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:value-of select="$ps"/>
  </xsl:function>
</xsl:stylesheet>
