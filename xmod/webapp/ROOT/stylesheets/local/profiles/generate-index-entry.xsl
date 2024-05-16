<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="filename"/>

  <xsl:template match="/">
    <entry xml:id="{tei:TEI/@xml:id}" filename="{$filename}"
           title="{tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]}"
           filing_title="{tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'file']/tei:term}"
           sortkey="{tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'file']/tei:term/@sortKey}"
           key="{tei:TEI/tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords[@scheme='EATS']/tei:term/@key}"/>
  </xsl:template>

</xsl:stylesheet>