<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 23, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="//file_list">
        <add xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0">
            <xsl:for-each select="child::file">
                <xsl:variable name="file" select="document(@name)"/>
                <doc>
                    <field name="category">
                        <xsl:value-of
                            select="local-name($file//sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1])"
                        />
                    </field>

                    <field name="id">
                        <xsl:value-of
                            select="$file//sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]/@sdoID"
                        />
                    </field>

                    <xsl:for-each
                        select="$file//sdo:recordCollection/sdo:record/sdo:itemDesc/dcterms:created">
                        <field name="date">
                            <xsl:value-of select="."/>
                        </field>
                    </xsl:for-each>
                    
                    <xsl:for-each select="sdo:recordCollection/sdo:record/sdo:itemDesc/dcterms:isPartOf">
                        <field name="tag">
                            <xsl:value-of select="."/>
                        </field>
                    </xsl:for-each>

                </doc>
            </xsl:for-each>
        </add>
    </xsl:template>
</xsl:stylesheet>
