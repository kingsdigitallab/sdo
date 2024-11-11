<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

    <xsl:if test="$record/tei:div[@n='early_v']">
      <a href="" id="versionToggle" data-active="final">Show Early Version</a>
    </xsl:if>

    <xsl:if test="$record//tei:note[@place='pre-text']">
      <div class="ft">
        <xsl:for-each select="$record//tei:note[@place='pre-text']">
          <p class="editorial">
            <xsl:apply-templates/>
          </p>
        </xsl:for-each>
      </div>
    </xsl:if>

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
      <!--
      <ul>
        <li class="printNavigation">
          <a href="/{replace($filedir, 'documents', 'mobile')}/{substring-before($filename, '.')}.html" target="_target">Print Preview</a>
        </li>        
      </ul>
      -->
      <div id="facingtexts">
        <table class="docDisplayGandE">
          <tr>
            <td id="GermanVersion">
              <!-- German version. -->
              <div class="finalVersion">
                <xsl:apply-templates
                  select="$record/tei:div[(@type='transcription' and @n='final_v') or (@type='transcription' and not(@n))]"
                />
              </div>
              <xsl:if test="$record/tei:div[@type='transcription' and @n='early_v']">
                <div class="earlyVersion">
                  <xsl:apply-templates
                    select="$record/tei:div[(@type='transcription' and @n='early_v')]"/>
                </div>
              </xsl:if>
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
              <div class="finalVersion">
                <xsl:apply-templates
                  select="$record/tei:div[(@type='translation' and @n='final_v') or (@type='translation' and not(@n))]"
                />
              </div>
              <xsl:if test="$record/tei:div[@type='translation' and @n='early_v']">
                <div class="earlyVersion">
                  <xsl:apply-templates
                    select="$record/tei:div[(@type='translation' and @n='early_v')]"/>
                </div>
              </xsl:if>
              <div id="translCopyright">
                <p>&#x00A9; Translation <xsl:for-each
                    select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt[contains(., 'Translation')]">
                  <xsl:value-of select="tei:persName"/>
                  <xsl:if test="child::tei:resp/child::tei:date"> (<xsl:value-of select="child::tei:resp/child::tei:date"/>)</xsl:if>
                    <xsl:choose><xsl:when test="following-sibling::tei:respStmt[position()=1 and contains(., 'Translation')]">, </xsl:when>
                    <xsl:when
                      test="child::tei:resp[contains(., 'Translation,')]">, <xsl:value-of select="substring-after(child::tei:resp[contains(., 'Translation,')], 'Translation,')"
                        /></xsl:when>
                    <xsl:otherwise>.</xsl:otherwise></xsl:choose>
                  </xsl:for-each>
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
              <div class="finalVersion">
                <xsl:apply-templates
                  select="$record/tei:div[(@type='transcription' and @n='final_v') or (@type='transcription' and not(@n))]"
                />
              </div>
              <xsl:if test="$record/tei:div[@type='transcription' and @n='early_v']">
                <div class="earlyVersion">
                  <xsl:apply-templates
                    select="$record/tei:div[(@type='transcription' and @n='early_v')]"/>
                </div>
              </xsl:if>
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
              <div class="finalVersion">
                <xsl:apply-templates
                  select="$record/tei:div[(@type='translation' and @n='final_v') or (@type='translation' and not(@n))]"
                />
              </div>
              <xsl:if test="$record/tei:div[@type='translation' and @n='early_v']">
                <div class="earlyVersion">
                  <xsl:apply-templates
                    select="$record/tei:div[(@type='translation' and @n='early_v')]"/>
                </div>
              </xsl:if>
              <div id="translCopyright">
                <p>&#x00A9; Translation <xsl:for-each
                  select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:respStmt[contains(., 'Translation')]">
                  <xsl:value-of select="tei:persName"/>
                  <xsl:if test="child::tei:resp/child::tei:date"> (<xsl:value-of select="child::tei:resp/child::tei:date"/>)</xsl:if>
                  <xsl:choose><xsl:when test="following-sibling::tei:respStmt[position()=1 and contains(., 'Translation')]">, </xsl:when>
                    <xsl:when
                      test="child::tei:resp[contains(., 'Translation,')]">, <xsl:value-of select="substring-after(child::tei:resp[contains(., 'Translation,')], 'Translation,')"
                      /></xsl:when>
                    <xsl:otherwise>.</xsl:otherwise></xsl:choose>
                </xsl:for-each>
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
              <xsl:choose>
                <xsl:when test="$record/tei:div[@n='final_v' or @n='early_v']">
                  <div class="finalVersion">
                    <xsl:call-template name="footnotes">
                      <xsl:with-param name="node"
                        select="$record/tei:div[(@n='final_v')]//tei:note[@place='foot']"/>
                      <xsl:with-param name="version" select="'_final'"/>
                    </xsl:call-template>
                  </div>
                  <div class="earlyVersion">
                    <xsl:call-template name="footnotes">
                      <xsl:with-param name="node"
                        select="$record/tei:div[(@n='early_v')]//tei:note[@place='foot']"/>
                      <xsl:with-param name="version" select="'_early'"/>
                    </xsl:call-template>
                  </div>
                </xsl:when>

                <xsl:otherwise>
                  <xsl:call-template name="footnotes">
                    <xsl:with-param name="node" select="$record//tei:note[@place='foot']"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </td>
        </tr>
      </xsl:if>
      <xsl:if
        test="($record//tei:hi[@rend='double-underline']) or ($record//tei:hi[@rend='triple-underline'])">
        <tr>
          <td colspan="2">
            <div class="ft">
              <h3>Format</h3>
              <xsl:if test="$record//tei:hi[@rend='double-underline']">
                <a id="f1">
                  <p><sup>&#8224;</sup> Double underlined</p>
                </a>
              </xsl:if>
              <xsl:if test="$record//tei:hi[@rend='triple-underline']">
                <a id="f2">
                  <p><sup>&#9674;</sup> Triple underlined</p>
                </a>
              </xsl:if>
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
                    <xsl:call-template name="simple-email-encoding"/>
                  </dd>
                </xsl:for-each>
                <xsl:for-each
                  select="container/statements/statement[@type != current()/statements/statement/@type]">
                  <dt>
                    <xsl:value-of select="@type"/>
                  </dt>
                  <dd>
                    <xsl:call-template name="simple-email-encoding"/>
                  </dd>
                </xsl:for-each>
              </dl>
              <p>
                <xsl:text>Digital version created: </xsl:text>
                <xsl:value-of select="$record/sdo:itemDesc/dcterms:dateSubmitted"/>
                <xsl:if test="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:revisionDesc">
                  <br/>
                  <xsl:text>Last updated: </xsl:text>
                  <xsl:value-of
                    select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:revisionDesc/tei:change[last()]/@when"
                  />
                </xsl:if>
              </p>
            </div>
          </td>
        </tr>
      </xsl:for-each>
    </table>

    <xsl:if test="$record/tei:div[@n='early_v']">
      <script type="text/javascript">
        $('.earlyVersion').hide();

        $('#versionToggle').click(function(e){
          e.preventDefault();
          if($(this).attr('data-active')=='final'){
            $('.finalVersion').hide();
            $('.earlyVersion').show();
            $(this).attr('data-active', 'early');
            $(this).text('Show Final Version');
          }
          else if($(this).attr('data-active')=='early'){
            $('.earlyVersion').hide();
            $('.finalVersion').show();
            $(this).attr('data-active', 'final');
            $(this).text('Show Early Version');
          }
        });
      </script>
    </xsl:if>

  </xsl:template>

  <xsl:template name="footnotes">
    <xsl:param name="node"/>
    <xsl:param name="version"/>
    <xsl:for-each select="$node">
      <xsl:variable name="noteNum" select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
      <p>
        <xsl:attribute name="id" select="concat('fn', $noteNum, $version)"/>
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
        <xsl:apply-templates/>
      </p>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="simple-email-encoding">
    <xsl:analyze-string flags="im" regex="([A-Z0-9._+-]+)(@)([A-Z0-9.-]+\.[A-Z]+)" select=".">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
        <xsl:text> [at] </xsl:text>
        <xsl:value-of select="replace(regex-group(3), '\.', ' (dot) ')"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
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

  <xsl:function as="xs:string" name="xms:path-separator">
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

  <xsl:template match="tei:rs[@key]">
    <xsl:variable name="display-name">
      <xsl:for-each select="/*/eats/entities/entity[keys/key = current()/@key]">
        <xsl:choose>
          <xsl:when test="names/name[@is_preferred = true()]">
            <xsl:value-of select="names/name[@is_preferred = true()]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="names/name[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <a href="/profiles/{@type}/{@key}.html" title="{$display-name}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
</xsl:stylesheet>
