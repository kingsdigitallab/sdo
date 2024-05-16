<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0">

  <xsl:import href="../default.xsl"/>
  <xsl:include href="cocoon://_internal/properties/properties.xsl" />  
  
  <xsl:param name="type"/>

  <xsl:template match="tei:rs[@key]">
    <xsl:variable name="display-name">
      <xsl:for-each select="$eats/entities/entity[keys/key = current()/@key]">
        <xsl:choose>
          <xsl:when test="names/name[@is_preferred = true()]">
            <xsl:value-of select="names/name[@is_preferred = true()]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="names/name[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="default-name"><xsl:apply-templates/></xsl:variable>
    
    <xsl:value-of select="$default-name" /><xsl:if test="not($default-name = $display-name)"><xsl:text> [</xsl:text><xsl:value-of select="$display-name" />]</xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:handShift">
    <xsl:variable name="handIDval" select="substring-after(@new, '#')"/>
    <xsl:variable name="handshift">
      <xsl:choose>
        <xsl:when test="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:handNotes/tei:handNote[@xml:id = $handIDval]"><xsl:value-of select="/aggregation/sdo:recordCollection/sdo:collectionDesc/tei:handNotes/tei:handNote[@xml:id = $handIDval]" /></xsl:when>
        <xsl:otherwise>Writing shift</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <span class="handshift">[<xsl:value-of select="$handshift" /> ->]</span>
  </xsl:template>
  
  
  <!-- NOT ALL REF OPTIONS CHECKED -->
  <xsl:template match="tei:ref">
    <xsl:choose>
      <xsl:when test="@type  = 'external' or @rend = 'external'">
        <xsl:text> [</xsl:text><xsl:apply-templates/>]
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
            <xsl:text> [</xsl:text><xsl:value-of select="$path"/>]
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
                <xsl:text> [</xsl:text><xsl:value-of select="$path"/>]        
              </xsl:when>
              <xsl:otherwise>
              </xsl:otherwise>
            </xsl:choose>
            
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="file" select="@cRef"/>
            <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
            <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
           <xsl:value-of select="$title" /><xsl:text> (http://www.schenkerdocumentsonline.org/</xsl:text><xsl:value-of select="$path"/><xsl:text>)</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@target">
        <xsl:text> [</xsl:text>
            <xsl:if test="starts-with(@target, '/')">
              <xsl:value-of select="$xmp:context-path"/>
            </xsl:if>
            <!-- This is well dodgy. -->
            <xsl:value-of select="@target"/>
          <xsl:apply-templates/>]
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:subst">
    <xsl:choose>
      <xsl:when test="child::tei:del[@rend='overwritten']/child::tei:gap">
        <xsl:value-of select="child::tei:add[@place='superimposed']"/><span class="green">[illeg]</span>
      </xsl:when>
      <xsl:when test="child::tei:del[@rend='overwritten']">
        <xsl:value-of select="child::tei:add[@place='superimposed']"/><span class="green"><del><xsl:value-of select="child::tei:del[@rend='overwritten']"/></del></span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

 <!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TEI:GRAPHIC AND RELATED TEMPLATES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
  
  
 <!-- SHOW FIGURE /// REDO IT ///-->
 <xsl:template name="showFigure">
   <!-- folder info -->
   <xsl:variable name="img-folder">
   <xsl:choose>
     <xsl:when test="$type = 'epub'"><xsl:text>../Image</xsl:text></xsl:when>
     <xsl:otherwise><xsl:value-of select="concat($xmp:images-path, '/local')"/></xsl:otherwise>
   </xsl:choose>
   </xsl:variable>
   <xsl:variable name="img-subpath-full" select="'full'"/>
   <xsl:variable name="img-subpath-thumb" select="'thumb'"/>
   <!-- file info -->
   <xsl:variable name="img-src" select="@url"/>
   <xsl:variable name="img-thm-prefix" select="'thm_'"/>
   <!-- path to images -->
   <xsl:variable name="img-path-full" select="concat($img-folder, '/', $img-subpath-full, '/', $img-src)"/>
   <xsl:variable name="img-path-thumb" select="concat($img-folder, '/', $img-subpath-thumb, '/thm_', $img-src)"/>
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
  
</xsl:stylesheet>