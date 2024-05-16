<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" 
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0" 
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xi="http://www.w3.org/2001/XInclude">

  <xsl:import href="sdo-pdf-p5.xsl" />
  
  <xsl:param name="lang" />

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="all" />
  <xsl:param name="qualifier" />

 <!--  <xsl:variable name="entity-key" select="substring-before($filename, '.')" /> -->

  <xsl:variable name="correspondence" select="/aggregation/response/result/doc[str[@name='kind']='correspondence']" />
  <xsl:variable name="diaries" select="/aggregation/response/result/doc[str[@name='kind']='diaries']" />
  <xsl:variable name="lessonbooks" select="/aggregation/response/result/doc[str[@name='kind']='lessonbooks']" />
  <xsl:variable name="other" select="/aggregation/response/result/doc[str[@name='kind']='other']" />
  <xsl:variable name="type">
    <xsl:for-each select="/*/eats/entities/entity[keys/key = $filename]">
          <xsl:for-each select="types/type">
            <xsl:value-of select="." />           
            <xsl:if test="position() != last()">
              <xsl:text>/</xsl:text>
            </xsl:if>
          </xsl:for-each>   
      </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="include">
    <xsl:choose>
      <xsl:when test="$all = 'false'"><xsl:value-of select="false()"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="true()"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  
  <xsl:template match="/">
    
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>
        <fo:simple-page-master master-name="page"
          page-height="29.7cm" 
          page-width="21cm"
          margin-top="1cm" 
          margin-bottom="2cm" 
          margin-left="2.5cm" 
          margin-right="2.5cm">
          <fo:region-before extent="3cm"/>
          <fo:region-body margin-top="3cm"/>
          <fo:region-after extent="1.5cm"/>
        </fo:simple-page-master>
        
        <fo:page-sequence-master master-name="all">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference master-reference="page" page-position="first"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="all">
        <fo:flow flow-name="xsl-region-body">
          <fo:block font-family="serif" space-after="12pt" keep-with-next="always" line-height="20pt" font-size="18pt">
            <xsl:choose>
              <xsl:when test="/*/tei:TEI">
                <xsl:value-of select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
              </xsl:when>
              <xsl:when test="/*/eats/entities/entity[keys/key = $filename]/names/name">
                <xsl:value-of select="/*/eats/entities/entity[keys/key = $filename]/names/name[1]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
          <xsl:if test="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']">
          <fo:block>
            <xsl:apply-templates mode="pagehead" select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']" />
          </fo:block>
          </xsl:if>
          <xsl:variable name="authors-and-editors" select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:*[self::tei:author or self::tei:editor]" />
          <xsl:if test="$authors-and-editors">
            <fo:block>
              <xsl:text>(</xsl:text>
              <xsl:apply-templates mode="pagehead" select="$authors-and-editors" />
              <xsl:text>)</xsl:text>
            </fo:block>  
          </xsl:if>
          
          <xsl:call-template name="xms:content" />
          
          <!--
          <xsl:if test="$include">
            <fo:block>xx</fo:block>
            <xsl:for-each select="/aggregation/response/result/doc">
              <xsl:variable name="chapter-path"><xsl:text>cocoon://</xsl:text><xsl:value-of select="replace(str[@name = 'file'], 'documents', 'mobile')" /><xsl:text>:</xsl:text><xsl:value-of select="$qualifier" /><xsl:text>.pdf?as=part</xsl:text></xsl:variable>
              <fo:block><xsl:value-of select="$chapter-path" /></fo:block>
              
              <xi:include href="$chapter-path" />
            </xsl:for-each>           
          </xsl:if>
          -->
          
        </fo:flow>
      </fo:page-sequence>
    </fo:root>  
  </xsl:template>
  
  

  <xsl:template name="xms:content">
        
    <xsl:if test="/aggregation/tei:TEI">
    <xsl:choose>
      <xsl:when test="/aggregation/response/result/doc">
        <fo:block>Documents associated with this <xsl:value-of select="$type" />:</fo:block>
        <fo:list-block provisional-distance-between-starts="0.2cm" provisional-label-separation="0.5cm" space-after="12pt" start-indent="1cm">        
          <xsl:if test="$correspondence">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>           
              <fo:list-item-body><fo:block><fo:basic-link internal-destination="correspondence" color="green">Correspondence</fo:basic-link></fo:block></fo:list-item-body>
            </fo:list-item> 
          </xsl:if>
          <xsl:if test="$diaries">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>           
              <fo:list-item-body><fo:block><fo:basic-link internal-destination="diaries" color="green">Diaries</fo:basic-link></fo:block></fo:list-item-body>
            </fo:list-item>  
          </xsl:if>
          <xsl:if test="$lessonbooks">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>           
              <fo:list-item-body><fo:block><fo:basic-link internal-destination="lessonbooks" color="green">Lessonbooks</fo:basic-link></fo:block></fo:list-item-body>
            </fo:list-item>             
          </xsl:if>
          <xsl:if test="$other">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>           
              <fo:list-item-body><fo:block><fo:basic-link internal-destination="other" color="green">Other material</fo:basic-link></fo:block></fo:list-item-body>
            </fo:list-item>  
          </xsl:if>
        </fo:list-block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>There are no documents associated with this entity.</fo:block>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:if>
 
    <xsl:choose>
      <xsl:when test="/aggregation/tei:TEI">
        <xsl:apply-templates select="/aggregation/tei:TEI" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="entity-from-eats" />
      </xsl:otherwise>
    </xsl:choose>
 
    <xsl:if test="/aggregation/response/result/doc">      
      <fo:block>
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Correspondence'" />
          <xsl:with-param name="id" select="'correspondence'" />
          <xsl:with-param name="docs" select="$correspondence" />
        </xsl:call-template>
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Diaries'" />
          <xsl:with-param name="id" select="'diaries'" />
          <xsl:with-param name="docs" select="$diaries" />
        </xsl:call-template>
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Lessonbooks'" />
          <xsl:with-param name="id" select="'lessonbooks'" />
          <xsl:with-param name="docs" select="$lessonbooks" />
        </xsl:call-template>
        <xsl:call-template name="make-section">
          <xsl:with-param name="name" select="'Other material'" />
          <xsl:with-param name="id" select="'other'" />
          <xsl:with-param name="docs" select="$other" />
        </xsl:call-template>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template name="entity-from-eats">
    <xsl:for-each select="/*/eats/entities/entity[keys/key = $filename]">
      <xsl:variable name="entity-name" select="names/name[1]" />
      <fo:block>
        <fo:inline font-weight="bold">Types: </fo:inline>
        <fo:inline><xsl:value-of select="replace($type, '/', ', ')" /></fo:inline>
      </fo:block>

      <xsl:if test="names/name">      
      <fo:block>
          <xsl:choose>
            <xsl:when test="count(names/name/text()) > 1">
              <fo:block font-weight="bold">Names:</fo:block>
              <fo:block>
                <fo:list-block provisional-distance-between-starts="0.2cm" provisional-label-separation="0.5cm" space-after="12pt" start-indent="1cm">  
                  <xsl:for-each select="names/name">
                    <fo:list-item>
                      <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>           
                      <fo:list-item-body><fo:block><xsl:value-of select="." /></fo:block></fo:list-item-body>
                    </fo:list-item> 
                  </xsl:for-each>
                </fo:list-block> 
              </fo:block>              
            </xsl:when>
            <xsl:otherwise>
              <fo:inline font-weight="bold">Name: </fo:inline>
              <fo:inline><xsl:value-of select="names/name" /></fo:inline>
            </xsl:otherwise>
          </xsl:choose>
          </fo:block>
      </xsl:if>
       
      <xsl:if test="relationships/relationship">
        <fo:block font-weight="bold">Relationships:</fo:block>
        <fo:block>
          <fo:list-block provisional-distance-between-starts="0.2cm" provisional-label-separation="0.5cm" space-after="12pt" start-indent="1cm">  
                <xsl:for-each select="relationships/relationship[@direction = 'direct']">
                  <fo:list-item>
                    <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
                    <fo:list-item-body><fo:block>
                    <xsl:value-of select="$entity-name" />
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@type" />
                    <xsl:text> </xsl:text>
                    [<xsl:value-of select="names/name[1]" />]
                    </fo:block></fo:list-item-body>
                  </fo:list-item> 
                </xsl:for-each>
                <xsl:for-each select="relationships/relationship[@direction = 'inverse']">
                  <fo:list-item>
                    <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
                    <fo:list-item-body><fo:block>
                    <xsl:value-of select="names/name[1]" />
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@type" />
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$entity-name" />
                    </fo:block></fo:list-item-body>
                  </fo:list-item> 
                </xsl:for-each>
            </fo:list-block>
        </fo:block>
        </xsl:if>  
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="make-section">
    <xsl:param name="name" />
    <xsl:param name="id" />
    <xsl:param name="docs" />
    <xsl:if test="$docs">
      <fo:block id="{$id}" font-family="serif" space-after="14pt" keep-with-next="always" line-height="24pt" font-size="21pt">
        <xsl:value-of select="$name" />
      </fo:block>
      <fo:block>
        <fo:list-block provisional-distance-between-starts="0.2cm" provisional-label-separation="0.5cm" space-after="12pt" start-indent="1cm">  
          <xsl:apply-templates select="$docs" />
        </fo:list-block>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="doc">
    <xsl:variable name="path" select="concat('http://www.schenkerdocumentsonline.org/', str[@name='url'])"/>
    
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()"><fo:block>   </fo:block></fo:list-item-label>
      <fo:list-item-body>
        <fo:block>
          <fo:basic-link color="blue" external-destination="{$path}">
          <xsl:value-of select="str[@name='shelfmark']" />
          <xsl:text> </xsl:text>
          <fo:inline font-weight="bold">
            <xsl:choose>
              <xsl:when test="arr[@name='title']">
                <xsl:value-of select="arr[@name='title']/str" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Diary entry by Schenker for </xsl:text>
                <xsl:value-of select="format-date(xs:date(str[@name='dateShort']), '[D] [MNn] [Y]')" />
              </xsl:otherwise>
            </xsl:choose>
          </fo:inline>
        <xsl:if test="arr[@name='author'] and arr[@name='author_key'] = $filename"> [Author]</xsl:if>
          </fo:basic-link>
          <fo:inline font-size="6pt">
          <xsl:text> [</xsl:text><xsl:value-of select="$path"/><xsl:text>]</xsl:text>
        </fo:inline>  
      </fo:block>
           
      <xsl:if test="str[@name='description']">
        <fo:block>
          <xsl:value-of select="str[@name='description']" />
        </fo:block>
      </xsl:if>
      </fo:list-item-body>
      </fo:list-item>
  </xsl:template>
</xsl:stylesheet>
