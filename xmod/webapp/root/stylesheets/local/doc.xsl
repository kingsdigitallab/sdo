<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:egxml="http://www.tei-c.org/ns/Examples" xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl"/>

  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>

  <xsl:variable name="xmg:title" select="//tei:titleStmt/tei:title"/>
  <xsl:variable name="xmg:pathroot" select="$filedir"/>
  <xsl:variable name="xmg:path"
    select="concat($filedir, '/', substring-before($filename, '.'), '.', $fileextension)"/>

  <xsl:template match="/">
    <xsl:apply-imports/>
  </xsl:template>

  <xsl:template name="xms:content">
    <div>
      <h1>
        <xsl:value-of select="$xmg:title"/>
      </h1>
      <xsl:apply-templates select="//tei:sourceDesc"/>
    </div>
    <div>
      <h3>Contents by Module</h3>
      <ol>
        <xsl:for-each
          select="//tei:elementSpec/@module[not(. = preceding::tei:elementSpec/@module)]">
          <xsl:variable name="module" select="."/>

          <li>
            <xsl:choose>
              <xsl:when test="contains(.,'derived-module-')">
                <a href="#CCH">
                  <xsl:text>CCH</xsl:text>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="#{.}">
                  <xsl:value-of select="."/>
                </a>
              </xsl:otherwise>
            </xsl:choose>

            <ul>
              <li>
                <xsl:for-each select="//tei:elementSpec[@module = $module]">
                  <xsl:sort select="@ident"/>

                  <a href="#{@ident}">
                    <xsl:value-of select="@ident"/>
                  </a>
                  <xsl:text> </xsl:text>
                </xsl:for-each>
              </li>
            </ul>
          </li>
        </xsl:for-each>
      </ol>
    </div>

    <xsl:for-each select="//tei:elementSpec">
      <xsl:sort select="@module"/>
      <xsl:call-template name="elements"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:classSpec"/>

  <xsl:template name="elements">
    <xsl:if test="@module[not(. = preceding::tei:elementSpec/@module)]">
      <h2>
        <xsl:attribute name="id">
          <xsl:choose>
            <xsl:when test="@module[contains(., 'derived-module-')]">
              <xsl:text>CCH</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@module"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="@module[contains(., 'derived-module-')]">
            <xsl:text>CCH</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@module"/>
          </xsl:otherwise>
        </xsl:choose>
      </h2>
    </xsl:if>

    <h4 id="{@ident}">&lt;<xsl:value-of select="@ident"/>&gt;</h4>

    <table>
      <tr>
        <td class="def" valign="top">Module</td>
        <td>
          <xsl:value-of select="@module"/>
        </td>
      </tr>
      <tr>
        <td class="def" valign="top">Definition</td>
        <td>
          <xsl:if test="gloss[not(@xml:lang)]"><xsl:value-of select="gloss[not(@xml:lang)]"/>,</xsl:if>
          <xsl:value-of select="desc[not(@xml:lang)]"/>
        </td>
      </tr>
      <tr>
        <td style="border-right:solid thin;" valign="top">Content</td>
        <td>
          <xsl:value-of select="tei:content/rng:ref/@name"/>
        </td>
      </tr>
      <tr>
        <td class="def" valign="top">Member of</td>
        <td>
          <ul>
            <xsl:for-each select="tei:classes/tei:memberOf">
              <li>
                <xsl:value-of select="@key"/>
              </li>
            </xsl:for-each>
          </ul>
        </td>
      </tr>
      <tr>
        <td class="def" valign="top">Attributes</td>
        <td>
          <ul>
            <xsl:for-each select="tei:attList/tei:attRef">
              <li>
                <xsl:choose>
                  <xsl:when test="contains(@name, 'attribute.')">
                    <xsl:value-of select="substring-after(@name, 'attribute.')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                  </xsl:otherwise>
                </xsl:choose>
              </li>
            </xsl:for-each>

            <xsl:for-each select="tei:attList/tei:attDef">
              <li>
                <xsl:text>@</xsl:text>
                <xsl:value-of select="@ident"/>
                <xsl:if test="xmt:desc">
                  <xsl:for-each
                    select="xmt:desc/following-sibling::tei:exemplum[not(@xml:lang)]/egxml:egXML">
                    <p>
                      <xsl:if test="preceding-sibling::tei:p">
                        <xsl:apply-templates select="preceding-sibling::tei:p"/>
                      </xsl:if>
                      <pre><xsl:apply-templates mode="egxml"/></pre>
                    </p>
                  </xsl:for-each>
                </xsl:if>
              </li>
            </xsl:for-each>

            <xsl:if test="tei:attList/tei:attDef[@mode = 'add']">
              <xsl:for-each select="tei:attList/tei:attDef[@mode = 'add']">
                <li>
                  <xsl:text>@xmt:</xsl:text>
                  <xsl:value-of select="@ident"/>
                </li>
              </xsl:for-each>
            </xsl:if>
          </ul>
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">Examples</td>
        <td>
          <xsl:for-each select="tei:exemplum[not(@xml:lang)]/egxml:egXML">
            <p>
              <pre><xsl:apply-templates mode="egxml"/></pre>
            </p>
          </xsl:for-each>
        </td>
      </tr>

      <xsl:if test="tei:remarks[not(@xml:lang)]">
        <tr>
          <td class="def" valign="top">Notes</td>
          <td>
            <xsl:apply-templates select="tei:remarks[not(@xml:lang)]"/>
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

  <xsl:template match="*" mode="egxml">
    <b>
      <span style="color:#00008B">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>
      </span>

      <xsl:for-each select="@*">
        <xsl:text> </xsl:text>
        <span style="color:#CC6633">
          <xsl:value-of select="name()"/>
        </span>
        <span style="color:#993300">
          <xsl:text>=&quot;</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>&quot;</xsl:text>
        </span>
      </xsl:for-each>

      <span style="color:#00008B">
        <xsl:if test="not(./text())">
          <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:text>&gt;</xsl:text>
      </span>
    </b>

    <xsl:if test="comment()">
      <xsl:for-each select="comment()">
        <span style="color:green; font-weight:bold;">
          <xsl:text>&lt;!--</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>--&gt;</xsl:text>
        </span>
      </xsl:for-each>
    </xsl:if>

    <xsl:apply-templates mode="egxml"/>

    <xsl:if test="./text()">
      <span style="color:#00008B">
        <b>
          <xsl:text>&lt;/</xsl:text>
          <xsl:value-of select="name()"/>
          <xsl:text>&gt;</xsl:text>
        </b>
      </span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:gi">
    <xsl:text> &lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:att">
    <xsl:text>@</xsl:text><xsl:value-of select="."/>
  </xsl:template>
</xsl:stylesheet>
