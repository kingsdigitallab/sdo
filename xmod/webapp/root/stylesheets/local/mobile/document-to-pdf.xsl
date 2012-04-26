<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:import href="sdo-pdf-p5.xsl" />

    <xsl:param name="lang" />
    <xsl:param name="type" />
    <xsl:param name="as" />
    <xsl:param name="recordId" />
    
  <!--   <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[1]"/>  -->
    
    <xsl:variable name="record">
        <xsl:choose>
            <xsl:when test="$recordId"><xsl:sequence select="/aggregation/sdo:recordCollection/sdo:record[@ID=$recordId]"/></xsl:when>
            <xsl:otherwise><xsl:sequence select="/aggregation/sdo:recordCollection/sdo:record[1]" /></xsl:otherwise>
        </xsl:choose>
    </xsl:variable> 
    
    <xsl:variable name="eats" select="/aggregation/eats" />    

    
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$as = 'part'"><xsl:call-template name="chapter" /></xsl:when>
            <xsl:otherwise><xsl:call-template name="standalone" /></xsl:otherwise>
        </xsl:choose>        
    </xsl:template>    
    

    <!-- generate PDF page structure -->
        <xsl:template name="standalone">

            <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
                <fo:layout-master-set>
                    <fo:simple-page-master master-name="page"
                        page-height="29.7cm" 
                        page-width="21cm"
                        margin-top="1cm" 
                        margin-bottom="2cm" 
                        margin-left="2.5cm" 
                        margin-right="2.5cm">
                        <fo:region-before extent="3cm"/>
                        <fo:region-body margin-top="3cm"/>
                        <fo:region-after extent="1.5cm"/>
                    </fo:simple-page-master>
                    
                    <fo:page-sequence-master master-name="all">
                        <fo:repeatable-page-master-alternatives>
                            <fo:conditional-page-master-reference master-reference="page" page-position="first"/>
                        </fo:repeatable-page-master-alternatives>
                    </fo:page-sequence-master>
                </fo:layout-master-set>

            
                <fo:page-sequence master-reference="all">
                    <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="chapter" />
                    </fo:flow>    
                </fo:page-sequence>
            </fo:root>
        </xsl:template>
 
 
    <xsl:template match="tei:div">
        <xsl:choose>
            <!-- match 'transcription' and 'translation' divs in a primary document -->
            <xsl:when test="parent::sdo:record">
                <xsl:choose>
                    <xsl:when test="child::tei:div[contains(@type, 'part_')]">
                        <xsl:apply-templates mode="multipartItem"/>
                        <!-- SEE THE FOLLOWING <XSL:TEMPLATE> -->
                    </xsl:when>
                    <xsl:when test="child::tei:opener">
                        <fo:block>
                            <xsl:if test="child::tei:opener/preceding-sibling::tei:note">
                                <xsl:apply-templates select="tei:note"/>
                            </xsl:if>
                            <xsl:apply-templates select="child::tei:opener"/>
                        </fo:block>
                        <fo:block>
                            <xsl:apply-templates
                                select="child::tei:opener/following-sibling::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"
                            />
                        </fo:block>
                        <xsl:if test="child::tei:closer">
                            <fo:block id="closer_{@type}">
                                <xsl:apply-templates select="tei:closer"/>
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="child::tei:postscript">
                            <fo:block id="postscript_{@type}">
                                <xsl:apply-templates select="tei:postscript"/>
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="child::tei:fw[@type='envelope']">
                            <fo:list-block id="envelope_{@type}">
                                <xsl:apply-templates select="tei:fw[@type='envelope']"/>
                            </fo:list-block>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block>
                            <xsl:apply-templates
                                select="child::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"
                            />
                        </fo:block>
                        <xsl:if test="child::tei:closer">
                            <fo:block id="closer_{@type}">
                                <xsl:apply-templates select="tei:closer"/>
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="child::tei:postscript">
                            <fo:block id="postscript_{@type}">
                                <xsl:apply-templates select="tei:postscript"/>
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="child::tei:fw[@type='envelope']">
                            <fo:list-block id="envelope_{@type}">
                                <xsl:apply-templates select="tei:fw[@type='envelope']"/>
                            </fo:list-block>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!--   Default  -->
            <xsl:otherwise>
                <!-- Creates anchor if there is @xml:id -->
                <xsl:if test="@xml:id">
                    <fo:basic-link>
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                        <xsl:text>&#160;</xsl:text>
                    </fo:basic-link>
                </xsl:if>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
    <!-- This template takes care of situation where we have multiple items in one document, eg. the picture postcard with two separate messages, OJ-8-4_31.xml. It's the same as the <tei:div> template above, but now applying to <tei:div @type='part_X' -->
    <xsl:template match="tei:div" mode="multipartItem">
        <xsl:choose>
            <xsl:when test="child::tei:opener">
                <fo:block>
                    <xsl:if test="child::tei:opener/preceding-sibling::tei:note">
                        <xsl:apply-templates select="tei:note"/>
                    </xsl:if>
                    <xsl:apply-templates select="child::tei:opener"/>
                </fo:block>
                <fo:block>
                    <xsl:apply-templates
                        select="child::tei:opener/following-sibling::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"
                    />
                </fo:block>
                <xsl:if test="child::tei:closer">
                    <fo:block>
                        <xsl:apply-templates select="tei:closer"/>
                    </fo:block>
                </xsl:if>
                <xsl:if test="child::tei:postscript">
                    <fo:block>
                        <xsl:apply-templates select="tei:postscript"/>
                    </fo:block>
                </xsl:if>
                <xsl:if test="child::tei:fw[@type='envelope']">
                    <fo:list-block>
                        <xsl:apply-templates select="tei:fw[@type='envelope']"/>
                    </fo:list-block>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:apply-templates select="child::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]" />
                </fo:block>
                <xsl:if test="child::tei:closer">
                    <fo:block>
                        <xsl:apply-templates select="tei:closer"/>
                    </fo:block>
                </xsl:if>
                <xsl:if test="child::tei:postscript">
                    <fo:block>
                        <xsl:apply-templates select="tei:postscript"/>
                    </fo:block>
                </xsl:if>
                <xsl:if test="child::tei:fw[@type='envelope']">
                    <fo:list-block>
                        <xsl:apply-templates select="tei:fw[@type='envelope']"/>
                    </fo:list-block>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
 
    <xsl:template name="simple-email-encoding">
        <xsl:analyze-string flags="im" regex="([A-Z0-9._+-]+)(@)([A-Z0-9.-]+\.[A-Z]+)" select=".">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:text> [at] </xsl:text>
                <xsl:value-of select="replace(regex-group(3), '\.', ' (dot) ')"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
 
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
    
    <xsl:template name="chapter">
            <fo:block font-family="serif" space-after="22pt" keep-with-next="always" line-height="32pt" font-size="28pt">
                <xsl:if test="string-length(/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]/text()) != 0">
                    <xsl:value-of select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]" />
                    <xsl:text> - </xsl:text>
                </xsl:if>
                <xsl:value-of select="$record//sdo:itemDesc/dc:title"/>
            </fo:block>
            
            
            <xsl:if test="$record//tei:note[@place='pre-text']">
                <fo:block>
                    <xsl:for-each select="$record//tei:note[@place='pre-text']">
                        <fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
                    </xsl:for-each>
                </fo:block>
            </xsl:if>
            
            
            <fo:block>                         
                <xsl:choose>
                    <xsl:when test="$lang = 'de'"><xsl:apply-templates select="$record//tei:div[@type='transcription']"/></xsl:when>
                    <xsl:when test="$lang = 'en'"><xsl:apply-templates select="$record//tei:div[@type='translation']"/></xsl:when>
                    <xsl:otherwise>
                        <fo:table table-layout="fixed">
                            
                            
                            <fo:table-column column-width="50%" column-number="1" />
                            <fo:table-column column-width="50%" column-number="2" />
                            
                            <fo:table-body>
                                
                                <fo:table-row>
                                    <fo:table-cell><xsl:apply-templates select="$record//tei:div[@type='transcription']"/></fo:table-cell>
                                    <fo:table-cell><xsl:apply-templates select="$record//tei:div[@type='translation']"/></fo:table-cell>
                                </fo:table-row>
                                
                            </fo:table-body>
                            
                            
                            
                        </fo:table>    
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
            
            <xsl:if test="$record//tei:note[@place='foot']">
                <fo:block font-size="8pt">
                    <fo:inline font-weight="bold">Footnotes</fo:inline>
                    <xsl:for-each select="$record//tei:note[@place='foot']">
                        <xsl:variable name="noteNum" select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
                        <fo:block>
                            <xsl:attribute name="internal-destination" select="concat('fn', $noteNum)"/>  
                            <fo:inline vertical-align="sup">
                                <xsl:choose>
                                    <xsl:when test="starts-with($noteNum, '0')">
                                        <xsl:value-of select="substring($noteNum, 2, 1)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$noteNum"/>
                                    </xsl:otherwise>
                                </xsl:choose>                                              
                            </fo:inline>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates/>
                        </fo:block>
                    </xsl:for-each>
                    
                </fo:block>
            </xsl:if> 
            
            <xsl:for-each select="/aggregation/commentary/doc[statements/statement]">
                <fo:block>
                    <fo:block font-style="bold">Commentary</fo:block>
                    
                    <xsl:for-each select="statements/statement">
                        <fo:block font-weight="bold" keep-with-next="always">
                            <xsl:value-of select="@type"/>
                        </fo:block>
                        <fo:block start-indent="1cm">
                            <xsl:call-template name="simple-email-encoding"/>
                        </fo:block>
                    </xsl:for-each>
                    <xsl:for-each select="container/statements/statement[@type != current()/statements/statement/@type]">
                        <fo:block font-weight="bold" keep-with-next="always">
                            <xsl:value-of select="@type"/>
                        </fo:block>
                        <fo:block start-indent="1cm">
                            <xsl:call-template name="simple-email-encoding"/>
                        </fo:block>
                    </xsl:for-each>                                      
                </fo:block>
            </xsl:for-each>
                   
    </xsl:template>
 
    </xsl:stylesheet>