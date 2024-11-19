<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../profiles/profile-to-html.xsl" />

  <xsl:param name="entity" />

  <xsl:variable name="xmg:title">
    <!-- We should really be aggregating a search for the EATS entity
         data, and getting the title from there, rather than using
         text that comes from a random TEI document. -->
    <xsl:value-of
      select="substring-after(/aggregation/response/result/doc[1]/arr[@name='correspondence']/str[substring-before(., ' ') = $entity], ' ')"
     />
  </xsl:variable>

  <xsl:template name="xms:content">
    <xsl:choose>
      <xsl:when test="/aggregation/tei:TEI">
        <xsl:apply-templates select="/aggregation/tei:TEI" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="entity-from-eats" />
      </xsl:otherwise>
    </xsl:choose>
    <div>
      <xsl:choose>
        <xsl:when test="/aggregation/response/result/doc">
          
          <form action="/mobile/docs.zip" method="get" id="dlDocForm" onsubmit="return validate()">
            <!-- KFL - it would look nicer if this was replaced by side menu options (see default.xsl) when script was enabled and this is the no-script option -->
            
            <p>Downloads temporarily removed for testing purposes</p>
            <!-- COMMENTED OUT BY PC , 19 NOV 2024, TO SEE IF THESE DOWNLOAD FUNCTIONS WERE THE CAUSE OF INSTABILITY ISSUES, POSSIBLY BY BEING HIT REPEATEDLY BY BOTS
              
              <p>Download all selected files as <input type="submit" name="format" value="pdf" /> or <input type="submit" name="format" value="epub" /> or <input type="submit" name="format" value="both" /> (check files to select/deselect)<br />Where appropriate save: 
              <input type="radio" name="lang" value="all" checked="checked" /> English and German versions <input type="radio" name="lang" value="de" /> German version only <input type="radio" name="lang" value="en" /> English version only
            </p>--> <!-- <noscript> </noscript>-->
            <p>Documents comprising this correspondence:</p>
          <ul>
            <xsl:apply-templates select="/aggregation/response/result/doc" />
          </ul>
          </form>  
        </xsl:when>
        <xsl:otherwise>
          <p>There are no documents in this correspondence.</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
</xsl:stylesheet>
