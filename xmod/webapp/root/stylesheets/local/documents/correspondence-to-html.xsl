<xsl:stylesheet version="2.0" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="../default.xsl"/>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:param name="filedir"/>
    <xsl:param name="filename"/>
    <xsl:param name="fileextension"/>

    <xsl:template name="xms:pagehead">
        <div class="pageHeader">
            <div class="t01">
                <h1>
                    <!-- below will change to use a passed in parameter for the specific tag -->
                    <xsl:text>[will have all applicable tags, with appropriate NEXT and PREV links] </xsl:text>
                </h1>
                <h2 class="documentDisplay"><xsl:value-of select="//sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]"/>: [date here]</h2>             
                <h3 class="documentDisplay"><xsl:value-of select="//sdo:recordCollection/sdo:record/sdo:itemDesc/dc:title"/></h3>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="xms:content">
        <table class="docDisplayGandE">
            <tr>
                <td id="GermanVersion">
                    <!-- German version -->
                    <xsl:apply-templates select="//tei:div[@type='transcription']"/>
                </td>
                <td id="EnglishVersion">
                    <!-- English version -->
                    <xsl:apply-templates select="//tei:div[@type='translation']"/>
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
        <xsl:if test="@n > 1"><xsl:text> {</xsl:text><xsl:value-of select="@n"/><xsl:text>} </xsl:text></xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:salute">
        <br/>
        <xsl:if test="parent::tei:opener"><br/></xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:signed">
        <br/><xsl:text>[</xsl:text><em>signed:</em><xsl:text>] </xsl:text><xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
