<?xml version="1.0"?>
<!--  $Id$ -->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- This file overrides TEI P5 templates -->
  
  
  <xsl:template match="tei:lb" priority="1">
    <br/>
    </xsl:template>
  
  <xsl:template match="tei:divGen" priority="1">
  <xsl:if test="@xml:id='contact'">
           
        
        <form action="http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl" method="POST" name="sdo_c">
          <input name="script" type="hidden" value="sdo_c" />
          <p class="content">
            Full Name<br/>
           <input  id="fullname" name="fullname" type="text" />
          
           <br/>
            Institution<br/>
                      <input  id="institution" name="institution" type="text" />
           <br/>
            Email Address<br/>
                      <input id="email" name="email" type="text" />
           <br/>
             
             Your Comments<br/>
                  <textarea id="comments" name="comments" rows="6" cols="60">&#160;</textarea>
              
             <br/>
             </p>
                 <p class="content">
                   <input type="text" value="" name="subtotal" class="fs" />
                   
                   <input type="submit" value="Submit" name="B1"  /><xsl:text>  </xsl:text>
                   <input type="reset" value="Reset" name="B2" />
                   
                  </p>
               
        
        </form>
       
   
  </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="tei:listBibl" priority="1">
    <div class="unorderedList">
     <div class="t01">
    <ul>
      <xsl:apply-templates/>
    </ul>
    </div>
    </div>
  </xsl:template>
  
  
  
  <xsl:template match="tei:author" priority="1">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:title" priority="1">
    
    <xsl:choose>
      <xsl:when test="@level = 'j' or level='m'">
        <em>
            <xsl:apply-templates/>
        </em>
     </xsl:when>
    <xsl:when test="@level ='a'">
      <xsl:text>"</xsl:text><xsl:apply-templates/><xsl:text>"</xsl:text>
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
