<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">

<xsl:param name="sourceType"/>
<xsl:template match="/">
  
  
    <xsl:choose>
        <xsl:when test="$sourceType = 'diary'">
     
                        <xsl:apply-templates select="//c02" mode="schema-decl"/>
                   
        </xsl:when>
        <xsl:when test="$sourceType = 'correspondence'">
            <xs:element name="correspondence">
                <xs:complexType>
                    <xs:attribute use="required" name="shelfmark">
                        <xs:simpleType>
                            <xs:restriction base="xs:string">
                                <xsl:apply-templates select="//c03" mode="schema-decl"/>
                            </xs:restriction>
                        </xs:simpleType>
                    </xs:attribute>
                </xs:complexType>      
            </xs:element>
        </xsl:when>
        <xsl:when test="$sourceType = 'lessonbook'">
            <xs:element name="lessonbook">
                <xs:complexType>
                    <xs:attribute use="required" name="shelfmark">
                        <xs:simpleType>
                            <xs:restriction base="xs:string">
                                <xsl:apply-templates select="//c03" mode="schema-decl"/>
                            </xs:restriction>
                        </xs:simpleType>
                    </xs:attribute>
                </xs:complexType>      
            </xs:element>
        </xsl:when>
        <xsl:when test="$sourceType = 'ephemera'">
            <xs:element name="ephemera">
                <xs:complexType>
                    <xs:attribute use="required" name="shelfmark">
                        <xs:simpleType>
                            <xs:restriction base="xs:string">
                                <xsl:apply-templates select="//c03" mode="schema-decl"/>
                            </xs:restriction>
                        </xs:simpleType>
                    </xs:attribute>
                </xs:complexType>      
            </xs:element>
        </xsl:when>
    </xsl:choose>
     
</xsl:template>
    

<xsl:template match="c02" mode="html-out">
    <xsl:apply-templates/><br/>
</xsl:template>
<xsl:template match="c02" mode="schema-decl">
    
    <xsl:apply-templates select="did/daogrp/daoloc"/>
    
</xsl:template>
    
 <xsl:template match="daoloc">
     
     
     <xsl:result-document exclude-result-prefixes="#all" href="/tmp/schenker/{@id}.xml"  output-version="1.0" indent="yes">
         
         <xsl:processing-instruction name="xml-stylesheet" select="'type=&quot;text/css&quot;','href=&quot;../../../css/sdo_oxygen.css&quot;'"/>
         <xsl:text>&#xA;</xsl:text>
         <sdo:recordCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:tei="http://www.tei-c.org/ns/1.0"
             xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:dc="http://purl.org/dc/elements/1.1/"
             xmlns:dcterms="http://purl.org/dc/terms/"
             xsi:schemaLocation="http://www.cch.kcl.ac.uk/schenker ../../../schema/schenker.xsd">
             
             
             <xsl:variable name="displayDescription">
                 <xsl:apply-templates select="ancestor::c02/did" mode="doco-val"/>
             </xsl:variable>
             <xsl:variable name="thisDaoDesc" select="."/>
             <xsl:variable name="thisDate"><xsl:value-of select="substring-after(@id,'_')"/>-[DD]</xsl:variable>
             
             <xsl:text>&#xA;</xsl:text>
             <xsl:comment>
                 
                 <xsl:value-of select="@id"/>
                 <xsl:value-of select="$thisDaoDesc"/> <xsl:text> - </xsl:text> ( <xsl:value-of select="$displayDescription"/> )
                 
             </xsl:comment>
             <xsl:text>&#xA;</xsl:text>
             
             <sdo:collectionDesc>
                    
                 <sdo:source>
                     <xsl:text>&#xA;</xsl:text><xsl:comment>Select a shelfmark from the controlled list </xsl:comment><xsl:text>&#xA;</xsl:text>    
                     <sdo:diary  shelfmark="{@id}"/>
                 </sdo:source>
                 
                 <xsl:text>&#xA;</xsl:text><xsl:comment> Most documents will be in the hand of either Heinrich or Jeanette; add additional notes as needed to indicate
                     the presence of other hands</xsl:comment><xsl:text>&#xA;</xsl:text>
                 <tei:handNotes>
                     <tei:handNote xml:id="HS" scope="minor">Heinrich Schenker's hand</tei:handNote>
                     <tei:handNote xml:id="JS" scope="major">Jeanette Schenker's hand</tei:handNote>
                     <tei:handNote xml:id="unknown">Unknown hand</tei:handNote>
                 </tei:handNotes>
                 <xsl:text>&#xA;</xsl:text><xsl:comment> Add additional or remove unnecessary statements of responsiblity as needed below </xsl:comment><xsl:text>&#xA;</xsl:text>
                 <tei:respStmt xml:id="IB">
                     <tei:persName>Marko Deisinger</tei:persName>
                     <tei:resp>Footnotes</tei:resp>
                 </tei:respStmt>
                 <tei:respStmt xml:id="MD">
                     <tei:persName>Marko Deisinger</tei:persName>
                     <tei:resp>Transcription</tei:resp>
                 </tei:respStmt>
                 <tei:respStmt xml:id="XX">
                     <tei:persName>[Insert Translator's Name Here]</tei:persName>
                     <tei:resp>English Translation</tei:resp>
                 </tei:respStmt>
                 <tei:respStmt xml:id="IJV">
                     <tei:persName>Iby-Jolande Varga</tei:persName>
                     <tei:resp>XML Encoding</tei:resp>
                 </tei:respStmt>
                 <tei:respStmt xml:id="TL">
                     <tei:persName>Tamara Lopez</tei:persName>
                     <tei:resp>XML Encoding Model</tei:resp>
                 </tei:respStmt>
                 
                 <xsl:text>&#xA;</xsl:text><xsl:comment> Add additional change elements below to note major changes to the document </xsl:comment><xsl:text>&#xA;</xsl:text>
                 <tei:revisionDesc>
                     <tei:change when="2008-10-17" who="#TL">Template Generated</tei:change>
                 </tei:revisionDesc>
             </sdo:collectionDesc>
                          
             <xsl:for-each select="1 to 31">
                 
                 <xsl:variable name="recordNum">
                     <xsl:choose>
                         <xsl:when test=". &gt; 9">
                             <xsl:value-of select="concat('r00',.)"/>
                         </xsl:when>
                         <xsl:otherwise>
                             <xsl:value-of select="concat('r000',.)"/>
                         </xsl:otherwise>
                     </xsl:choose>
                 </xsl:variable>
                 
                 
                 <sdo:record ID="{$recordNum}">
                     <xsl:text>&#xA;</xsl:text><xsl:comment>Use the itemDesc to group information about a single record, e.g. a single diary entry, lessonbook entry or piece of correspondence. 
                         The <itemDesc> contains a series of Dublin Core elements. </itemDesc></xsl:comment><xsl:text>&#xA;</xsl:text>
                     
                     <sdo:itemDesc>
                        <!-- <dc:title><xsl:value-of select="."/> <xsl:text> - </xsl:text> (<xsl:text> </xsl:text><xsl:apply-templates select="ancestor::c02/did" mode="doco-val"/><xsl:text> </xsl:text>)</dc:title>
                        -->  
                         <dc:title>Diary entry by Schenker <xsl:value-of select="$thisDaoDesc"/></dc:title>
                         <dcterms:created><xsl:value-of select="$thisDate"/></dcterms:created>
                         <dcterms:dateSubmitted>The Date of Electronic Creation Goes Here: YYYY-MM-DD</dcterms:dateSubmitted>
                         <dc:description>A summary of the contents of the record (currently unused)</dc:description>
                         <dc:subject>A list of subjects (currently unused)</dc:subject>
                     </sdo:itemDesc>
                     
                     <tei:transcription>
                         <tei:opener>
                             <tei:date></tei:date>
                         </tei:opener>
                         <tei:ab>The German Transcription Goes Here.</tei:ab>
                     </tei:transcription>
                     <tei:translation>
                         <tei:opener>
                             <tei:date></tei:date>
                         </tei:opener>
                         <tei:ab>The English Translation Goes Here.</tei:ab>
                     </tei:translation>
                 </sdo:record>
                 
                 
             </xsl:for-each>
             
         </sdo:recordCollection>
                 
     
     
     
     
     </xsl:result-document>
 </xsl:template>
    
    
    
    <xsl:template match="did" mode="attr-val"><xsl:value-of select="normalize-space(ancestor::archdesc/did/unitid)"/><xsl:text>-</xsl:text><xsl:apply-templates select="container[@type='box']"/>-<xsl:apply-templates select="container[@type='folder']"/></xsl:template>
    
    <xsl:template match="did" mode="doco-val">
      <xsl:apply-templates select="unittitle"/><xsl:text> </xsl:text><xsl:value-of select="ancestor::c01/did/unittitle"/><xsl:text> </xsl:text><xsl:apply-templates mode="doco-val"/><xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="container">
        <xsl:value-of select="normalize-space(.)"/>   
    </xsl:template>
      
    <xsl:template match="container" mode="doco-val">
        <xsl:value-of select="@type"/>:<xsl:text> </xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text> </xsl:text>   
    </xsl:template>
    <xsl:template match="unittitle" mode="doco-val"/>
    
    <xsl:template match="physdesc" mode="doco-val">
        <xsl:value-of select="@label"/><xsl:text>: </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text>
    </xsl:template>
   
     
    <xsl:template match="unitdate" mode="doco-val">date: <xsl:value-of select="normalize-space(.)"/><xsl:text> </xsl:text>
    </xsl:template>    
    
    <xsl:template match="daoloc" mode="doco-val"/>


</xsl:stylesheet>
