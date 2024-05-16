<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:import href="index-to-html.xsl"/>

    <xsl:param name="filename"/>
    
<xsl:template match="/">

    <xsl:variable name="other-entities">
        <xsl:for-each
            select="/*//lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='entity_key']/int">
            <xsl:variable name="ent_id" select="@name"/>
            
            <xsl:if test="not(/*/indices/index/entry[@xml:id = $ent_id])">
                <xsl:variable name="type" select="/*/eats/entities/entity[keys/key = $ent_id]/types/type"/>
                <xsl:variable name="name"
                    select="/*/eats/entities/entity[keys/key = $ent_id]/names/name[@is_preferred = 'true']"/>
                <xsl:variable name="related-name"
                    select="/*/eats/entities/entity[keys/key = $ent_id]/relationships/relationship[@type = 'is composed by']/names/name[@is_preferred = 'true']/text()[1]"/>
                
                <xsl:variable name="entity-name">
                    <xsl:choose>
                        <xsl:when test="contains($name, '(')">
                            <xsl:value-of select="normalize-space(substring-before($name, '('))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="related-entity-name">
                    <xsl:choose>
                        <xsl:when test="not($related-name)">
                            <xsl:text>Unknown:</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains($related-name, '(')">
                            <xsl:value-of select="normalize-space(substring-before($related-name, '('))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$related-name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="suffix">
                    <xsl:choose>
                        <xsl:when test="contains($name, '(')">
                            <xsl:text>(</xsl:text>
                            <xsl:value-of select="substring-after($name, '(')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="tokenised-name" select="tokenize($entity-name, '\s+')"/>
                <xsl:variable name="tokenised-related-name" select="tokenize($related-entity-name, '\s+')"/>
                <xsl:variable name="name-count"
                    select="count(/*/eats/entities/entity[types/type = $type]/relationships/relationship[@type = 'is composed by']/names[name = $related-name])"/>
                <xsl:variable name="surname" select="$tokenised-related-name[last()]"/>
                <xsl:variable name="surname-count"
                    select="count(/*/eats/entities/entity[types/type = $type]/relationships/relationship[@type = 'is composed by']/names/name[@is_preferred = 'true' and contains(text()[1], $surname[1])])"/>
                <xsl:variable name="forenames">
                    <xsl:for-each select="$tokenised-name">
                        <xsl:if test="not(position() eq last())">
                            <xsl:value-of select="."/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="initials">
                    <xsl:for-each select="$tokenised-related-name">
                        <xsl:if test="not(position() eq last())">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="substring(., 1, 1)"/>
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                
                <entity>
                    
                    <entity-id>
                        <xsl:value-of select="$ent_id"/>
                    </entity-id>
                    <title>
                        <xsl:value-of select="$name"/>
                    </title>
                    
                    <xsl:choose>
                        
                        <xsl:when
                            test="$type = 'person' and count($tokenised-name) > 1 and not($tokenised-name[last()] = 'I') and not($tokenised-name[last()] = 'II') and not($tokenised-name[last()] = 'family')">
                            <filing_title>
                                <xsl:value-of select="$tokenised-name[last()]"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="normalize-space($forenames)"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$suffix"/>
                            </filing_title>
                        </xsl:when>
                        <!-- composer: composition title -->
                        
                        <xsl:when
                            test="$type = 'composition' and count($tokenised-related-name) > 1 and not($tokenised-related-name[last()] = 'I') and not($tokenised-related-name[last()] = 'II')">
                            <filing_title>
                                <xsl:value-of select="$tokenised-related-name[last()]"/>
                                <xsl:if test="$name-count != $surname-count">
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$initials"/>
                                </xsl:if>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="$name"/>
                            </filing_title>
                        </xsl:when>
                        <!---->
                        
                        <xsl:when test="$type = 'composition'">
                            <filing_title>
                                <xsl:value-of select="$tokenised-related-name"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$name"/>
                            </filing_title>
                        </xsl:when>
                        <!---->
                        
                        <xsl:otherwise>
                            <filing_title>
                                <xsl:value-of select="$name"/>
                            </filing_title>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                    <type>
                        <xsl:value-of select="$type"/>
                    </type>
                </entity>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
   
   <list>
    <xsl:for-each select="/*/indices/index[@name=$filename]/entry">
        <xsl:copy-of select="."/>
    </xsl:for-each>
    
    <xsl:for-each select="$other-entities/child::*">
        <xsl:if
            test="child::*[name()='type'] = $filename and not(/*/indices/index[@name=$filename]/entry[@xml:id = child::*[name()='entity-id']])">
            <entry>
                <xsl:for-each select="child::*">
                    <xsl:choose>
                        <xsl:when test="name() = 'entity-id'">
                            <xsl:attribute name="xml:id">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:attribute name="filename">
                                <xsl:value-of select="."/>
                                <xsl:text>.html</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="name() = 'filing_title'">
                            <xsl:attribute name="filing_title">
                                <xsl:call-template name="parse">
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:attribute>
                            
                            <xsl:attribute name="sortkey">
                                
                                <xsl:variable name="parsed">
                                    <xsl:call-template name="parse">
                                        <xsl:with-param name="value">
                                            <xsl:value-of select="."/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:variable>
                                
                                <xsl:variable name="deaccented">
                                    <xsl:value-of
                                        select="replace(normalize-unicode(normalize-space($parsed),'NFKD'),'[^A-Za-z0-9 ]','')"
                                    />
                                </xsl:variable>
                                <xsl:value-of
                                    select="lower-case(translate(translate(normalize-space($deaccented), ' ', '_'), ',', ''))"
                                />
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="name() = 'title'">
                            <xsl:attribute name="title">
                                <xsl:call-template name="parse">
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </entry>
        </xsl:if>
    </xsl:for-each>
    </list>
</xsl:template>    
    
</xsl:stylesheet>