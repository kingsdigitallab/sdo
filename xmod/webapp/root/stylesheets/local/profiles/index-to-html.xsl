<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:import href="../default.xsl" />

  <xsl:param name="menutop" select="'true'" />

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />

  <xsl:variable name="xmg:title"
    select="concat(upper-case(substring($filename, 1, 1)), substring($filename, 2), ' Index')" />
  <xsl:variable name="root" select="/" />
  
  <!-- <xsl:key match="/*/indices/index[@name=$filename]/entry" name="alpha-profiles" use="upper-case(substring(@sortkey, 1, 1))" /> -->
  
  
  <!-- 
    NB: Currently this file gets the list of all the entities referred to in the documents and uses that list as the master list for the short biographies. 
    Alterately it's possible to just get the values from the /*/eats/entities page which is quicker but includes a bunch of entities about whom there is not only no information but which are not referenced by any documents meaning the page is both blank and pointless.
  -->
  <xsl:variable name="other-entities">
    <xsl:for-each select="/*//lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='entity_key']/int"> 
    <!--<xsl:for-each select="/*/eats/entities/entity">-->
      <xsl:variable name="ent_id" select="@name" />  
      <!--<xsl:variable name="ent_id" select="keys/key" />-->
      
      <xsl:if test="not(/*/indices/index/entry[@xml:id = $ent_id])">
    	<xsl:variable name="type" select="/*/eats/entities/entity[keys/key = $ent_id]/types/type" />
       	<xsl:variable name="name" select="/*/eats/entities/entity[keys/key = $ent_id]/names/name[@is_preferred = 'true']" /> 
       	<xsl:variable name="related-name" select="/*/eats/entities/entity[keys/key = $ent_id]/relationships/relationship[@type = 'is composed by']/names/name[@is_preferred = 'true']/text()[1]" />
        
       <!-- <xsl:variable name="type" select="types/type" />
        <xsl:variable name="name" select="names/name[@is_preferred = 'true']" /> -->
        
        <xsl:variable name="entity-name">
            <xsl:choose>
              <xsl:when test="contains($name, '(')"><xsl:value-of select="normalize-space(substring-before($name, '('))" /></xsl:when>
              <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="related-entity-name">
            <xsl:choose>
              <xsl:when test="not($related-name)"><xsl:text>Unknown:</xsl:text></xsl:when>            
              <xsl:when test="contains($related-name, '(')"><xsl:value-of select="normalize-space(substring-before($related-name, '('))" /></xsl:when>
              <xsl:otherwise><xsl:value-of select="$related-name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="suffix">
            <xsl:choose>
              <xsl:when test="contains($name, '(')"><xsl:text>(</xsl:text><xsl:value-of select="substring-after($name, '(')" /></xsl:when>
            </xsl:choose>
        </xsl:variable>
          
        <xsl:variable name="tokenised-name" select="tokenize($entity-name, '\s+')" />        
        <xsl:variable name="tokenised-related-name" select="tokenize($related-entity-name, '\s+')" />    
        
        <!-- 
          /*/eats/entities/entity[types/type = $type]/relationships/relationship[@type = 'is composed by']/names/[name = $related-name]
        -->
        
        <xsl:variable name="name-count" select="count(/*/eats/entities/entity[types/type = $type]/relationships/relationship[@type = 'is composed by']/names[name = $related-name])" />
        
        <xsl:variable name="surname" select="$tokenised-related-name[last()]" />  
        
        <xsl:variable name="surname-count" select="count(/*/eats/entities/entity[types/type = $type]/relationships/relationship[@type = 'is composed by']/names/name[@is_preferred = 'true' and contains(text()[1], $surname[1])])" />     
        
        <xsl:variable name="forenames"><xsl:for-each select="$tokenised-name"><xsl:if test="not(position() eq last())"><xsl:value-of select="." /><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:variable>
        
        <xsl:variable name="initials"><xsl:for-each select="$tokenised-related-name"><xsl:if test="not(position() eq last())"><xsl:text> </xsl:text><xsl:value-of select="substring(., 1, 1)" /><xsl:text>.</xsl:text></xsl:if></xsl:for-each></xsl:variable>
        
        <entity>
          
        <entity-id><xsl:value-of select="$ent_id"/></entity-id>
        <title><xsl:value-of select="$name"/></title> 
 
        <xsl:choose>
        
          <xsl:when test="$type = 'person' and count($tokenised-name) > 1 and not($tokenised-name[last()] = 'I') and not($tokenised-name[last()] = 'II') and not($tokenised-name[last()] = 'family')">                   
            <filing_title><xsl:value-of select="$tokenised-name[last()]" /><xsl:text>, </xsl:text><xsl:value-of select="normalize-space($forenames)" /><xsl:text> </xsl:text><xsl:value-of select="$suffix" /></filing_title>
          </xsl:when>
          <!-- composer: composition title -->
          
          <xsl:when test="$type = 'composition' and count($tokenised-related-name) > 1 and not($tokenised-related-name[last()] = 'I') and not($tokenised-related-name[last()] = 'II')">
            <filing_title><xsl:value-of select="$tokenised-related-name[last()]" /><xsl:if test="$name-count != $surname-count"><xsl:text>,</xsl:text><xsl:value-of select="$initials"/></xsl:if><xsl:text>: </xsl:text><xsl:value-of select="$name"/></filing_title>
          </xsl:when> <!---->

          <xsl:when test="$type = 'composition'">
          	<filing_title><xsl:value-of select="$tokenised-related-name" /><xsl:text> </xsl:text><xsl:value-of select="$name"/></filing_title>
          </xsl:when> <!---->
                    
          <xsl:otherwise><filing_title><xsl:value-of select="$name"/></filing_title></xsl:otherwise>
          
        </xsl:choose> 
        
          <type><xsl:value-of select="$type"/></type>
        </entity>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="index">
    <xsl:for-each select="/*/indices/index[@name=$filename]/entry">
      <xsl:copy-of select="." />
    </xsl:for-each>  
    
    <xsl:for-each select="$other-entities/child::*">
      <xsl:if test="child::*[name()='type'] = $filename and not(/*/indices/index[@name=$filename]/entry[@xml:id = child::*[name()='entity-id']])">
        <entry>
          <xsl:for-each select="child::*">
            <xsl:choose>
              <xsl:when test="name() = 'entity-id'">
                <xsl:attribute name="xml:id"><xsl:value-of select="." /></xsl:attribute>
                <xsl:attribute name="filename"><xsl:value-of select="." /><xsl:text>.html</xsl:text></xsl:attribute>
              </xsl:when>
              <xsl:when test="name() = 'filing_title'">
                <xsl:attribute name="filing_title"><xsl:call-template name="parse"><xsl:with-param name="value" select="."/></xsl:call-template></xsl:attribute>
                <xsl:attribute name="sortkey">
                  
                  <xsl:variable name="parsed"><xsl:call-template name="parse"><xsl:with-param name="value"><xsl:value-of select="."/></xsl:with-param></xsl:call-template></xsl:variable>
                  <!-- <xsl:variable name="deaccented_first"><xsl:value-of select="replace(normalize-unicode(substring(normalize-space($parsed), 1, 1),'NFKD'),'[^A-Za-z0-9]','')" /></xsl:variable> -->
                  
                  <xsl:variable name="deaccented"><xsl:value-of select="replace(normalize-unicode(normalize-space($parsed),'NFKD'),'[^A-Za-z0-9]','')" /></xsl:variable>
                  
                  <xsl:value-of select="concat(lower-case($deaccented), substring(lower-case(translate(translate(normalize-space($parsed), ' ', '_'), ',', '')), 2))" />
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="name() = 'title'"><xsl:attribute name="title"><xsl:call-template name="parse"><xsl:with-param name="value" select="."/></xsl:call-template></xsl:attribute></xsl:when>
            </xsl:choose>  
          </xsl:for-each>
        </entry>
      </xsl:if>   
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:key match="$index/child::*" name="alpha-profiles" use="upper-case(substring(@sortkey, 1, 1))" />

  <xsl:template name="xms:content">
 
      <!--     <xsl:if test="child::*[name()='type'] = $filename">{<xsl:for-each select="child::*"><xsl:value-of select="." /></xsl:for-each>}</xsl:if>
      <xsl:if test="child::*[name()='type'] = $filename">[<xsl:value-of select=".[name()='filing_title']" />]</xsl:if> -->

<!--{<xsl:value-of select="count($index/child::*)" />}
  <xsl:for-each select="$index/child::*">
     <p> {<xsl:value-of select="@*"></xsl:value-of>}</p>
   </xsl:for-each> -->
    
     
    
    <xsl:variable as="xs:string" name="alphabet" select="'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'" />
    
    
    
   <!-- <xsl:if test="/*/indices/index[@name=$filename]/entry"> -->
    <xsl:if test="count($index/child::*)">
      <div class="alphaNav">
        <div class="t01">
          <ul>
            <xsl:for-each select="tokenize($alphabet, ',')">
              <li>
                <xsl:choose>
                  <xsl:when test="key('alpha-profiles', ., $index)">
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

      <!--<xsl:for-each-group group-by="substring(@sortkey, 1, 1)" select="/*/indices/index[@name=$filename]/entry"> -->
      <xsl:for-each-group group-by="substring(@sortkey, 1, 1)" select="$index/child::*">
        <xsl:sort select="@sortkey" /> 
        <h3>
          <a name="{upper-case(substring(current-grouping-key(), 1))}" />
          <xsl:value-of select="upper-case(substring(current-grouping-key(), 1))" />
        </h3>
        <ul>
          <xsl:for-each select="current-group()">
            <xsl:sort select="@sortkey" />
            <li>
              <xsl:variable name="id" select="@xml:id"/>
              <a href="{@filename}" title="{@title}">
                <xsl:value-of select="@filing_title" />
              </a> <!--<xsl:if test="not(@key)"><xsl:text> (short)</xsl:text></xsl:if>--> 
              
              <xsl:variable name="source" select="concat('../../../xml/content/', $filedir, '/', replace(@filename, 'html', 'xml'))" />
              <!--[<xsl:value-of select="$source" />]-->
              
              <!-- rather than using @key, could use doc-available($source) which will check whether the document exists or not in the file system -->
              <xsl:if test="@key">
                     <img src="{$xmp:assets-path}/i/profile.png" alt="[Profile]" class="profile-icon"/> <!---->
                <xsl:if test="boolean(document($source)//tei:graphic)">
                   <xsl:text>+</xsl:text><img src="{$xmp:assets-path}/i/camera.png" alt="[Images]"/>
                   </xsl:if> 
               <!-- <xsl:choose>
                  <xsl:when test="boolean(document($source)//tei:graphic)"><img src="{$xmp:assets-path}/i/profile-image.png" alt="[Illustrated Profile]"/></xsl:when>
                  <xsl:otherwise><img src="{$xmp:assets-path}/i/profile.png" alt="[Profile]"/></xsl:otherwise>
                </xsl:choose>-->
              </xsl:if> 
            </li>
          </xsl:for-each>
        </ul>
      </xsl:for-each-group>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="parse">
    <xsl:param name="value" />
    <xsl:param name="trans" />
    <xsl:choose>
      <xsl:when test="normalize-space($value) = ''"><xsl:text>Unknown</xsl:text></xsl:when>
      <xsl:otherwise><xsl:value-of select="normalize-space($value)" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
