<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:param name="type"/>

  <xsl:variable name="xmg:title">
    <xsl:text>Browse </xsl:text>
    <xsl:choose>
      <xsl:when test="$type = 'cd'">
        <xsl:text>Correspondnece and Diaries</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="upper-case(substring($type, 1, 1))"/>
        <xsl:value-of select="substring($type, 2)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> by Date</xsl:text>
  </xsl:variable>

  <xsl:template name="xms:content">
    <div id="side">
      <ul id="acc3" class="accordion">
        <!-- Group by year. -->
        <xsl:for-each-group select="/aggregation/response/result/doc/str[@name='dateShort']" group-by="substring(., 1, 4)">
          <xsl:sort select="current-grouping-key()"/>
          <li class="s7">
            <a>
              <span>
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:call-template name="add-item-count"/>
              </span>
            </a>
            <!-- Group by month. -->
            <xsl:for-each-group select="current-group()"
                                group-by="substring(., 6, 2)">
              <xsl:sort select="current-grouping-key()"/>
              <ul>
                <li class="s7">
                  <a>
                    <span>
                      <xsl:value-of select="format-date(xs:date(concat('1111-', current-grouping-key(), '-01')), '[MNn]', 'en', (), ())"/>
                      <xsl:call-template name="add-item-count"/>
                    </span>
                  </a>
                  <ul id="date">
                    <!-- Group by day. -->
                    <xsl:for-each-group select="current-group()"
                                        group-by="substring(., 9, 2)">
                      <xsl:sort select="current-grouping-key()"/>
                      <li>
                        <a>
                          <xsl:attribute name="href">
                            <xsl:text>../../profiles/date/</xsl:text>
                            <xsl:value-of select="."/>
                            <xsl:text>.html#</xsl:text>
                            <xsl:value-of select="$type"/>
                          </xsl:attribute>
                          <span>
                            <xsl:value-of select="format-date(xs:date(concat('1111-01-', current-grouping-key())), '[D1o]', 'en', (), ())"/>
                            <xsl:call-template name="add-item-count"/>
                          </span>
                        </a>
                      </li>
                    </xsl:for-each-group>
                  </ul>
                </li>
              </ul>
            </xsl:for-each-group>
          </li>
        </xsl:for-each-group>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="add-item-count">
    <xsl:text>: </xsl:text>
    <xsl:value-of select="count(current-group())"/>
    <xsl:text> item</xsl:text>
    <xsl:if test="count(current-group()) &gt; 1">
      <xsl:text>s</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>