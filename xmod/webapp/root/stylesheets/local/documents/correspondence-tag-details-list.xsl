<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="../default.xsl"/>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:param name="tag"/>
    <xsl:param name="filedir"/>
    <xsl:param name="filename"/>
    <xsl:param name="fileextension"/>

    <xsl:variable name="xmg:title">
        <xsl:text>Browse Correspondence By Name</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>
    <xsl:variable name="expanded_tag" select="replace($tag, '_', ' ')"/>

    <xsl:template name="xms:content">
        <h2><xsl:value-of select="$expanded_tag"></xsl:value-of></h2>
        <ul>
            
            <xsl:for-each select="/*/indices/index[@name=$filename]/entry[child::tag = $expanded_tag]">
                <xsl:sort select="@date"/>
                <xi:include href="cocoon://internal/tag/correspondence/FILENAME.html"/>
            </xsl:for-each>
        </ul>
    </xsl:template>

</xsl:stylesheet>
