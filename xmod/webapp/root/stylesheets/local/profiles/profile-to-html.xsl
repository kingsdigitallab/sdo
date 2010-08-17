<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
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
          <xsl:value-of select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
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

</xsl:stylesheet>