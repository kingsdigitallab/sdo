<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="tei:lb">
    <br/>
  </xsl:template>

  <xsl:template match="tei:divGen">
    <xsl:if test="@xml:id='contact'">
      <form action="http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl"
            method="POST" name="sdo_c">
        <input name="script" type="hidden" value="sdo_c" />
        <p class="content">
          <xsl:text>Full Name</xsl:text><br/>
          <input id="fullname" name="fullname" type="text" /><br/>
          <xsl:text>Institution</xsl:text><br/>
          <input id="institution" name="institution" type="text" /><br/>
          <xsl:text>Email Address</xsl:text><br/>
          <input id="email" name="email" type="text" /><br/>
          <xsl:text>Your Comments</xsl:text><br/>
          <textarea id="comments" name="comments" rows="6" cols="60">&#160;</textarea>
        </p>
        <p class="content">
          <input type="text" value="" name="subtotal" class="fs" />
          <input type="submit" value="Submit" name="B1"  /><xsl:text>  </xsl:text>
        </p>
      </form>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:listBibl">
    <div class="unorderedList">
      <div class="t01">
        <ul>
          <xsl:apply-templates/>
        </ul>
      </div>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:author">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:title">
    <xsl:choose>
      <xsl:when test="@level = 'j' or level='m'">
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:when test="@level ='a'">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="@level ='s'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:otherwise>  
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:note | tei:ptr[@type='footnote']">
    <sup>
      <a class="fnLink">
        <xsl:attribute name="href">
          <xsl:text>#fn</xsl:text>
          <xsl:number format="01" from="sdo:recordCollection" level="any"/>
        </xsl:attribute>
        <xsl:attribute name="id">
          <xsl:text>fnLink</xsl:text>
          <xsl:number format="01" from="sdo:recordCollection" level="any"/>
        </xsl:attribute>
        <xsl:number from="sdo:recordCollection" level="any"/>
      </a>
    </sup>
  </xsl:template>

</xsl:stylesheet>