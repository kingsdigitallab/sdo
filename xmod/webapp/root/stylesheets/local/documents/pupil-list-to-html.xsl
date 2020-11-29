<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>
  <xsl:param name="filter"/>

  <xsl:param name="subtype-name"></xsl:param>
  <xsl:param name="subtype-value"></xsl:param>

  <xsl:variable name="xmg:title">
    <xsl:text>Browse Lessonbooks by Pupil </xsl:text>
    <xsl:if test="$subtype-name">
      <xsl:text> for </xsl:text>
      <xsl:value-of select="$subtype-name" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="$subtype-value" />
    </xsl:if>
  </xsl:variable>

  <xsl:key match="/aggregation/response/result/doc/str[@name='pupil']" name="alpha-tags"
    use="upper-case(substring(substring-after(., ' '), 1, 1))" />
  <xsl:variable name="root" select="/" />

  <xsl:template name="xms:content">
    <xsl:variable as="xs:string" name="alphabet" select="'All,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'" />
    <div class="alphaNav">
      <div class="t01">
        <ul>
          <xsl:for-each select="tokenize($alphabet, ',')">
            <li>
              <xsl:choose>
                <xsl:when test="key('alpha-tags', ., $root) or . = 'All'">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="."/>
                    </xsl:attribute>                    
                    <xsl:value-of select="." />
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <span class="s01">
                    <xsl:value-of select="." />
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>

    <xsl:for-each-group group-by="substring(substring-after(., ' '), 1, 1)"
      select="distinct-values(/aggregation/response/result/doc/str[@name='pupil'])">
      <xsl:sort select="substring-after(., ' ')" />
      <xsl:variable name="initial" select="upper-case(current-grouping-key())" />
      <xsl:if test="upper-case($filter) = $initial or $filter = 'All' or ($filter = '' and $initial = 'A')">
        
      <h3 id="{$initial}">
        <xsl:value-of select="$initial" />
      </h3>

      <ul>
        <xsl:for-each select="current-group()[string(substring-before(., ' '))]">
          <xsl:sort select="." />
          <li>
            <a>
              <xsl:attribute name="href">
                <xsl:text>/profiles/person/</xsl:text>
                <xsl:value-of select="substring-before(., ' ')" />
                <xsl:text>.html#lessonbooks</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="substring-after(., ' ')" />
            </a>
          </li>
        </xsl:for-each>
      </ul>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>
