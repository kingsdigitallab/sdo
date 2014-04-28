<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" 
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="../default.xsl" />
  <xsl:param name="filter"/>

  <xsl:variable name="xmg:title">
    <xsl:text>Browse Correspondence by Correspondents</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="corresp">
    <xsl:copy-of select="/aggregation/response/result/doc"/>
  </xsl:variable>
  
  <xsl:key match="/aggregation/response/result/doc/arr[@name='correspondence']/str" name="alpha-profiles" use="upper-case(substring(replace(normalize-unicode(normalize-space(substring-after(., ' ')),'NFKD'),'[^A-Za-z0-9 ]',''), 1, 1))" />
  <xsl:variable name="root" select="/" />

  <xsl:template name="xms:content">
    
    <xsl:variable as="xs:string" name="alphabet" select="'All,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'" />
    
    <div class="alphaNav">
      <div class="t01">
        <ul>
          <xsl:for-each select="tokenize($alphabet, ',')">
            <li>
              <xsl:choose>
                <xsl:when test="key('alpha-profiles', ., $root) or . = 'All'">
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
    
    
    <!-- Group by first initial of correspondent. -->
    <xsl:for-each-group group-by="substring(replace(normalize-unicode(normalize-space(substring-after(., ' ')),'NFKD'),'[^A-Za-z0-9 ]',''), 1, 1)"
      select="distinct-values(/aggregation/response/result/doc/arr[@name='correspondence']/str)">
<xsl:sort select="replace(normalize-unicode(normalize-space(substring-after(., ' ')),'NFKD'),'[^A-Za-z0-9 ]','')" />
      
      
      <xsl:if test="upper-case($filter) = upper-case(current-grouping-key()) or $filter = 'All' or ($filter = '' and upper-case(current-grouping-key()) = 'A')">
            
      <h3>
        <a name="{upper-case(current-grouping-key())}" />
        <xsl:value-of select="upper-case(current-grouping-key())" />
      </h3>
 <!--     
      <xsl:for-each select="current-group()">
        
      </xsl:for-each>  
 
      <xsl:for-each-group select="current-group()" group-by="substring-before(., ' ')">
        [[<xsl:value-of select="."/>]]
      </xsl:for-each-group>  
-->     
     
      <ul>
        <xsl:for-each-group select="current-group()" group-by="substring-before(., ' ')">
          <xsl:sort select="replace(normalize-unicode(normalize-space(substring-after(., ' ')),'NFKD'),'[^A-Za-z0-9 ]','')" />                
          
        <li>
          <a>
            <xsl:attribute name="href">
              <xsl:text>/profiles/correspondence/</xsl:text>
              <xsl:value-of select="substring-before(., ' ')" />
              <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="replace(substring-after(., ' '), '_', ' ~ ')" />
          </a>
          
          <xsl:call-template name="add-item-count" />
        </li>

          </xsl:for-each-group>
      </ul>
 <!--      
-->        </xsl:if>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template name="add-item-count">

    <xsl:variable name="entity" select="substring-before(., ' ')"/>
   <!-- [[<xsl:value-of select="$entity"/>]]-->
    
    <xsl:for-each-group select="$corresp/doc/arr[@name='correspondence']/str" group-by="substring-before(., ' ')"> 
      
      <xsl:if test="current-grouping-key() = $entity">  <!---->
        
        
        <xsl:text>: </xsl:text>
        <xsl:value-of select="count(current-group())" />
        <xsl:text> item</xsl:text>
        <xsl:if test="count(current-group()) &gt; 1">
          <xsl:text>s</xsl:text>
        </xsl:if>       
   </xsl:if>      
    </xsl:for-each-group>   
     
  </xsl:template>


</xsl:stylesheet>
