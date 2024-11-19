<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../default.xsl" />

  <xsl:variable name="xmg:title">
    <xsl:text>Browse Other by Title</xsl:text>
  </xsl:variable>

  <xsl:template name="xms:content">

    <form action="/mobile/docs.zip" method="get" id="dlDocForm" onsubmit="return validate()">
      <!-- KFL - it would look nicer if this was replaced by side menu options (see default.xsl)
      when script was enabled and this is the no-script option -->
      
      
      <p>Downloads temporarily removed for testing purposes</p>
      <!-- COMMENTED OUT BY PC , 19 NOV 2024, TO SEE IF THESE DOWNLOAD FUNCTIONS WERE THE CAUSE OF INSTABILITY ISSUES, POSSIBLY BY BEING HIT REPEATEDLY BY BOTS
        
        <p>Download all selected files as <input type="submit" name="format" value="pdf" /> or <input
          type="submit" name="format" value="epub" /> or <input type="submit" name="format"
          value="both" /> (check files to select/deselect)<br />Where appropriate save: <input
          type="radio" name="lang" value="all" checked="checked" /> English and German versions <input
          type="radio" name="lang" value="de" /> German version only <input type="radio" name="lang"
          value="en" /> English version only </p>--> <!-- <noscript> </noscript>-->
      <xsl:for-each
        select="/aggregation/response/result/doc/arr[@name='title']/str | /aggregation/response/result/doc/str[@name='title']">
        <ul>
          <li>
            <!-- COMMENTED OUT BY PC , 19 NOV 2024, TO SEE IF THESE DOWNLOAD FUNCTIONS WERE THE CAUSE OF INSTABILITY ISSUES, POSSIBLY BY BEING HIT REPEATEDLY BY BOTS
              
              <input type="checkbox" name="do*ot*{ancestor::doc/str[@name='fileId']}" value="1" />-->
            <a>
              <xsl:attribute name="href">
                <xsl:text>../../documents/other/</xsl:text>
              <xsl:value-of select="ancestor::doc/str[@name='fileId']" />
              <xsl:text>.html</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="." />
            </a>
          </li>
        </ul>
      </xsl:for-each>
    </form>
  </xsl:template>
</xsl:stylesheet>