<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Stylesheet for home page only.
      
      Yes, it's ugly to have all the HTML in here, but this was a hack to allow 
      the new homepage (June 2012) to use Kiln while the rest of SDO uses xMod
  -->


  <xsl:include href="cocoon://_internal/properties/properties.xsl"/>
  <xsl:import href="sdo-p5.xsl"/>

  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>
  <xsl:param name="menutop" select="'true'"/>
  <xsl:param name="print" select="'false'"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="printable"/>

  <xsl:variable name="xmg:title"
    select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]"/>
  <xsl:variable name="xmg:pathroot" select="concat($xmp:context-path, '/', $filedir)"/>
  <xsl:variable name="xmg:path"
    select="concat($xmg:pathroot, '/', substring-before($filename, '.'), '.', $fileextension)"/>


  <xsl:template match="/">
    <!--[if IE 7 ]>    <html class="no-js ie7" lang="en"> <![endif]-->
    <!--[if IE 8 ]>    <html class="no-js ie8" lang="en"> <![endif]-->
    <!--[if (gte IE 9)|!(IE)]><!-->

    <html lang="en" class="no-js">
      <!--<![endif]-->
      <head>
        <title>Schenker - Home</title>

        <!-- Google Analytics tracking code -->
        <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-40132787-1', 'schenkerdocumentsonline.org');
  ga('send', 'pageview');

</script>

        <!-- jquery from Google CDN -->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"/>

        <!-- jquery tools from Flowplayer CDN -->
        <script src="http://cdn.jquerytools.org/1.2.5/all/jquery.tools.min.js"/>

        <!-- mobile etc. devices: courtesy of 320+Up: http://stuffandnonsense.co.uk/projects/320andup/ -->
        <!-- For Nokia -->
        <link rel="shortcut icon" href="{$xmp:assets-path}/hp_assets/images/apple-touch-icon.png"/>
        <!-- For everything else -->
        <link rel="shortcut icon" href="{$xmp:assets-path}/hp_assets/images/favicon.ico"/>

        <!--iOS. Delete if not required -->
        <meta name="apple-mobile-web-app-capable" content="yes"/>
        <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/>
        <link rel="apple-touch-startup-image"
          href="{$xmp:assets-path}/hp_assets/images/i/splash.png"/>

        <!--Microsoft. Delete if not required -->
        <meta http-equiv="cleartype" content="on"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=IE6"/>
        <meta name="viewport" content="width=device-width,initial-scale=1"/>

        <link rel="stylesheet" type="text/css" href="{$xmp:assets-path}/hp_assets/styles/base.css"/>
        <link rel="stylesheet" type="text/css" href="{$xmp:assets-path}/hp_assets/styles/site.css"/>


        <!-- Modernizr: this should be called AFTER CSS to avoid FOUC
        For dev purposes use /_a/s/libs/modernizr-dev.js
      -->
        <script src="{$xmp:assets-path}/hp_assets/scripts/libs/modernizr-dev.js"/>
        <script src="{$xmp:assets-path}/hp_assets/scripts/config.js"/>



      </head>

      <body>
        <div class="hidden">
          <ul>
            <li>
              <a href="#contentSection">Skip to content</a>
            </li>
            <li>
              <a href="#localNavigation">Skip to local navigation</a>
            </li>
            <li>
              <a href="#mainNavigation">Skip to main navigation</a>
            </li>
          </ul>
        </div>

        <div class="wrapper">
          <header class="line headerSection">
            <div class="unit size1of1 lastUnit">
              <h1 class="headerLogo">Schenker Documents Online</h1>
              <div class="logoRight">
                <h2>Schenker Documents Online</h2>
              </div>
            </div>
          </header>
          <!-- end line -->
          <div class="line">
            <nav class="primary" id="mainNavigation">
              <ul class="inline">
                <li>
                  <a class="navLink first selected" href="/index.html">Home</a>
                </li>
                <li>
                  <a class="navLink" href="/project_information/project_aims.html">Project
                    Information</a>
                </li>
                <li>
                  <a class="navLink" href="/documents/browse.html">Browse Documents</a>
                </li>
                <li>
                  <a class="navLink" href="/search/">Search</a>
                </li>
                <li>
                  <a class="navLink" href="/colloquy/colloquy.html">Colloquy</a>
                </li>
                <li>
                  <a class="navLink" href="/editorial_guide/editorial_conventions.html">Editorial
                    Guide</a>
                </li>
                <li>
                  <a class="navLink" href="/profiles/index.html">Profiles</a>
                </li>
                <li>
                  <a class="navLink" href="/help/comment.html">Help</a>
                </li>
                <li>
                  <a class="navLink last" href="http://blog.schenkerdocumentsonline.org/">Blog</a>
                </li>

              </ul>
            </nav>
          </div>
          <!-- end line for navigation -->


          <div class="line contentSection">


            <div id="content">
              <div class="mod tabs">

                <ul class="tabControls tpc">
                  <li class="tabControlHeader">
                    <a href="#tab1" class="current">
                      <img src="{$xmp:assets-path}/hp_assets/images/thumb-letter.jpg" width="80"
                        height="80" alt="" title=""/>
                    </a>
                    <h4>Letter from Schenker to Otto Erich Deutsch, May 15, 1930 (OJ 5/9, [3])</h4>
                  </li>
                  <li class="tabControlHeader">
                    <a href="#tab2">
                      <img src="{$xmp:assets-path}/hp_assets/images/thumb-diary.jpg" width="80"
                        height="80" alt="" title=""/>
                    </a>

                    <h4>Page of Schenker's diary, late January and early February 1907</h4>
                  </li>
                  <li class="tabControlHeader">
                    <a href="#tab3">
                      <img src="{$xmp:assets-path}/hp_assets/images/thumb-lesson.jpg" width="80"
                        height="80" alt="" title=""/>
                    </a>
                    <h4>Page of Schenker's lessonbook for 1923/24</h4>
                  </li>
                </ul>
                <div class="tabPanes line">
                  <section id="tab1" class="tabPane">Letter <div class="tabTeaser">
                      <p>This single-page letter - a note rather than a letter, perhaps - offers
                        some opinions and analytical thoughts on materials that O.E. Deutsch had
                        sent him six weeks earlier.</p>
                      <p><a class="tabLink" href="/documents/overviews/correspondence_eg.html">See
                          more</a></p>
                    </div>
                  </section>
                  <section id="tab2" class="tabPane">Diary <div class="tabTeaser">
                      <p>This diary page, p. 33, includes a notorious passage: his outspoken
                        reaction to Schoenberg's first string quartet.</p>
                      <p><a class="tabLink" href="/documents/overviews/diaries_eg.html">See
                        more</a></p>
                    </div>
                  </section>
                  <section id="tab3" class="tabPane">Lessonbook <div class="tabTeaser">
                      <p>This is p. 14 of the 1923/24 lessonbook. It records part of the series of
                        lessons of Hans Weisse, covering April 1 to June 3, 1924.</p>
                      <p><a class="tabLink" href="/documents/overviews/lessonbooks_eg.html">See
                          more</a></p>
                    </div>
                  </section>
                </div>

              </div>
              <!-- mod tabs ends-->

              <div class="line bottomBoxes">
                <div class="unit size1of3">
                  <h3>Heinrich Schenker</h3>
                  <p>Viennese musician and teacher Heinrich Schenker (1868-1935), the twentieth
                    century's leading theorist of tonal music, produced a series of innovative
                    studies and editions between 1903 and 1935, while exerting a powerful and
                    sustained influence, directly and through his pupils, on the teaching of music
                    from the 1930s onward in the USA, and since the 1970s in Europe and
                    elsewhere.</p>
                  <p>Schenker maintained a vigorous correspondence over nearly half a century, kept
                    a meticulously detailed diary over 40 years, and recorded precise notes on
                    lessons that he gave over a period of twenty years. It is these three
                    collections of personal documents that constitute the core of <em>Schenker
                      Documents Online</em>.</p>
                  <!-- PREVIOUS VERSION <p>Viennese musician and teacher Heinrich Schenker (1868-1935), the twentieth
                    century's leading theorist of tonal music, produced a series of innovative
                    studies and editions between 1903 and 1935, while exerting a powerful and
                    sustained influence, directly and through his pupils, on the teaching of music
                    from the 1930s onward in the USA, and since the 1970s in Europe and elsewhere.
                    Today, Schenkerian theory and analysis constitutes a large and ever-growing
                    field of vital academic study, with its own body of scholars, journals, book
                    literature, institutions, and courses of instruction. (For a more detailed study
                    of Schenker's life and work, see "<a class="int" title="Link to Heinrich Schenker" href="/colloquy/heinrich_schenker.html"
                      >Heinrich Schenker</a>.")</p> -->


                </div>

                <div class="unit size1of3">
                  <h3>Schenker Documents and this Edition</h3>
                  <p>Schenker left behind approximately 130,000 manuscript and typescript leaves
                    comprising unpublished works, preparatory materials, and personal documents,
                    preserved in two dedicated archives, numerous libraries, and private possession.
                    (See "<a class="int" title="Link to Major Collections"
                      href="/colloquy/major_collections.html">Major Collections</a>.") The archived
                    papers of several other scholars, among them Guido Adler, Oswald Jonas, Moriz
                    Violin, and Arnold Schoenberg, also preserve correspondence and other documents
                    relating to Schenker and his circle.</p>
                  <p><em>Schenker Documents Online</em> offers a scholarly edition of this material
                    based not on facsimiles but on near-diplomatic transcriptions of the original
                    texts, together with English translations, explanatory footnotes, summaries, and
                    contextual material relating the texts to Schenker's personal development and
                    that of his correspondents.</p>

                </div>
                <div class="unit size1of3 lastUnit">
                  <h3>Latest</h3>
                  <!-- COPY AND PASTE LINK BELOW TO DIRECT USERS TO THE 'OVERFLOW' PAGE FOR UPDATE NEWS -->
                  <!-- <a class="int" title="Link to Latest Material"
                        href="/documents/overviews/latest_material.html">More</a> -->
                  <h4>What’s New? ‒ Diaries; Akademie, Hammer, Hoboken, Karpath, Universal
                    Edition</h4>
                  <ul>
                    <li>December brings a magnificent haul of new diary materials, including the
                      last eight months of Schenker's life, and material from 1912‒14 ‒ entries
                      concerning the Ninth Symphony monograph and beginning of the
                      Erlaäuterungsausgabe and other matters. For more on this, see <a class="int"
                        title="Link to Latest Material"
                        href="/documents/overviews/latest_material.html">the following</a>.</li>

                    <li>New correspondence includes all of that with Universal Edition for 1909.
                      It also includes correspondences with the Vienna Music Academy, Ludwig
                      Karpath, a new installment of Hoboken, and the first letters from Victor
                      Hammer. For more, see <a class="int" title="Link to Latest Material"
                        href="/documents/overviews/latest_material.html">the following</a>.</li>
                  </ul>

                  <nav class="local" id="blogPosts">
                    <h4>From the Blog</h4>
                    <ul>


                      <xsl:for-each select="/*/rss/channel/item[position() &lt;= 2]">
                        <li>
                          <a>
                            <xsl:attribute name="href">
                              <xsl:value-of select="./link"/>
                            </xsl:attribute>
                            <xsl:attribute name="class">
                              <xsl:if test="position() = 1">
                                <xsl:text>navLink first</xsl:text>
                              </xsl:if>
                              <xsl:if test="position() > 1">
                                <xsl:text>navLink</xsl:text>
                              </xsl:if>
                            </xsl:attribute>
                            <xsl:value-of select="./title"/>
                          </a>
                          <p>
                            <xsl:value-of select="substring-before(./description, ' &amp;#8230;')"/>
                            <xsl:text>&#8230;</xsl:text>
                            <a>
                              <xsl:attribute name="href">
                                <xsl:value-of select="./link"/>
                              </xsl:attribute> Continue reading → </a>
                          </p>
                        </li>
                      </xsl:for-each>

                      <!--
                      <li>
                        <a class="navLink first" href="#">SDO Hat Trick at SMA TAGS</a>
                        <p>The Schenker Documents Online project was well represented at the recent
                          Society for Music Analysis's Theory and Analysis Graduate Students (TAGS)
                          conference...</p>
                      </li>
                      <li>
                        <a class="navLink" href="#">Hofrat Heinrich Schenker ??</a>
                        <p>Under the Hapsburgs, public honors (Berufstitel) rewarded people for
                          distinguished service to the state...</p>
                      </li> -->

                      <li class="seeAll">
                        <a class="navLink" href="http://blog.schenkerdocumentsonline.org/">See all
                          &#x203A;&#x203A;</a>
                      </li>

                    </ul>
                  </nav>
                </div>
                <!-- end column right -->




              </div>
              <!-- end bottomBoxes -->






            </div>
            <!-- left content ends -->




          </div>
          <!-- end ContentSection -->

          <!-- logos -->

          <div class="line logos">
            <ul class="inline">
              <li>
                <a href="http://www.ahrc.ac.uk">
                  <img src="{$xmp:assets-path}/hp_assets/images/ahrc.png" width="169" height="40"
                    alt="ahrc logo" title=""/>
                </a>
              </li>
              <li>
                <a href="http://www.leverhulme.ac.uk/">
                  <img src="{$xmp:assets-path}/hp_assets/images/leverhulme.png" width="102"
                    height="60" alt="Leverhulme logo" title=""/>
                </a>
              </li>
              <li>
                <a href="http://www.kcl.ac.uk/ddh">
                  <img src="{$xmp:assets-path}/hp_assets/images/ddh.png"
                    alt="Department of Digital Humanities logo" title=""/>
                </a>
              </li>
              <li>
                <a href="http://ccnmtl.columbia.edu/">
                  <img src="{$xmp:assets-path}/hp_assets/images/columbia.png" width="122"
                    height="55" alt="Columbia logo" title=""/>
                </a>
              </li>
              <li>
                <a href="http://www.soton.ac.uk/">
                  <img src="{$xmp:assets-path}/hp_assets/images/southampton_logo.png" width="161"
                    height="40" alt="Southampton logo" title=""/>
                </a>
              </li>
            </ul>
          </div>
          <!-- end logos -->

          <footer class="line footerSection">
            <ul class="inline">
              <li>&#x00A9;&#x00A0;2012&#x00A0;Schenker Documents Online.</li>
              <li>In collaboration with the Department of Digital Humanities, King's College
                London.</li>
              <li class="s01">Powered by <a title="xMod home page"
                  href="http://www.cch.kcl.ac.uk/xmod/">
                  <span>xMod</span>
                </a>
              </li>
            </ul>
          </footer>
        </div>
        <!-- end wrapper -->


      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
