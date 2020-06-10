<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl" />

  <xsl:param name="rows" select="10" />
  
  <xsl:param name="inc" />
  <xsl:param name="lang" />

  <xsl:variable name="kw" select="/*/response/lst/lst[@name='params']/str[@name='q']" />
  
  <xsl:variable name="filter">
    <xsl:choose>
      <xsl:when test="/*/response/lst/lst[@name='params']/str[@name='fq']"><xsl:value-of  select="/*/response/lst/lst[@name='params']/str[@name='fq']"/></xsl:when>
      <xsl:when test="/*/response/lst/lst[@name='params']/arr[@name='fq']"><xsl:value-of select="/*/response/lst/lst[@name='params']/arr[@name='fq']/str[1]" /></xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="filter2">
    <xsl:choose>
      <xsl:when test="/*/response/lst/lst[@name='params']/str[@name='fq' and (contains(text(), 'foreign_word') or contains(text(), 'term'))]"><xsl:value-of select="/*/response/lst/lst[@name='params']/str[@name='fq']" /></xsl:when>
      <xsl:when test="/*/response/lst/lst[@name='params']/arr[@name='fq']"><xsl:value-of select="/*/response/lst/lst[@name='params']/arr[@name='fq']/str[2]" /></xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="fq" >
    <xsl:choose>
      <xsl:when test="contains($filter, 'kind:')">
        <xsl:value-of select="substring-after($filter, 'kind:')"></xsl:value-of>
      </xsl:when>
      <xsl:otherwise />      
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="fq2" >
    <xsl:value-of select="substring-before($filter2, ':')" />     
  </xsl:variable> 
  
  <xsl:variable name="start" select="number(/*/response/result/@start)" />
  <xsl:variable name="number-results" select="number(/*/response/result/@numFound)" />

  <xsl:variable name="current-page" select="floor($start div $rows)+1" />
  <xsl:variable name="total-pages" select="xs:integer(ceiling($number-results div $rows))" />
  <xsl:variable name="requestString" select="$inc" />
  
  <xsl:variable name="print-list">
    <xsl:for-each select="tokenize($requestString, '&amp;')">
      <xsl:choose>
        <xsl:when test="substring-before(.,'=') = 'fq'" />
        <xsl:when test="substring-before(.,'=') = 'fq2'" />
        <xsl:when test="substring-before(.,'=') = 'kw'" />
        <xsl:when test="substring-before(.,'=') = 'p'" />
        <xsl:when test="substring-before(.,'=') = 'lang'" />
        <xsl:otherwise>&amp;<xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  

  <xsl:template name="xms:content">
    
    <div>
      <h2>Full text search of German original and English translation</h2>
      <p>About searching:</p>
      <ul>
        <li>searches are case-insensitive - <strong>bakery</strong> finds <strong>bakery</strong> and <strong>Bakery</strong></li>
        <li>searches find closely related words - <strong>bakery</strong> finds <strong>bakery</strong> and <strong>bakeries</strong></li>
        <li>use quote marks to find words together - <strong>"railway station"</strong> finds just <strong>railway station</strong> while <strong>railway station</strong> finds instances of <strong>railway</strong> and <strong>station</strong></li>
        <li>add tilde (~) and number to specify desired proximity - <strong>"errors copy"~5</strong> finds <strong>errors</strong> and <strong>copy within 5 words of each other</strong></li>
      </ul>
      <form action="" method="get" name="searchForm">
        <p>
          <label class="search" style="display:inline;">Search <select name="fq" style="display:inline;">
              <option value="all">
                <xsl:if test="$fq='all' or $fq = ''">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>Entire Site</option>
            <option value="diaries">
              <xsl:if test="$fq='diaries' and $fq2 = ''">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Diaries</option>
            <option value="correspondence">
              <xsl:if test="$fq='correspondence' and $fq2 = ''">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Correspondence</option>
            <option value="lessonbooks">
              <xsl:if test="$fq='lessonbooks' and $fq2 = ''">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Lessonbooks</option>
            <option value="work">
              <xsl:if test="$fq='work' and $fq2 = ''">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Works</option>
            <option value="journal">
              <xsl:if test="$fq='journal' and $fq2 = ''">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Journals</option>
 <!--           <option value="mixed">
              <xsl:if test="$fq='mixed' and $fq2 = ''">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Mixed Documents</option>   -->            
            <option value="other">
              <xsl:if test="$fq='other' and $fq2 = ''">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Other Documents</option>               
            <option value="person">
              <xsl:if test="$fq='person' and $fq2 = ''">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>People</option>
              <option value="place">
                <xsl:if test="$fq='place' and $fq2 = ''">
                  <xsl:attribute name="selected">true</xsl:attribute>
                </xsl:if>Places</option>
            <option value="organization">
              <xsl:if test="$fq='organization' and $fq2 = ''">
              <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Organizations</option>
            <option value="term">
              <xsl:if test="contains($fq2,'term')">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Technical Terms</option>           
    <!--        <option value="term_en">
              <xsl:if test="$fq2='term_en'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - Terms (English)</option>             
            <option value="term_de">
              <xsl:if test="$fq2='term_de'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - Terms (German)</option>  -->
            <option value="foreign_word">
              <xsl:if test="contains($fq2,'foreign_word')">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if>Foreign Words</option>                      
  <!--          <option value="foreign_word_fre">
              <xsl:if test="$fq2='foreign_word_fre'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - French Word</option>              
            <option value="foreign_word_ger">
              <xsl:if test="$fq2='foreign_word_ger'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - German Word</option>    
            <option value="foreign_word_gre">
              <xsl:if test="$fq2='foreign_word_re'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - Greek Word</option>              
            <option value="foreign_word_ita">
              <xsl:if test="$fq2='foreign_word_ita'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - Italian Word</option> 
            <option value="foreign_word_lat">
              <xsl:if test="$fq2='foreign_word_lat'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - Latin Word</option>              
            <option value="foreign_word_yid">
              <xsl:if test="$fq2='foreign_word_yid'">
                <xsl:attribute name="selected">true</xsl:attribute>
              </xsl:if> - Yiddish Word</option>  -->

            </select></label>
          <label class="search"> for 
          <input name="kw" size="20" type="text" value="{$kw}" />
          </label>
          <input type="submit" />
        </p>
      </form>
      <form action="/mobile/docs.zip" method="get" onsubmit="return validate()">
      
      <xsl:apply-templates select="/*/response" />
        <input name="fq" value="{$fq}" type="hidden"/>
        <input name="fq2" value="{$fq2}" type="hidden"/>
        <input name="p" value="{$current-page}" type="hidden"/>
        <input name="kw" value="{$kw}" type="hidden"/>
      </form>
    </div>
  </xsl:template>

  <xsl:template match="response">
    <h2>Searched for <em><xsl:value-of select="lst/lst[@name='params']/str[@name='q']" /></em>
      <xsl:if test="$fq != '' and $fq != 'all'"><xsl:text> in </xsl:text><xsl:value-of select="upper-case(substring($fq, 1, 1))" /><xsl:value-of select="substring($fq, 2)"></xsl:value-of></xsl:if>
      <xsl:if test="$number-results > 0"><xsl:text> (</xsl:text><xsl:value-of select="$number-results"/><xsl:text> result</xsl:text><xsl:if test="$number-results > 1">s</xsl:if><xsl:text> found)</xsl:text></xsl:if></h2>
    <xsl:variable name="regex">(^|[\W])<xsl:value-of select="translate($kw, '&quot;', '')"/>($|[\W])</xsl:variable>
<!--
    <p>FQ: '<xsl:value-of select="$fq" />'</p>
    <p>FQ2: '<xsl:value-of select="$fq2" />'</p>
    <p>PL: '<xsl:value-of select="$print-list"/>'</p>
    <p>regex: <xsl:value-of select="$regex" /></p>
-->
  <xsl:choose>
    <xsl:when test="($fq='' or $fq='all') and $number-results > 0">
      <p>Filter: <xsl:for-each select="lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='kind']/int[. > 0]">
      <a>
        <xsl:attribute name="href">
          <xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/>
          <xsl:text>&amp;fq=</xsl:text><xsl:value-of select="@name" />
          <xsl:text>&amp;fq2=</xsl:text><xsl:value-of select="$fq2" />
          <xsl:value-of select="$print-list"/>
        </xsl:attribute>
        <xsl:attribute name="onClick">buildURL(this)</xsl:attribute>
        <xsl:value-of select="@name" /><xsl:text>: </xsl:text><xsl:value-of select="." />
      </a>
      <xsl:if test="not(position() = last())">,</xsl:if><xsl:text> </xsl:text>
      </xsl:for-each></p>
    </xsl:when>
    <xsl:when test="$fq='' or $fq='all'" />
    <xsl:otherwise><p>Remove filter -      
      <a>
        <xsl:attribute name="href"><xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/><xsl:text>&amp;fq=</xsl:text><xsl:text>&amp;fq2=</xsl:text><xsl:value-of select="$fq2" /><xsl:value-of select="$print-list"/></xsl:attribute>
      <xsl:attribute name="onClick">buildURL(this)</xsl:attribute>
       Category: <xsl:value-of select="$fq" />
      </a></p></xsl:otherwise>
  </xsl:choose> 
    
    <xsl:choose>
      <xsl:when test="contains($fq2, 'term_') or contains($fq2, 'foreign_word_')">
        <xsl:variable name="lang_id" >
          <xsl:choose>
            <xsl:when test="contains($fq2, 'term_')"><xsl:value-of select="substring-after($fq2, '_')"/></xsl:when>
            <xsl:when test="contains($fq2, 'foreign_word_')"><xsl:value-of select="substring-after($fq2, 'word_')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        
        <!-- PC, 04 Mar 2014: changed from original template because previously if $lang_id was empty
          the value of $facet_base got set to be just 'foreign', and that caused Solr to throw severe
          exceptions because there is no such field named 'foreign'.  -->
        <xsl:variable name="facet_base" >
          <xsl:choose>
            <xsl:when test="contains($fq2, 'term')"><xsl:text>term</xsl:text></xsl:when>
            <xsl:when test="contains($fq2, 'foreign_word')"><xsl:text>foreign_word</xsl:text></xsl:when>
          </xsl:choose>
        </xsl:variable>
        
        
        <p>Remove <xsl:value-of select="translate(substring-before($fq2, concat('_', $lang_id)), '_', ' ')" /><xsl:text> </xsl:text>language filter -      
        <a>
          <!-- <xsl:choose>
            <xsl:when test="contains($fq, 'term') or contains($fq, 'foreign_word')">
              <xsl:attribute name="href"><xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/><xsl:text>&amp;fq=</xsl:text><xsl:value-of select="substring-before($fq, '_')"></xsl:value-of><xsl:value-of select="$print-list"/></xsl:attribute></xsl:when>
            <xsl:otherwise><xsl:attribute name="href"><xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/><xsl:text>&amp;fq=</xsl:text><xsl:value-of select="substring-before($fq, '_')"></xsl:value-of><xsl:value-of select="concat(substring-before($print-list, '_'), substring-after($print-list, 'en'))"/></xsl:attribute></xsl:otherwise>
            </xsl:choose> -->   
          
          <xsl:attribute name="href"><xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/><xsl:text>&amp;fq=</xsl:text><xsl:value-of select="$fq"/><xsl:text>&amp;fq2=</xsl:text><xsl:value-of select="$facet_base"/><xsl:value-of select="$print-list"/>
          </xsl:attribute>
          
          <xsl:attribute name="onClick">buildURL(this)</xsl:attribute>
          <xsl:value-of select="$lang_id" />
          
        </a></p></xsl:when>      
      <xsl:when test="($fq2 = 'term' or $fq2 = 'foreign_word') and $number-results > 0">
        <xsl:variable name="type"><xsl:value-of select="upper-case(substring($fq2, 1, 1))" /><xsl:value-of select="substring(translate($fq2, '_', ' '), 2)" /></xsl:variable>
        <p><xsl:value-of select="$type" /><xsl:text> </xsl:text>language filter: 
          
          <xsl:for-each-group select="//response/result/doc/arr/str[matches(text(), $regex)]" group-by="../@name"> 
            
           <xsl:if test="contains(current-grouping-key(), '_')">     
             
             <xsl:variable name="facet" >
               <xsl:choose>
                 <xsl:when test="contains(current-grouping-key(), 'term_')"><xsl:value-of select="substring-after(current-grouping-key(), '_')"/></xsl:when>
                 <xsl:when test="contains(current-grouping-key(), 'foreign_word_')"><xsl:value-of select="substring-after(current-grouping-key(), 'word_')"/></xsl:when>
               </xsl:choose>
             </xsl:variable>            
                        
             <xsl:variable name="nodes" as="item()*">
             <xsl:for-each-group select="current-group()" group-by="../../str[@name = 'fileId']">1</xsl:for-each-group></xsl:variable>  
             
          <xsl:if test="$facet != ''">  
          <a>
            <xsl:attribute name="href"> 
              <xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/>
              <xsl:text>&amp;fq=</xsl:text><xsl:value-of select="$fq" />
              <xsl:text>&amp;fq2=</xsl:text><xsl:value-of select="concat($fq2, '_', $facet)" />
              <xsl:value-of select="$print-list"/>
            </xsl:attribute>
            <xsl:attribute name="onClick">buildURL(this)</xsl:attribute>
            <xsl:value-of select="$facet" /><xsl:text>: </xsl:text><xsl:value-of select="count($nodes)" />
          </a>
              <xsl:if test="not(position() = last())">,</xsl:if><xsl:text> </xsl:text>
          </xsl:if> 
          </xsl:if> 
          
            
        </xsl:for-each-group></p>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>     
    
    <p>Download all selected files as <input type="submit" name="format" value="pdf" /> or <input type="submit" name="format" value="epub" /> or <input type="submit" name="format" value="both" /> (check files to select/deselect)<br />Where appropriate save: 
      <xsl:choose>
        <xsl:when test="$lang = 'de'"><input type="radio" name="lang" value="all" /> English and German versions <input type="radio" name="lang" value="de" checked="checked" /> German version only <input type="radio" name="lang" value="en" /> English version only</xsl:when>
        <xsl:when test="$lang = 'en'"><input type="radio" name="lang" value="all" /> English and German <input type="radio" name="lang" value="de" /> German Only <input type="radio" name="lang" value="en" checked="checked" /> English only</xsl:when>
        <xsl:otherwise><input type="radio" name="lang" value="all" checked="checked" /> English and German versions <input type="radio" name="lang" value="de" /> German version only <input type="radio" name="lang" value="en" /> English version only</xsl:otherwise>
      </xsl:choose>
    </p>   
    
    <xsl:choose>
      <xsl:when test="$number-results = 0">
        <h3>No results found</h3>
       </xsl:when> 
       <xsl:otherwise> 
        <ul>
      <xsl:for-each select="result/doc">
        <xsl:variable name="hl-pos" select="position()" />
        <xsl:variable name="kind" select="str[@name='kind']" />
        <xsl:variable name="href">
              <xsl:choose>
                <xsl:when test="$kind = 'diaries' or $kind = 'correspondence' or $kind = 'lessonbooks' or $kind = 'other'"><xsl:text>../documents/</xsl:text></xsl:when>
                <xsl:otherwise><xsl:text>../profiles/</xsl:text></xsl:otherwise>
              </xsl:choose>              
              <xsl:value-of select="arr[@name = 'url']/str" />          
        </xsl:variable>
        <xsl:variable name="doccode">
          <xsl:for-each select="tokenize($href, '/')">
            <xsl:choose>
              <xsl:when test="position() = last()"><xsl:value-of select="substring-before(., '.html')"/></xsl:when>
              <xsl:when test="position() = (last() - 1) and ($kind = 'lessonbooks' or $kind = 'diaries')"><xsl:value-of select="."/>*</xsl:when>
              <xsl:when test="position() > 1"><xsl:value-of select="substring(., 1, 2)"/><xsl:text>*</xsl:text></xsl:when>
              <xsl:otherwise><!--  --></xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:variable>
        
        <li>
          <xsl:choose>
            <xsl:when test="contains($print-list, $doccode)"><input type="checkbox" name="{$doccode}" value="1" checked="checked" /></xsl:when>
            <xsl:otherwise><input type="checkbox" name="{$doccode}" value="1" /></xsl:otherwise>
          </xsl:choose>
          <a href="{$href}">
            <xsl:value-of select="arr[@name='title']/str" />
            <xsl:if test="$kind = 'diaries'">
              <xsl:text>Diary entry for </xsl:text>
              <xsl:value-of select="str[@name='dateShort']" />
            </xsl:if>
          </a>
          
          <xsl:for-each select="../../lst[@name = 'highlighting']/lst[$hl-pos]">
            <p>
              <xsl:text>... </xsl:text>
              <xsl:call-template name="unescape-highlight">
                <xsl:with-param name="text" select="arr/str" />
              </xsl:call-template>
              <xsl:text> ...</xsl:text>
            </p>
          </xsl:for-each>
          
        </li>
      </xsl:for-each>
    </ul>



    <p>Pages: <xsl:for-each select="1 to $total-pages">
        <xsl:choose>
          <xsl:when test=". = $current-page">
            <xsl:value-of select="." />
            <xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <a>
              <xsl:attribute name="href"><xsl:text>?kw=</xsl:text><xsl:value-of select="$kw"/><xsl:text>&amp;fq=</xsl:text><xsl:value-of select="$fq"/><xsl:text>&amp;p=</xsl:text><xsl:value-of select="."/><xsl:value-of select="$print-list"/></xsl:attribute>
              <xsl:attribute name="onClick">buildURL(this)</xsl:attribute>
              <xsl:value-of select="." />
            </a>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="unescape-highlight">
    <xsl:param name="text" select="''" />

    <xsl:variable name="gt" select="'&gt;'" /> <!-- '>' -->
    <xsl:variable name="open-tag" select="'&lt;'" />  <!-- '<' -->
    <xsl:variable name="close-tag" select="'&lt;/'" />  <!-- '</' -->
    <xsl:variable name="pre-hl" select="substring-before($text, $open-tag)" />
    
    <xsl:choose>
      <xsl:when test="$pre-hl or starts-with($text, $open-tag)">
        <xsl:value-of select="$pre-hl" />
        <b>
          <xsl:value-of select="substring-after(substring-before($text, $close-tag), $gt)" />
        </b>

        <xsl:variable name="remainder" select="substring-after(substring-after($text, $gt), $gt)" />

        <xsl:if test="$remainder">
          
          <xsl:call-template name="unescape-highlight">
            <xsl:with-param name="text" select="$remainder" />
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
