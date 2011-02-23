<xsl:stylesheet version="2.0" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="../default.xsl"/>

    <xsl:param name="menutop" select="'true'"/>
    <xsl:param name="record"/>

    <xsl:variable name="prevLink" select="//prevLink"/>
    <xsl:variable name="nextLink" select="//nextLink"/>


    <xsl:template name="xms:pagehead">
        <div class="pageHeader">
            <div class="t01">
                <h1>
                    <xsl:value-of
                        select="//sdo:recordCollection/sdo:record[@ID = $record]/sdo:itemDesc/dc:title"
                    />
                </h1>
                <div class="options">
                    <ul class="s4">
                        <li class="info">
                            <xsl:value-of
                                select="//sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]"
                            />
                        </li>
                        <li>
                            <xsl:choose>
                                <xsl:when test="$nextLink != 'NULL'">
                                    <a href="{$nextLink}">Next ›</a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <span>Next</span>
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                        <li>
                            <xsl:choose>
                                <xsl:when test="$prevLink != 'NULL'">
                                    <a class="s02" href="{$prevLink}">‹ Prev</a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <span>Prev </span>
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                        
                    </ul>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="xms:content">
        <table class="docDisplayGandE">
            <tr>
                <td id="GermanVersion">
                    <!-- German version -->
                    <xsl:apply-templates
                        select="//sdo:record[@ID = $record]/tei:div[@type='transcription']"/>
                </td>
                <td id="EnglishVersion">
                    <!-- English version -->
                    <xsl:apply-templates
                        select="//sdo:record[@ID = $record]/tei:div[@type='translation']"/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="ft">
                        <h3>Footnotes</h3>
                        <xsl:for-each select="//sdo:recordCollection/sdo:record[@ID = $record]//tei:note[@place='foot']">
                            <xsl:variable name="noteNum"
                                select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
                            <p>
                                <xsl:attribute name="id" select="concat('fn', $noteNum)"/>
                                <sup>
                                    <xsl:choose>
                                        <xsl:when test="starts-with($noteNum, '0')">
                                            <xsl:value-of select="substring($noteNum, 2, 1)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$noteNum"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </sup>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="."/>
                            </p>
                        </xsl:for-each>
                    </div>
                </td>
            </tr>
        </table>
    </xsl:template>

    <!-- TEMPLATES SPECIFIC TO CORRESPONDENCE DISPLAY -->
    <xsl:template match="tei:opener | tei:closer">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:fw[@type='envelope']">
        <!-- do nothing -->
    </xsl:template>

    <xsl:template match="tei:dateline">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test="@place='foot'">
                <xsl:variable name="fnNum" select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
                <sup>
                    <a class="fnLink">
                        <xsl:attribute name="href">
                            <xsl:text>#fn</xsl:text>
                            <xsl:value-of select="$fnNum"/>
                        </xsl:attribute>
                        <xsl:attribute name="id">
                            <xsl:text>fnLink</xsl:text>
                            <xsl:value-of select="$fnNum"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="starts-with($fnNum, '0')">
                                <xsl:value-of select="substring($fnNum, 2, 1)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$fnNum"/>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </a>
                </sup>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:pb">
        <xsl:if test="@n > 1">
            <xsl:text> {</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>} </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <xsl:variable name="ptrNum" select="substring(substring-after(@corresp, '-'), 3, 2)"/>
        <sup>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>#fn</xsl:text>
                    <xsl:value-of select="$ptrNum"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="starts-with(@corresp, 'http://')">
                        <xsl:call-template name="external-link"/>
                    </xsl:when>
                    <xsl:when test="starts-with(@corresp, '#')">
                        <xsl:attribute name="title">
                            <xsl:text>Link internal to this page</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="title">
                            <xsl:text>Encoding error: @corresp does not start with 'http://' and not internal link</xsl:text>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="starts-with($ptrNum, '0')">
                        <xsl:value-of select="substring($ptrNum, 2, 1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$ptrNum"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </sup>
    </xsl:template>

    <xsl:template match="tei:salute">
        <br/>
        <xsl:if test="parent::tei:opener">
            <br/>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:signed">
        <br/>
        <xsl:text>[</xsl:text>
        <em>signed:</em>
        <xsl:text>] </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
