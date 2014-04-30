<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:import href="../default.xsl"/>

  <xsl:param name="menutop" select="'true'"/>

  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>
  <xsl:param name="filter"/>

  <xsl:variable name="xmg:title"
    select="concat(upper-case(substring($filename, 1, 1)), substring($filename, 2), ' Index')"/>
  <xsl:variable name="root" select="/"/>


  <!-- 
    NB: Currently this file gets the list of all the entities referred to in the documents and uses 
    that list as the master list for the short biographies. 
    Alterately it's possible to just get the values from the /*/eats/entities page which is quicker 
    but includes a bunch of entities about whom there is not only no information but which are not 
    referenced by any documents meaning the page is both blank and pointless.
  -->
  
  <xsl:variable name="index">
    <xsl:for-each select="/*/list/entry">
      <xsl:copy-of select="."/>
    </xsl:for-each>   
  </xsl:variable>

  <xsl:key match="$index/child::*" name="alpha-profiles" use="upper-case(substring(@sortkey, 1, 1))"/>
  
  <xsl:variable name="first">
    <xsl:for-each-group select="$index/child::*" group-by="./substring(@sortkey, 1, 1)">
      <xsl:sort select="current-grouping-key()"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="current-grouping-key()"/>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:variable>

  <xsl:template name="xms:content">

    <xsl:variable as="xs:string" name="alphabet"
      select="'All,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'"/>

    <xsl:if test="count($index/child::*)">
      <div class="alphaNav">
        <div class="t01">
          <ul>
            <xsl:for-each select="tokenize($alphabet, ',')">
              <li>
                <xsl:choose>
                  <xsl:when test="(key('alpha-profiles', ., $index) or . = 'All') and . != $filter">
                    <a>
                      <xsl:attribute name="href">
                          <xsl:if test="contains($filedir,'index')"><xsl:text>index/</xsl:text></xsl:if>
                        <xsl:value-of select="."/></xsl:attribute>
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

      <xsl:for-each-group group-by="substring(@sortkey, 1, 1)" select="$index/child::*">
        <xsl:sort select="@sortkey"/>
        <xsl:if test="upper-case(current-grouping-key()) = upper-case($filter) or $filter = 'All' or ($filter = '' and upper-case(current-grouping-key()) = upper-case($first))"> <!---->
        <h3>
          <a name="{upper-case(substring(current-grouping-key(), 1))}"/>
          <xsl:value-of select="upper-case(substring(current-grouping-key(), 1))"/>
        </h3>
        <ul>
          <xsl:for-each select="current-group()">
            <xsl:sort select="@sortkey"/>
            <li>
              <xsl:variable name="id" select="@xml:id"/>
              <a title="{@title}">
                <xsl:attribute name="href">
                  <xsl:text>/</xsl:text><xsl:value-of select="$filedir"/><xsl:text>/</xsl:text><xsl:value-of select="@filename"/>
                </xsl:attribute>
                <xsl:value-of select="@filing_title"/>
              </a>

              <xsl:variable name="source"
                select="concat('../../../xml/content/', $filedir, '/', replace(@filename, 'html', 'xml'))"/>

              <!-- rather than using doc-available($source), could use @key which will check whether there is a key in the index file (although the key is meaningless and should probably be done away with) -->
              <xsl:if test="doc-available($source)">
                <img src="{$xmp:assets-path}/i/profile.png" alt="[Profile]" class="profile-icon"/>
                <!---->
                <xsl:if test="boolean(document($source)//tei:graphic)">
                  <xsl:text>+</xsl:text>
                  <img src="{$xmp:assets-path}/i/camera.png" alt="[Images]"/>
                </xsl:if>
              </xsl:if>
            </li>
          </xsl:for-each>
        </ul>
       </xsl:if><!--  -->
      </xsl:for-each-group>
    </xsl:if>
  </xsl:template>

  <xsl:template name="parse">
    <xsl:param name="value"/>
    <xsl:param name="trans"/>
    <xsl:choose>
      <xsl:when test="normalize-space($value) = ''">
        <xsl:text>Unknown</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($value)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
