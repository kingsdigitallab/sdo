<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:eats="http://hdl.handle.net/10063/234"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Nov 4, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>Normalizes the EATSML for Solr indexing.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template match="/">
    <entities>
      <xsl:apply-templates select="eats:collection/eats:entities" />
      <languages>
        <xsl:apply-templates select="eats:collection/eats:languages" />
      </languages>
    </entities>
  </xsl:template>

  <xsl:template match="eats:entity">
    <xsl:variable name="entity-id" select="@xml:id" />

    <entity>
      <keys>
        <xsl:apply-templates select="eats:existence_assertions" />
      </keys>
      <types>
        <xsl:apply-templates select="eats:entity_type_assertions" />
      </types>
      <names>
        <xsl:for-each select="eats:name_assertions/eats:name_assertion">
          <xsl:sort select="@type" />
          
          <xsl:apply-templates select="." />
        </xsl:for-each>
      </names>
      <relationships>
        <xsl:apply-templates mode="direct" select="eats:entity_relationship_assertions" />

        <xsl:for-each
          select="../eats:entity[@xml:id != $entity-id]/eats:entity_relationship_assertions/eats:entity_relationship_assertion[@related_entity = $entity-id]">
          <xsl:apply-templates mode="inverse" select="." />
        </xsl:for-each>
      </relationships>
    </entity>
  </xsl:template>

  <xsl:template match="eats:existence_assertion">
    <key>
      <xsl:apply-templates select="id(@authority_record)" />
    </key>
  </xsl:template>

  <xsl:template match="eats:authority_record">
    <xsl:if test="eats:authority_system_id/@is_complete = 'false'">
      <xsl:apply-templates select="id(@authority)" />
    </xsl:if>

    <xsl:value-of select="eats:authority_system_id" />
  </xsl:template>

  <xsl:template match="eats:authority">
    <xsl:value-of select="eats:base_id" />
  </xsl:template>

  <xsl:template match="eats:entity_type_assertion">
    <type>
      <xsl:apply-templates select="id(@entity_type)" />
    </type>
  </xsl:template>

  <xsl:template match="eats:name_assertion">
    <!-- PC, 23 Apr 2019:  the is_preferred variable introduced to fix a major issue where project partners created numerous 
      entity records without the proper "is_preferred" value. This led to enitities appearing in the profile indices as 'Unknown' -->
    <xsl:variable name="is_preferred">
      <xsl:choose>
        <xsl:when test="@is_preferred='true'">
          <!-- preference has already been made, no problem -->
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:when test="(@is_preferred='false') and not(preceding-sibling::eats:name_assertion) and not(following-sibling::eats:name_assertion)">
          <!-- if condition is met, we don't have other name assertions to worry about, so make this preferred -->
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:when test="(@is_preferred='false') and not(preceding-sibling::eats:name_assertion[@is_preferred='true']) and not(preceding-sibling::eats:name_assertion[@is_preferred='false']) and not(following-sibling::eats:name_assertion[@is_preferred='true']) and (following-sibling::eats:name_assertion[@is_preferred='false'])">
          <!-- there are 2 or more name assertions none of which have been marked preferred: I am the first of them so make me preferred -->
          <xsl:text>true</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>false</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <name is_preferred="{$is_preferred}">
      <xsl:choose>
        <xsl:when test="normalize-space(eats:display_form)">
          <xsl:value-of select="normalize-space(eats:display_form)" />
        </xsl:when>
        <xsl:when test="normalize-space(eats:assembled_form)">
          <xsl:value-of select="normalize-space(eats:assembled_form)" />
        </xsl:when>
      </xsl:choose>
    </name>
  </xsl:template>

  <xsl:template match="eats:entity_relationship_assertion" mode="direct">
    <relationship direction="direct">
      <xsl:attribute name="type">
        <xsl:apply-templates select="id(@type)" />
      </xsl:attribute>

      <xsl:apply-templates mode="related-entity" select="id(@related_entity)" />
    </relationship>
  </xsl:template>

  <xsl:template match="eats:entity" mode="related-entity">
    <keys>
      <xsl:apply-templates select="eats:existence_assertions" />
    </keys>
    <names>
      <xsl:apply-templates select="eats:name_assertions" />
    </names>
  </xsl:template>

  <xsl:template match="eats:entity_relationship_assertion" mode="inverse">
    <relationship direction="inverse">
      <xsl:attribute name="type">
        <xsl:apply-templates select="id(@type)" />
      </xsl:attribute>

      <xsl:apply-templates mode="related-entity" select="ancestor::eats:entity[1]" />
    </relationship>
  </xsl:template>
  
  <xsl:template match="eats:language">
    <language>
      <name><xsl:value-of select="normalize-space(eats:name)"/></name>
      <code><xsl:value-of select="normalize-space(eats:code)"/></code>
    </language>
  </xsl:template>
  
</xsl:stylesheet>
