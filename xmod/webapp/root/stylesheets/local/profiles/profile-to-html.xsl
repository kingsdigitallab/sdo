<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:param name="menutop" select="'true'"/>

  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:choose>
            <xsl:when test="/*/tei:TEI">
              <xsl:value-of select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$xmg:title"/>
            </xsl:otherwise>
          </xsl:choose>
        </h1>
        
        <xsl:if test="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']">
          <h2>
            <xsl:apply-templates mode="pagehead"
                                 select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']" />
          </h2>
        </xsl:if>
        
        <xsl:variable name="authors-and-editors" select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:*[self::tei:author or self::tei:editor]"/>
        <xsl:if test="$authors-and-editors">
          <p>
            <xsl:text>(</xsl:text>
            <xsl:apply-templates mode="pagehead" select="$authors-and-editors"/>
            <xsl:text>)</xsl:text>
          </p>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:toc1"/>

  <xsl:template name="make-section">
    <xsl:param name="name"/>
    <xsl:param name="id"/>
    <xsl:param name="docs"/>
    <xsl:if test="$docs">
      <div id="{$id}">
        <h2>
          <xsl:value-of select="$name"/>
        </h2>
              
        <ul>
          <xsl:apply-templates select="$docs"/>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="doc">
    <li>
      <p>
        <a href="{$xmp:context-path}/documents/{str[@name='url']}">
          <xsl:choose>
            <xsl:when test="str[@name='title']">
              <xsl:value-of select="str[@name='title']"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Diary entry by Schenker for </xsl:text>
              <xsl:value-of select="format-date(xs:date($date), '[D] [MNn] [Y]')"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </p>
      <xsl:if test="str[@name='description']">
        <p>
          <xsl:value-of select="str[@name='description']"/>
        </p>
      </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>