<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">

<xsl:param name="sourceType"/>
<xsl:template match="/">
    <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"  
        targetNamespace="http://www.cch.kcl.ac.uk/schenker" 
        xmlns="http://www.cch.kcl.ac.uk/schenker" 
        xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" 
        xmlns:tei="http://www.tei-c.org/ns/1.0" 
        xmlns:mods="http://www.loc.gov/mods/v3" 
        xmlns:xlink="http://www.w3.org/1999/xlink" 
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:dcterms="http://purl.org/dc/terms/"> 
    <xsl:choose>
        <xsl:when test="$sourceType = 'diary'">
     <xs:element name="diary">
        <xs:complexType>
            <xs:attribute use="required" name="shelfmark">
                <xs:simpleType>
                    <xs:restriction base="xs:string">
                        <xsl:apply-templates select="//c02" mode="schema-decl"/>
                    </xs:restriction>
                </xs:simpleType>
            </xs:attribute>
        </xs:complexType>      
     </xs:element>
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
   </xs:schema>  
</xsl:template>
    

<xsl:template match="c02" mode="html-out">
    <xsl:apply-templates/><br/>
</xsl:template>
<xsl:template match="c02" mode="schema-decl">
    
    <xsl:apply-templates select="did/daogrp/daoloc"/>
    
</xsl:template>
    
 <xsl:template match="daoloc">
     <xs:enumeration><xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
         <xsd:annotation><xsd:documentation><xsl:apply-templates select="ancestor::did" mode="doco-val"/></xsd:documentation></xsd:annotation>
     </xs:enumeration>
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


</xsl:stylesheet>
