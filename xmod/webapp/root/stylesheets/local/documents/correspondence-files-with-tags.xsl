<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="filename"/>

    <xsl:template match="/">
        <li>
            <h2>
                <a href="{$filename}.html"><xsl:value-of
                    select="sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]"/>
                <xsl:text> : </xsl:text>
                <xsl:value-of select="substring(sdo:recordCollection/sdo:record/sdo:itemDesc/dcterms:created, 1, 10)"
                /></a>
            </h2>
            <p>
                <xsl:value-of select="sdo:recordCollection/sdo:record/sdo:itemDesc/dc:title"/>
                <br/>
                <xsl:value-of select="sdo:recordCollection/sdo:record/sdo:itemDesc/dc:description"/>
            </p>
        </li>
    </xsl:template>

</xsl:stylesheet>

