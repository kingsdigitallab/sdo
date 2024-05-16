<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:sdo="http://www.cch.kcl.ac.uk/schenker"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
    xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">
    
   <xsl:param name="filename" />
   <xsl:param name="filedir" />
    <xsl:param name="qualifier" />
    <xsl:param name="lang" />
  
  <xsl:template match="/">
      
      <zip:archive>
          
          <xsl:choose>
              <xsl:when test="$lang">
                  <!-- Profile PDF -->         
                  <zip:entry name="{$filename}_{$lang}.pdf" src="cocoon://{$filedir}/{$filename}:{$qualifier}.pdf?lang={$lang}" />                  
                  <!-- Accompanying PDFs -->
                  
                  <xsl:for-each select="/response/result/doc">
                    <xsl:variable name="path">
                        <xsl:value-of select="replace(str[@name = 'file'], 'documents', 'mobile')" />
                    </xsl:variable>  
                    <zip:entry name="{$filename}_{$lang}.pdf" src="cocoon://{$path}:{$qualifier}.pdf?lang={$lang}" />
                   </xsl:for-each>   
              </xsl:when>
              <xsl:otherwise>
                  <!-- Profile PDF -->          
                  <zip:entry name="{$filename}.pdf" src="cocoon://{$filedir}/{$filename}:{$qualifier}.pdf" />                  
                  <!-- Accompanying PDFs -->
                  
                  <xsl:for-each select="/response/result/doc">
                      <xsl:variable name="path">
                          <xsl:value-of select="replace(str[@name = 'file'], 'documents', 'mobile')" />
                      </xsl:variable>  
                      <zip:entry name="{str[@name = 'fileId']}.pdf" src="cocoon://{$path}:{$qualifier}.pdf" />
                      <!--<zip:entry name="{replace($path, '/', '_')}" src="../../stylesheets/local/mobile/documents/mimetype" method="stored" /> -->
                  </xsl:for-each> 
              </xsl:otherwise>
          </xsl:choose>
          

          
      </zip:archive>       

  </xsl:template>
    
 
    </xsl:stylesheet>