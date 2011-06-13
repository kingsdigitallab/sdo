<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl" />

  <xsl:param name="menutop" select="'true'" />

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />

  <xsl:variable name="xmg:title"
    select="concat(upper-case(substring($filename, 1, 1)), substring($filename, 2), ' Index')" />
  <xsl:variable name="root" select="/" />

  <xsl:key match="/*/indices/index[@name=$filename]/entry" name="alpha-profiles"
    use="upper-case(substring(@sortkey, 1, 1))" />

  <xsl:template name="xms:content">
    <xsl:variable as="xs:string" name="alphabet" select="'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'" />
    <xsl:if test="/*/indices/index[@name=$filename]/entry">
      <div class="alphaNav">
        <div class="t01">
          <ul>
            <xsl:for-each select="tokenize($alphabet, ',')">
              <li>
                <xsl:choose>
                  <xsl:when test="key('alpha-profiles', ., $root)">
                    <a href="#{.}">
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

      <xsl:for-each-group group-by="substring(@sortkey, 1, 1)" select="/*/indices/index[@name=$filename]/entry">
        <xsl:sort select="@sortkey" />
        <h3>
          <a name="{upper-case(substring(current-grouping-key(), 1))}" />
          <xsl:value-of select="upper-case(substring(current-grouping-key(), 1))" />
        </h3>
        <ul>
          <xsl:for-each select="current-group()">
            <xsl:sort select="@sortkey" />
            <li>
              <a href="{@filename}" title="{@title}">
                <xsl:value-of select="@filing_title" />
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:for-each-group>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
