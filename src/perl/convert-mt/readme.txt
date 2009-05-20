========== 6 June 2008 =========

These files are a *first* attempt to map the Movable Type content model  as represented by their export feature to an XML format.
The files are not at this stage well-formed, nor are they entirely semantically meaningful.

The data has been modified from the original MovableType output in in the following ways:

1. They were split into three pieces: mtdocs-1880-1912.txt mtdocs-1913-1951.txt and mtdocs-2005-2008.txt.  This was done to facilitate error checking in the output.
2. Minor hand editing was done on a piece-by-piece basis to correct errors in the source file, again to facilitate error checking into output.  Examples of such editing include:

    * editing ill-nested <u> and <i> tags
    * closing ill-formed tags, including: <u> <dcterms:provenance>, <a>, <i>, <dc:description>, <b>, <dcterms:license>
    * switching  the use of '-' to '='; because the '-' is meaningful to MovableType output. 
    * earch and replaced 'DATE': to 'NEWDATE' - for some reason I was having trouble matching this string with perl regular expressions. 

During the conversion, the following provisional mappings were made:

 ++ Structural markup
   AUTHOR: ianbent       = <record><dc:source>Movable Type Export<\/dc:source>
   TITLE:                       = <dc:title>[VALUE]<\/dc:title>
   PRIMARY CATEGORY:  = <dc:subject>primary cat: [VALUE]<\/dc:subject>
   CATEGORY:                = <dc:subject>cat: [VALUE]<\/dc:subject
   NEWDATE:                 = <dc:date>[VALUE]<\/dc:date
   BODY:                       = <tei:transcription>
   EXTENDED BODY       = <tei:translation>
   EXCERPT:                  = <notes>
   *FOOTNOTES:*          = <!-- FOOTNOTES -->
   *COMMENTARY:*       = <!-- COMMENTARY -->
   *SUMMARY:*              = <!-- SUMMARY -->
   *Sender address:*     = <dc:contributor>sender: [VALUE]<\/dc:contributor>
   *Recipient address:*  = <dc:contributor>recipient: [VALUE]<\/dc:contributor>
   *Format:*                  = <dc:format>[VALUE]<\/dc:format>
   ©                              = <dc:rights>© [VALUE]<\/dc:rights
   fn1.                           = <tei:note n="fn1.">[VALUE]<\/tei:note>
   KEYWORDS:                = <dc:subject>

 ++ Inline markup
   <u>                           = <!-- was: u elem in MT --><tei:hi rend="underline">
   <em>                        = <!-- was: em elem in MT --><tei:hi rend="italic"
   <i>                            = <!-- was: i elem in MT --><tei:hi rend="italic"
   <strong>                    = <tei:hi rend="bold">
   <a href>                     = <!-- was: a elem in MT --><tei:ref target>
   

 ++ Tags with no clear equivalent were removed
   <small>                       = <!-- start: small elem in MT --
   <big>                          = <!-- start: big elem in MT --
  
++ XML entities
   &                                  = &amp\;

++ Record boundaries
   -----                            = removed.
   --------                       = record boundary
   
   
==== Some other things to note:

* There are multiple uses of the u tag (html underline), both for titles (title)  and for emphasis (hi) and variants between use in transcription and apparatus.  All are <hi rend="underline">
* em has been converted to <hi rend="italic"> since this is how browsers normally render this tag.
* there are differences in how sections are called (e.g. *FOOTNOTES:* and *FOOTNOTES*).  Catching these will require smarter regular expressions.
* there is some use of p tag, not well formed.