<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>
  <xsl:include href="cocoon://_internal/properties/properties.xsl" />


  <xsl:template match="tei:rs[@key]">
    <xsl:variable name="display-name">
      <xsl:for-each select="$eats/entities/entity[keys/key = current()/@key]">
        <xsl:choose>
          <xsl:when test="names/name[@is_preferred = true()]">
            <xsl:value-of select="names/name[@is_preferred = true()]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="names/name[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="default-name"><xsl:apply-templates/></xsl:variable>
    
    <xsl:value-of select="$default-name" /><xsl:if test="not($default-name = $display-name)"><xsl:text> [</xsl:text><xsl:value-of select="$display-name" />]</xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:handShift">
    <xsl:variable name="handIDval" select="substring-after(@new, '#')"/>
    <xsl:variable name="handshift">
      <xsl:choose>
        <xsl:when test="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:handNotes/tei:handNote[@xml:id = $handIDval]"><xsl:value-of select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:handNotes/tei:handNote[@xml:id = $handIDval]" /></xsl:when>
        <xsl:otherwise>Writing shift</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <span class="handshift">[<xsl:value-of select="$handshift" /> ->]</span>
  </xsl:template>
  
  
  <!-- NOT ALL REF OPTIONS CHECKED -->
  <xsl:template match="tei:ref">
    <xsl:choose>
      <xsl:when test="@type  = 'external' or @rend = 'external'">
        <xsl:text> [</xsl:text><xsl:apply-templates/>]
      </xsl:when>
      <xsl:when test="@cRef">
        <xsl:choose>
          <xsl:when test="contains(@cRef, '#')">
            <xsl:variable name="file" select="substring-before(@cRef, '#')"/>
            <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
            <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
            <xsl:variable name="anchor" select="substring-after(@cRef, '#')"/>
            <a title="Link internal to this page">
              <xsl:attribute name="href">
                <xsl:if test="string($file)">
                  <xsl:value-of select="$path"/>
                </xsl:if>
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$anchor"/>
              </xsl:attribute>
              <xsl:call-template name="internal-link">
                <xsl:with-param name="title" select="$title"/>
              </xsl:call-template>
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:when test="@type != 'unknown'">
            <!-- ie. one of "correspondence", "diaries", "lessonbooks", "other" -->
            <xsl:variable name="type" select="@type"/>
            <xsl:variable name="file">
              <xsl:choose>
                <xsl:when test="$type='diaries'">
                  <!-- For DIARIES WE HAVE TO APPEND THE RECORD ID TO URL, eg. diaries/OJ-02-10_1918-01/r0003.html -->
                  <xsl:value-of
                    select="concat(substring-before(@cRef, ':'), '/', substring-after(@cRef, ':'))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@cRef"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="path">
              <xsl:value-of select="concat('/documents/', $type, '/', $file, '.html')"/>
            </xsl:variable>
            <xsl:text> [</xsl:text><xsl:value-of select="$path"/>]
          </xsl:when>
          <xsl:when test="@type = 'unknown'">
            <xsl:variable name="file" select="@cRef"/>
            <xsl:variable name="fileref">
              <xsl:choose>
                <xsl:when test="doc-available(string(concat('../../xml/content/documents/correspondence/', $file, '.xml')))">  
                  <xsl:value-of select="$file"/>
                </xsl:when>
                <xsl:when test="doc-available(string(concat('../../xml/content/documents/diaries/', $file, '.xml')))">
                  <xsl:value-of select="concat(substring-before(@cRef, ':'), '/', substring-after(@cRef, ':'))"/>
                </xsl:when>
                <xsl:when test="doc-available(string(concat('../../xml/content/documents/lessonbooks/', $file, '.xml')))">
                  <xsl:value-of select="$file"/>
                </xsl:when>
                <xsl:when test="doc-available(string(concat('../../xml/content/documents/other/', $file, '.xml')))">
                  <xsl:value-of select="$file"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="''" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$fileref != ''">
                <xsl:variable name="path" select="concat('/documents/correspondence/', $fileref, '.html')"/>
                <xsl:text> [</xsl:text><xsl:value-of select="$path"/>]        
              </xsl:when>
              <xsl:otherwise>
              </xsl:otherwise>
            </xsl:choose>
            
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="file" select="@cRef"/>
            <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
            <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
           <xsl:value-of select="$title" /><xsl:text> (http://sdo.cch.kcl.ac.uk/</xsl:text><xsl:value-of select="$path"/><xsl:text>)</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@target">
        <xsl:text> [</xsl:text>
            <xsl:if test="starts-with(@target, '/')">
              <xsl:value-of select="$xmp:context-path"/>
            </xsl:if>
            <!-- This is well dodgy. -->
            <xsl:value-of select="@target"/>
          <xsl:apply-templates/>]
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:subst">
    <xsl:choose>
      <xsl:when test="child::tei:del[@rend='overwritten']/child::tei:gap">
        <xsl:value-of select="child::tei:add[@place='superimposed']"/><span class="green">[illeg]</span>
      </xsl:when>
      <xsl:when test="child::tei:del[@rend='overwritten']">
        <xsl:value-of select="child::tei:add[@place='superimposed']"/><span class="green"><del><xsl:value-of select="child::tei:del[@rend='overwritten']"/></del></span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
</xsl:stylesheet>