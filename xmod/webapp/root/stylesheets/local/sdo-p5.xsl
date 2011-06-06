<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
 xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
 xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
 xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


 <xsl:import href="../xmod/tei/p5.xsl"/>

 <!-- NOW OVERRIDE DEFAULTS FROM p5.xsl OR SUPPLY TEMPLATES IT DOESN'T HAVE -->


 <xsl:template match="tei:ab">
  <p>
   <xsl:apply-templates/>
  </p>
 </xsl:template>

 <xsl:template match="tei:add">
  <xsl:choose>
   <xsl:when test="@place = 'inline'">
    <span class="inline-addition">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@place = 'interlinear-above'">
    <span class="interlinear-addition">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@place = 'superimposed'"/>
   <!-- template for tei:subst handles this -->
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
    <span class="inline-deletion">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend = 'overwritten'"/>
   <!-- template for tei:subst handles this -->
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

 <xsl:template match="tei:gap">
  <span class="editorial">
   <xsl:text>[illegible]</xsl:text>
  </span>
 </xsl:template>


 <xsl:template match="tei:hi">
  <xsl:choose>
   <!-- ITALICS -->
   <xsl:when test="@rend='italic'">
    <em>
     <xsl:apply-templates/>
    </em>
   </xsl:when>
   <!-- BOLD -->
   <xsl:when test="@rend='bold'">
    <strong>
     <xsl:apply-templates/>
    </strong>
   </xsl:when>
   <!-- BOLD AND ITALICS -->
   <xsl:when test="@rend='bolditalic'">
    <strong>
     <em>
      <xsl:apply-templates/>
     </em>
    </strong>
   </xsl:when>
   <xsl:when test="@rend='sup'">
    <sup>
     <xsl:apply-templates/>
    </sup>
   </xsl:when>
   <xsl:when test="@rend='sub'">
    <sub>
     <xsl:apply-templates/>
    </sub>
   </xsl:when>
   <xsl:when test="@rend='supralinear'">
    <sup>
     <xsl:apply-templates/>
    </sup>
   </xsl:when>
   <xsl:when test="@rend='underline'">
    <span class="underline">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <!-- CURRENT DEFAULT: italics -->
   <xsl:otherwise>
    <em>
     <xsl:apply-templates/>
    </em>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:item">
  <li>
   <xsl:apply-templates/>
  </li>
 </xsl:template>

 <xsl:template match="tei:lb">
  <br/>
 </xsl:template>

 <xsl:template match="tei:list">
  <ul>
   <xsl:apply-templates/>
  </ul>
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


 <xsl:template match="tei:ref">
  <xsl:choose>
   <xsl:when test="@type  = 'external' or @rend = 'external'">
    <a href="{@target}">
     <xsl:call-template name="external-link"/>
     <xsl:apply-templates/>
    </a>
   </xsl:when>
   <xsl:when test="@cRef">
    <xsl:choose>
     <xsl:when test="contains(@cRef, '#')">
      <xsl:variable name="file" select="substring-before(@cRef, '#')"/>
      <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
      <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
      <xsl:variable name="anchor" select="substring-after(@cRef, '#')"/>
      <a title="Link internal to this page">
       <xsl:attribute name="href">
        <xsl:if test="string($file)">
         <xsl:value-of select="$path"/>
        </xsl:if>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$anchor"/>
       </xsl:attribute>
       <xsl:call-template name="internal-link">
        <xsl:with-param name="title" select="$title"/>
       </xsl:call-template>
       <xsl:apply-templates/>
      </a>
     </xsl:when>
     <xsl:otherwise>
      <xsl:variable name="file" select="@cRef"/>
      <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
      <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
      <a>
       <xsl:call-template name="internal-link">
        <xsl:with-param name="title" select="$title"/>
       </xsl:call-template>
       <xsl:attribute name="href">
        <xsl:value-of select="$xmp:context-path"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$path"/>
       </xsl:attribute>
       <xsl:apply-templates/>
      </a>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:when test="@target">
    <a>
     <xsl:attribute name="href">
      <xsl:if test="starts-with(@target, '/')">
       <xsl:value-of select="$xmp:context-path"/>
      </xsl:if>
      <!-- This is well dodgy. -->
      <xsl:value-of select="@target"/>
     </xsl:attribute>
     <xsl:apply-templates/>
    </a>
   </xsl:when>
  </xsl:choose>
 </xsl:template>
 <!-- href classes for same or new window -->
 <xsl:template name="external-link">
  <!-- Title information and extra class for if external window -->
  <xsl:choose>
   <!-- Open in a new window -->
   <xsl:when test="@rend='newWindow'">
    <xsl:attribute name="class">
     <xsl:text>extNew</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="rel">
     <xsl:text>external</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="title">
     <xsl:text>External website (Opens in a new window)</xsl:text>
    </xsl:attribute>
   </xsl:when>
   <!-- Open in same window -->
   <xsl:otherwise>
    <xsl:attribute name="class">
     <xsl:text>ext</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="title">
     <xsl:text>External website</xsl:text>
    </xsl:attribute>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 <xsl:template name="internal-link">
  <xsl:param name="title"/>
  <!-- Title information and extra class for if external window -->
  <xsl:choose>
   <!-- Open in a new window -->
   <xsl:when test="@rend='newWindow'">
    <xsl:attribute name="class">
     <xsl:text>intNew</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="rel">
     <xsl:text>external</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="title">
     <xsl:text>Link to </xsl:text>
     <xsl:value-of select="$title"/>
     <xsl:text> (Opens in a new window)</xsl:text>
    </xsl:attribute>
   </xsl:when>
   <!-- Open in same window -->
   <xsl:otherwise>
    <xsl:attribute name="class">
     <xsl:text>int</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="title">
     <xsl:text>Link to </xsl:text>
     <xsl:value-of select="$title"/>
    </xsl:attribute>
   </xsl:otherwise>
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
  <xsl:choose>
   <xsl:when test="child::tei:del[@rend='overwritten']">
    <span class="erased" onmouseover="show(this)" onmouseout="show(this)" xml:space="preserve"><span class="erased2"><xsl:value-of select="child::tei:del[@rend='overwritten']"/></span><xsl:value-of select="child::tei:add[@place='superimposed']"/></span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:supplied">
  <span class="editorial">
   <xsl:text>[</xsl:text>
   <xsl:apply-templates/>
   <xsl:text>] </xsl:text>
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
