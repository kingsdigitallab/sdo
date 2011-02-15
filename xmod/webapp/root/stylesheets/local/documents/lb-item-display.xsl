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
                    <p>[commentary]</p>
                    <p>[footnotes]</p>
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

    <xsl:template match="tei:pb">
        <xsl:if test="@n > 1">
            <xsl:text> {</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>} </xsl:text>
        </xsl:if>
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
