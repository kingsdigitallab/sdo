<xsl:stylesheet version="2.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">

    <xsl:import href="../default.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 27, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> paulcaton</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:param name="menutop" select="'true'"/>

    <xsl:param name="filedir"/>
    <xsl:param name="filename"/>
    <xsl:param name="fileextension"/>

    <xsl:variable name="xmg:title">
        <xsl:text>Browse Diaries by Date</xsl:text>
    </xsl:variable>
    <xsl:variable name="root" select="/"/>

    <xsl:template name="xms:content">
        <ul>
            <li>
                <a>1896 - 1899</a>
                <ul>
                    <li>
                        <a>1896</a>
                        <ul>
                            <li><a>January</a> | <a>February</a> | <a>March</a> | <a>April</a> |
                                    <a>May</a> | <a>June</a> | <a>July</a> | <a>August</a> |
                                    <a>September</a> | <a>October</a> | <a>November</a> |
                                    <a>December</a></li>
                        </ul>

                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1897</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1898</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1899</a>
                    </li>
                </ul>
            </li>
            <li>
                <a>1900 - 1909</a>
                <ul>
                    <li>
                        <a>1900</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1901</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1902</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1902</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1904</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1905</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1906</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1907</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1908</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1909</a>
                    </li>
                </ul>
            </li>
            <li>
                <a>1910 - 1919</a>
                <ul>
                    <li>
                        <a>1910</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1911</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1912</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1913</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1914</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1915</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1916</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1917</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1918</a>
                        <ul>
                            <li><a>January</a> | <a>February</a> | <a>March</a> | <a>April</a> |
                                <a>May</a> | <a>June</a> | <a>July</a> | <a>August</a> |
                                <a>September</a> | <a>October</a> | <a>November</a> |
                                <a>December</a></li>
                        </ul>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1919</a>
                    </li>
                </ul>
            </li>
            <li>
                <a>1920 - 1929</a>
                <ul>
                    <li>
                        <a>1920</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1921</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1922</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1923</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1924</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1925</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1926</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1927</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1928</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1929</a>
                    </li>
                </ul>
            </li>
            <li>
                <a>1930 - 1936</a>
                <ul>
                    <li>
                        <a>1930</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1931</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1932</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1933</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1934</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1935</a>
                    </li>
                </ul>
                <ul>
                    <li>
                        <a>1936</a>
                    </li>
                </ul>
            </li>
        </ul>


        <!-- THIS IS THE CODE THAT TRANSFORMS ELEMENTS FROM THE SOLR RESPONSE
            <xsl:for-each select="//doc">
                <xsl:variable name="file" select="concat(child::str[@name='id'], '.html')"></xsl:variable>
                <h3>
                    <a href="{$file}"><xsl:value-of select="child::arr[@name='date']/child::str[1]"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="child::arr[@name='date']/child::str[position()=last()]"/></a>
                </h3>
            </xsl:for-each>
-->
    </xsl:template>

</xsl:stylesheet>
