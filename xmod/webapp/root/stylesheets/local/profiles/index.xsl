<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:egxml="http://www.tei-c.org/ns/Examples" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
  xmlns:xmi="http://www.cch.kcl.ac.uk/xmod/metadata/indexes/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0"
  xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>
  
  <!-- override the 'false' value of $menutop from ../default.xsl -->
  <xsl:param name="menutop" select="'true'" />

  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>
  
  <xsl:include href="../overrides.xsl"/>
  
  <xsl:variable name="xmg:title" select="'Index'"/>
  <xsl:variable name="xmg:pathroot" select="$filedir"/>
  <xsl:variable name="xmg:path"
    select="concat($filedir, '/', $filename, '.', $fileextension)"/>

  
  <xsl:variable name="root" select="/"/>
  <xsl:key name="alpha-profiles" match="//xmi:index/xmi:entry[@index = $filename]"
    use="upper-case(substring(@sortkey,1,1))"/>

  <xsl:template match="/">
    <xsl:apply-imports/>
  </xsl:template>

<!-- Overridden templates -->
  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:value-of
            select="concat(upper-case(substring($filename,1,1)), lower-case(substring($filename,2)))"/>
        </h1>
      </div>
    </div>
  </xsl:template>
  
  
  <xsl:template name="xms:content">
    
   
    
    <xsl:variable name="alphabet" as="xs:string"
      select="'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'"/>
    
    <xsl:choose>
      <xsl:when test="//xmi:index/xmi:entry">


        <div class="alphaNav">
          <div class="t01">
            <ul>
              <xsl:for-each select="tokenize($alphabet,',')">
                <li>
                  <xsl:choose>
                    <xsl:when test="key('alpha-profiles',.,$root)">
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

        <xsl:for-each-group select="//xmi:index/xmi:entry[contains(@index, $filename)]" group-by="substring(@sortkey,1,1)" >
            <xsl:sort select="@sortkey"/>
          <h3>
            <a name="{upper-case(substring(current-grouping-key(),1))}"/>
            <xsl:value-of select="upper-case(substring(current-grouping-key(),1))"/>
          </h3>
          <ul>
            <xsl:for-each select="current-group()">
             <xsl:sort select="@sortkey"/>

              <li>
                <a href="{@filename}" title="{@title}">
                  <xsl:value-of select="@filingTitle"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:for-each-group>

      </xsl:when>
      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
