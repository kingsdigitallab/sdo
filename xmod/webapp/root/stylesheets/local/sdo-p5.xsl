<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns="http://www.w3.org/1999/xhtml"
 xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
 xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
 xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
 xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
 xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:import href="../xmod/tei/p5.xsl"/>

 <!-- NOW OVERRIDE DEFAULTS FROM p5.xsl OR SUPPLY TEMPLATES IT DOESN'T HAVE -->


 <xsl:template match="tei:ab">
  <xsl:choose>
   <xsl:when test="(name(child::*[1])='tei:list') and (name(child::*[last()])='tei:list')">
    <!-- if <tei:ab> just wraps a <tei:list>, don't create a <p> -->
    <xsl:apply-templates/>
   </xsl:when>
   <!-- ****** -->
   <!-- this second condition relates to visualization testing by PC, 04/06/2014 -->
   <xsl:when test="@type='makediv'">
    <div>
     <xsl:if test="@subtype">
      <xsl:attribute name="class" select="@subtype"/>
     </xsl:if>
     <xsl:if test="@xml:id">
      <xsl:attribute name="id" select="@xml:id"/>
     </xsl:if>
     <xsl:apply-templates/>
    </div>
   </xsl:when>
   <!-- ****** -->
   <xsl:otherwise>
    <p>
     <xsl:if test="@type='division-marker'">
      <xsl:attribute name="class">c</xsl:attribute>
     </xsl:if>
     <xsl:apply-templates/>
    </p>
   </xsl:otherwise>
  </xsl:choose>
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
   <xsl:when test="@place = 'margin-bot'">
    <br/>
    <br/>
    <xsl:apply-templates/>
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
  <br/>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:author">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:bibl">
  <xsl:choose>
   <xsl:when test="parent::tei:listBibl">
    <li>
     <xsl:apply-templates/>
    </li>
   </xsl:when>
   <xsl:when test="parent::tei:cit and preceding-sibling::tei:q">
    <br/>
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:cell">
  <td>
   <xsl:attribute name="class" select="@rend"/>
   <xsl:apply-templates/>
  </td>
 </xsl:template>

 <xsl:template match="tei:choice">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:cit">
  <xsl:choose>
   <xsl:when test="parent::tei:p">
    <span class="inside-block">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- ****************** -->
 <!-- ****************** -->
 <!-- <tei:code> is not used in regular SDO encoding so we use it for visualization test code. PC, 3rd June 2014-->
 <xsl:template match="tei:code">
  <xsl:choose>
   <xsl:when test="@lang = 'js'">
    <span>Make way for Wibbly-Wobbly ducks!</span>
    <script type="text/javascript">
     <xsl:apply-templates/>
    </script>

   </xsl:when>
   <xsl:otherwise>
    <!-- do nothing useful -->
    <xsl:text>Rafts!</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="processing-instruction()">
  <xsl:value-of select="."/>
 </xsl:template>
 <!-- ****************** -->
 <!-- ****************** -->

 <xsl:template match="tei:corr">
  <xsl:value-of select="."/>
  <span class="editorial">]</span>
 </xsl:template>


 <xsl:template match="tei:date">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:dateline">
  <br/>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:del">
  <xsl:choose>
   <xsl:when test="(@rend='overwritten') and (parent::tei:subst)">
    <!-- do nothing: template for tei:subst handles it -->
   </xsl:when>
   <xsl:when test="@rend = 'overstrike'">
    <span class="inline-deletion">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- tei:desc should only occur inside tei:gap to explain why 
  editor is ommitting some text; template for tei:gap will create a 
  <span class="editorial" to wrap the explanation in -->
 <xsl:template match="tei:desc">
  <xsl:apply-templates/>
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

   <!-- Logos on home page -->
   <xsl:when test="@type='logos'">
    <div class="logoMatrix">
     <div class="t01">
      <xsl:apply-templates/>
     </div>
    </div>
   </xsl:when>

   <!-- match 'transcription' and 'translation' divs in a primary document -->
   <xsl:when test="parent::sdo:record">
    <xsl:choose>
     <xsl:when test="child::tei:div[contains(@type, 'part_')]">
      <xsl:apply-templates mode="multipartItem"/>
      <!-- SEE THE FOLLOWING <XSL:TEMPLATE> -->
     </xsl:when>
     <xsl:when test="child::tei:opener">
      <div>
       <xsl:attribute name="id">
        <xsl:text>opener</xsl:text>
        <xsl:if test="@type">
         <xsl:text>_</xsl:text>
         <xsl:value-of select="@type"/>
        </xsl:if>
       </xsl:attribute>
       <xsl:attribute name="class">
        <xsl:text>opener</xsl:text>
       </xsl:attribute>
       <xsl:if test="child::tei:opener/preceding-sibling::tei:note">
        <xsl:apply-templates select="tei:note"/>
       </xsl:if>
       <xsl:apply-templates select="child::tei:opener"/>
      </div>
      <div>
       <xsl:apply-templates
        select="child::tei:opener/following-sibling::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"
       />
      </div>
      <xsl:if test="child::tei:closer">
       <div class="closer">
        <xsl:attribute name="id">
         <xsl:text>closer</xsl:text>
         <xsl:if test="@type">
          <xsl:text>_</xsl:text>
          <xsl:value-of select="@type"/>
         </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates select="tei:closer"/>
       </div>
      </xsl:if>
      <xsl:if test="child::tei:postscript">
       <div id="postscript">
        <xsl:apply-templates select="tei:postscript"/>
       </div>
      </xsl:if>
      <xsl:if test="child::tei:fw[@type='envelope']">
       <div id="envelope">
        <xsl:apply-templates select="tei:fw[@type='envelope']"/>
       </div>
      </xsl:if>
     </xsl:when>
     <!-- now if there is NOT a <tei:div type="opener"> -->
     <xsl:otherwise>
      <div>
       <xsl:apply-templates
        select="child::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"
       />
      </div>
      <xsl:if test="child::tei:closer">
       <div class="closer">
        <xsl:attribute name="id">
         <xsl:text>closer</xsl:text>
         <xsl:if test="@type">
          <xsl:text>_</xsl:text>
          <xsl:value-of select="@type"/>
         </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates select="tei:closer"/>
       </div>
      </xsl:if>
      <xsl:if test="child::tei:postscript">
       <div id="postscript">
        <xsl:apply-templates select="tei:postscript"/>
       </div>
      </xsl:if>
      <xsl:if test="child::tei:fw[@type='envelope']">
       <div id="envelope">
        <xsl:apply-templates select="tei:fw[@type='envelope']"/>
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

 <!-- This template takes care of situation where we have multiple items in one document, eg. the 
  picture postcard with two separate messages, OJ-8-4_31.xml. It's the same as the <tei:div> template 
  above, but now applying to <tei:div @type='part_X' -->
 <xsl:template match="tei:div" mode="multipartItem">
  <xsl:choose>
   <xsl:when test="child::tei:opener">
    <div>
     <xsl:attribute name="id">
      <xsl:text>opener</xsl:text>
      <xsl:if test="parent::tei:div[1]/@type">
       <xsl:text>_</xsl:text>
       <xsl:value-of select="parent::tei:div[1]/@type"/>
      </xsl:if>
      <xsl:if test="@type">
       <xsl:text>_</xsl:text>
       <xsl:value-of select="@type"/>
      </xsl:if>
     </xsl:attribute>
     <xsl:attribute name="class">
      <xsl:text>opener</xsl:text>
     </xsl:attribute>
     <xsl:if test="child::tei:opener/preceding-sibling::tei:note">
      <xsl:apply-templates select="tei:note"/>
     </xsl:if>
     <xsl:apply-templates select="child::tei:opener"/>
    </div>
    <div>
     <xsl:apply-templates
      select="child::tei:opener/following-sibling::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"
     />
    </div>
    <xsl:if test="child::tei:closer">
     <div class="closer">
      <xsl:attribute name="id">
       <xsl:text>closer</xsl:text>
       <xsl:if test="parent::tei:div[1]/@type">
        <xsl:text>_</xsl:text>
        <xsl:value-of select="parent::tei:div[1]/@type"/>
       </xsl:if>
       <xsl:if test="@type">
        <xsl:text>_</xsl:text>
        <xsl:value-of select="@type"/>
       </xsl:if>
      </xsl:attribute>
      <xsl:apply-templates select="tei:closer"/>
     </div>
    </xsl:if>
    <xsl:if test="child::tei:postscript">
     <div id="postscript">
      <xsl:apply-templates select="tei:postscript"/>
     </div>
    </xsl:if>
    <xsl:if test="child::tei:fw[@type='envelope']">
     <div id="envelope">
      <xsl:apply-templates select="tei:fw[@type='envelope']"/>
     </div>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <div>
     <xsl:apply-templates
      select="child::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"
     />
    </div>
    <xsl:if test="child::tei:closer">
     <div class="closer">
      <xsl:attribute name="id">
       <!--       <xsl:text>closer</xsl:text>-->
       <xsl:if test="parent::tei:div[1]/@type">
        <xsl:text>_</xsl:text>
        <xsl:value-of select="parent::tei:div[1]/@type"/>
       </xsl:if>
       <xsl:if test="@type">
        <xsl:text>_</xsl:text>
        <xsl:value-of select="@type"/>
       </xsl:if>
      </xsl:attribute>
      <xsl:apply-templates select="tei:closer"/>
     </div>
    </xsl:if>
    <xsl:if test="child::tei:postscript">
     <div id="postscript">
      <xsl:apply-templates select="tei:postscript"/>
     </div>
    </xsl:if>
    <xsl:if test="child::tei:fw[@type='envelope']">
     <div id="envelope">
      <xsl:apply-templates select="tei:fw[@type='envelope']"/>
     </div>
    </xsl:if>
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

 <xsl:template match="tei:ex">
  <span class="editorial">
   <xsl:text>[</xsl:text>
   <xsl:apply-templates/>
   <xsl:text>] </xsl:text>
  </span>
 </xsl:template>

 <xsl:template match="tei:figDesc"/>

 <xsl:template match="tei:figure/tei:head"/>

 <xsl:template match="tei:figure">
  <xsl:choose>
   <xsl:when test="parent::tei:p and tei:head"/>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:foreign">
  <xsl:apply-templates/>
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
     <xsl:when test="@rend='inline'">
      <xsl:apply-templates/>
     </xsl:when>
    </xsl:choose>
   </xsl:when>
   <xsl:when test="@type='line'">
    <hr/>
   </xsl:when>
   <xsl:when test="@type='postmark'">
    <br/>
    <span class="editorial">
     <xsl:text>[postmark:]</xsl:text>
    </span>
    <span class="postmark">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:g">
  <xsl:choose>
   <!-- need this first choice because Chord Symbol font does not have clef symbols -->
   <xsl:when test="substring(@type, 2, 4) = 'clef'">
    <span class="char">
     <xsl:choose>
      <xsl:when test="substring(@type, 1, 1) = 'C'">&#x1D121;</xsl:when>
      <xsl:when test="substring(@type, 1, 1) = 'F'">&#x1D122;</xsl:when>
      <xsl:when test="substring(@type, 1, 1) = 'G'">&#x1D120;</xsl:when>
     </xsl:choose>
    </span>
   </xsl:when>
   <xsl:when test="@type='cresc'">&#x1D192;</xsl:when>
   <xsl:when test="@type='dim'">&#x1D193;</xsl:when>
   <xsl:when test="@type='crescdim'">&#x1D192;&#x1D193;</xsl:when>


   <xsl:otherwise>
    <!-- these use Chord Symbol font replacement -->
    <span class="csthree">
     <xsl:choose>
      <xsl:when test="@type='cap1'">&#x0102;</xsl:when>
      <xsl:when test="@type='cap2'">&#x0103;</xsl:when>
      <xsl:when test="@type='cap3'">&#x0104;</xsl:when>
      <xsl:when test="@type='cap4'">&#x0105;</xsl:when>
      <xsl:when test="@type='cap5'">&#x0106;</xsl:when>
      <xsl:when test="@type='cap6'">&#x0107;</xsl:when>
      <xsl:when test="@type='cap7'">&#x0108;</xsl:when>
      <xsl:when test="@type='cap8'">&#x0109;</xsl:when>
      <xsl:when test="@type='2flat'">&#x0118;</xsl:when>
      <xsl:when test="@type='flat'">&#x0119;</xsl:when>
      <xsl:when test="@type='nat'">&#x011A;</xsl:when>
      <xsl:when test="@type='sharp'">&#x011B;</xsl:when>
      <xsl:when test="@type='2sharp'">&#x011C;</xsl:when>
      <xsl:when test="@type='div'">&#x026F;</xsl:when>
      <xsl:otherwise><!-- do nothing for now --></xsl:otherwise>
     </xsl:choose>
    </span>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:gap">
  <xsl:choose>
   <xsl:when test="child::tei:desc">
    <span class="editorial">
     <xsl:text>[</xsl:text>
     <xsl:apply-templates/>
     <xsl:text>]</xsl:text>
    </span>
   </xsl:when>
   <xsl:when test="@reason='illegible' and not(child::tei:desc)">
    <span class="editorial">
     <xsl:text>[illeg]</xsl:text>
    </span>
   </xsl:when>
  </xsl:choose>
 </xsl:template>

 <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TEI:GRAPHIC AND RELATED TEMPLATES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

 <xsl:template match="tei:graphic">
  <xsl:if test="string(@url)">
   <xsl:call-template name="showFigure"/>
  </xsl:if>
 </xsl:template>
 <!-- Image dimensions -->
 <xsl:template name="img-dim">
  <xsl:param name="img-width"/>
  <xsl:param name="img-height"/>
  <xsl:attribute name="width">
   <xsl:value-of select="$img-width"/>
  </xsl:attribute>
  <xsl:attribute name="height">
   <xsl:value-of select="$img-height"/>
  </xsl:attribute>
 </xsl:template>
 <!-- Popup information -->
 <xsl:template name="img-popup">
  <xsl:param name="popup"/>
  <xsl:choose>
   <xsl:when test="string($popup)">
    <xsl:value-of select="$popup"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>x87</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 <!-- SHOW FIGURE /// REDO IT ///-->
 <xsl:template name="showFigure">
  <!-- VARIABLES -->
  <!--   Find info for publication images  -->
  <!-- folder info -->
  <xsl:variable name="img-folder" select="concat($xmp:images-path, '/local')"/>
  <xsl:variable name="img-subpath-full" select="'full'"/>
  <xsl:variable name="img-subpath-thumb" select="'thumb'"/>
  <!-- file info -->
  <xsl:variable name="img-src" select="@url"/>
  <xsl:variable name="img-thm-prefix" select="'thm_'"/>
  <!-- path to images -->
  <xsl:variable name="img-path-full"
   select="concat($img-folder, '/', $img-subpath-full, '/',
      $img-src)"/>
  <xsl:variable name="img-path-thumb"
   select="concat($img-folder, '/', $img-subpath-thumb,
      '/thm_', $img-src)"/>
  <!-- Dimensions -->
  <xsl:variable name="img-width">
   <xsl:choose>
    <xsl:when test="@width">
     <xsl:value-of select="number(substring-before(@width, 'px'))"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>0</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="img-height">
   <xsl:choose>
    <xsl:when test="@height">
     <xsl:value-of select="number(substring-before(@height, 'px'))"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>0</xsl:text>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="img-max-height">
   <xsl:value-of
    select="max(ancestor::tei:list[starts-with(@type,
        'figure')]/tei:item/tei:graphic/number(substring-before(@height, 'px')))"
   />
  </xsl:variable>
  <!-- Caption or description -->
  <xsl:variable name="img-cap-alt">
   <xsl:choose>
    <xsl:when test="parent::tei:figure/tei:figDesc">
     <xsl:value-of select="parent::tei:figure/tei:figDesc"/>
    </xsl:when>
    <xsl:when test="@n">
     <xsl:value-of select="@n"/>
    </xsl:when>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="img-cap-desc" select="ancestor::tei:figure/tei:head"/>
  <!-- Rendition info -->
  <!-- extra width to delimit captions for the inline thumbnails -->
  <xsl:variable name="img-thm-plus-width" select="$img-width + 12"/>
  <!-- Use for the image: prefix with 's' and the div: prefix with 't' -->
  <xsl:variable name="img-left-right">
   <xsl:choose>
    <xsl:when test="contains(@rend, 'left')">
     <xsl:text>01</xsl:text>
    </xsl:when>
    <xsl:when test="contains(@rend, 'right')">
     <xsl:text>02</xsl:text>
    </xsl:when>
    <xsl:otherwise/>
   </xsl:choose>
  </xsl:variable>
  <!-- Used on the anchor for thumb-captions -->
  <xsl:variable name="cap-left-right">
   <xsl:choose>
    <xsl:when test="contains(@rend, 'left')">
     <xsl:text>s03</xsl:text>
    </xsl:when>
    <xsl:when test="contains(@rend, 'right')">
     <xsl:text>s04</xsl:text>
    </xsl:when>
    <xsl:otherwise/>
   </xsl:choose>
  </xsl:variable>
  <!-- Different popup options, x87: shrink to fit, x88 and x89 different html pages -->
  <xsl:variable name="popup">
   <xsl:choose>
    <xsl:when test="contains(@rend, 'img') or ancestor::table[@type='thumbnail'][@rend='img']">
     <xsl:text>x87</xsl:text>
    </xsl:when>
    <xsl:when
     test="contains(@rend, 'html1') or
          ancestor::table[@type='thumbnail'][@rend='html1']">
     <xsl:text>x88</xsl:text>
    </xsl:when>
    <xsl:when
     test="contains(@rend, 'html2') or
          ancestor::table[@type='thumbnail'][@rend='html2']">
     <xsl:text>x89</xsl:text>
    </xsl:when>
   </xsl:choose>
  </xsl:variable>
  <!-- OUTPUT FIGURE TEMPLATE -->
  <xsl:choose>
   <!-- PC, 5 March 2013 -->
   <!-- THE 'WHEN' CONDITION BELOW IS THE CURRENT CODE FOR MUSICAL EXAMPLES IN SDO PRIMARY DOCUMENTS -->
   <xsl:when test="parent::tei:figure[@type='musical_example'] and @n='thumb'">
    <a href="{$img-path-full}" class="x87">
     <img src="{$img-path-thumb}">
      <!-- @alt info -->
      <xsl:if test="string($img-cap-alt)">
       <xsl:attribute name="alt">
        <xsl:value-of select="$img-cap-alt"/>
       </xsl:attribute>
      </xsl:if>
     </img>
    </a>
   </xsl:when>
   <!-- END CODE FOR SDO MUSICAL EXAMPLES IN PRIMARY DOCS-->
   <!-- PC, 24 April 2013 -->
   <!-- THE 'WHEN' CONDITION BELOW IS THE CURRENT CODE FOR MISCELLANEOUS IMAGES IN SDO PRIMARY DOCUMENTS.  IT IS -->
   <!-- FUNCTIONALLY IDENTICAL TO THE MUSICAL EXAMPLE CODE ABOVE, BUT WE WANT TO KEEP THE IMAGE TYPES SEPARATE -->
   <xsl:when test="parent::tei:figure[@type='misc_image'] and @n='thumb'">
    <br/>
    <br/>
    <a href="{$img-path-full}" class="x87">
     <img src="{$img-path-thumb}">
      <!-- @alt info -->
      <xsl:if test="string($img-cap-alt)">
       <xsl:attribute name="alt">
        <xsl:value-of select="$img-cap-alt"/>
       </xsl:attribute>
      </xsl:if>
     </img>
    </a>
    <br/>
   </xsl:when>
   <!-- END CODE FOR SDO MUSICAL EXAMPLES IN PRIMARY DOCS-->
   <!-- START Option 1: showing thumbnail lists -->
   <xsl:when test="ancestor::tei:list[@type='figure-full']">
    <dl style="width: {$img-width}px;">
     <!--<dt style="height: {$img-max-height}px;">-->
     <dt style="height: {$img-max-height}px;">
      <!-- Image -->
      <img src="{$img-path-full}">
       <!-- @alt info -->
       <xsl:if test="string($img-cap-alt)">
        <xsl:attribute name="alt">
         <xsl:value-of select="$img-cap-alt"/>
        </xsl:attribute>
       </xsl:if>
      </img>
     </dt>
     <dd>
      <p>
       <xsl:value-of select="$img-cap-desc"/>
      </p>
     </dd>
    </dl>
   </xsl:when>
   <xsl:when test="ancestor::tei:list[@type='figure-thumb']">
    <dl style="width: {$img-width}px;">
     <dt style="height: {$img-max-height}px;">
      <!-- Full size popup -->
      <a class="x87" href="{$img-path-full}">
       <span>&#160;</span>
       <!-- Thumbnail image -->
       <img src="{$img-path-thumb}">
        <!-- @alt info -->
        <xsl:if test="string($img-cap-alt)">
         <xsl:attribute name="alt">
          <xsl:value-of select="$img-cap-alt"/>
         </xsl:attribute>
        </xsl:if>
       </img>
      </a>
     </dt>
     <dd>
      <p>
       <xsl:value-of select="$img-cap-desc"/>
      </p>
     </dd>
    </dl>
   </xsl:when>
   <xsl:when test="ancestor::tei:list[@type='graphic-list']">
    <img src="{$img-path-full}">
     <!-- IMG @ALT INFO STARTS -->
     <xsl:attribute name="alt">
      <xsl:choose>
       <xsl:when test="string($img-cap-alt)">
        <xsl:value-of select="$img-cap-alt"/>
       </xsl:when>
       <xsl:otherwise>
        <xsl:text>empty</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
     <!-- IMG @ALT INFO ENDS -->
     <xsl:if test="$img-width != 0">
      <xsl:attribute name="width">
       <xsl:value-of select="$img-width"/>
      </xsl:attribute>
     </xsl:if>
     <xsl:if test="$img-height != 0">
      <xsl:attribute name="height">
       <xsl:value-of select="$img-height"/>
      </xsl:attribute>
     </xsl:if>
    </img>
   </xsl:when>
   <!-- START Option 2: Inline images -->
   <!-- Images with renditional information are treated differently, they can be thumbnails, thumbnails with captions or full sized images -->
   <xsl:when test="string(@rend)">
    <xsl:choose>
     <xsl:when test="(@xmt:type='thumb') or (@n='thumb')">
      <a href="{$img-path-full}">
       <xsl:attribute name="class">
        <xsl:value-of select="$cap-left-right"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="img-popup">
         <xsl:with-param name="popup" select="$popup"/>
        </xsl:call-template>
       </xsl:attribute>
       <span>&#160;</span>
       <img class="s{$img-left-right}" src="{$img-path-thumb}">
        <!-- @alt info -->
        <xsl:if test="string($img-cap-alt)">
         <xsl:attribute name="alt">
          <xsl:value-of select="$img-cap-alt"/>
         </xsl:attribute>
        </xsl:if>
       </img>
      </a>
     </xsl:when>
     <!-- Thumbnail with caption inline image: special version for the "Overviews" examples -->
     <xsl:when test="(@n='overviews_eg') and (@xmt:type='thumb-caption')">
      <div class="figure">
       <div class="t{$img-left-right}" id="thumbs">
        <dl style="width: {$img-thm-plus-width}px;">
         <dt>
          <!-- Thumbnail image -->
          <img class="s{$img-left-right}" src="{$img-path-thumb}" data-highres="{$img-path-full}">
           <!-- @alt info -->
           <xsl:attribute name="alt">
            <xsl:value-of select="$img-cap-alt"/>
           </xsl:attribute>
           <xsl:attribute name="onclick">$(this).mbZoomify_overlay({startLevel:0});</xsl:attribute>
          </img>
         </dt>
         <dd>
          <xsl:value-of select="$img-cap-desc"/>
         </dd>
        </dl>
       </div>
      </div>
     </xsl:when>
     <!-- Thumbnail with caption inline image: ordinary version -->
     <xsl:when test="(@xmt:type='thumb-caption') or (@n='thumb-caption')">
      <div class="figure">
       <div class="t{$img-left-right}">
        <dl style="width: {$img-thm-plus-width}px;">
         <dt>
          <!-- Full size popup -->
          <a href="{$img-path-full}">
           <xsl:attribute name="class">
            <xsl:value-of select="$cap-left-right"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="img-popup">
             <xsl:with-param name="popup" select="$popup"/>
            </xsl:call-template>
           </xsl:attribute>
           <span>&#160;</span>
           <!-- Thumbnail image -->
           <img class="s{$img-left-right}" src="{$img-path-thumb}">
            <!-- @alt info -->
            <xsl:if test="string($img-cap-alt)">
             <xsl:attribute name="alt">
              <xsl:value-of select="$img-cap-alt"/>
             </xsl:attribute>
            </xsl:if>
           </img>
          </a>
         </dt>
         <dd>
          <xsl:value-of select="$img-cap-desc"/>
         </dd>
        </dl>
       </div>
      </div>
     </xsl:when>
     <xsl:when test="@xmt:type='full'">
      <xsl:if
       test="not(preceding-sibling::tei:graphic[@xmt:type='thumb' or
              @xmt:type='thumb-caption'])">
       <img class="s{$img-left-right}" src="{$img-path-full}">
        <!-- @alt info -->
        <xsl:if test="string($img-cap-alt)">
         <xsl:attribute name="alt">
          <xsl:value-of select="$img-cap-alt"/>
         </xsl:attribute>
        </xsl:if>
       </img>
      </xsl:if>
     </xsl:when>
     <!-- Full size inline image -->
     <xsl:otherwise>
      <img class="s{$img-left-right}" src="{$img-path-full}">
       <!-- @alt info -->
       <xsl:if test="string($img-cap-alt)">
        <xsl:attribute name="alt">
         <xsl:value-of select="$img-cap-alt"/>
        </xsl:attribute>
       </xsl:if>
      </img>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <!-- START Option 3: showing oneoff thumbnail -->
   <xsl:when test="@xmt:type='thumb-caption'">
    <!-- Displayed in a div unlike the thumbnails which are inline. -->
    <div class="image">
     <div class="t03">
      <dl style="width: {$img-thm-plus-width}px;">
       <dt>
        <!-- Full size popup -->
        <a href="{$img-path-full}">
         <xsl:attribute name="class">
          <xsl:call-template name="img-popup">
           <xsl:with-param name="popup" select="$popup"/>
          </xsl:call-template>
         </xsl:attribute>
         <span>&#160;</span>
         <!-- Thumbnail image -->
         <img class="s{$img-left-right}" src="{$img-path-thumb}">
          <!-- @alt info -->
          <xsl:if test="string($img-cap-desc)">
           <xsl:attribute name="alt">
            <xsl:value-of select="$img-cap-desc"/>
           </xsl:attribute>
          </xsl:if>
         </img>
        </a>
       </dt>
       <dd>
        <xsl:value-of select="$img-cap-desc"/>
       </dd>
      </dl>
     </div>
    </div>
   </xsl:when>
   <xsl:when test="@xmt:type='thumb'">
    <a href="{$img-path-full}">
     <xsl:attribute name="class">
      <xsl:value-of select="$cap-left-right"/>
      <xsl:text> </xsl:text>
      <xsl:call-template name="img-popup">
       <xsl:with-param name="popup" select="$popup"/>
      </xsl:call-template>
     </xsl:attribute>
     <span>&#160;</span>
     <img class="s{$img-left-right}" src="{$img-path-thumb}">
      <!-- @alt info -->
      <xsl:if test="string($img-cap-alt)">
       <xsl:attribute name="alt">
        <xsl:value-of select="$img-cap-alt"/>
       </xsl:attribute>
      </xsl:if>
     </img>
    </a>
   </xsl:when>
   <!-- START Option 4: showing logo tables -->
   <xsl:when test="ancestor::tei:list/@type='logo'">
    <img src="{$img-path-full}">
     <!-- @alt info -->
     <xsl:attribute name="alt">
      <xsl:choose>
       <xsl:when test="string($img-cap-desc)">
        <xsl:value-of select="$img-cap-desc"/>
       </xsl:when>
       <xsl:otherwise>
        <xsl:text>logo</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
     <!-- dimension info -->
     <xsl:call-template name="img-dim">
      <xsl:with-param name="img-width" select="$img-width"/>
      <xsl:with-param name="img-height" select="$img-height"/>
     </xsl:call-template>
    </img>
   </xsl:when>
   <xsl:when test="@xmt:type='full'">
    <xsl:if
     test="not(preceding-sibling::tei:graphic[@xmt:type='thumb' or
          @xmt:type='thumb-caption'])">
     <div class="image">
      <div class="t03">
       <dl style="width: {$img-width}px;">
        <dt>
         <img src="{$img-path-full}">
          <!-- @alt info -->
          <xsl:if test="string($img-cap-desc)">
           <xsl:attribute name="alt">
            <xsl:value-of select="$img-cap-desc"/>
           </xsl:attribute>
          </xsl:if>
          <!-- dimension info -->
          <xsl:call-template name="img-dim">
           <xsl:with-param name="img-width" select="$img-width"/>
           <xsl:with-param name="img-height" select="$img-height"/>
          </xsl:call-template>
         </img>
        </dt>
        <dd>
         <xsl:value-of select="$img-cap-desc"/>
        </dd>
       </dl>
      </div>
     </div>
    </xsl:if>
   </xsl:when>
   <!-- START Default: show full image -->
   <xsl:otherwise>
    <!-- Changed: div is centered -->
    <div class="image">
     <div class="t03">
      <dl style="width: {$img-width}px;">
       <dt>
        <img src="{$img-path-full}">
         <!-- @alt info -->
         <xsl:if test="string($img-cap-desc)">
          <xsl:attribute name="alt">
           <xsl:value-of select="$img-cap-desc"/>
          </xsl:attribute>
         </xsl:if>
         <!-- dimension info -->
         <xsl:call-template name="img-dim">
          <xsl:with-param name="img-width" select="$img-width"/>
          <xsl:with-param name="img-height" select="$img-height"/>
         </xsl:call-template>
        </img>
       </dt>
       <dd>
        <xsl:value-of select="$img-cap-desc"/>
       </dd>
      </dl>
     </div>
    </div>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ END GRAPHICS TEMPLATES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

 <xsl:template match="tei:handShift">
  <xsl:variable name="handIDval" select="substring-after(@new, '#')"/>
  <span class="handshift">
   <xsl:attribute name="title"><xsl:value-of
     select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:handNotes/tei:handNote[@xml:id = $handIDval]"
    /></xsl:attribute>&#x21E7; </span>
 </xsl:template>

 <xsl:template match="tei:hi">
  <xsl:choose>
   <xsl:when test="@rend='italic' or @rend='lateinschr'">
    <em>
     <xsl:apply-templates/>
    </em>
   </xsl:when>
   <xsl:when test="@rend='bold'">
    <strong>
     <xsl:apply-templates/>
    </strong>
   </xsl:when>
   <xsl:when test="contains(@rend, 'bold') and contains(@rend, 'italic')">
    <strong>
     <em>
      <xsl:apply-templates/>
     </em>
    </strong>
   </xsl:when>
   <xsl:when test="contains(@rend, 'bold') and contains(@rend, 'underline')">
    <span class="bold-underline">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <!-- @@@@@@@@@ MAY NEED TO MOVE INTERLINEAR-ABOVE TO A SEPARATE TEMPLATE IF WE CAN ACTUALLY DISTINGUISH IT IN THE DISPLAY -->
   <xsl:when test="@rend='sup' or @rend='supralinear' or @rend='interlinear-above'">
    <sup>
     <xsl:apply-templates/>
    </sup>
   </xsl:when>
   <!-- @@@@@@@@@ MAY NEED TO MOVE INTERLINEAR-BELOW TO A SEPARATE TEMPLATE IF WE CAN ACTUALLY DISTINGUISH IT IN THE DISPLAY -->
   <xsl:when test="@rend='sub' or @rend='infralinear' or @rend='interlinear-below'">
    <sub>
     <xsl:apply-templates/>
    </sub>
   </xsl:when>
   <xsl:when test="@rend='underline'">
    <span class="underline">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend='double-underline'">
    <span class="doubleunderline">
     <xsl:apply-templates/>
    </span>
    <sup>
     <a href="#f1">&#8224;</a>
    </sup>
   </xsl:when>
   <xsl:when test="@rend='triple-underline'">
    <span class="tripleunderline">
     <xsl:apply-templates/>
    </span>
    <sup>
     <a href="#f2">&#9674;</a>
    </sup>
   </xsl:when>
   <xsl:when test="contains(@rend, 'lateinschr') and contains(@rend, 'underline')">
    <span class="italic-underline">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend='sperr'">
    <span class="sperr">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="contains(@rend, 'sperr') and contains(@rend, 'underline')">
    <span class="sperr-underline">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend='strikethrough'">
    <span class="inline-deletion">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend='strikethroughNONE'">
    <span class="inline-deletion-none">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend='strikethroughPINK'">
    <span class="inline-deletion-pink">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend='strikethroughLEMON'">
    <span class="inline-deletion-lemon">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@rend='strikethroughLIME'">
    <span class="inline-deletion-lime">
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
  <xsl:if test="not(following-sibling::*[1][self::tei:list])">
   <br/>
  </xsl:if>

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

 <xsl:template match="tei:milestone">
  <xsl:choose>
   <xsl:when test="@n='recto'">
    <span class="folio_milestone">
     <strong>{<em>recto</em>}</strong>
    </span>
   </xsl:when>
   <xsl:when test="@n='verso'">
    <span class="folio_milestone">
     <strong>{<em>verso</em>}</strong>
    </span>
   </xsl:when>
   <xsl:when test="@rend='inline em-dash'">
    <xsl:text>&#8212;</xsl:text>
   </xsl:when>
   <xsl:when test="@rend='block asterisk'">
    <xsl:text>*</xsl:text>
   </xsl:when>
  </xsl:choose>
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
     <xsl:when test="@place = 'pre-text'">
      <!-- do nothing -->
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
    <xsl:variable name="position">
     <xsl:choose>
      <xsl:when test="@place='margin-bot'">bottom</xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="substring-after(@place, '-')"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    <span class="editorial">[note in <xsl:value-of select="$position"/>
     margin]<xsl:text> </xsl:text></span>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template name="para-splt">
  <xsl:param name="spliter"/>
  <xsl:param name="nodes"/>

  <xsl:variable name="current-group">
   <xsl:copy-of select="$nodes"/>
  </xsl:variable>

  <xsl:variable name="first-nodes"
   select="$current-group/*[self::tei:list][1]/preceding-sibling::*|text()"/>
  <xsl:variable name="remaining-nodes"
   select="$current-group/*[self::tei:list][1]/following-sibling::*|text()"/>

  <xsl:choose>
   <xsl:when test="count($nodes) > 0 and count($first-nodes) = 0">
    <p>
     <xsl:apply-templates select="$nodes"/>
    </p>
   </xsl:when>
   <xsl:when test="count($nodes) > 0 and count($first-nodes) > 0">
    <p>
     <xsl:apply-templates select="$first-nodes"/>
    </p>
    <xsl:apply-templates select="$current-group/*[self::tei:list][1]"/>

    <xsl:if test="count($remaining-nodes) > 0">
     <xsl:call-template name="para-splt">
      <xsl:with-param name="nodes" select="$remaining-nodes"/>
     </xsl:call-template>
    </xsl:if>
   </xsl:when>
  </xsl:choose>

 </xsl:template>

 <xsl:template match="tei:p">
  <xsl:choose>
   <xsl:when test="tei:figure/tei:head">
    <xsl:for-each select="tei:figure[tei:head]/tei:graphic">
     <xsl:call-template name="showFigure"/>
    </xsl:for-each>
    <p>
     <xsl:call-template name="a-id"/>
     <xsl:apply-templates/>
    </p>
   </xsl:when>
   <xsl:otherwise>
    <xsl:choose>
     <xsl:when test="child::*[self::tei:list]">

      <xsl:variable name="first-nodes"
       select="child::*[self::tei:list][1]/preceding-sibling::*|text()"/>
      <xsl:variable name="remaining-nodes" select="child::*[self::tei:list][1]/following-sibling::*"/>

      <xsl:if test="count($first-nodes) > 0">
       <p>
        <xsl:call-template name="a-id"/>
        <xsl:apply-templates select="$first-nodes"/>
       </p>
      </xsl:if>

      <xsl:apply-templates select="child::*[self::tei:list][1]"/>

      <xsl:if test="count($remaining-nodes) > 0">
       <xsl:call-template name="para-splt">
        <xsl:with-param name="nodes" select="$remaining-nodes"/>
       </xsl:call-template>
      </xsl:if>
      <!-- -->
     </xsl:when>
     <xsl:otherwise>
      <p>
       <xsl:call-template name="a-id"/>
       <xsl:apply-templates/>
      </p>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:pb">
  <xsl:if test="number(@n) > 1">
   <strong>{<xsl:value-of select="@n"/>}</strong>
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:postscript">
  <xsl:apply-templates/>
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

 <xsl:template match="tei:quote | tei:q">
  <xsl:choose>
   <xsl:when test="@rend='block' and parent::tei:p">
    <span class="inside-block">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
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
     <xsl:when test="@type != 'unknown'">
      <!-- ie. one of "correspondence", "diaries", "lessonbooks", "other" -->
      <xsl:variable name="type" select="@type"/>
      <xsl:variable name="file">
       <xsl:choose>
        <xsl:when test="$type='diaries'">
         <!-- For DIARIES WE HAVE TO APPEND THE RECORD ID TO URL, eg. diaries/OJ-02-10_1918-01/r0003.html -->
         <xsl:value-of
          select="concat(substring-before(@cRef, ':'), '/', substring-after(@cRef, ':'))"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="@cRef"/>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      <xsl:variable name="path">
       <xsl:value-of select="concat('/documents/', $type, '/', $file, '.html')"/>
      </xsl:variable>
      <a>
       <xsl:call-template name="internal-link">
        <xsl:with-param name="title" select="$file"/>
       </xsl:call-template>
       <xsl:attribute name="href">
        <xsl:value-of select="$path"/>
       </xsl:attribute>
       <xsl:apply-templates/>
      </a>
     </xsl:when>
     <xsl:when test="@type = 'unknown'">
      <xsl:variable name="file" select="@cRef"/>
      <xsl:variable name="fileref">
       <xsl:choose>
        <xsl:when
         test="doc-available(string(concat('../../xml/content/documents/correspondence/', $file, '.xml')))">
         <xsl:value-of select="$file"/>
        </xsl:when>
        <xsl:when
         test="doc-available(string(concat('../../xml/content/documents/diaries/', $file, '.xml')))">
         <xsl:value-of
          select="concat(substring-before(@cRef, ':'), '/', substring-after(@cRef, ':'))"/>
        </xsl:when>
        <xsl:when
         test="doc-available(string(concat('../../xml/content/documents/lessonbooks/', $file, '.xml')))">
         <xsl:value-of select="$file"/>
        </xsl:when>
        <xsl:when
         test="doc-available(string(concat('../../xml/content/documents/other/', $file, '.xml')))">
         <xsl:value-of select="$file"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="''"/>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      <xsl:choose>
       <xsl:when test="$fileref != ''">
        <xsl:variable name="path" select="concat('/documents/correspondence/', $fileref, '.html')"/>
        <a>
         <xsl:call-template name="internal-link">
          <xsl:with-param name="title" select="$file"/>
         </xsl:call-template>
         <xsl:attribute name="href">
          <xsl:value-of select="$path"/>
         </xsl:attribute>
         <xsl:apply-templates/>
        </a>
       </xsl:when>
       <xsl:otherwise>
        <a>
         <xsl:call-template name="internal-link">
          <xsl:with-param name="title">
           <xsl:text>this unavailable - document not yet online.</xsl:text>
          </xsl:with-param>
         </xsl:call-template>
         <xsl:apply-templates/>
        </a>
       </xsl:otherwise>
      </xsl:choose>

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

 <xsl:template match="tei:row">
  <tr>
   <xsl:if test="@rend = 'demo'">
    <xsl:attribute name="class">demoTable</xsl:attribute>
   </xsl:if>
   <xsl:apply-templates/>
  </tr>
 </xsl:template>

 <xsl:template match="tei:rs">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:salute">
  <br/>
  <xsl:if test="parent::tei:opener">
   <br/>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="parent::tei:opener">
   <br/>
   <br/>
  </xsl:if>
 </xsl:template>


 <xsl:template match="tei:seg">
  <xsl:choose>
   <!-- FOR THE PAGE GIVING EXAMPLES OF EDITORIAL CONVENTIONS USED IN THE REGULAR TEXT DISPLAY -->
   <xsl:when test="@type = 'demo' and @subtype = 'editorial'">
    <span class="editorial">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'added'">
    <span class="interlinear-addition">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'underline'">
    <span class="underline">
     <xsl:apply-templates/>
    </span>
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'overwritten'">
    <span class="erased" onmouseover="show(this)" onmouseout="show(this)" xml:space="preserve"><span class="erased2"><xsl:value-of select="child::tei:seg[@subtype='undertext']"/></span><xsl:value-of select="child::tei:seg[@subtype='overtext']"/></span>
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'handshift'">
    <xsl:variable name="handIDval" select="substring-after(@n, '#')"/>
    <span class="handshift">
     <xsl:attribute name="title"
     ><xsl:text>Otto Erich Deutsch's hand</xsl:text></xsl:attribute>&#x21E7;
     <xsl:apply-templates/></span>
   </xsl:when>
   <!-- END THE DEMO PAGE TYPES -->

   <!-- this is for handwritten parts of telegrams -->
   <xsl:when test="@type='entry' and @rend='ms'">
    <em>
     <xsl:apply-templates/>
    </em>
   </xsl:when>

   <!-- ****** -->
   <!-- this condition relates to visualization testing by PC, 04/06/2014 -->
   <!--<xsl:when test="@type='button'">
    <button>
     <xsl:attribute name="onclick" select="concat(substring-before(@subtype, 'QQQ'), '(', substring-after(@subtype, 'QQQ'), ')')"></xsl:attribute>
     <xsl:apply-templates/>
    </button>
   </xsl:when>-->
   <xsl:when test="contains(@type, 'makebutton_')">
    <xsl:variable name="func" select="substring-after(@type, 'makebutton_')"/>
    <button>
     <xsl:attribute name="onclick">
      <xsl:choose>
       <xsl:when test="@subtype">
        <xsl:value-of select="concat($func, '(', @subtype, ')')"/>
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="concat($func, '()')"/>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
     <xsl:apply-templates/>
    </button>
   </xsl:when>
   <!-- ****** -->

   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:sic">
  <xsl:choose>
   <xsl:when test="not(following-sibling::tei:corr)">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
    <span class="editorial">[sic]</span>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
    <span class="editorial">[recte </span>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:signed">
  <br/>
  <span class="editorial">
   <xsl:text>[</xsl:text>signed:<xsl:text>] </xsl:text>
  </span>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:subst">
  <xsl:choose>
   <xsl:when test="child::tei:del[@rend='overwritten']/child::tei:gap">
    <span class="erased" onmouseover="show(this)" onmouseout="show(this)" xml:space="preserve"><span class="erased2 green">[illeg]</span><xsl:value-of select="child::tei:add[@place='superimposed']"/></span>
   </xsl:when>
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
   <xsl:text>]</xsl:text>
  </span>
 </xsl:template>

 <xsl:template match="tei:table">
  <table>
   <!--  
   <xsl:if test="starts-with(ancestor::tei:div/@type, 'trans')">
    <xsl:attribute name="class">tableInSource</xsl:attribute>
   </xsl:if>
   <xsl:if test="starts-with(ancestor::tei:TEI/@xml:id, 'entity')">
    <xsl:attribute name="class">tableInProfile</xsl:attribute>
   </xsl:if>
    -->
   <!-- PC: 11 Jan 2024, change to deal with instances like OC-54-357-358 -->
   <xsl:choose>
    <xsl:when test="starts-with(ancestor::tei:TEI/@xml:id, 'entity')">
     <xsl:attribute name="class">tableInProfile</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
     <xsl:attribute name="class">tableInSource</xsl:attribute>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:apply-templates/>
  </table>
 </xsl:template>


 <xsl:template match="tei:title">
  <xsl:choose>
   <xsl:when test="@level ='j'">
    <em>
     <xsl:apply-templates/>
    </em>
   </xsl:when>
   <xsl:when test="@level='m'">
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
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:unclear">
  <span class="editorial">
   <xsl:text>[?</xsl:text>
   <xsl:apply-templates/>
   <xsl:text>]</xsl:text>
  </span>
 </xsl:template>


</xsl:stylesheet>
