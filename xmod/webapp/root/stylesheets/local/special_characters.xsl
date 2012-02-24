<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
    xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
    xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
    xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:template match="tei:g">
        <xsl:choose>
            <!-- need this first choice because Chord Symbol font does not have clef symbols -->
            <xsl:when test="substring(@type, 2, 4) = 'clef'">
                <span class="char">
                    <xsl:choose>
                        <xsl:when test="substring(@type, 1, 1) = 'C'">&#x1D121;</xsl:when>
                        <xsl:when test="substring(@type, 1, 1) = 'F'">&#x1D122;</xsl:when>
                        <xsl:when test="substring(@type, 1, 1) = 'G'">&#x1D120;</xsl:when>
                    </xsl:choose>
                </span>
            </xsl:when>
            <!-- these use Chord Symbol font replacement -->
            <xsl:otherwise>
                <span class="csthree">
                    <xsl:choose>
                        <xsl:when test="@type='cap1'">&#x0102;</xsl:when>
                        <xsl:when test="@type='cap2'">&#x0103;</xsl:when>
                        <xsl:when test="@type='cap3'">&#x0104;</xsl:when>
                        <xsl:when test="@type='cap4'">&#x0105;</xsl:when>
                        <xsl:when test="@type='cap5'">&#x0106;</xsl:when>
                        <xsl:when test="@type='cap6'">&#x0107;</xsl:when>
                        <xsl:when test="@type='cap7'">&#x0108;</xsl:when>
                        <xsl:when test="@type='cap8'">&#x0109;</xsl:when>
                        <xsl:when test="@type='2flat'">&#x0118;</xsl:when>
                        <xsl:when test="@type='flat'">&#x0119;</xsl:when>
                        <xsl:when test="@type='nat'">&#x011A;</xsl:when>
                        <xsl:when test="@type='sharp'">&#x011B;</xsl:when>
                        <xsl:when test="@type='2sharp'">&#x011C;</xsl:when>
                        <xsl:when test="@type='cresc'">&#x02D2;</xsl:when>
                        <xsl:when test="@type='dim'">&#x02D3;</xsl:when>
                        <xsl:when test="@type='crescdim'">&#x02D2;&#x02D3;</xsl:when>
                        <xsl:when test="@type='Gclef'">&#x;</xsl:when>
                        <xsl:when test="@type='Fclef'">&#x;</xsl:when>
                        <xsl:when test="@type='Cclef'">&#x;</xsl:when>
                        <xsl:otherwise><!-- do nothing for now --></xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
