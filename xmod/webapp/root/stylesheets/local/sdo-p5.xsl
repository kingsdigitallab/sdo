<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


 <xsl:import href="../xmod/tei/p5.xsl"/>
 
 <xsl:strip-space elements="tei:subst"/>

 <!-- NOW OVERRIDE DEFAULTS FROM p5.xsl OR SUPPLY TEMPLATES IT DOESN'T HAVE -->


 <xsl:template match="tei:ab">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:add">
  <xsl:choose>
   <xsl:when test="@place = 'superimposed'">
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:address">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::tei:address">
   <br/>
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:addrLine">
  <xsl:apply-templates/>
  <br/>
 </xsl:template>

 <xsl:template match="tei:author">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:del">
  <xsl:choose>
   <xsl:when test="@rend = 'overstrike'">
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:when test="@rend = 'overwritten'">
    <span class="erased2">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:div">
  <xsl:choose>
   <!--Contact Details Box -->
   <!-- THIS IS WRONG, DOESN'T WORK IN HTML -->
   <xsl:when test="@type='box'">
    <address>
          <xsl:apply-templates/>
        </address>
   </xsl:when>
   <!-- match 'transcription' and 'translation' divs in a primary document -->
   <xsl:when test="parent::sdo:record">
    <xsl:choose>
     <xsl:when test="child::tei:opener">
      <div id="opener">
       <xsl:apply-templates select="child::tei:opener"/>
      </div>
      <div>
       <xsl:apply-templates
        select="child::tei:opener/following-sibling::tei:*[not(self::tei:closer)]"/>
      </div>
      <xsl:if test="child::tei:closer">
       <div id="closer">
        <xsl:apply-templates select="tei:closer"/>
       </div>
      </xsl:if>
     </xsl:when>
     <xsl:otherwise>
      <div>
       <xsl:apply-templates select="child::tei:*[not(self::tei:closer)]"/>
      </div>
      <xsl:if test="child::tei:closer">
       <div id="closer">
        <xsl:apply-templates select="tei:closer"/>
       </div>
      </xsl:if>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <!--   Default  -->
   <xsl:otherwise>
    <!-- Creates anchor if there is @xml:id -->
    <xsl:if test="@xml:id">
     <a>
      <xsl:attribute name="id">
       <xsl:value-of select="@xml:id"/>
      </xsl:attribute>
      <xsl:text>&#160;</xsl:text>
     </a>
    </xsl:if>
    <div>
     <xsl:apply-templates/>
    </div>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:divGen">
  <xsl:if test="@xml:id='contact'">
   <form action="http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl" method="POST" name="sdo_c">
    <input name="script" type="hidden" value="sdo_c"/>
    <p class="content">
     <xsl:text>Full Name</xsl:text>
     <br/>
     <input id="fullname" name="fullname" type="text"/>
     <br/>
     <xsl:text>Institution</xsl:text>
     <br/>
     <input id="institution" name="institution" type="text"/>
     <br/>
     <xsl:text>Email Address</xsl:text>
     <br/>
     <input id="email" name="email" type="text"/>
     <br/>
     <xsl:text>Your Comments</xsl:text>
     <br/>
     <textarea id="comments" name="comments" rows="6" cols="60">&#160;</textarea>
    </p>
    <p class="content">
     <input type="text" value="" name="subtotal" class="fs"/>
     <input type="submit" value="Submit" name="B1"/>
     <xsl:text>  </xsl:text>
    </p>
   </form>
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:fw">
  <xsl:choose>
   <xsl:when test="@type='envelope'">
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:when test="@type='header'">
    <xsl:choose>
     <xsl:when test="@rend='center'">
      <br/>
      <span class="headerCenter">
       <xsl:apply-templates/>
      </span>
     </xsl:when>
    </xsl:choose>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:lb">
  <br/>
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

 <xsl:template match="tei:note">
  <xsl:choose>
   <xsl:when test="@type='editorial'">
    <xsl:choose>
     <xsl:when test="@place='foot'">
      <xsl:variable name="fnNum" select="substring(substring-after(@xml:id, '-'), 3, 2)"/>
      <sup>
       <a class="fnLink">
        <xsl:attribute name="href">
         <xsl:text>#fn</xsl:text>
         <xsl:value-of select="$fnNum"/>
        </xsl:attribute>
        <xsl:attribute name="id">
         <xsl:text>fnLink</xsl:text>
         <xsl:value-of select="$fnNum"/>
        </xsl:attribute>
        <xsl:choose>
         <xsl:when test="starts-with($fnNum, '0')">
          <xsl:value-of select="substring($fnNum, 2, 1)"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:value-of select="$fnNum"/>
         </xsl:otherwise>
        </xsl:choose>
       </a>
      </sup>
     </xsl:when>
     <xsl:otherwise>
      <span class="editorial">
       <xsl:text>[</xsl:text>
       <xsl:apply-templates/>
       <xsl:text>]</xsl:text>
      </span>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text> </xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:pb">
  <xsl:if test="number(@n) > 1">
   <xsl:text> {</xsl:text>
   <xsl:value-of select="@n"/>
   <xsl:text>} </xsl:text>
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:ptr">
  <xsl:variable name="ptrNum" select="substring(substring-after(@corresp, '-'), 3, 2)"/>
  <sup>
   <a class="fnLink">
    <xsl:attribute name="href">
     <xsl:text>#fn</xsl:text>
     <xsl:value-of select="$ptrNum"/>
    </xsl:attribute>
    <xsl:choose>
     <xsl:when test="starts-with(@corresp, 'http://')">
      <xsl:call-template name="external-link"/>
     </xsl:when>
     <xsl:when test="starts-with(@corresp, '#')">
      <xsl:attribute name="title">
       <xsl:text>Link internal to this page</xsl:text>
      </xsl:attribute>
     </xsl:when>
     <xsl:otherwise>
      <xsl:attribute name="title">
       <xsl:text>Encoding error: @corresp does not start with 'http://' and not internal link</xsl:text>
      </xsl:attribute>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
     <xsl:when test="starts-with($ptrNum, '0')">
      <xsl:value-of select="substring($ptrNum, 2, 1)"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="$ptrNum"/>
     </xsl:otherwise>
    </xsl:choose>
   </a>
  </sup>
 </xsl:template>

 <xsl:template match="tei:quote">
  <xsl:choose>
   <xsl:when test="@rend='block'">
    <blockquote>
     <xsl:apply-templates/>
    </blockquote>
   </xsl:when>
   <xsl:otherwise><!-- do nothing --></xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:salute">
  <br/>
  <xsl:if test="parent::tei:opener">
   <br/>
  </xsl:if>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:signed">
  <br/>
  <span class="editorial">
   <xsl:text>[</xsl:text>
   <em>signed:</em>
   <xsl:text>] </xsl:text>
  </span>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:subst">
  <span onmouseout="show(this)" onmouseover="show(this)" class="erased">
   <xsl:apply-templates/>
  </span>
 </xsl:template>

 <xsl:template match="tei:supplied">
  <span class="editorial">
   <xsl:apply-templates/>
  </span>
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

</xsl:stylesheet>
