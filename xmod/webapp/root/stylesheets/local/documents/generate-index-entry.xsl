<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="filename"/>

    <xsl:template match="/">
        <entry xml:id="{sdo:recordCollection/sdo:collectionDesc/sdo:source/child::*[1]/@sdoID}"
            filename="{$filename}"
            tag1="{sdo:recordCollection/sdo:record/sdo:itemDesc/dcterms:isPartOf[1]}"
            date="{sdo:recordCollection/sdo:record/sdo:itemDesc/dcterms:created}"/>
    </xsl:template>

</xsl:stylesheet>
