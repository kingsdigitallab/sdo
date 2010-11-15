<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/" xmlns:tei="http://www.tei-c.org/ns/1.0">
  <xsl:import href="../../xmod/solr/tei-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
      which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:variable name="document-metadata">
  </xsl:variable>
  
  <xsl:variable name="free-text">
  </xsl:variable>
  
  <xsl:template match="/">
    <add>
      <xsl:for-each select="//sdo:record">
        <xsl:variable name="fileID"
          select="preceding-sibling::sdo:collectionDesc/sdo:source/child::*[1]/@sdoID"/>
        <xsl:variable name="recordID" select="@ID"/>
        <doc>
          <field name="kind"><!-- whether it is correspondence, diary, etc. -->
            <xsl:value-of
              select="local-name(preceding-sibling::sdo:collectionDesc/sdo:source/child::*[1])"
            />
          </field>
          
          <field name="shelfmark">
            <xsl:value-of
              select="preceding-sibling::sdo:collectionDesc/sdo:source/child::*[1]"
            />
          </field>
          
          <field name="fileId">
            <xsl:value-of select="$fileID"/>
          </field>
          
          <field name="recordId">
            <xsl:value-of select="$recordID"/>
          </field>
          
          <field name="uniqueId"><!-- Solr schema will use this field to uniquely identify records -->
            <xsl:value-of select="concat($recordID, '_', $fileID)"/>
          </field>
          
          <xsl:if
            test="local-name(preceding-sibling::sdo:collectionDesc/sdo:source/child::*[1]) = 'correspondence'">
            <field name="title">
              <xsl:value-of select="child::sdo:itemDesc/dc:title"/>
            </field>
            
            <field name="description">
              <xsl:value-of select="child::sdo:itemDesc/dc:description"/>
            </field>
          </xsl:if>          
          
          <field name="date">
            <xsl:value-of
              select="substring(child::sdo:itemDesc/dcterms:created, 1, 10)"/>
          </field>
                  
          <xsl:for-each select="child::sdo:itemDesc/dcterms:isPartOf">
            <field name="tag">
              <xsl:value-of select="replace(., '\s~\s', '_')"/>
            </field>
          </xsl:for-each>
          
          <field name="file">
            <xsl:value-of select="$file-path" />
          </field>
          
          <field name="document-title">
            <xsl:text>NULL</xsl:text>
          </field>
          
          <field name="author">
            <xsl:text>NULL</xsl:text>
          </field>
          
          <field name="tei-id">
            <xsl:text>NULL</xsl:text>
          </field>
          
          <field name="section-id">
            <xsl:text>NULL</xsl:text>
          </field>
          
          <field name="entity-key">
            <xsl:text>NULL</xsl:text>
          </field>
          
          <field name="entity-name">
            <xsl:text>NULL</xsl:text>
          </field>
          
          <field name="eats-entity-name">
            <xsl:text>NULL</xsl:text>
          </field>
          
        </doc>
      </xsl:for-each>
      
      
      
      
      
    </add>
  </xsl:template>
  
  <xsl:template match="tei:*[@key]" mode="entity-mention">
  </xsl:template>
</xsl:stylesheet>
