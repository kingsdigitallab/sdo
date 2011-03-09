<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:marcrel="http://www.loc.gov/loc.terms/relators/"
                xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../xmod/solr/tei-to-solr.xsl"/>

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Nov 15, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> pcaton</xd:p>
      <xd:p>This stylesheet is the local version of the default ../../xmod/solr/tei-to-solr.xsl. It
        has been heavily customised for SDO and currently overrides practically everything in the
        default.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:variable name="free-text">
    <xsl:apply-templates mode="free-text" select="//tei:div[not(ancestor::tei:div)]" />
  </xsl:variable>

  <xsl:template match="/">
    <add>
      <!-- each Solr doc is based on a single sdo:record -->
      <xsl:for-each select="//sdo:record">
        <!-- $kind refers to whether it is correspondence, diary, etc. -->
        <xsl:variable name="kind" select="local-name(preceding-sibling::sdo:collectionDesc/sdo:source/*[1])"/>
        <xsl:variable name="fileID" select="preceding-sibling::sdo:collectionDesc/sdo:source/*[1]/@sdoID"/>
        <xsl:variable name="shelfmark" select="preceding-sibling::sdo:collectionDesc/sdo:source/*[1]"/>
        <xsl:variable name="recordID" select="@ID"/>
        <!-- record IDs are not unique across the whole set, so we bodge up a unique identifier -->
        <xsl:variable name="uniqueID" select="concat($recordID, '_', $fileID)"/>

        <!-- begin the metadata <doc> -->
        <doc>
          <field name="kind">
            <xsl:choose>
              <xsl:when test="$kind = 'other'">
                <xsl:text>other</xsl:text>
              </xsl:when>
              <xsl:when test="$kind = 'diary'">
                <xsl:text>diaries</xsl:text>
              </xsl:when>
              <xsl:when test="$kind = 'lessonbook'">
                <xsl:text>lessonbooks</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$kind"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>

          <field name="shelfmark">
            <xsl:value-of select="$shelfmark"/>
          </field>

          <field name="fileId">
            <xsl:value-of select="$fileID"/>
          </field>

          <field name="recordId">
            <xsl:value-of select="$recordID"/>
          </field>

          <field name="uniqueId">
            <xsl:value-of select="$uniqueID"/>
          </field>

          <xsl:if test="$kind = 'correspondence'">
            <field name="description">
              <xsl:value-of select="sdo:itemDesc/dc:description"/>
            </field>

            <xsl:for-each select="sdo:itemDesc/marcrel:correspondent">
              <field name="correspondent">
                <xsl:value-of select="@key"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/>
              </field>
            </xsl:for-each>

            <xsl:for-each select="sdo:itemDesc/marcrel:recipient">
              <field name="recipient">
                <xsl:value-of select="@key"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/>
              </field>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="$kind != 'diary'">
            <field name="title">
              <xsl:value-of select="sdo:itemDesc/dc:title"/>
            </field>
          </xsl:if>

          <xsl:if test="$kind = 'lessonbook'">
            <field name="pupil">
              <xsl:value-of select="substring-before(sdo:itemDesc/dc:title, ':')"/>
            </field>
          </xsl:if>

          <xsl:if test="substring(sdo:itemDesc/dcterms:created, 9, 4) != '[DD]'">
            <!-- in full W3C format Solr requires:  yyyy-mm-ddT12:00:00Z -->
            <field name="dateFull">
              <xsl:value-of select="sdo:itemDesc/dcterms:created"/>
            </field>
            <!-- as a handy string:   yyyy-mm-dd -->
            <field name="dateShort">
              <xsl:value-of select="substring(sdo:itemDesc/dcterms:created, 1, 10)"/>
            </field>
          </xsl:if>

          <field name="type">
            <xsl:value-of select="replace(sdo:itemDesc/dc:type, ' ', '_')"/>
          </field>

          <xsl:for-each select="sdo:itemDesc/dcterms:isPartOf">
            <field name="correspondence">
              <xsl:value-of select="tei:rs/@key"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="replace(., '\s~\s', '_')"/>
            </field>
          </xsl:for-each>

          <field name="file">
            <xsl:value-of select="$file-path"/>
          </field>

          <xsl:for-each select="distinct-values(descendant::tei:*[@key]/@key)">
            <field name="entity-key">
              <xsl:value-of select="."/>
            </field>
          </xsl:for-each>

          <field name="text">
            <xsl:value-of select="normalize-space($free-text)" />
          </field>
        </doc>
      </xsl:for-each>

    </add>
  </xsl:template>

</xsl:stylesheet>
