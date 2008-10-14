<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="//text"></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="text">
        
        
        <div>To use, cut and paste: 
            <ol>
                <li>Title goes into the MovableType Title field.</li>
                <li>
                    The text from the Body textarea below into the MovableType Entry body.</li>
                <li>Tags go into the Tags field.</li>
            </ol>
            
            
            
            <strong>N.B.</strong> Edits made here will <em>not</em> be saved!
            <br/><br/>        
        </div>
        
        <xsl:apply-templates select="body"/>
        
        
        <div style="background:#eeeeee;">Tags</div>
        <xsl:apply-templates select="index"/>
        
    </xsl:template>
    
    <xsl:template match="body">
        
        <div style="background:#eeeeee;">Title</div> 
        
        <xsl:apply-templates select="head"/>
            
         <div><br/><br/></div>
        
        <div style="background:#eeeeee;">Body</div>
        <br/>
        <form><textarea rows="20" cols="100"><xsl:apply-templates/></textarea></form>
    </xsl:template>
    
    <xsl:template match="emph"><em><xsl:apply-templates/></em></xsl:template>
    <xsl:template match="title"><em><xsl:apply-templates/></em></xsl:template>
    <xsl:template match="head"><strong><xsl:apply-templates/></strong></xsl:template>
    <xsl:template match="xref"><a><xsl:attribute name="href"><xsl:value-of select="@from"/></xsl:attribute><xsl:apply-templates/></a>  
    </xsl:template>
    <xsl:template match="p"><p><xsl:apply-templates/></p></xsl:template>
    <xsl:template match="index"><xsl:value-of select="@level1"/><xsl:text> , </xsl:text></xsl:template>
    
</xsl:stylesheet>
