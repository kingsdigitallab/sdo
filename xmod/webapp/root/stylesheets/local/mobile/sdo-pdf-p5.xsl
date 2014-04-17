<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns:sdo="http://www.cch.kcl.ac.uk/schenker" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
 xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
 xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
 xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:fo="http://www.w3.org/1999/XSL/Format">


 <xsl:include href="cocoon://_internal/properties/properties.xsl" />

 <!-- NOW OVERRIDE DEFAULTS FROM p5.xsl OR SUPPLY TEMPLATES IT DOESN'T HAVE -->
 <xsl:template match="tei:teiHeader"/>

 <xsl:template match="tei:ab">
  <fo:block>
   <xsl:if test="@type='division-marker'">
    <xsl:attribute name="class">c</xsl:attribute>
   </xsl:if>
   <xsl:apply-templates/>
  </fo:block>
 </xsl:template>

 <xsl:template match="tei:add">
  <xsl:choose>
   <xsl:when test="@place = 'inline'">
    <fo:inline font-weight="bold">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <xsl:when test="@place = 'interlinear-above'">
    <fo:inline font-weight="bold">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <xsl:when test="@place = 'margin-bot'">
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
 </xsl:template>

 <xsl:template match="tei:addrLine">
  <fo:list-item>
       <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
   <fo:list-item-body start-indent="body-start()">
    <fo:block><xsl:apply-templates/></fo:block>
   </fo:list-item-body>
  </fo:list-item> 
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
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:choice">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:corr">
  <xsl:value-of select="."/>
  <span class="editorial">]</span>
 </xsl:template>


 <xsl:template match="tei:date">
    <fo:inline><xsl:apply-templates/></fo:inline>
 </xsl:template>

 <xsl:template match="tei:dateline">
  <fo:block>
  <xsl:apply-templates/>
  </fo:block>
 </xsl:template>

 <xsl:template match="tei:del">
  <xsl:choose>
   <xsl:when test="@rend = 'overstrike'">
    <fo:inline text-decoration="line-through">
     <xsl:apply-templates/>
    </fo:inline>
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
   
   <!-- match 'transcription' and 'translation' divs in a primary document -->
   <xsl:when test="parent::sdo:record">
    <xsl:choose>
     <xsl:when test="child::tei:div[contains(@type, 'part_')]">
      <xsl:apply-templates mode="multipartItem"/>
      <!-- SEE THE FOLLOWING <XSL:TEMPLATE> -->
     </xsl:when>
     <xsl:when test="child::tei:opener">
      <fo:block>
       <xsl:if test="child::tei:opener/preceding-sibling::tei:note">
        <xsl:apply-templates select="tei:note"/>
       </xsl:if>
       <xsl:apply-templates select="child::tei:opener"/>
      </fo:block>
      <fo:block>
       <xsl:apply-templates select="child::tei:opener/following-sibling::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]" />
      </fo:block>
      <xsl:if test="child::tei:closer">
       <fo:block>
        <xsl:apply-templates select="tei:closer"/>
       </fo:block>
      </xsl:if>
      <xsl:if test="child::tei:postscript">
       <fo:block>
        <xsl:apply-templates select="tei:postscript"/>
       </fo:block>
      </xsl:if>
      <xsl:if test="child::tei:fw[@type='envelope']">
       <fo:block>
        <xsl:apply-templates select="tei:fw[@type='envelope']"/>
       </fo:block>
      </xsl:if>
     </xsl:when>
     <xsl:otherwise>
      <fo:block>
       <xsl:apply-templates select="child::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]" />
      </fo:block>
      <xsl:if test="child::tei:closer">
       <fo:block>
        <xsl:apply-templates select="tei:closer"/>
       </fo:block>
      </xsl:if>
      <xsl:if test="child::tei:postscript">
       <fo:block>
        <xsl:apply-templates select="tei:postscript"/>
       </fo:block>
      </xsl:if>
      <xsl:if test="child::tei:fw[@type='envelope']">
       <fo:block>
        <xsl:apply-templates select="tei:fw[@type='envelope']"/>
       </fo:block>
      </xsl:if>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <!--   Default  -->
   <xsl:otherwise>
    <!-- Creates anchor if there is @xml:id -->
    <xsl:if test="@xml:id">
     <fo:block>
      <xsl:attribute name="id">
       <xsl:value-of select="@xml:id"/>
      </xsl:attribute>
      <xsl:text>&#160;</xsl:text>
     </fo:block>
    </xsl:if>
    <fo:block>
     <xsl:apply-templates/>
    </fo:block>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- This template takes care of situation where we have multiple items in one document, eg. the picture postcard with two separate messages, OJ-8-4_31.xml. It's the same as the <tei:div> template above, but now applying to <tei:div @type='part_X' -->
 <xsl:template match="tei:div" mode="multipartItem">
  <xsl:choose>
   <xsl:when test="child::tei:opener">
    <fo:block>
     <xsl:if test="child::tei:opener/preceding-sibling::tei:note">
      <xsl:apply-templates select="tei:note"/>
     </xsl:if>
     <xsl:apply-templates select="child::tei:opener"/>
    </fo:block>
    <fo:block>
     <xsl:apply-templates select="child::tei:opener/following-sibling::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]" />
    </fo:block>
    <xsl:if test="child::tei:closer">
     <fo:block>
      <xsl:apply-templates select="tei:closer"/>
     </fo:block>
    </xsl:if>
    <xsl:if test="child::tei:postscript">
     <fo:block>
      <xsl:apply-templates select="tei:postscript"/>
     </fo:block>
    </xsl:if>
    <xsl:if test="child::tei:fw[@type='envelope']">
     <fo:block>
      <xsl:apply-templates select="tei:fw[@type='envelope']"/>
     </fo:block>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <fo:block>
     <xsl:apply-templates select="child::tei:*[not(self::tei:closer) and not(self::tei:postscript) and not(self::tei:fw[@type='envelope'])]"  />
    </fo:block>
    <xsl:if test="child::tei:closer">
     <fo:block>
      <xsl:apply-templates select="tei:closer"/>
     </fo:block>
    </xsl:if>
    <xsl:if test="child::tei:postscript">
     <fo:block>
      <xsl:apply-templates select="tei:postscript"/>
     </fo:block>
    </xsl:if>
    <xsl:if test="child::tei:fw[@type='envelope']">
     <fo:block>
      <xsl:apply-templates select="tei:fw[@type='envelope']"/>
     </fo:block>
    </xsl:if>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:ex">
  <!-- <span class="editorial"> -->
   <xsl:text>[</xsl:text>
   <xsl:apply-templates/>
   <xsl:text>] </xsl:text>
  <!-- </span> -->
 </xsl:template>

 <xsl:template match="tei:foreign">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:fw">
  <fo:list-block>
  <xsl:choose>
   <xsl:when test="@type='envelope'">
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:when test="@type='header'">
    <xsl:choose>
     <xsl:when test="@rend='center'">
       <xsl:apply-templates/>      
     </xsl:when>
     <xsl:when test="@rend='inline'">
      <xsl:apply-templates/>
     </xsl:when>
    </xsl:choose>
   </xsl:when>
   <xsl:when test="@type='line'">
    <fo:leader leader-length="2in" leader-pattern="rule" alignment-baseline="middle" rule-thickness="0.5pt" color="black"/>
   </xsl:when>
   <xsl:when test="@type='postmark'">
     <xsl:text>[postmark:]</xsl:text>
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
  </fo:list-block> 
 </xsl:template>
 
 <xsl:template match="tei:g">
  <xsl:choose>
   <!-- need this first choice because Chord Symbol font does not have clef symbols -->
   <xsl:when test="substring(@type, 2, 4) = 'clef'">
     <xsl:choose>
      <xsl:when test="substring(@type, 1, 1) = 'C'">&#x1D121;</xsl:when>
      <xsl:when test="substring(@type, 1, 1) = 'F'">&#x1D122;</xsl:when>
      <xsl:when test="substring(@type, 1, 1) = 'G'">&#x1D120;</xsl:when>
     </xsl:choose>    
   </xsl:when>
   <!-- these use Chord Symbol font replacement -->
   <xsl:otherwise>
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
      <xsl:when test="@type='cresc'">&#x02D2;</xsl:when>
      <xsl:when test="@type='dim'">&#x02D3;</xsl:when>
      <xsl:when test="@type='crescdim'">&#x02D2;&#x02D3;</xsl:when>
      <xsl:when test="@type='div'">&#x026F;</xsl:when>
      <xsl:otherwise><!-- do nothing for now --></xsl:otherwise>
     </xsl:choose>
    
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:gap">
   <xsl:text>[illeg]</xsl:text>
 </xsl:template>

 <xsl:template match="tei:handShift">
  <xsl:variable name="handIDval" select="substring-after(@new, '#')"/>
  <xsl:variable name="handshift">
   <xsl:choose>
    <xsl:when test="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:handNotes/tei:handNote[@xml:id = $handIDval]"><xsl:value-of select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:handNotes/tei:handNote[@xml:id = $handIDval]" /></xsl:when>
    <xsl:otherwise>Writing shift</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  [<xsl:value-of select="$handshift" /> ->]
 </xsl:template>

 <xsl:template match="tei:hi">
  <xsl:choose>
   <!-- ITALICS -->
   <xsl:when test="@rend='italic' or @rend='lateinschr'">
    <fo:inline font-style="italic">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <!-- BOLD -->
   <xsl:when test="@rend='bold'">
    <fo:inline font-style="bold">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <!-- BOLD AND ITALICS -->
   <xsl:when test="@rend='bolditalic'">
    <fo:inline font-style="bold">
     <fo:inline font-style="italic">
      <xsl:apply-templates/>
     </fo:inline>
    </fo:inline>
   </xsl:when>
   <!-- @@@@@@@@@ MAY NEED TO MOVE INTERLINEAR-ABOVE TO A SEPARATE TEMPLATE IF WE CAN ACTUALLY DISTINGUISH IT IN THE DISPLAY -->
   <xsl:when test="@rend='sup' or @rend='supralinear' or @rend='interlinear-above'">
    <fo:inline vertical-align="super" font-size="8pt">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <!-- @@@@@@@@@ MAY NEED TO MOVE INTERLINEAR-BELOW TO A SEPARATE TEMPLATE IF WE CAN ACTUALLY DISTINGUISH IT IN THE DISPLAY -->
   <xsl:when test="@rend='sub' or @rend='infralinear' or @rend='interlinear-below'">
    <fo:inline vertical-align="sub" font-size="8pt">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <xsl:when test="@rend='underline'">
    <fo:inline text-decoration="underline">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <xsl:when test="@rend='double-underline'">
    <fo:inline text-decoration="underline">
     <xsl:apply-templates/>
    </fo:inline>
    <fo:inline vertical-align="super" font-size="8pt">&#8224;</fo:inline>
    <!--
    <fo:inline vertical-align="bottom" font-size="8pt" font-style="italic">
      <xsl:text> [double underline]</xsl:text>
    </fo:inline>
    -->
   </xsl:when>
   <xsl:when test="@rend='triple-underline'">
    <fo:inline text-decoration="underline">
     <xsl:apply-templates/>
    </fo:inline>
    <fo:inline vertical-align="super" font-size="8pt">&#9674;</fo:inline>
    <!--<fo:inline vertical-align="bottom" font-size="8pt" font-style="italic">
      <xsl:text> [triple underline]</xsl:text>
    </fo:inline>
    -->
   </xsl:when>
   <xsl:when test="@rend='lateinschr-underline'">
    <fo:inline text-decoration="underline" font-style="italic">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <xsl:when test="@rend='sperr'">
    <fo:inline letter-spacing="0.09em">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <!-- CURRENT DEFAULT: italics -->
   <xsl:otherwise>
    <fo:inline font-style="italic">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:item">
  <fo:list-item>
    <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
    <fo:list-item-body start-indent="body-start()"><fo:block><xsl:apply-templates /></fo:block></fo:list-item-body>
  </fo:list-item>

 </xsl:template>

 <xsl:template match="tei:lb">
  <fo:block />
 </xsl:template>

 <xsl:template match="tei:list">
  <fo:list-block>
   <xsl:apply-templates />
  </fo:list-block>
 </xsl:template>

 <xsl:template match="tei:listBibl">
<fo:list-block>
 <fo:list-item>
  <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
  <fo:list-item-body start-indent="body-start()"><xsl:apply-templates/></fo:list-item-body>
 </fo:list-item>
</fo:list-block>
 </xsl:template>
 
 <xsl:template match="tei:milestone">
  <fo:list-item>
       <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
   <fo:list-item-body start-indent="body-start()">
  
  <xsl:choose>
   <xsl:when test="@n='recto'">
    <fo:block font-style="bold">{<fo:inline font-style="italic">recto</fo:inline>}</fo:block>
   </xsl:when>
   <xsl:when test="@n='verso'">
    <fo:block font-style="bold">{<fo:inline font-style="italic">verso</fo:inline>}</fo:block>
   </xsl:when>
   <xsl:when test="@rend='inline em-dash'">
    <xsl:text>&#8212;</xsl:text>
   </xsl:when>
   <xsl:when test="@rend='block asterisk'">
    <xsl:text>*</xsl:text>
   </xsl:when>
  </xsl:choose>
   </fo:list-item-body>
  </fo:list-item> 
 </xsl:template>

 <xsl:template match="tei:note">
  <fo:inline>
  <xsl:choose>
   <xsl:when test="@type='editorial'">
    <xsl:choose>
     <xsl:when test="@place='foot'">
      <xsl:variable name="fnNum" select="substring(substring-after(@xml:id, '-'), 3, 2)"/>

       <fo:basic-link>
        <xsl:attribute name="internal-destination">
         <xsl:text>#fn</xsl:text>
         <xsl:value-of select="$fnNum"/>
        </xsl:attribute>
        
        <xsl:attribute name="id">
         <xsl:text>fnLink</xsl:text>
         <xsl:value-of select="$fnNum"/>
        </xsl:attribute>
        
        <xsl:choose>
         <xsl:when test="starts-with($fnNum, '0')">
          <fo:inline font-size="6pt" vertical-align="super"><xsl:value-of select="substring($fnNum, 2, 1)"/></fo:inline>
         </xsl:when>
         <xsl:otherwise>
          <fo:inline font-size="6pt" vertical-align="super"><xsl:value-of select="$fnNum"/></fo:inline>
         </xsl:otherwise>
        </xsl:choose>
       </fo:basic-link>
      
     </xsl:when>
     <xsl:when test="@place = 'pre-text'">
      <!-- do nothing -->
     </xsl:when>
     <xsl:otherwise>
      <!-- <span class="editorial"> -->
       <xsl:text>[</xsl:text>
       <xsl:apply-templates/>
       <xsl:text>]</xsl:text>
     <!--  </span> -->
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
    <!-- <span class="editorial"> -->[note in <xsl:value-of select="$position"/>
     margin]<xsl:text> </xsl:text><!-- </span> -->
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
  </fo:inline>
 </xsl:template>

 <xsl:template match="tei:pb">
  <xsl:if test="number(@n) > 1">
   <fo:inline font-style="bold">{<xsl:value-of select="@n"/>}</fo:inline>
  </xsl:if>
 </xsl:template>

 <xsl:template match="tei:postscript">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:ptr">
  <xsl:variable name="ptrNum" select="substring(substring-after(@corresp, '-'), 3, 2)"/>
  
   <fo:basic-link>
    <xsl:attribute name="internal-destination">
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
      <fo:inline font-size="6pt" vertical-align="super"><xsl:value-of select="substring($ptrNum, 2, 1)"/></fo:inline>
     </xsl:when>
     <xsl:otherwise>
      <fo:inline font-size="6pt" vertical-align="super"><xsl:value-of select="$ptrNum"/></fo:inline>
     </xsl:otherwise>
    </xsl:choose>
   </fo:basic-link>
 </xsl:template>

 <xsl:template match="tei:quote">
  <xsl:choose>
   <xsl:when test="@rend='block'">
    <fo:block start-indent="1.5cm" end-indent="1.5cm">
     <xsl:apply-templates/>
    </fo:block>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>


 <xsl:template match="tei:ref">
  <xsl:choose>
   <xsl:when test="@type  = 'external' or @rend = 'external'">
    <!-- <fo:basic-link color="blue" external-destination="{@target}">
     <xsl:call-template name="external-link"/>
     <xsl:apply-templates/>
     </fo:basic-link> -->
    <fo:inline><xsl:apply-templates/></fo:inline><fo:inline font-size="6pt">[<xsl:value-of select="@target"/>]</fo:inline>
   </xsl:when>
   <xsl:when test="@cRef">
    <xsl:choose>
     <xsl:when test="contains(@cRef, '#')">
      <xsl:variable name="file" select="substring-before(@cRef, '#')"/>
      <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
      <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
      <xsl:variable name="anchor" select="substring-after(@cRef, '#')"/>
      
      <!--
      <fo:basic-link color="blue">
       <xsl:attribute name="internal-destination">
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
      </fo:basic-link> -->
      
      <fo:inline>       
       <xsl:call-template name="internal-link">
        <xsl:with-param name="title" select="$title"/>
       </xsl:call-template>
       <xsl:apply-templates/>
      </fo:inline>
      <fo:inline font-size="6pt">
        <xsl:text> [http://www.schenkerdocumentsonline.org/</xsl:text>        
        <xsl:if test="string($file)">
        <xsl:value-of select="$path"/>
       </xsl:if>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$anchor"/><xsl:text>]</xsl:text>
       </fo:inline>
      
      
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
      
      <!--
      <fo:basic-link color="blue">
       <xsl:call-template name="internal-link">
        <xsl:with-param name="title" select="$file"/>
       </xsl:call-template>
       <xsl:attribute name="internal-destination">
        <xsl:value-of select="$path"/>
       </xsl:attribute>
       <xsl:apply-templates/>
      </fo:basic-link>
      -->
      
      <fo:inline>       
       <xsl:call-template name="internal-link">
        <xsl:with-param name="title" select="$file"/>
       </xsl:call-template>
       <xsl:apply-templates/>
      </fo:inline>
      <fo:inline font-size="6pt">
       <xsl:text> [http://www.schenkerdocumentsonline.org/</xsl:text><xsl:value-of select="$path"/><xsl:text>]</xsl:text>
      </fo:inline>     
      
     </xsl:when>
     <xsl:when test="@type = 'unknown'">
      <xsl:variable name="file" select="@cRef"/>
      
      <xsl:variable name="fileref">
       <xsl:choose>
        <xsl:when test="doc-available(string(concat('../../xml/content/documents/correspondence/', $file, '.xml')))">  
          <xsl:value-of select="$file"/>
        </xsl:when>
        <xsl:when test="doc-available(string(concat('../../xml/content/documents/diaries/', $file, '.xml')))">
         <xsl:value-of select="concat(substring-before(@cRef, ':'), '/', substring-after(@cRef, ':'))"/>
        </xsl:when>
        <xsl:when test="doc-available(string(concat('../../xml/content/documents/lessonbooks/', $file, '.xml')))">
         <xsl:value-of select="$file"/>
        </xsl:when>
        <xsl:when test="doc-available(string(concat('../../xml/content/documents/other/', $file, '.xml')))">
         <xsl:value-of select="$file"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="''" />
        </xsl:otherwise>
       </xsl:choose>
      </xsl:variable>
      
      <xsl:choose>
       <xsl:when test="$fileref != ''">
         <xsl:variable name="path" select="concat('/documents/correspondence/', $fileref, '.html')"/>
         <fo:basic-link color="blue">
          <xsl:call-template name="internal-link">
           <xsl:with-param name="title" select="$file"/>
          </xsl:call-template>
          <xsl:attribute name="external-destination">
           <xsl:value-of select="concat('http://www.schenkerdocumentsonline.org/', $path)"/>
          </xsl:attribute>
          <xsl:apply-templates/>
         </fo:basic-link>         
       </xsl:when>
       <xsl:otherwise>
         <xsl:apply-templates/>        
       </xsl:otherwise>
      </xsl:choose>     
     </xsl:when>
     
     <xsl:otherwise>
      <xsl:variable name="file" select="@cRef"/>
      <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
      <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
      <fo:basic-link color="blue">
       <xsl:call-template name="internal-link">
        <xsl:with-param name="title" select="$file"/>
       </xsl:call-template>
       <xsl:attribute name="external-destination">
        <xsl:value-of select="concat('http://www.schenkerdocumentsonline.org/', $path)"/>
       </xsl:attribute>
       <xsl:apply-templates/>
      </fo:basic-link>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   
   <xsl:when test="@target">
    <fo:basic-link color="blue">
     <xsl:attribute name="external-destination">
      <xsl:if test="starts-with(@target, '/')">
       <xsl:value-of select="$xmp:context-path"/>
      </xsl:if>
      <!-- This is well dodgy. -->
      <xsl:value-of select="@target"/>
     </xsl:attribute>
     <xsl:apply-templates/>
    </fo:basic-link>
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

 <xsl:template match="tei:rs">
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match="tei:salute">
<fo:block>
  <xsl:apply-templates/>
 </fo:block>
 </xsl:template>

 <!-- FOR THE PAGE GIVING EXAMPLES OF EDITORIAL CONVENTIONS USED IN THE REGULAR TEXT DISPLAY -->
 <xsl:template match="tei:seg">
  <xsl:choose>
   <xsl:when test="@type = 'demo' and @subtype = 'editorial'">
    <!--  <span class="editorial"> -->
     <xsl:apply-templates/>
    <!-- </span> -->
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'added'">
    <!--  <span class="inline-addition"> -->
     <xsl:apply-templates/>
    <!-- </span> -->
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'underline'">
    <fo:inline text-decoration="underline">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'overwritten'">
    <!-- <span class="erased" onmouseover="show(this)" onmouseout="show(this)" xml:space="preserve"><span class="erased2"><xsl:value-of select="child::tei:seg[@subtype='undertext']"/></span><xsl:value-of select="child::tei:seg[@subtype='overtext']"/></span> -->
    <xsl:value-of select="child::tei:seg[@subtype='overtext']"/> [overwritten: <fo:inline text-decoration="line-through"><xsl:value-of select="child::tei:seg[@subtype='undertext']"/></fo:inline>]
   </xsl:when>
   <xsl:when test="@type = 'demo' and @subtype = 'handshift'">
    <xsl:variable name="handIDval" select="substring-after(@n, '#')"/>
    <!-- <span class="handshift"> -->
     <xsl:attribute name="title"><xsl:text>Otto Erich Deutsch's hand</xsl:text></xsl:attribute>
     <xsl:apply-templates/><!-- </span> -->
   </xsl:when>

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
    <!-- <span class="editorial"> -->[sic] <!-- </span> -->
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
    <!-- <span class="editorial"> -->[recte <!-- </span> -->
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:signed">
  <fo:block>
  <!--<span class="editorial"> -->
   <xsl:text>[</xsl:text> signed: <xsl:text>] </xsl:text>
  <!-- </span> -->
  <xsl:apply-templates/>
  </fo:block>
 </xsl:template>

 <xsl:template match="tei:subst">
  <xsl:choose>
   <xsl:when test="child::tei:del[@rend='overwritten']/child::tei:gap">
    <!--<span class="erased" onmouseover="show(this)" onmouseout="show(this)" xml:space="preserve"><span class="erased2 green">[illeg]</span><xsl:value-of select="child::tei:add[@place='superimposed']"/></span> -->
    <fo:inline font-weight="bold"><xsl:value-of select="child::tei:add[@place='superimposed']"/></fo:inline><xsl:text>[illeg]</xsl:text>
   </xsl:when>
   <xsl:when test="child::tei:del[@rend='overwritten']">
    <!-- <span class="erased" onmouseover="show(this)" onmouseout="show(this)" xml:space="preserve"><span class="erased2"><xsl:value-of select="child::tei:del[@rend='overwritten']"/></span><xsl:value-of select="child::tei:add[@place='superimposed']"/></span> -->
    <fo:inline font-weight="bold"><xsl:value-of select="child::tei:add[@place='superimposed']"/></fo:inline><fo:inline text-decoration="line-through"><xsl:value-of select="child::tei:del[@rend='overwritten']"/></fo:inline>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="tei:supplied">
  <!-- <span class="editorial"> -->
   <xsl:text>[</xsl:text>
   <xsl:apply-templates/>
   <xsl:text>]</xsl:text>
  <!-- </span> -->
 </xsl:template>


 <xsl:template match="tei:title">
  <xsl:choose>
   <xsl:when test="@level ='j'">
    <fo:inline font-style="italic">
     <xsl:apply-templates/>
    </fo:inline>
   </xsl:when>
   <xsl:when test="@level='m'">
    <fo:inline font-style="italic">
     <xsl:apply-templates/>
    </fo:inline>
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
  <!--<span class="editorial"> -->
   <xsl:text>[?</xsl:text>
   <xsl:apply-templates/>
   <xsl:text>]</xsl:text>
  <!--</span> -->
 </xsl:template>
 
 <xsl:template match="tei:p">
 <fo:block padding-bottom="5mm">
  <xsl:apply-templates/>
 </fo:block> 
 </xsl:template>
 
 <!--   HEADINGS   -->  
 <xsl:template match="tei:TEI/*/*/tei:div/tei:head">
  <fo:block id="{generate-id()}">
   <xsl:apply-templates/>
  </fo:block>
 </xsl:template>
 <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:head">
  <fo:block id="{generate-id()}">
   <xsl:apply-templates/>
  </fo:block>
 </xsl:template>
 <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:head">
  <fo:block id="{generate-id()}">
   <xsl:apply-templates/>
  </fo:block>
 </xsl:template>
 <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:div/tei:head">
  <fo:block id="{generate-id()}">
   <xsl:apply-templates/>
  </fo:block>
 </xsl:template>
 <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:div/tei:div/tei:head">
  <fo:block id="{generate-id()}">
   <xsl:apply-templates/>
  </fo:block>
 </xsl:template>
 <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:div/tei:div/tei:div/tei:head">
  <fo:block id="{generate-id()}">
   <xsl:apply-templates/>
  </fo:block>
 </xsl:template>
 
 
 <xsl:template match="tei:bibl[parent::tei:listBibl]">
  <fo:list-item>
   <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
   <fo:list-item-body>
    <fo:block start-indent="body-start()"><xsl:apply-templates/></fo:block>
   </fo:list-item-body>
  </fo:list-item> 
 </xsl:template>
 
 <xsl:template match="tei:listBibl/tei:head">
  <fo:block font-weight="bold">
    <xsl:apply-templates/>
  </fo:block>
 </xsl:template>
 
 <xsl:template match="tei:dl">
  <xsl:apply-templates select="*"/>
 </xsl:template>
 
 <xsl:template match="tei:dt">
  <fo:block font-weight="bold" space-after="2pt"
   keep-with-next="always">
   <xsl:apply-templates select="*|text()"/>
  </fo:block>
 </xsl:template>
 
 <xsl:template match="tei:dd">
  <fo:block start-indent="1cm">
   <xsl:attribute name="space-after">
    <xsl:choose>
     <xsl:when test="name(following::*[1]) = 'dd'">
      <xsl:text>3pt</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>12pt</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
   <xsl:apply-templates select="*|text()"/>
  </fo:block>
 </xsl:template>
 
 <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TEI:GRAPHIC AND RELATED TEMPLATES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->

 <xsl:template match="tei:graphic[@url]">
  <xsl:call-template name="showFigure"/> 
 </xsl:template>
 
 <xsl:template match="tei:figure/tei:head"/>
 <xsl:template match="tei:figure/tei:figDesc"/> 
 
 
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
  <xsl:variable name="img-path-full" select="concat($img-folder, '/', $img-subpath-full, '/', $img-src)"/>
  <xsl:variable name="img-path-thumb" select="concat($img-folder, '/', $img-subpath-thumb, '/thm_', $img-src)"/>
  
  <!-- caption -->
  <xsl:variable name="img-cap-desc">
   <xsl:choose>
    <xsl:when test="ancestor::tei:figure/tei:head"><xsl:value-of select="ancestor::tei:figure/tei:head"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="ancestor::tei:figure/tei:figDesc"/></xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  
  <!-- OUTPUT FIGURE TEMPLATE -->
  <xsl:choose>
    
   <!-- PC, 5 March 2013 -->
   <!-- THE 'WHEN' CONDITION BELOW IS THE CURRENT CODE FOR MUSICAL EXAMPLES IN SDO PRIMARY DOCUMENTS -->
   <xsl:when test="parent::tei:figure[@type='musical_example'] and @n='thumb'">
    <fo:external-graphic src="url('{concat('http://www.schenkerdocumentsonline.org', $img-path-thumb)}')" content-type="image/png" content-height="scale-to-fit" height="0.6cm"/>
   </xsl:when>

   <!-- END CODE FOR SDO MUSICAL EXAMPLES IN PRIMARY DOCS-->
   <!-- PC, 24 April 2013 -->
   <!-- THE 'WHEN' CONDITION BELOW IS THE CURRENT CODE FOR MISCELLANEOUS IMAGES IN SDO PRIMARY DOCUMENTS.  IT IS -->
   <!-- FUNCTIONALLY IDENTICAL TO THE MUSICAL EXAMPLE CODE ABOVE, BUT WE WANT TO KEEP THE IMAGE TYPES SEPARATE -->
   <xsl:when test="parent::tei:figure[@type='misc_image'] and @n='thumb'">
    <fo:external-graphic src="url('{concat('http://www.schenkerdocumentsonline.org', $img-path-thumb)}')" content-type="image/png" content-height="scale-to-fit" height="0.6cm"/>
   </xsl:when>
   
   <xsl:when test="not(contains(@xmt:type, 'thumb'))">
   
    <fo:block font-weight="bold" space-after="2pt" keep-with-next="always">
     <fo:external-graphic src="url('{concat('http://www.schenkerdocumentsonline.org', $img-path-full)}')" content-type="image/png" content-height="scale-to-fit" height="6cm"/>	
    </fo:block>
    
    <xsl:if test="$img-cap-desc != ''">
    <fo:block start-indent="1cm">
     <xsl:attribute name="space-after">
      <xsl:choose>
       <xsl:when test="name(following::*[1]) = 'dd'">
        <xsl:text>3pt</xsl:text>
       </xsl:when>
       <xsl:otherwise>
        <xsl:text>12pt</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
     <xsl:value-of select="$img-cap-desc"/>
    </fo:block>
    </xsl:if>
   </xsl:when>

  </xsl:choose>
 </xsl:template>

 
</xsl:stylesheet>
