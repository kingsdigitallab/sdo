<xsl:stylesheet version="2.0"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" 
                xmlns:xmtp="http://www.cch.kcl.ac.uk/xmod/template/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a document that includes every template in the
       inheritance chain into a single template with the content
       merged up the chain. -->

  <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

  <xsl:template match="/">
    <axsl:stylesheet version="2.0"
                     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <axsl:template match="/">
        <xsl:apply-templates/>
      </axsl:template>
    </axsl:stylesheet>
  </xsl:template>

  <xsl:template match="xmtp:block">
    <!-- Process the leaf instance of this named block (ie, the
         definition closest to the template being rendered, and
         consequently the last with its name in the XML). -->
    <xsl:apply-templates select="//xmtp:block[@name=current()/@name][not(following::xmtp:block[@name=current()/@name])]"
                         mode="render"/>
  </xsl:template>

  <!-- Render a block's content. -->
  <xsl:template match="xmtp:block" mode="render">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Render the content of this block as defined in the inherited
       template. -->
  <xsl:template match="xmtp:super">
    <xsl:variable name="block-name" select="ancestor::xmtp:block[1]/@name"/>
    <xsl:apply-templates select="preceding::xmtp:block[@name=$block-name][1]"
                         mode="render"/>
  </xsl:template>

  <!-- Copy anything which is not template XML. -->
  <xsl:template match="xmtp:child"/>
  <xsl:template match="xmtp:*">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>