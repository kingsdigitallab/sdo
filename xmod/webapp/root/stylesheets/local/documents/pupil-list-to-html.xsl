<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:variable name="xmg:title" select="'Browse Lessonbooks by Pupil'"/>

  <xsl:key name="alpha-tags"
           use="upper-case(substring(substring-after(., ' '), 1, 1))"
           match="/aggregation/response/result/doc/str[@name='pupil']"/>
  <xsl:variable name="root" select="/"/>

  <xsl:template name="xms:content">
    <xsl:variable name="alphabet" as="xs:string"
                  select="'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'"/>
    <div class="alphaNav">
      <div class="t01">
        <ul>
          <xsl:for-each select="tokenize($alphabet, ',')">
            <li>
              <xsl:choose>
                <xsl:when test="key('alpha-tags', ., $root)">
                  <a href="#{.}">
                    <xsl:value-of select="."/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <span class="s01">
                    <xsl:value-of select="."/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>

    <xsl:for-each-group select="distinct-values(/aggregation/response/result/doc/str[@name='pupil'])" group-by="substring(substring-after(., ' '), 1, 1)">
      <xsl:sort select="substring-after(., ' ')"/>
      <xsl:variable name="initial"
                    select="upper-case(substring(current-grouping-key(), 1))"/>
      <h3 id="{$initial}">
        <xsl:value-of select="$initial"/>
      </h3>

      <ul>
        <xsl:for-each select="current-group()">
          <xsl:sort select="."/>
          <li>
            <a>
              <xsl:attribute name="href">
                <xsl:text>../../profiles/person/</xsl:text>
                <xsl:value-of select="substring-before(., ' ')"/>
                <xsl:text>.html#lessonbooks</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="substring-after(., ' ')"/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>
