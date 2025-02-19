<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
  xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../default.xsl"/>

  <xsl:param name="menutop" select="'true'"/>

  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>
  <xsl:param name="type"/>

  <xsl:variable name="entity-key" select="substring-before($filename, '.')"/>
  <xsl:variable name="referring_string">
    <xsl:choose>
      <xsl:when test="$type='person'">person</xsl:when>
      <xsl:otherwise>entity</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- the prefix "WSLB" needs to be mapped to the collection identifier WSLB-Mus -->
  <xsl:variable name="filePrefix">
    <xsl:choose>
      <xsl:when
        test="/aggregation/response/result/doc[arr[@name=$type]/str=$entity-key][1]/str[@name='filePrefix'] = 'WSLB'"
        >WSLB-Mus</xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="/aggregation/response/result/doc[arr[@name=$type]/str=$entity-key][1]/str[@name='filePrefix']"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="correspondence"
    select="/aggregation/response/result/doc[str[@name='kind']='correspondence']"/>
  <xsl:variable name="diaries"
    select="/aggregation/response/result/doc[str[@name='kind']='diaries']"/>
  <xsl:variable name="lessonbooks"
    select="/aggregation/response/result/doc[str[@name='kind']='lessonbooks']"/>
  <xsl:variable name="other" select="/aggregation/response/result/doc[str[@name='kind']='other']"/>
  <xsl:variable name="repository"
    select="/aggregation/response/result/doc[str[@name='filePrefix']=$filePrefix][1]/arr[@name='repository']/str[1]"/>
  <xsl:variable name="collection"
    select="/aggregation/response/result/doc[str[@name='filePrefix']=$filePrefix][1]/arr[@name='collection']/str[1]"/>
  <!-- <xsl:variable name="mixed" select="/aggregation/response/result/doc[str[@name='kind']='mixed']" /> -->


<!-- get the element containing all the repository/collection descriptions -->
  <xsl:variable name="loc">
    <xsl:if test="doc-available('../../../xml/content/colloquy/major_collections.xml')">
      <xsl:copy-of
        select="document('../../../xml/content/colloquy/major_collections.xml')//tei:text"/>
    </xsl:if>
  </xsl:variable>

<!-- a repository <div> might contain several collection <div>s, otherwise it's the same as the collection <div> -->
  <xsl:variable name="repos-node">
    <xsl:choose>
      <xsl:when test="$loc//tei:div[@xml:id = $filePrefix]/parent::tei:div[@xml:id]">
        <!--<xsl:copy-of select="$loc//tei:div[@xml:id = $filePrefix]/.."/>-->
        <xsl:copy-of select="$loc//tei:div[child::tei:div[@xml:id = $filePrefix]]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$loc//tei:div[@xml:id = $filePrefix]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <h1>
          <xsl:choose>
            <xsl:when test="$type = 'collection' or $type = 'repository'">
              <xsl:if test="$type = 'repository'">
                <a>
                  <xsl:attribute name="name">
                    <xsl:value-of select="$filePrefix"/>
                  </xsl:attribute>
                </a>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="contains($repos-node/tei:div/tei:head, ':')">
                  <xsl:value-of
                    select="normalize-space(substring-after($repos-node/tei:div/tei:head, ':'))"/>
                </xsl:when>
                <xsl:when test="$repos-node/tei:div/tei:head">
                  <xsl:value-of select="$repos-node/tei:div/tei:head"/>
                </xsl:when>
                <xsl:when test="$type = 'collection'">
                  <xsl:value-of select="replace($collection, '_', ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="replace($repository, '_', ' ')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="/*/tei:TEI">
              <xsl:value-of
                select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]"/>
            </xsl:when>
            <xsl:when test="/*/eats/entities/entity[keys/key = $entity-key]/names/name">
              <xsl:value-of select="/*/eats/entities/entity[keys/key = $entity-key]/names/name[1]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$xmg:title"/>
            </xsl:otherwise>
          </xsl:choose>
        </h1>


        <xsl:choose>
          <xsl:when test="$type = 'collection' or $type = 'repository'">
            <xsl:if test="contains($repos-node/tei:div/tei:head, ':')">
              <xsl:value-of
                select="normalize-space(substring-before($repos-node/tei:div/tei:head, ':'))"/>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>

            <xsl:if
              test="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']">
              <h2>
                <xsl:apply-templates mode="pagehead"
                  select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub']"
                />
              </h2>
            </xsl:if>

            <xsl:variable name="authors-and-editors"
              select="/*/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:*[self::tei:author or self::tei:editor]"/>
            <xsl:if test="$authors-and-editors">
              <p>
                <xsl:text>(</xsl:text>
                <xsl:apply-templates mode="pagehead" select="$authors-and-editors"/>
                <xsl:text>)</xsl:text>
              </p>
            </xsl:if>

          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:toc1"/>

  <xsl:template name="xms:content">
    <xsl:choose>
      <xsl:when test="/aggregation/response/result/doc">
        <p>Documents associated with this <xsl:value-of select="$referring_string"/>:</p>

        <ul>
          <xsl:if test="$correspondence">
            <li>
              <a href="#correspondence">Correspondence</a>
            </li>
          </xsl:if>
          <xsl:if test="$diaries">
            <li>
              <a href="#diaries">Diaries</a>
            </li>
          </xsl:if>
          <xsl:if test="$lessonbooks">
            <li>
              <a href="#lessonbooks">Lessonbooks</a>
            </li>
          </xsl:if>
          <!--         <xsl:if test="$mixed">
            <li>
              <a href="#mixed">Mixed material</a>
            </li>
          </xsl:if>   -->
          <xsl:if test="$other">
            <li>
              <a href="#other">Other material</a>
            </li>
          </xsl:if>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <p>There are no documents associated with this <xsl:value-of select="$referring_string"/>.</p>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$type = 'repository'">
        <xsl:for-each select="$repos-node//tei:div">

          <xsl:if test="not(./tei:head = $repos-node/tei:div/tei:head)">
            <h2>
              <a>
                <xsl:attribute name="name">
                  <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
              </a>
              <xsl:apply-templates select="tei:head"/>
            </h2>
          </xsl:if>
          <xsl:apply-templates select="tei:p"/>
          <xsl:apply-templates select="tei:listBibl"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$type = 'collection'">
        <xsl:for-each select="$repos-node//tei:div[@xml:id = $filePrefix]">

          <xsl:if test="not(./tei:head = $repos-node/tei:div/tei:head)">
            <h2>
              <a>
                <xsl:attribute name="name">
                  <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
              </a>
              <xsl:apply-templates select="tei:head"/>
            </h2>
          </xsl:if>
          <xsl:apply-templates select="tei:p"/>
          <xsl:apply-templates select="tei:listBibl"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="/aggregation/tei:TEI">
        <xsl:apply-templates select="/aggregation/tei:TEI"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="entity-from-eats"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="/aggregation/response/result/doc">
      <div>
        <form action="/mobile/docs.zip" method="get" id="dlDocForm" onsubmit="return validate()">
          <!-- KFL - it would look nicer if this was replaced by side menu options (see default.xsl) when script was enabled and this is the no-script option -->
          
          <p>Downloads temporarily removed for testing purposes</p>
          <!-- COMMENTED OUT BY PC , 19 NOV 2024, TO SEE IF THESE DOWNLOAD FUNCTIONS WERE THE CAUSE OF INSTABILITY ISSUES, POSSIBLY BY BEING HIT REPEATEDLY BY BOTS
              
            <p>Download all selected files as <input type="submit" name="format" value="pdf"/> or
              <input type="submit" name="format" value="epub"/> or <input type="submit"
              name="format" value="both"/> (check files to select/deselect)<br/>Where appropriate
            save: <input type="radio" name="lang" value="all" checked="checked"/> English and German
            versions <input type="radio" name="lang" value="de"/> German version only <input
              type="radio" name="lang" value="en"/> English version only </p>-->
          <!-- <noscript> </noscript>-->
          <xsl:call-template name="make-section">
            <xsl:with-param name="name" select="'Correspondence'"/>
            <xsl:with-param name="id" select="'correspondence'"/>
            <xsl:with-param name="docs" select="$correspondence"/>
          </xsl:call-template>
          <xsl:call-template name="make-section">
            <xsl:with-param name="name" select="'Diaries'"/>
            <xsl:with-param name="id" select="'diaries'"/>
            <xsl:with-param name="docs" select="$diaries"/>
          </xsl:call-template>
          <xsl:call-template name="make-section">
            <xsl:with-param name="name" select="'Lessonbooks'"/>
            <xsl:with-param name="id" select="'lessonbooks'"/>
            <xsl:with-param name="docs" select="$lessonbooks"/>
          </xsl:call-template>
          <!--   <xsl:call-template name="make-section">
            <xsl:with-param name="name" select="'Mixed material'" />
            <xsl:with-param name="id" select="'mixed'" />
            <xsl:with-param name="docs" select="$mixed" />
          </xsl:call-template>    -->
          <xsl:call-template name="make-section">
            <xsl:with-param name="name" select="'Other material'"/>
            <xsl:with-param name="id" select="'other'"/>
            <xsl:with-param name="docs" select="$other"/>
          </xsl:call-template>
        </form>
      </div>

    </xsl:if>
  </xsl:template>

  <xsl:template name="entity-from-eats">
    <xsl:for-each select="/*/eats/entities/entity[keys/key = $entity-key]">
      <xsl:variable name="entity-name" select="names/name[1]"/>
      <div class="accordion2">
        <h3>Types</h3>
        <div>
          <p>
            <xsl:for-each select="types/type">
              <xsl:value-of select="."/>

              <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:for-each>
          </p>
        </div>

        <h3>Names</h3>
        <div>
          <div class="unorderedList">
            <div class="t01">
              <ul>
                <xsl:for-each select="names/name">
                  <li>
                    <xsl:value-of select="."/>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </div>
        </div>

        <h3>Relationships</h3>
        <div>
          <div class="unorderedList">
            <div class="t01">
              <ul>
                <xsl:for-each select="relationships/relationship[@direction = 'direct']">
                  <xsl:variable name="rel-entity-key" select="keys/key[1]"/>
                  <xsl:variable name="rel-entity-type"
                    select="/*/eats/entities/entity[keys/key = $rel-entity-key]/types/type[1]"/>

                  <li>
                    <xsl:value-of select="$entity-name"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@type"/>
                    <xsl:text> </xsl:text>
                    <a href="/profiles/{$rel-entity-type}/{$rel-entity-key}.html">
                      <xsl:value-of select="names/name[1]"/>
                    </a>
                  </li>
                </xsl:for-each>
                <xsl:for-each select="relationships/relationship[@direction = 'inverse']">
                  <xsl:variable name="rel-entity-key" select="keys/key[1]"/>
                  <xsl:variable name="rel-entity-type"
                    select="/*/eats/entities/entity[keys/key = $rel-entity-key]/types/type[1]"/>

                  <li>
                    <a href="/profiles/{$rel-entity-type}/{$rel-entity-key}.html">
                      <xsl:value-of select="names/name[1]"/>
                    </a>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="@type"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$entity-name"/>
                  </li>
                </xsl:for-each>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="make-section">
    <xsl:param name="name"/>
    <xsl:param name="id"/>
    <xsl:param name="docs"/>
    <xsl:if test="$docs">
      <h3>
        <xsl:value-of select="$name"/>
      </h3>
      <div id="{$id}">
        <ul>
          <xsl:apply-templates select="$docs"/>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="doc">

    <xsl:variable name="href">
      <xsl:value-of select="$xmp:context-path"/>
      <xsl:text>/documents/</xsl:text>
      <xsl:choose>
        <xsl:when test="arr[@name='url']">
            <xsl:value-of select="arr[@name='url']/str"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="str[@name='url']"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="doccode">
      <xsl:for-each select="tokenize($href, '/')">
        <xsl:choose>
          <xsl:when test="position() = last()">
            <xsl:value-of select="substring-before(., '.html')"/>
          </xsl:when>
          <xsl:when test="position() = (last() - 1) and ($lessonbooks or $diaries)"><xsl:value-of
              select="."/>*</xsl:when>
          <xsl:when test="position() > 1">
            <xsl:value-of select="substring(., 1, 2)"/>
            <xsl:text>*</xsl:text>
          </xsl:when>
          <xsl:otherwise><!--  --></xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <li>
      <p>
        <!-- COMMENTED OUT BY PC , 19 NOV 2024, TO SEE IF THESE DOWNLOAD FUNCTIONS WERE THE CAUSE OF INSTABILITY ISSUES, POSSIBLY BY BEING HIT REPEATEDLY BY BOTS
          
          <input type="checkbox" name="{$doccode}" value="1"/>-->
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$href"/>
          </xsl:attribute>
          <xsl:value-of select="str[@name='shelfmark']"/>
          <xsl:text> </xsl:text>
          <strong>
            <xsl:choose>
              <xsl:when test="arr[@name='title']">
                <xsl:value-of select="arr[@name='title']/str"/>
              </xsl:when>
              <xsl:when test="str[@name='title']">
                <xsl:value-of select="str[@name='title']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="starts-with(str[@name='dateShort'], '1936')">
                    <xsl:text>Diary entry by Jeanette Schenker for </xsl:text>
                    <xsl:value-of select="format-date(xs:date(str[@name='dateShort']), '[D] [MNn] [Y]')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Diary entry by Schenker for </xsl:text>
                    <xsl:value-of select="format-date(xs:date(str[@name='dateShort']), '[D] [MNn] [Y]')"/>
                  </xsl:otherwise>
                </xsl:choose>
                
              </xsl:otherwise>
            </xsl:choose>
          </strong>
        </a>
        <xsl:if test="arr[@name='author'] and arr[@name='author_key'] = $entity-key">
          [Author]</xsl:if>
      </p>

      <xsl:if test="str[@name='description']">
        <p>
          <xsl:value-of select="str[@name='description']"/>
        </p>
      </xsl:if>
    </li>
  </xsl:template>
</xsl:stylesheet>
