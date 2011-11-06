<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- This stylesheet displays a list of the correspondence items (sorted by tag) and diary entries under one date, .
        eg.  
        
    -->

    <xsl:import href="../default.xsl"/>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:param name="date"/>

    <xsl:variable name="xmg:title">
        <xsl:text>Browse Correspondence/Diaries By Date</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>

    <xsl:template name="xms:content">
        <h2>
            <xsl:value-of select="$date"/>
        </h2>
        <xsl:call-template name="corrItems"/>
        <xsl:call-template name="diaryEntries"/>
    </xsl:template>

    <xsl:template name="corrItems">
        <h3>Items of correspondence</h3>
        <xsl:choose>
            <xsl:when
                test="/aggregation/response/result/doc[child::str[@name='kind']='correspondence']">
                <ul>
                    <xsl:for-each
                        select="/aggregation/response/result/doc[child::str[@name='kind']='correspondence']">
                        <xsl:sort select="child::arr[@name='tag']/child::str[1]"/>
                        <xsl:variable name="filename" select="child::str[@name='fileId']"/>
                        <li>
                            <h2>
                                <a href="{concat('/documents/correspondence/dates/', $date, '/', $filename)}">
                                    <xsl:value-of select="child::str[@name='shelfmark']"/>
                                    <xsl:text> : </xsl:text>
                                    <xsl:value-of
                                        select="replace(child::arr[@name='tag']/child::str[1], '_', ' ~ ')"
                                    />
                                </a>
                            </h2>
                            <p>
                                <xsl:value-of select="child::str[@name='document_title']"/>
                                <br/>
                                <xsl:value-of select="child::str[@name='description']"/>
                            </p>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[none]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="diaryEntries">
        <h3>Diary entries</h3>
        <ul>
            <xsl:for-each
                select="/aggregation/response/result/doc[child::str[@name='kind']='diary']">
                <xsl:variable name="filename" select="child::str[@name='fileId']"/>
                <li>
                    <h2>
                        <a href="{concat('/documents/diaries/dates/', $date, '/', $filename)}">
                            <xsl:value-of select="child::str[@name='dateShort']"/>
                            <xsl:text> : </xsl:text>
                            <xsl:value-of
                                select="replace(child::arr[@name='tag']/child::str[1], '_', ' ~ ')"
                            />
                        </a>
                    </h2>
                    <p>
                        <xsl:value-of select="child::str[@name='document_title']"/>
                        <br/>
                        <xsl:value-of select="child::str[@name='description']"/>
                    </p>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>


</xsl:stylesheet>
