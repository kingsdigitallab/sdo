<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:param name="type"/>

  <xsl:variable name="xmg:title">
    <xsl:text>Browse </xsl:text>
    <xsl:value-of select="upper-case(substring($type, 1, 1))"/>
    <xsl:value-of select="substring($type, 2)"/>
    <xsl:text> by Date</xsl:text>
  </xsl:variable>

  <xsl:template name="xms:content">
    <div id="side">
      <!-- <ul class="accordion" id="acc3"> 
      <div class="accordion" id="acc3">-->
      <!-- Group by year. -->
      <xsl:for-each-group group-by="substring(., 1, 4)"
        select="/aggregation/response/result/doc/str[@name='dateShort']">
        <table>
          <xsl:sort select="current-grouping-key()"/>
          <xsl:variable name="year" select="current-grouping-key()"/>
          <!-- <li class="s7">
            <a>
            <span> -->
          <tr>
            <td colspan="12" align="left">
              <h2>
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:text>: </xsl:text>
                <xsl:call-template name="add-item-count">
                  <xsl:with-param name="year" select="$year" />
                  <xsl:with-param name="month" select="'*'" />
                </xsl:call-template>
              </h2>
            </td>
          </tr>
          <!--  </span>
             </a> -->
          <tr class="monthList">
            <!-- Group by month. -->
            <xsl:for-each-group group-by="substring(., 6, 2)" select="current-group()">
              <xsl:sort select="current-grouping-key()"/>
              
              <xsl:variable name="dayList" >              
              <!-- Group by day. -->
                <xsl:for-each-group group-by="substring(., 9, 2)" select="current-group()">
                  <xsl:sort select="current-grouping-key()" />
                      <xsl:value-of select="substring(., 9, 2)" /><xsl:text>:</xsl:text><xsl:value-of select="count(current-group())" /><xsl:text>,</xsl:text>     
                </xsl:for-each-group>  
              </xsl:variable>
              
              <td>
                <xsl:attribute name="id">
                  <xsl:value-of select="concat($year, '-', current-grouping-key())"/>
                </xsl:attribute>
                <xsl:attribute name="days">
                  <xsl:value-of select="$dayList"/>
                </xsl:attribute>
                <ul>
                  <li class="s7">
                    <span>
                      <xsl:value-of select="format-date(xs:date(concat('1111-', current-grouping-key(), '-01')), '[MNn]', 'en', (), ())" />
                    </span>
                  </li>
                  <li>
                    <xsl:call-template name="add-item-count">
                      <xsl:with-param name="year" select="$year" />
                      <xsl:with-param name="month" select="current-grouping-key()" />
                    </xsl:call-template>
                  </li>
                  <!-- <li>                
                    <span id="date"> -->
                  <!-- Group by day. -->
                  <!-- <xsl:for-each-group group-by="substring(., 9, 2)" select="current-group()">
                      <xsl:sort select="current-grouping-key()" />
                      <p>
                        <a>
                          <xsl:attribute name="href">
                            <xsl:text>../../profiles/date/</xsl:text>
                            <xsl:value-of select="." />
                            <xsl:text>.html#</xsl:text>
                            <xsl:value-of select="$type" />
                          </xsl:attribute>
                          <span>
                            <xsl:value-of
                              select="format-date(xs:date(concat('1111-01-', current-grouping-key())), '[D1o]', 'en', (), ())" />
                            <xsl:call-template name="add-item-count" />
                          </span>
                        </a>
                      </p>
                    </xsl:for-each-group>
                  </span>                   
                  </li> -->
                </ul>
                <!-- <div>
                <xsl:attribute name="id"><xsl:value-of select="substring(., 1, 7)" /></xsl:attribute>
                <a href="#">OO</a>
                <xsl:for-each-group group-by="substring(., 9, 2)" select="current-group()">
                      <xsl:sort select="current-grouping-key()" />                
                </xsl:for-each-group>
              </div> -->
              </td>
              <!-- <ul id="date"> -->
              <!-- Group by day. -->
              <!-- <xsl:for-each-group group-by="substring(., 9, 2)" select="current-group()">
                      <xsl:sort select="current-grouping-key()" />
                      <li>
                        <a>
                          <xsl:attribute name="href">
                            <xsl:text>../../profiles/date/</xsl:text>
                            <xsl:value-of select="." />
                            <xsl:text>.html#</xsl:text>
                            <xsl:value-of select="$type" />
                          </xsl:attribute>
                          <span>
                            <xsl:value-of
                              select="format-date(xs:date(concat('1111-01-', current-grouping-key())), '[D1o]', 'en', (), ())" />
                            <xsl:call-template name="add-item-count" />
                          </span>
                        </a>
                      </li>
                    </xsl:for-each-group>
                  </ul>
                </li>
              </ul> -->
            </xsl:for-each-group>
          </tr>
          <!-- </li> -->
        </table>
        <xsl:for-each-group group-by="substring(., 6, 2)" select="current-group()">
          <xsl:sort select="current-grouping-key()"/>
          <span class="calendar">
            <xsl:attribute name="id">
              <xsl:value-of select="concat('datepicker', substring(current(), 1, 4), current-grouping-key())"/>
            </xsl:attribute><xsl:text> </xsl:text>
          </span>
        </xsl:for-each-group>
        <!-- 
            <xsl:for-each-group group-by="substring(., 6, 2)" select="current-group()">
              <xsl:sort select="current-grouping-key()" />
              <div>
                <xsl:attribute name="id"><xsl:value-of select="substring(., 6, 2)" /></xsl:attribute>
                XX
                <xsl:for-each-group group-by="substring(., 9, 2)" select="current-group()">
                      <xsl:sort select="current-grouping-key()" />                
                </xsl:for-each-group>
              </div>
          </xsl:for-each-group> -->
      </xsl:for-each-group>
    </div>
    <!-- </ul>
    </div> -->
  </xsl:template>

  <xsl:template name="add-item-count">
    <xsl:param name="year" />
    <xsl:param name="month" />
    <!-- <xsl:text>: </xsl:text> --><a>
      <xsl:attribute name="href">/profiles/date/<xsl:value-of select="$year" />-<xsl:value-of select="$month" />-*.html</xsl:attribute>
      <xsl:value-of select="count(current-group())"/></a><!--  -->
    <xsl:text> item</xsl:text>
    <xsl:if test="count(current-group()) &gt; 1">
      <xsl:text>s</xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
