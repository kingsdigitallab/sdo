<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:marcrel="http://www.loc.gov/loc.terms/relators/" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../../xmod/solr/tei-eats-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Nov 15, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> pcaton</xd:p>
      <xd:p>This stylesheet converts a TEI document together with an EATSML document into a Solr index document. It
        expects the parameter file-path, which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>

  <!-- <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template> -->
  
  <xsl:template match="/">
    <add>
      <xsl:variable name="fileId">
      	<xsl:choose>
      	<xsl:when test="//sdo:recordCollection">
       		<xsl:value-of select="//sdo:recordCollection/sdo:collectionDesc/sdo:source/*[1]/@sdoID" />  
       	</xsl:when>
       	<xsl:otherwise>
       		<xsl:text>n/a</xsl:text>
       	</xsl:otherwise>
       	</xsl:choose>
      </xsl:variable>
      
      <xsl:for-each select="//tei:body">
      
      <xsl:variable name="eats_key" select="ancestor::tei:TEI/@xml:id" />  
      <xsl:variable name="eats_type" select="../../../../eats/entities/entity[keys/key = $eats_key]/types/type[1]" />
      
      <!-- begin the metadata <doc> -->
      
      <doc>
      	
      	<!-- REQUIRED -->
        
          <field name="fileId">
            <xsl:value-of select="$eats_key" />
          </field>
          
          <field name="recordId">
            <xsl:text></xsl:text>
          </field>  
          
         <!-- END REQUIRED -->

		<xsl:if test="$eats_type != ''">
      	 <field name="kind">
      	 	<xsl:value-of select="$eats_type" />
         	<!--<xsl:value-of select="distinct-values(../../../../eats/entities/entity[keys/key = $eats_key]/types/type)" /> -->
        </field> 
		</xsl:if>
          
          <field name="file">
            <xsl:value-of select="$file-path" />
          </field>

          <field name="url">
            <!-- The partial URL for the resource this is a record
                 for, to be concatenated with the xmg:pathroot in the
                 display XSLT. -->
            <xsl:value-of select="$eats_type" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$eats_key" />
            <!-- It would be nicer to leave the extension out, to
                 allow more easily for different rendering
                 options. However, since there's likely only to ever
                 be HTML, this saves repeating adding the same
                 extension everywhere when rendering a document. -->
            <xsl:text>.html</xsl:text>
          </field>

            <field name="title">
              <xsl:for-each select="../../../../eats/entities/entity[keys/key = $eats_key]/names/name">
              	<xsl:if test="@is_preferred = 'true'"><xsl:value-of select="." /></xsl:if>
              </xsl:for-each>
            </field>

          <field name="text">
            <xsl:variable name="free-text">
              <xsl:apply-templates mode="free-text" select="tei:div" />
            </xsl:variable>

            <xsl:value-of select="normalize-space($free-text)" />
          </field>
        
       </doc>      
      </xsl:for-each>

      <!-- each Solr doc is based on a single sdo:record -->
    <xsl:for-each select="//sdo:record">
        <!-- $kind refers to whether it is correspondence, diary, etc. -->
        <xsl:variable name="source" select="local-name(preceding-sibling::sdo:collectionDesc/sdo:source/*[1])" />
        <xsl:variable name="kind">
          <xsl:choose>
            <xsl:when test="$source = 'diary'">
              <xsl:text>diaries</xsl:text>
            </xsl:when>
            <xsl:when test="$source = 'lessonbook'">
              <xsl:text>lessonbooks</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$source" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="recordId" select="@ID" />

        <!-- begin the metadata <doc> -->
        <doc>

		<!-- REQUIRED -->
          <field name="fileId">
            <xsl:value-of select="$fileId" />
          </field>

          <field name="recordId">
            <xsl:value-of select="$recordId" />
          </field>
     	
     	<!-- END REQUIRED -->
     	
          <field name="kind">
            <xsl:value-of select="$kind" />
          </field>

          <field name="shelfmark">
            <xsl:value-of select="preceding-sibling::sdo:collectionDesc/sdo:source/*[1]" />
          </field>


          <field name="url">
            <!-- The partial URL for the resource this is a record
                 for, to be concatenated with the xmg:pathroot in the
                 display XSLT. -->
            <xsl:value-of select="$kind" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$fileId" />
            <xsl:if test="$kind = 'lessonbooks' or $kind = 'diaries'">
              <xsl:text>/</xsl:text>
              <xsl:value-of select="$recordId" />
            </xsl:if>
            <!-- It would be nicer to leave the extension out, to
                 allow more easily for different rendering
                 options. However, since there's likely only to ever
                 be HTML, this saves repeating adding the same
                 extension everywhere when rendering a document. -->
            <xsl:text>.html</xsl:text>
          </field>

          <xsl:if test="$kind = 'correspondence'">
            <field name="description">
              <xsl:value-of select="sdo:itemDesc/dc:description" />
            </field>

            <xsl:for-each select="sdo:itemDesc/marcrel:correspondent">
              <field name="correspondent">
                <xsl:value-of select="@key" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="." />
              </field>
            </xsl:for-each>            

            <xsl:for-each select="sdo:itemDesc/marcrel:recipient">
              <field name="recipient">
                <xsl:value-of select="@key" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="." />
              </field>
            </xsl:for-each>
          </xsl:if>

		<xsl:for-each select="sdo:itemDesc/marcrel:author">
             <field name="author_key">
               <xsl:value-of select="@key" />
             </field>
             <field name="entity_key">
               <xsl:value-of select="@key" />
             </field>
             <field name="author">
               <xsl:value-of select="." />
             </field>
           </xsl:for-each>

          <xsl:if test="$kind != 'diaries'">
            <field name="title">
              <xsl:value-of select="sdo:itemDesc/dc:title" />
            </field>
          </xsl:if>


          <xsl:if test="$kind = 'lessonbooks'">
            <field name="pupil">
              <xsl:value-of select="sdo:itemDesc/tei:rs[@role='pupil']/@key" />
              <xsl:text> </xsl:text>
              <xsl:value-of select="sdo:itemDesc/tei:rs[@role='pupil']" />
            </field>
          </xsl:if>

          <xsl:if test="substring(sdo:itemDesc/dcterms:created, 9, 4) != '[DD]'">
            <!-- in full W3C format Solr requires: yyyy-mm-ddT12:00:00Z -->
            <field name="dateFull">
              <xsl:value-of select="sdo:itemDesc/dcterms:created" />
            </field>
            <!-- as a handy string: yyyy-mm-dd -->
            <field name="dateShort">
              <xsl:value-of select="substring(sdo:itemDesc/dcterms:created, 1, 10)" />
            </field>
            <!-- year only for saison: yyyy -->
            <field name="dateYear">
              <xsl:value-of select="substring(sdo:itemDesc/dcterms:created, 1, 4)" />
            </field>
          </xsl:if>

          <field name="type">
            <xsl:value-of select="sdo:itemDesc/tei:rs[@role='corr-item-type']/@key" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="sdo:itemDesc/tei:rs[@role='corr-item-type']" />
          </field>       

          <xsl:for-each select="sdo:itemDesc/tei:rs[@role='correspondence']">
            <field name="correspondence">
              <xsl:value-of select="@key" />
              <xsl:text> </xsl:text>
              <xsl:value-of select="replace(., '\s~\s', '_')" />
            </field>
          </xsl:for-each>

          <field name="file">
            <xsl:value-of select="$file-path" />
          </field>

          <xsl:for-each select="distinct-values(descendant::tei:*[@key]/@key)">
            <field name="entity_key">
              <xsl:value-of select="." />
            </field>
          </xsl:for-each>

          <field name="text">
            <xsl:variable name="free-text">
              <xsl:apply-templates mode="free-text" select="tei:div" />
            </xsl:variable>

            <xsl:value-of select="normalize-space($free-text)" />
          </field>
          
          
          <field name="illustrated">
            <xsl:choose>
              <xsl:when test="//tei:figure">true</xsl:when>
              <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
          </field>         
          
          <xsl:for-each select="tei:div[@type='transcription']//tei:term">           
            <field name="term">
              <xsl:value-of select="normalize-space(lower-case(.))" />
            </field>
            
            <xsl:choose>
              <xsl:when test="@xml:lang and @xml:lang != 'de'">
              <field>
                <xsl:attribute name="name"><xsl:value-of select="concat('term_', @xml:lang)" /></xsl:attribute>
                <xsl:value-of select="normalize-space(lower-case(.))" />
              </field>                 
              </xsl:when>
              <xsl:otherwise>
              <field name="term_de">
                <xsl:value-of select="normalize-space(lower-case(.))" />
              </field>               
              </xsl:otherwise>
              </xsl:choose>        
          </xsl:for-each>    

          <xsl:for-each select="tei:div[@type='translation']//tei:term">           
            <field name="term">
              <xsl:value-of select="normalize-space(lower-case(.))" />
            </field>
            
            <xsl:choose>
              <xsl:when test="@xml:lang and @xml:lang != 'en'">               
                <field>
                  <xsl:attribute name="name"><xsl:value-of select="concat('term_', @xml:lang)" /></xsl:attribute>
                  <xsl:value-of select="normalize-space(lower-case(.))" />
                </field>                 
              </xsl:when>
              <xsl:otherwise>
                <field name="term_en">
                  <xsl:value-of select="normalize-space(lower-case(.))" />
                </field>               
              </xsl:otherwise>
            </xsl:choose>        
          </xsl:for-each> 

          <xsl:for-each select="//tei:foreign">  
            <field name="foreign_word">
              <xsl:value-of select="normalize-space(lower-case(.))" />
            </field>
            
            <field>
              <xsl:attribute name="name"><xsl:value-of select="concat('foreign_word_', @xml:lang)" /></xsl:attribute>
              <xsl:value-of select="normalize-space(lower-case(.))" />
            </field>                       
          </xsl:for-each> 

        </doc>
      </xsl:for-each>

    </add>
  </xsl:template>
  
</xsl:stylesheet>
