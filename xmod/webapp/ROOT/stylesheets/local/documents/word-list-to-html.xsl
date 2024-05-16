<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" 
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="../default.xsl" />
  
  <xsl:param name="fq"/>

  <xsl:variable name="xmg:title">
    <xsl:text>Search Foreign Words by Word</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="filter">
    <xsl:choose>
      <xsl:when test="$fq = ''"><xsl:text>foreign_word</xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="$fq"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:key match="/aggregation/response/result/doc/arr[@name=$filter]/str" name="alpha-profiles" use="upper-case(substring(replace(normalize-unicode(normalize-space(.),'NFKD'),'[^A-Za-z0-9 ]',''), 1, 1))" />
  <xsl:variable name="root" select="/" />
  
  <xsl:template name="xms:content">
 
    <xsl:variable as="xs:string" name="alphabet" select="'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'" />

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
    

    
    <xsl:choose>
      <xsl:when test="$filter = 'foreign_word'">
        
        <p><xsl:text>Foreign Word Language Filter: </xsl:text> 
          
          <xsl:for-each-group select="/aggregation/response/result/doc/arr[contains(@name, 'foreign_word_')]/str" group-by="../@name"> 
            
            <xsl:variable name="facet" >
              <xsl:value-of select="substring-after(current-grouping-key(), 'word_')"/>
            </xsl:variable>   
            
            <xsl:choose>
              <xsl:when test="$facet = ''">
                <a>
                  <xsl:attribute name="href"> 
                    <xsl:text>?fq=foreign_word_</xsl:text>
                  </xsl:attribute>
                <xsl:text>Unclassified: </xsl:text>
                <xsl:value-of select="count(distinct-values(/aggregation/response/result/doc/arr[@name=current-grouping-key()]/str))" />
                </a>
                <xsl:text>, </xsl:text>
              </xsl:when>
              <xsl:otherwise>               
                <a>
                  <xsl:attribute name="href"> 
                    <xsl:text>?fq=foreign_word_</xsl:text><xsl:value-of select="$facet" />
                  </xsl:attribute>
                  <xsl:value-of select="$facet" /><xsl:text>: </xsl:text><xsl:value-of select="count(distinct-values(/aggregation/response/result/doc/arr[@name=current-grouping-key()]/str))" />
                </a>
                <xsl:if test="not(position() = last())">,</xsl:if><xsl:text> </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
                       
          </xsl:for-each-group>
        </p>               
      </xsl:when>
      <xsl:otherwise>
        <p>Remove filter -                
          <a>
            <xsl:attribute name="href">?fq=foreign_word</xsl:attribute>  
            <xsl:text>Language: </xsl:text><xsl:value-of select="substring-after($fq, 'word_')"/>
        </a></p>
      </xsl:otherwise>
    </xsl:choose>
      
    <!-- Group by item type. -->
    <xsl:for-each-group group-by="substring(replace(normalize-unicode(normalize-space(.),'NFKD'),'[^A-Za-z0-9 ]',''), 1, 1)"
      select="distinct-values(/aggregation/response/result/doc/arr[@name=$filter]/str)">
      
      <xsl:sort select="replace(normalize-unicode(normalize-space(.),'NFKD'),'[^A-Za-z0-9 ]','')" />
      
      <h3>
        <a name="{upper-case(substring(current-grouping-key(), 1))}" />
        <xsl:value-of select="upper-case(substring(current-grouping-key(), 1))" />
      </h3>
      
      <ul>
        <xsl:for-each select="current-group()">
          <xsl:sort select="replace(normalize-unicode(normalize-space(.),'NFKD'),'[^A-Za-z0-9 ]','')" />
        <li>
          <a>
              <xsl:attribute name="href">
                <xsl:text>/search/?fq=foreign_word&amp;kw=</xsl:text>
                <xsl:value-of select="." />
                <xsl:if test="not($filter = 'foreign_word') and not($filter = 'foreign_word_')">
                  <xsl:text>&amp;fq2=</xsl:text>
                  <xsl:value-of select="$fq" />
                </xsl:if>
              </xsl:attribute>
              <xsl:value-of select="." />
          </a>
         <!-- <xsl:call-template name="add-item-count" /> -->
        </li>
        </xsl:for-each>  
      </ul>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template name="add-item-count">
    <xsl:text>: </xsl:text>
    <xsl:value-of select="count(current-group())" />
    <xsl:text> instance</xsl:text>
    <xsl:if test="count(current-group()) &gt; 1">
      <xsl:text>s</xsl:text>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
