<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0" xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl" />

  <xsl:variable name="xmg:title" select="'Browse Lessonbooks by Saison'" />

  <xsl:template name="xms:content">
    <ul>
      <li><a href="pupil/1913-1914.html">Saison 1913/14</a></li>
      <li><a href="pupil/1914-1915.html">Saison 1914/15</a></li>
      <li><a href="pupil/1915-1916.html">Saison 1915/16</a></li>
      <li><a href="pupil/1916-1917.html">Saison 1916/17</a></li>
      <li><a href="pupil/1917-1918.html">Saison 1917/18</a></li>
      <li><a href="pupil/1918-1919.html">Saison 1918/19</a></li>
      <li><a href="pupil/1919-1920.html">Saison 1919/20</a></li>
      <li><a href="pupil/1920-1921.html">Saison 1920/21</a></li>
      <li><a href="pupil/1923-1924.html">Saison 1923/24</a></li>
      <li><a href="pupil/1924-1925.html">Saison 1924/25</a></li>
    </ul>
    <!--<ul>-->
      <!-- Group by year. -->
      <!--<xsl:for-each-group group-by="." select="/aggregation/response/result/doc/str[@name='dateYear']">
        <xsl:sort select="current-grouping-key()" />

        <xsl:variable name="saison">
          <xsl:value-of select="xs:integer(current-grouping-key()) - 1" />
          <xsl:text>-</xsl:text>
          <xsl:value-of select="current-grouping-key()" />
        </xsl:variable>

        <li>
          <xsl:choose>
            <xsl:when test="$saison = '1912-1913'"><!-\- do nothing -\-></xsl:when>
            <xsl:otherwise>
              <a href="pupil/{$saison}.html">
              <xsl:text>Saison </xsl:text>
              <xsl:value-of select="substring-before($saison, '-')" />
              <xsl:text>/</xsl:text>
              <xsl:value-of select="substring-after($saison, '-19')" />
            </a>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each-group>-->
    <!--</ul>-->
    <p>To read the entries for a saison in chronologial order, use the starting points listed below:</p>   
    <ul>
      <li>Saison 1915/16 - <a href="https://sdo3.kdl.kcl.ac.uk/documents/lessonbooks/OC-3-3_1915/r0001.html">Brunauer: lessons: Oct 1915</a></li>
      <li>Saison 1917/18 - <a href="https://sdo3.kdl.kcl.ac.uk/documents/lessonbooks/OC-3-3_1917/r0001.html">Blum: lessons: 1st semester 1917/18</a></li>
      <li>Saison 1918/19 - <a href="https://sdo3.kdl.kcl.ac.uk/documents/lessonbooks/OC-3-3_1918/r0001.html">Breisach: lessons: 1918/19</a></li>
      <li>Saison 1919/20 - <a href="https://sdo3.kdl.kcl.ac.uk/documents/lessonbooks/OC-3-3_1919/r0001.html">Brunauer: lessons; Oct 1919-Jan 1920</a></li>
    </ul>
  </xsl:template>
</xsl:stylesheet>
