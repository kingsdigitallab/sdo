<xsl:stylesheet version="2.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:param name="menutop" select="'true'"/>

  <xsl:variable name="xmg:title"><xsl:text>Browse Correspondence By Name</xsl:text></xsl:variable>
  <xsl:variable name="root" select="/"/>

  <xsl:key name="alpha-tags" match="//arr[@name='tag']/str"
           use="upper-case(substring(., 1, 1))"/>

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

      <xsl:for-each-group select="distinct-values(//arr[@name='tag']/str)"
                          group-by="substring(., 1, 1)">
        <xsl:sort select="."/>
        <h3>
          <a name="{upper-case(substring(current-grouping-key(), 1))}"/>
          <xsl:value-of select="upper-case(substring(current-grouping-key(), 1))"/>
        </h3>
        <ul>
          <xsl:for-each select="current-group()">
            <xsl:sort select="."/>
            <li>
              <a href="{concat('correspondence/name/summary/', .)}">
                <xsl:value-of select="replace(., '_', ' ~ ')"/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:for-each-group>
    
  </xsl:template>

</xsl:stylesheet>