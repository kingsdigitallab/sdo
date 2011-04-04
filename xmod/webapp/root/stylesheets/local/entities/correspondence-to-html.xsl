<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../profiles/profile-to-html.xsl"/>

  <xsl:param name="entity"/>

  <xsl:variable name="xmg:title">
    <!-- We should really be aggregating a search for the EATS entity
         data, and getting the title from there, rather than using
         text that comes from a random TEI document. -->
    <xsl:value-of select="substring-after(/aggregation/response/result/doc[1]/arr[@name='correspondence']/str[substring-before(., ' ') = $entity], ' ')"/>
  </xsl:variable>

  <xsl:template name="xms:content">
    <xsl:apply-templates select="/aggregation/tei:TEI"/>
    <div>
      <xsl:choose>
        <xsl:when test="/aggregation/response/result/doc">
          <p>Documents comprising this correspondence:</p>

          <ul>
            <xsl:apply-templates select="/aggregation/response/result/doc"/>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <p>There are no documents in this correspondence.</p>
        </xsl:otherwise>
      </xsl:choose>      
    </div>
  </xsl:template>

</xsl:stylesheet>
