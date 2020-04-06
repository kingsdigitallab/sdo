<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
    xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">
    
    <!-- Base stylesheet from http://wiki.tei-c.org/index.php/Cocoon_epub_Compiler-->
    

    <xsl:import href="to-print.xsl" />
    
    <xsl:param name="filedir" />
    <xsl:param name="filename" />
    <xsl:param name="fileextension" />
    <xsl:param name="all" />
    
    <xsl:variable name="entity-key" select="substring-before($filename, '.')" />
    <!--
    <xsl:variable name="correspondence" select="/aggregation/response/result/doc[str[@name='kind']='correspondence']" />
    <xsl:variable name="diaries" select="/aggregation/response/result/doc[str[@name='kind']='diaries']" />
    <xsl:variable name="lessonbooks" select="/aggregation/response/result/doc[str[@name='kind']='lessonbooks']" />
    <xsl:variable name="other" select="/aggregation/response/result/doc[str[@name='kind']='other']" />
    -->
    <xsl:param name="lang" />
    
    <xsl:variable name="record">    
        <xsl:choose>
            <xsl:when test="/aggregation/tei:TEI">
                <xsl:value-of select="/aggregation/tei:TEI/tei:text" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/aggregation/eats/entities/entity[keys/key = $entity-key]" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="title">
        <xsl:choose>
            <xsl:when test="/*/tei:TEI">
                <xsl:value-of select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
            </xsl:when>
            <xsl:when test="/*/eats/entities/entity[keys/key = $entity-key]/names/name">
                <xsl:value-of select="/*/eats/entities/entity[keys/key = $entity-key]/names/name[1]" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$xmg:title" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!--
    <xsl:variable name="webpage">
        <xsl:copy-of select="/aggregation/child::*[name() = 'html']"/>
    </xsl:variable>
    -->
    <xsl:variable name="webpage">       
        <xsl:value-of select="$filedir" />/<xsl:value-of select="$filename" /><xsl:text>.html?type=epub</xsl:text>
    </xsl:variable>
    
    <!-- KFL - This whole bit isn't working as expected as the supporting documents are always being included but if this gets fixed so epubs are generated without the supporting docs then need to fix the *-to-print.xsl files so that links are created to docs that don't exist -->
    <xsl:variable name="include">
        <xsl:choose>
            <xsl:when test="$all = 'false'"><xsl:value-of select="false()"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="true()"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- generate ePub structure -->
  
  <xsl:template match="/">

    <!-- <xsl:variable name="chapters" select=""/> -->

      
      <zip:archive>
          <!-- this needs to be first in the archive -->
          
 <!-- MIMETYPE -->
          <zip:entry name="mimetype" src="../../stylesheets/local/mobile/documents/mimetype" method="stored" />
          
          <!-- Metadata / intro page
              <zip:entry name=".html" 
              src="" /> -->
          
          
<!-- RECORDS -->
          
          <xsl:for-each select="$record">             
              <!-- texts -->
                 <zip:entry name="OEBPS/Text/{$filename}.html" src="cocoon://{$webpage}" />           
          </xsl:for-each>
          <!--
          <xsl:if test="$include">
          <xsl:for-each select="/aggregation/response/result/doc">
              <xsl:variable name="supporting-doc"><xsl:value-of select="$xmp:context-path"/><xsl:text>/mobile/</xsl:text><xsl:value-of select="arr[@name='url']/str"/><xsl:text>?type=epub</xsl:text></xsl:variable>
              
              <zip:entry name="OEBPS/Text/{arr[@name='url']/str}.html" src="cocoon://{$supporting-doc}" /> 
          </xsl:for-each> 
          </xsl:if>-->
          
<!-- STYLESHEETS -->
          <zip:entry name="OEBPS/Style/default.css" src="../../_a/c/default.css" />
          <zip:entry name="OEBPS/Style/personality.css" src="../../_a/c/personality.css" />

<!-- IMAGES -->
          
          <xsl:for-each select="/aggregation/tei:TEI//tei:graphic[not(@xmt:type='thumb-caption')]">   
              <xsl:variable name="image_full" select="concat('../../', $xmp:images-path, '/local/full/', @url)"/>
              <xsl:variable name="image_thumb" select="concat('../../', $xmp:images-path, '/local/thumb/thm_', @url)"/>
              <!-- texts -->
              <zip:entry name="OEBPS/Image/full/{@url}" src="{$image_full}" />       
              <zip:entry name="OEBPS/Image/thumb/thm_{@url}" src="{$image_thumb}" /> 
          </xsl:for-each> 
          
<!-- CONTAINER.XML -->
          <zip:entry name="META-INF/container.xml" src="../../stylesheets/local/mobile/documents/container.xml" />
<!--          <zip:entry name="META-INF/container.xml" serializer="xml">
<xsl:text>  
</xsl:text><container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container"><xsl:text>
    </xsl:text><rootfiles><xsl:text>
        </xsl:text><rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml" /><xsl:text>
    </xsl:text></rootfiles><xsl:text>
</xsl:text></container>
</zip:entry>
-->
          
          
<!-- CONTENT.OPF -->
          <zip:entry name="OEBPS/content.opf" serializer="xml">
              <xsl:text>                 
</xsl:text><ns2:package xmlns:ns2="http://www.idpf.org/2007/opf" unique-identifier="BookID" version="2.0"><xsl:text>
</xsl:text><ns2:metadata xmlns:dcterms="http://purl.org/dc/terms/"
                      xmlns:dc="http://purl.org/dc/elements/1.1/"
                      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xmlns:opf="http://www.idpf.org/2007/opf"><xsl:text>
                      </xsl:text><dc:title><xsl:text>Profile: </xsl:text><xsl:value-of select="$title"/></dc:title>
                      <xsl:text>                            
                      </xsl:text><dc:language xsi:type="dcterms:RFC3066">en</dc:language>
<xsl:text>
                      </xsl:text><dc:identifier id="BookID" opf:scheme="URI">urn:uuid:<xsl:value-of select="$filename"></xsl:value-of></dc:identifier>
                      <!-- <xsl:for-each select="//tei:textClass/tei:keywords//tei:rs">
                          <dc:subject><xsl:value-of select="normalize-space(.)"/></dc:subject>
                          </xsl:for-each> -->
                      
                      <!--<dc:description>A guide for making Epub ebooks/publications.</dc:description>-->
                      <!--<dc:relation>http://www.hxa.name/</dc:relation>-->
                      
                      
                      <!--
                          <xsl:for-each select="//tei:author/">
                          <xsl:variable name="author" select="." />
                          <xsl:if test="not(preceding::*[author = $entity])">
                          
                          <dc:creator><xsl:value-of select="."/></dc:creator>
                          </xsl:if>
                          </xsl:for-each>
                      -->
                      <!--   
                          <xsl:for-each select="//tei:author[generate-id() = generate-id(key('authors',normalize-space(.))[1])]">
                          <dc:creator><xsl:value-of select="normalize-space(.)"/></dc:creator>
                          </xsl:for-each>
                      -->
<xsl:text>
        </xsl:text><dc:publisher>Schenker Documents Online</dc:publisher><xsl:text>
        </xsl:text><dc:date xsi:type="dcterms:W3CDTF"><xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')" /></dc:date><xsl:text>
    </xsl:text>
                      <!-- <dc:rights>Creative Commons</dc:rights> -->
                  </ns2:metadata>
<xsl:text>
    </xsl:text><ns2:manifest>
                      <!-- Fixed items -->
        <xsl:text>
        </xsl:text><ns2:item id="default.css" href="Style/default.css" media-type="text/css" />
        <xsl:text>
        </xsl:text><ns2:item id="personality.css" href="Style/personality.css" media-type="text/css" />                     
                      
                      <!-- this includes both figures and texts -->
                      <xsl:for-each select="$record">
                          <!-- texts -->
<xsl:text>
        </xsl:text><ns2:item id="{$filename}" href="Text/{$filename}.html" media-type="application/xhtml+xml" />
                      </xsl:for-each>
        
        <xsl:if test="$include">
        <xsl:for-each select="/aggregation/response/result/doc">           
<xsl:text>
        </xsl:text><ns2:item id="{str[@name='fileId']}" href="Text/{str[@name='fileId']}.html" media-type="application/xhtml+xml" /> 
        </xsl:for-each>
        </xsl:if>    
                      
<xsl:text>
        </xsl:text><ns2:item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml" />

<xsl:text>
    </xsl:text></ns2:manifest>

    <xsl:text>
    </xsl:text><ns2:spine toc="ncx">
                      <!-- this includes both figures and texts -->
                      <xsl:for-each select="$record">
                          <!-- texts -->
                          <xsl:text>
        </xsl:text><ns2:itemref idref="{$filename}" />
                      </xsl:for-each>
        
        <xsl:if test="$include">
        <xsl:for-each select="/aggregation/response/result/doc">           
            <xsl:text>
        </xsl:text><ns2:itemref idref="{str[@name='fileId']}" /> 
        </xsl:for-each>
        </xsl:if>    
        
        <xsl:text>
    </xsl:text></ns2:spine>
                  
    <xsl:text>
    </xsl:text><ns2:guide>
                      
                      <!-- this includes both figures and texts -->
                      <xsl:for-each select="$record">
                          <!-- texts -->
                          <xsl:text>
        </xsl:text><ns2:reference type="text" title="{$title}" href="Text/{$filename}.html" />
                      </xsl:for-each>
        
        <xsl:if test="$include">
        <xsl:for-each select="/aggregation/response/result/doc">           
            <xsl:text>
        </xsl:text><ns2:reference type="text" title="{normalize-space(str[@name='title'])}" href="Text/{str[@name='fileId']}.html" /> 
        </xsl:for-each>
        </xsl:if>    
 
        <xsl:text>
    </xsl:text></ns2:guide>
    <xsl:text>
</xsl:text></ns2:package>
          </zip:entry>
          
          
<!-- TOC.NCX -->
          <zip:entry name="OEBPS/toc.ncx"  serializer="xml" xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">

<xsl:text>

</xsl:text><ncx:ncx version="2005-1">
                              
    <xsl:text>
    </xsl:text><ncx:head>
        <xsl:text>
        </xsl:text><ncx:meta name="dtb:uid" content="http://www.schenkerdocumentsonline.org/{replace($filedir, 'mobile', 'documents')}/{$filename}.html"/>
        <xsl:text>
        </xsl:text><ncx:meta name="dtb:depth" content="2"/>
        <xsl:text>
        </xsl:text><ncx:meta name="dtb:totalPageCount" content="0"/>
        <xsl:text>
        </xsl:text><ncx:meta name="dtb:maxPageNumber" content="0"/>
        <xsl:text>
    </xsl:text></ncx:head>
              
    <xsl:text>
    </xsl:text><ncx:docTitle>
        <xsl:text>
        </xsl:text><ncx:text><xsl:value-of select="normalize-space($title)"/></ncx:text>
        <xsl:text>
    </xsl:text></ncx:docTitle>
              
    <xsl:text>
    </xsl:text><ncx:navMap>
                  <!-- 
                  <navPoint id="navPoint-1" playOrder="1">
                      <navLabel>
                          <text><xsl:value-of select="$record/sdo:itemDesc/dc:title" /></text>
                      </navLabel>
                      <content src="{$filename}.html"/>
                  </navPoint>
                  -->
                  
                  <xsl:for-each select="$record">
                      <xsl:text>
        </xsl:text><ncx:navPoint id="navPoint-{@ID}" playOrder="{position()}">
            <xsl:text>
            </xsl:text><ncx:navLabel>
                <xsl:text>
                </xsl:text><ncx:text><xsl:value-of select="normalize-space($title)" /></ncx:text>
                <xsl:text>
            </xsl:text></ncx:navLabel>
            <xsl:text>
            </xsl:text><ncx:content src="Text/{$filename}.html"/>
            <xsl:text>
        </xsl:text></ncx:navPoint>
                  </xsl:for-each>
        <xsl:text>
    </xsl:text></ncx:navMap>
    <xsl:text>
</xsl:text></ncx:ncx>   
          </zip:entry>
          
      </zip:archive>       

  </xsl:template>
    
 
    </xsl:stylesheet>
