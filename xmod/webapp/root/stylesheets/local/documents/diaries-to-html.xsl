<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:import href="../default.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 27, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:param name="menutop" select="'true'"/>
    <xsl:param name="date"/>
    <xsl:variable name="prevDate" select="//prevDate"/>
    <xsl:variable name="prevFile" select="//prevFile"/>
    <xsl:variable name="nextDate" select="//nextDate"/>
    <xsl:variable name="nextFile" select="//nextFile"/>
    <xsl:variable name="record"
        select="//sdo:recordCollection/sdo:record[descendant::dcterms:created = $date]"/>

    <xsl:template name="xms:pagehead">
        <div class="pageHeader">
            <div class="t01">
                <h1>
                    <a><xsl:attribute name="href" select="concat($prevFile, '/', $prevDate)"
                        />prev</a>
                    <xsl:text> | </xsl:text>
                    <a><xsl:attribute name="href" select="concat($nextFile, '/', $nextDate)"
                        />next</a>

                </h1>
                <h2 class="documentDisplay"><xsl:value-of
                        select="//sdo:recordCollection/sdo:collectionDesc/sdo:source/sdo:diary/@sdoID"/>:
                    [date here]</h2>
                <h3 class="documentDisplay">
                    <xsl:value-of select="$record/sdo:itemDesc/dc:title"/>
                </h3>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="xms:content">
        <table class="docDisplayGandE">
            <tr>
                <td id="GermanVersion">
                    <!-- German version -->
                    <xsl:apply-templates select="$record/tei:div[@type='transcription']"/>
                </td>
                <td id="EnglishVersion">
                    <!-- English version -->
                    <xsl:apply-templates select="$record/tei:div[@type='translation']"/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <p>[commentary]</p>
                    <p>[footnotes]</p>
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
