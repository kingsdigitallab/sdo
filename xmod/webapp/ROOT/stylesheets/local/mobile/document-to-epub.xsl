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

    <xsl:param name="lang" />
    <xsl:param name="filedir" select="'documents/'"/>
    <xsl:param name="recordId" />
    
    <xsl:variable name="record" select="/aggregation/sdo:recordCollection/sdo:record[1]"/>
    <xsl:variable name="fileName" select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/*[1]/@sdoID"/>
    <xsl:variable name="fileIdentifier" select="/aggregation/sdo:recordCollection/sdo:collectionDesc/sdo:source/*/@sdoID"/>
    <xsl:variable name="fileId">
        <xsl:value-of select="$fileName" /><xsl:if test="$recordId"><xsl:text>-</xsl:text><xsl:value-of select="$recordId"/></xsl:if>
    </xsl:variable>
    
    <!--
    <xsl:variable name="webpage">
        <xsl:copy-of select="/aggregation/child::*[name() = 'html']"/>
    </xsl:variable>
    -->
<!-- 
    <xsl:variable name="webpage">       
        <xsl:choose>
            <xsl:when test="$lang"><xsl:value-of select="replace($filedir, 'documents', 'mobile')" /><xsl:text>/</xsl:text><xsl:value-of select="$fileName" /><xsl:text>.html?type=epub&amp;lang=</xsl:text><xsl:value-of select="$lang" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="replace($filedir, 'documents', 'mobile')" /><xsl:text>/</xsl:text><xsl:value-of select="$fileName" /><xsl:text>.html?type=epub</xsl:text></xsl:otherwise>
        </xsl:choose>  
    </xsl:variable>
-->
   
    <xsl:variable name="webpage">       
        <xsl:choose>
            <xsl:when test="$lang"><xsl:value-of select="replace($filedir, 'documents', 'mobile')" /><xsl:text>/</xsl:text><xsl:value-of select="$fileName" /><xsl:if test="$recordId"><xsl:text>/</xsl:text><xsl:value-of select="$recordId"/></xsl:if><xsl:text>.html?type=epub&amp;lang=</xsl:text><xsl:value-of select="$lang" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="replace($filedir, 'documents', 'mobile')" /><xsl:text>/</xsl:text><xsl:value-of select="$fileName" /><xsl:if test="$recordId"><xsl:text>/</xsl:text><xsl:value-of select="$recordId"/></xsl:if><xsl:text>.html?type=epub</xsl:text></xsl:otherwise>
        </xsl:choose>  
    </xsl:variable>

    <!-- generate ePub structure -->
  
  <xsl:template match="/">

    <!-- <xsl:variable name="chapters" select=""/> -->

    <!-- Remove macrons from document titles for interoperability -->
    <xsl:variable name="accented">ĀĒĪŌŪāēīōū </xsl:variable>
    <xsl:variable name="unaccented">AEIOUaeiou </xsl:variable>
      
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
                 <zip:entry name="OEBPS/Text/{$fileId}.html" src="cocoon://{$webpage}" />           
          </xsl:for-each>
          
          
<!-- STYLESHEETS -->
          <zip:entry name="OEBPS/Style/default.css" src="../../_a/c/default.css" />
          <zip:entry name="OEBPS/Style/personality.css" src="../../_a/c/personality.css" />
 
<!-- IMAGES -->
          
          <xsl:for-each select="$record//tei:graphic[not(@xmt:type='thumb-caption')]">   
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
                      </xsl:text><dc:title><xsl:value-of select="normalize-space($record/sdo:itemDesc/dc:title)"/></dc:title>
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'"><xsl:text>
                      </xsl:text><dc:language xsi:type="dcterms:RFC3066"><xsl:value-of select="$lang" /></dc:language></xsl:when>
                        <xsl:otherwise><xsl:text>
                      </xsl:text><dc:language xsi:type="dcterms:RFC3066">de</dc:language><xsl:text>                            
                      </xsl:text><dc:language xsi:type="dcterms:RFC3066">en</dc:language></xsl:otherwise>
                    </xsl:choose>
    
<xsl:text>
                      </xsl:text><dc:identifier id="BookID" opf:scheme="URI">urn:uuid:<xsl:value-of select="$fileIdentifier"></xsl:value-of></dc:identifier>
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
        </xsl:text><ns2:item id="{$fileId}" href="Text/{$fileId}.html" media-type="application/xhtml+xml" />
                      </xsl:for-each>
                      
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
        </xsl:text><ns2:itemref idref="{$fileId}" />
                      </xsl:for-each>
        <xsl:text>
    </xsl:text></ns2:spine>
                  
    <xsl:text>
    </xsl:text><ns2:guide>
                      
                      <!-- this includes both figures and texts -->
                      <xsl:for-each select="$record">
                          <!-- texts -->
                          <xsl:text>
        </xsl:text><ns2:reference type="text" title="{normalize-space($record/sdo:itemDesc/dc:title)}" href="Text/{$fileId}.html" />
                      </xsl:for-each>
                      
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
        </xsl:text><ncx:meta name="dtb:uid" content="http://www.schenkerdocumentsonline.org/{replace($filedir, 'mobile', 'documents')}/{$fileId}.html"/>
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
        </xsl:text><ncx:text><xsl:value-of select="translate(normalize-space($record/sdo:itemDesc/dc:title),$accented,$unaccented)"/></ncx:text>
        <xsl:text>
    </xsl:text></ncx:docTitle>
              
    <xsl:text>
    </xsl:text><ncx:navMap>
                  <!-- 
                  <navPoint id="navPoint-1" playOrder="1">
                      <navLabel>
                          <text><xsl:value-of select="$record/sdo:itemDesc/dc:title" /></text>
                      </navLabel>
                      <content src="{$fileId}.html"/>
                  </navPoint>
                  -->
                  
                  <xsl:for-each select="$record">
                      <xsl:text>
        </xsl:text><ncx:navPoint id="navPoint-{@ID}" playOrder="{position()}">
            <xsl:text>
            </xsl:text><ncx:navLabel>
                <xsl:text>
                </xsl:text><ncx:text><xsl:value-of select="$record/sdo:itemDesc/dc:title" /></ncx:text>
                <xsl:text>
            </xsl:text></ncx:navLabel>
            <xsl:text>
            </xsl:text><ncx:content src="Text/{$fileId}.html"/>
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