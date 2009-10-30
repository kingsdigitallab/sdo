#!/usr/bin/env python

# extract MoveableType correspondence information and write to TEI XML file

# TODO:
# - separate records
# - group files into subfolders. 
#   For example, given the TITLE: OJ 11/42, [1] : 10-11-92, 
#   a file should be created with the name OJ-11-42_1.xml. 
#   It should be saved into this folder tree: OJ/11/42 

# PROBLEMS:

# DONE:
# - mixed content in body - markup that I inserted by "replace" and not by
#   using etree's methods is escaped when XML file is written
#   find a solution!!
#   I write etree tree to StringIO object, do a replace on the string, and write to file 
# - id in TEI element, see comment in sdo-profile-template.xml
# - should resp/date be without time? format of date. OK
# - date format for change date: 12/11/2008. OK
# - will there be only ever one change date? YES
# - how should other body parts ("EXTENDED BODY", etc.) be marked up?
#   right now they are just paragraphs
#   put in comment between paragraphs, i. e.: <!-- EXTENDED BODY -->
# - The headword has mixed content - this is being properly converted to <hi>
#   in the body, but not when it appears in the titleStmt or in the head for
#   the entry (knorr_iwan.html).
# - Perhaps related to this, accented characters appear to be handled differently
#   in the head, titleStmt and body (see adler_guido.xml)
#   I have fixed "title" and "bodyhead", check other possible places, too!!!
# 
# - The tag <small> should be detected and removed - there is no equivalent in
#   the TEI. (see wiener_dr_karl_von.xml, for example)
#   now represented as <!-- small --> and <!-- /small -->
# 
# - Similarly, the bq. should be handled - this is to create a blockquote,
#   but there is no close tag so it would be difficult to do this reliably.
#   Is it possible to check for this string and then to comment it out,
#   e.g. <!-- bq. -->, or is that too risky?

# PRETTYPRINT:
# -------------------------------------------
# from xml.minidom import parseString
# from xml.etree import ElementTree
# 
# def prettyPrint(element):
#     txt = ElementTree.tostring(element)
#     print minidom.parseString(txt).toprettyxml()
# -------------------------------------------
# xmlpp.py
# -------------------------------------------


import sys
import string
import StringIO
import re
import time
import os, os.path
import shutil
from xml.etree import ElementTree as ET

#####################################
# GLOBAL CONSTANTS
#####################################

# MoveableType data file
# RV
mtfile = "/home/rviglianti/Projects/schenker/data/movable-type/schenker_documents_online.txt"
outpath = "/tmp/correspondence"
# TL
# mtfile = "/home/tamara/cchsvn/schenker/trunk/data/movable-type/schenker_documents_online.txt"
# outpath = "/tmp/profiles"
logpath = "/tmp/logs"
# GB
# mtfile = "/projects/cch/schenker/data/movable-type/schenker_documents_online.txt"
# outpath = "/xi/schenker/profiles"
# logpath = "/xi/schenker/logs"

# declarations at beginning of XML file
pidic = {
         "xml" : 'version="1.0"',
         # PROFILES
	 #"oxygen" : 'RNGSchema="../../../../../schema/tei/xmod_web.rnc" type="compact"'
        }

# CORRESPONDENCE - TBA
schemalocation = "/home/rviglianti/Projects/schenker/schema/sdo/schenker.xsd"

# basename (for filename) to use should "BASENAME" header be empty
dummybasename = "CCHGENERATED"

# Start of a new entry is mtentrysep1 followed on a new line by mtentrysep2
mtentrysep1 = "--------"
mtentrysep2 = "AUTHOR:"
mtentrysep = mtentrysep1 + "\n" + mtentrysep2

# Separator between head and body
headsep1 = "-----"
headsep2 = "BODY:"
headsep = headsep1 + "\n" + headsep2

# Separator to start "EXTENDED BODY"
extbodysep2 = "EXTENDED BODY:"
extbodysep  = headsep1 + "\n" + extbodysep2

# Separator to start "EXCERPT"
excbodysep2 = "EXCERPT:"
excbodysep  = headsep1 + "\n" + excbodysep2

# Separator to start "KEYWORDS"
kwbodysep2 = "KEYWORDS:"
kwbodysep  = headsep1 + "\n" + kwbodysep2

bodyheaderslist = [
                   "BODY:",
                   "EXTENDED BODY:",
                   "EXCERPT:",
                   "KEYWORDS:",
                   "COMMENT:"
                   ]

# (?P<name>...)
# rebody = re.compile(r"""^(?P<rbody>.*)(?P<rextbody>.*)$""")

# CORRESPONDENCE
# categories, after "PRIMARY CATEGORY:", that determine if an entry is correspondence
correspprimcatlist = [
                      "Announcement",
                      "Calling card ",
                      "Delivery slip ",
                      "Envelope",
                      "Excerpt",
                      "Greetings card",
                      "Invitation",
		      "Invoice",
		      "Letter",
		      "Lettercard",
		      "Memo",
		      "Note",
		      "Packet",
		      "Postal receipt ",
		      "Postcard",
		      "Sales report ",
		      "Statement",
		      "Telegram",
		      "Telegraph",
                      ]
		      
# PROFILES
# categories, after "PRIMARY CATEGORY:", that determine if an entry is a profile
#~ profileprimcatlist = [
                      #~ "Company",
                      #~ "Work",
                      #~ "Title",
                      #~ "Person",
                      #~ "Place",
                      #~ "Organization",
                      #~ "Institution"
                      #~ ]

# possible delimiters for headword
headworddelimsopenlist = [
                           '<strong>',
                           '<b>',
                           '**',
                           '*'
                           ]

headworddelimscloselist = [
                           '</strong>',
                           '</b>',
                           '**',
                           '*'
                           ]

htmlformatsdicORI = {
                  '<strong>'  : '<hi rend="bold">',
                  '</strong>' : '</hi>',
                  '<b>'       : '<hi rend="bold">',
                  '</b>'      : '</hi>',
                  '<em>'      : '<hi rend="italic">',
                  '</em>'     : '</hi>',
                  '<i>'       : '<hi rend="italic">',
                  '</i>'      : '</hi>'
                  }
                  
htmlformatsdic = {
                  'bq.'       : '@@o!-- bq. --@@c',
                  '<small>'   : '',
                  '</small>'  : '',
                  # '<small>'   : '@@o!-- small --@@c',
                  # '</small>'  : '@@o!-- /small --@@c',
                  '<strong>'  : '@@ohi rend=@@qbold@@q@@c',
                  '</strong>' : '@@o/hi@@c',
                  '<b>'       : '@@ohi rend=@@qbold@@q@@c',
                  '</b>'      : '@@o/hi@@c',
                  '<em>'      : '@@ohi rend=@@qitalic@@q@@c',
                  '</em>'     : '@@o/hi@@c',
                  '<i>'       : '@@ohi rend=@@qitalic@@q@@c',
                  '</i>'      : '@@o/hi@@c',
                  '<u>'       : '@@ohi rend=@@qitalic@@q@@c',
                  '</u>'      : '@@o/hi@@c'
                  }
                  
wikiformatsdic = {
                  '**' : ['<hi rend="bold">', '</hi>'],
                  '*'  : ['<hi rend="bold">', '</hi>'],
                  '_'  : ['<hi rend="italic">', '</hi>']
                  }

rewikiformatsdic = {
                  '**' : [r'\*\*(.+?)\*\*', r'<hi rend="bold">', '</hi>', '<hi rend="bold">\\1</hi>'],
                  '*'  : [r'\*(.+?)\*', r'<hi rend="bold">', '</hi>', '<hi rend="bold">\\1</hi>'],
                  '_'  : [r'_', r'<hi rend="italic">', '</hi>', '<hi rend="italic">\\1</hi>']
                  }

wikiformatslist = [
                  '**',
                  '*',
                  '_'
                   ]

#rewikiformatslist = [
#                  '**',
#                  '*',
#                  '_'
#                   ]

# for analysis:
#  counter for empty headwords
hwcount = 0
nohwcount = 0
bqcount = 0

#~ #  counter for profiles
#~ profcount = 0
# counter for correpsondences
correspcount = 0

#####################################
# END GLOBAL CONSTANTS
#####################################

# dict for frequencies of keys in the header
# for consistency checking
hfreqdic = {}

# list that collects basenames (used as output filenames) as we
# go along
# collecting the basenames in this list allows us to check if there
# are duplicates and act accordingly, i. e. add a date/time stamp
# to make the file name unique 
basenameslist = [ dummybasename ]

def printUsage():
    print
    print "ATTENTION:"
    print
    print "      ", os.path.basename(sys.argv[0]), ""
    print
    # print "      ", "get help with:"
    # print "      ", os.path.basename(sys.argv[0]), "-h"
    # print
    sys.exit(2)

def getRepfileObject(slp):
    repfiledir = slp
    repfilefile = "schenker-MT-to-XML"
    repfilefile += "-"
    # repfilefile += time.strftime("%Y-%m-%d-%H-%M", time.localtime())
    repfilefile += time.strftime("%Y%m%d%H%M", time.localtime())
    repfilefile += ".LOG"
    repfilepath = os.path.join(repfiledir, repfilefile)
    repf = file(repfilepath, "w")
    return repf

# PrintCF
# print to console and file
# 1: filehandle
# 2: if newline should be added at end
# 3: string to print
def printCF(fh, newline, s):
    if newline == 0:
        print s,
        fh.write(s)
        fh.flush()
    else:
        print s
        fh.write(s + "\n")
        fh.flush()

def checkDirs():
    if not os.path.exists(logpath):
        print
        print "Log path '%s' does not exist!" % (logpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(logpath):
        print
        print "Log path '%s' exists, but is not a directory!" % (logpath, )
        print
        sys.exit(2)

    if not os.path.exists(outpath):
        print
        print "Output path '%s' does not exist!" % (outpath, )
        print
        sys.exit(2)
    elif not os.path.isdir(outpath):
        print
        print "Output path '%s' exists, but is not a directory!" % (outpath, )
        print
        sys.exit(2)

# CORRESPONDENCE
def cleanupDirs():
	shutil.rmtree(outpath)
	os.makedirs(outpath)

# creates the three of directories from the tile (up to two levels)
# and returns the path
def makeFileDir(title):
	# end date
	#end_datelist = ["\d+-\d+-\d+$", "undated"]
	
	# Analyze title
	# ^([^\s:]+\s+)      top level
	# ([^\s:]+\s+)       second level [will be split in 2 levels if contains /]. can be filename
	# ([^\s:]+\s+)?      third level. can be filename
	# ([^\s:]+\s+)?      fourth level. can be filename
	# ([^\s:]+\s+)?      fifth level. will always be filename if present
	# (:|\d+-\d+-\d+)
	title_p = re.compile("^([^\s:]+\s+)([^\s:]+\s+)([^\s:]+\s+)?([^\s:]+\s+)?([^\s:]+\s+)?(:|\d+-\d+-\d+)")
	title_m = title_p.match(title)
	
	#top level
	toplevel_dir = title_m.group(1)
	toplevel_dir = string.strip(toplevel_dir)
	toplevel_dir = string.strip(toplevel_dir, string.punctuation)
	# Check that it starts with a letter, otherwise send to basket.
	if not re.compile('^[a-z]', re.IGNORECASE).match(toplevel_dir):
		toplevel_dir = "basket"
		
	if not os.path.exists(os.path.join(outpath,toplevel_dir)):
		os.makedirs(os.path.join(outpath,toplevel_dir))
		
	#second level
	secondlevel_dir = title_m.group(2)
	secondlevel_dir = string.strip(secondlevel_dir)
	secondlevel_dir = string.strip(secondlevel_dir, string.punctuation)
	#is second level last?
	if not title_m.group(3):
		#does it contain "/" ? Then get the first part and use it as second level directory
		if secondlevel_dir.find("/") != -1:
			secondlevel_dir = secondlevel_dir.split("/")[0]
			if not os.path.exists(os.path.join(outpath,toplevel_dir,secondlevel_dir)):
				os.makedirs(os.path.join(outpath,toplevel_dir,secondlevel_dir))
		else:
			secondlevel_dir = ""
	elif title_m.group(3):		
		if not os.path.exists(os.path.join(outpath,toplevel_dir,secondlevel_dir)):
				os.makedirs(os.path.join(outpath,toplevel_dir,secondlevel_dir))
	
	# determine name of the XML file to be created
	titleescaped = title
	titleescaped = titleescaped.replace("/", "-")
	badchars = ["&", "*", "?"]
	for b in badchars:
		titleescaped = titleescaped.replace(b, "")
	titleescaped_m = title_p.match(titleescaped)
	
	filename = ""
	for i, g in enumerate(titleescaped_m.groups()):
		if g != None and g != ":":
			if not re.compile("\d+-\d+-\d+$").match(g):
				if i == 0:
					filename = string.strip(string.strip(g), string.punctuation)
				else:
					filename = string.join([filename, string.strip(string.strip(g), string.punctuation)], "_")
	
	#print "@@"
	print os.path.join(outpath,toplevel_dir, secondlevel_dir, filename+".xml")
	#print "TITLE: "+title
	#print "@@"
	return os.path.join(outpath,toplevel_dir, secondlevel_dir, filename+".xml")
		
	#~ #third level
	#~ if title_m.group(3):
		#~ thirdlevel_dir = title_m.group(3)
		#~ thirdlevel_dir = string.strip(thirdlevel_dir)
		#~ thirdlevel_dir = string.strip(thirdlevel_dir, string.punctuation)
		#~ #only proceed if third level is not last
		#~ if title_m.group(4):
			#~ if not os.path.exists(os.path.join(outpath,toplevel_dir,secondlevel_dir,thirdlevel_dir)):
				#~ os.makedirs(os.path.join(outpath,toplevel_dir,secondlevel_dir,thirdlevel_dir))
			
	#~ #fourth level
	#~ if title_m.group(4):
		#~ fourthlevel_dir = title_m.group(4)
		#~ fourthlevel_dir = string.strip(fourthlevel_dir)
		#~ fourthlevel_dir = string.strip(fourthlevel_dir, string.punctuation)
		#~ #only proceed if fourth level is not last
		#~ if title_m.group(5):
			#~ if not os.path.exists(os.path.join(outpath,toplevel_dir,secondlevel_dir,thirdlevel_dir,fourthlevel_dir)):
				#~ os.makedirs(os.path.join(outpath,toplevel_dir,secondlevel_dir,thirdlevel_dir,fourthlevel_dir))
			
	#~ #fifth level
	#~ if title_m.group(5):
		#~ fifthlevel_dir = title_m.group(5)
		#~ fifthlevel_dir = string.strip(fifthlevel_dir)
		#~ fifthlevel_dir = string.strip(fifthlevel_dir, string.punctuation)
		#~ #only proceed if third level is not last
		#~ if title_m.group(6):
			#~ if not os.path.exists(os.path.join(outpath,toplevel_dir,secondlevel_dir,thirdlevel_dir,fourthlevel_dir,fifthlevel_dir)):
				#~ os.makedirs(os.path.join(outpath,toplevel_dir,secondlevel_dir,thirdlevel_dir,fourthlevel_dir,fifthlevel_dir))


# PROFILE
#~ def makeCatDirs():

    #~ # If it is already there, delete then remake, otherwise, just recreate
    #~ for c in profileprimcatlist:
        #~ if os.path.exists(os.path.join(outpath,c.lower())):
            #~ shutil.rmtree(os.path.join(outpath, c.lower()))
            #~ os.makedirs(os.path.join(outpath, c.lower()))
        #~ else:
            #~ os.makedirs(os.path.join(outpath, c.lower()))
             

def insertIntoHeadFreqDict(k):
    if hfreqdic.has_key(k):
        hfreqdic[k] += 1
    else:
        hfreqdic[k] = 1

def printHeadKeyStats(fh):
    printCF(fh, 1, "-" * 50)
    for k in hfreqdic.keys():
        printCF(fh, 1, "%20s : %d" % (k, hfreqdic[k]))
    printCF(fh, 1, "")
    #CORRESPONDENCE
    printCF(fh, 1, "No of correpondences:  %5d" % (correspcount, ))
    # PROFILE
    #printCF(fh, 1, "No of profiless:       %5d" % (profcount, ))
    printCF(fh, 1, "")
    printCF(fh, 1, "No of headwords:       %5d" % (hwcount, ))
    printCF(fh, 1, "No of empty headwords: %5d" % (nohwcount, ))

def getListOfEntries(ta):
    elist = ta.split(mtentrysep)
    return elist

def getHeadAndBody(t):
    # print t
    hblist = t.split(headsep)
    # print hblist
    if len(hblist) > 2:
        head = hblist[0]
        body = "\n".join(hblist[1:])
        print "XXX"
    else:
        head = hblist[0]
        body = hblist[1]
    # print head
    # print "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    # print body
    
    return head, body

def getBodyParts(fh, bd):
    bodypartsdic = {}
    # some body entries are enclosed in "<p>" tags
    bd = bd.replace("<p>", "")
    bd = bd.replace("</p>", "")
    bd = "BODY:\n" + bd
    bdpartslist = bd.split(headsep1)
    for b in bdpartslist:
        b = b.strip()
        for bh in bodyheaderslist:
            if b.startswith(bh):
                bp = b[len(bh):]
                bp = bp.strip()
                if bodypartsdic.has_key(bh):
                    bodypartsdic[bh] += "\n" + bp
                else:
                    bodypartsdic[bh] = bp
    return bodypartsdic

def getBodyPartsFind(fh, bd):
    extbodyopenpos = bd.find(extbodysep)
    if extbodyopenpos < 0:
        printCF(fh, 1, "BODYPART: NO EXTENDED BODY")
        extbody = ""
    else:
        extbodystartpos = extbodyopenpos + len(extbodysep)
    excbodyopenpos = bd.find(excbodysep)
    if excbodyopenpos < 0:
        printCF(fh, 1, "BODYPART: NO EXCERPT")
        excbody = ""
    else:
        excbodystartpos = excbodyopenpos + len(excbodysep)
    kwbodyopenpos = bd.find(kwbodysep)
    if kwbodyopenpos < 0:
        printCF(fh, 1, "BODYPART: NO KEYWORDS")
        kwbody = ""
    else:
        kwbodystartpos = kwbodyopenpos + len(kwbodysep)
    # handle missing headings later (missing "EXTENDED BODY", "EXCERPTF", "KEYWORDS")
    body = bd[:extbodyopenpos].strip()
    extbody = bd[extbodystartpos:excbodyopenpos].strip()
    excbody = bd[excbodystartpos:kwbodyopenpos].strip()
    kwbody = bd[kwbodystartpos:].strip()
    bddic = {}
    bddic["BODY"] = body
    print "BODYLEN.", len(body)
    
    bddic["EXTBODY"] = extbody
    print "EXTBODYLEN.", len(extbody)
    
    bddic["EXCBODY"] = excbody
    print "EXCBODYLEN.", len(excbody)

    bddic["KWBODY"] = kwbody
    print "KWBODYLEN.", len(kwbody)

    return bddic


def getHeadDict(h):
    hdic = {}
    for hlnum, line in enumerate(h.split("\n")):
        line = line.strip()
        if line != "":
            if hlnum == 0:
                hdic["AUTHOR"] = line
                insertIntoHeadFreqDict("AUTHOR")
            else:
                colonpos = line.find(":")
                # we want at least one character before the colon
                if colonpos > 1:
                    k = line[:colonpos]
                    v = line[colonpos+1:]
                    k = k.strip()
                    v = v.strip()
                    # print k, v
                    hdic[k] = v
                    insertIntoHeadFreqDict(k)
    return hdic


def buildXMLSkeleton():
    skeldic = {}
    #CORRESPONDENCE   
    skeldic["root"] = ET.Element("sdo:record")
    skeldic["root"].set("xmlns:sdo", "http://www.cch.kcl.ac.uk/schenker")
    skeldic["root"].set("xmlns:tei", "http://www.tei-c.org/ns/1.0")
    skeldic["root"].set("xmlns:dc", "http://purl.org/dc/elements/1.1/")
    skeldic["root"].set("xmlns:dcterms", "http://purl.org/dc/terms/")
    skeldic["root"].set("xmlns:marcrel", "http://www.loc.gov/loc.terms/relators/")
    skeldic["root"].set("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
    skeldic["root"].set("xsi:schemaLocation", "http://www.cch.kcl.ac.uk/schenker "+schemalocation) 
    
    # PROFILES
    #~ # build a tree structure
    #~ skeldic["root"] = ET.Element("TEI")
    #~ skeldic["root"].set("xmlns", "http://www.tei-c.org/ns/1.0")
    #~ # xml:id now set later with basename of output file name
    #~ # skeldic["root"].set("xml:id", "p1_1_1_2")
    #~ skeldic["root"].set("xmlns:xmt", "http://www.cch.kcl.ac.uk/xmod/tei/1.0")
    
    # pi = ET.ProcessingInstruction("oxygen", "xxx")
    # root.append(pi)
    # print ET.tostring(pi)

    
    #~ skeldic["teiHeader"] = ET.SubElement(skeldic["root"], "teiHeader")
    #~ skeldic["fileDesc"] = ET.SubElement(skeldic["teiHeader"], "fileDesc")
    #~ skeldic["titleStmt"] = ET.SubElement(skeldic["fileDesc"], "titleStmt")
    #~ skeldic["title"] = ET.SubElement(skeldic["titleStmt"], "title")
    #~ skeldic["filingTitle"] = ET.SubElement(skeldic["titleStmt"], "title")
    #~ skeldic["filingTitleTerm"] = ET.SubElement(skeldic["filingTitle"], "term")
    #~ skeldic["respStmt"] = ET.SubElement(skeldic["titleStmt"], "respStmt")
    #~ skeldic["resp"] = ET.SubElement(skeldic["respStmt"], "resp")
    #~ skeldic["respdate"] = ET.SubElement(skeldic["resp"], "date")
    #~ skeldic["name"] = ET.SubElement(skeldic["respStmt"], "name")
    #~ skeldic["publicationStmt"] = ET.SubElement(skeldic["fileDesc"], "publicationStmt")
    #~ skeldic["publisher"] = ET.SubElement(skeldic["publicationStmt"], "publisher")
    #~ skeldic["address"] = ET.SubElement(skeldic["publicationStmt"], "address")
    #~ skeldic["addrLine1"] = ET.SubElement(skeldic["address"], "addrLine")
    #~ skeldic["addrLine2"] = ET.SubElement(skeldic["address"], "addrLine")
    #~ # skeldic["note1"] = ET.SubElement(skeldic["notesStmt"], "note")
    #~ # skeldic["note2"] = ET.SubElement(skeldic["notesStmt"], "note")
    #~ skeldic["sourceDesc"] = ET.SubElement(skeldic["fileDesc"], "sourceDesc")
    #~ skeldic["psource"] = ET.SubElement(skeldic["sourceDesc"], "p")
    #~ skeldic["encodingDesc"] = ET.SubElement(skeldic["teiHeader"], "encodingDesc")
    #~ skeldic["profileDesc"] = ET.SubElement(skeldic["teiHeader"], "profileDesc")
    #~ skeldic["textClass"] = ET.SubElement(skeldic["profileDesc"], "textClass")
    #~ skeldic["keywords"] = ET.SubElement(skeldic["textClass"], "keywords")
    #~ skeldic["keywordsEats"] = ET.SubElement(skeldic["textClass"], "keywords")
    #~ skeldic["pencoding"] = ET.SubElement(skeldic["encodingDesc"], "p")
    #~ skeldic["revisionDesc"] = ET.SubElement(skeldic["teiHeader"], "revisionDesc")
    #~ skeldic["change1"] = ET.SubElement(skeldic["revisionDesc"], "change")
    #~ skeldic["change1date"] = ET.SubElement(skeldic["change1"], "date")
    #~ skeldic["change1desc"] = ET.SubElement(skeldic["change1"], "desc")

    #~ # CONSTANTS
    #~ skeldic["resp"].text = 'published in Movable Type'
    #~ skeldic["publisher"].text = 'Schenker Documents Online in association with the Centre for Computing in the Humanities'
    #~ skeldic["addrLine1"].text = 'http://www.schenkerdocumentsonline.org'
    #~ skeldic["addrLine2"].text = 'http://www.kcl.ac.uk/cch/'
    #~ skeldic["psource"].text = 'No source: created in electronic format.'
    #~ skeldic["pencoding"].text = 'Encoding according to the CCH TEI Guidelines'
    #~ skeldic["change1desc"].text = 'Automatic Conversion from Movable Type'
    
    #~ skeldic["text"] = ET.SubElement(skeldic["root"], "text")
    #~ skeldic["body"] = ET.SubElement(skeldic["text"], "body")
    #~ skeldic["bodyhead"] = ET.SubElement(skeldic["body"], "head")
    #~ skeldic["bodydiv"]  = ET.SubElement(skeldic["body"], "div")
    
    # skeldic["title"] = ET.SubElement(head, "title")
    # skeldic["title"].text = "Page Title"
    
    # body = ET.SubElement(skeldic["root"], "body")
    # body.set("bgcolor", "#ffffff")
    
    # body.text = "Hello, World!"
    
    # wrap it in an ElementTree instance, and save as XML
    # tree = ET.ElementTree(skeldic["root"])
    # tree.write(logpath + "/" + "page.xhtml")
    return skeldic

# UGLY HACK:
# handling mixed content with etree is teadious
# hack:
# all XMl markup chars that I generate directly (by replace in the text for example)
# uses "@@o" for "<", "@@c" for ">", "@@q" for '""
# I then write the etree tree to a string (via StringIO)
# replace the temporary markup characters by their real XML equivalents
# and finally write the string to a file
def fixMixedContent(xs):
    xs = xs.replace("@@o", "<")
    xs = xs.replace("@@c", ">")
    xs = xs.replace("@@q", '"')
    xs = xs.replace("@@u", '_') # specifically to preserve underscores in basenames

    return xs

def writeXMLFile(repf, ofp, root):
    printCF(repf, 1, "writing to file '%s'" % (ofp, ))

    # ofpobj = file(ofp, "w")
    ofpobj = StringIO.StringIO()

    # write declarations
    dec = ET.ProcessingInstruction("xml", pidic["xml"])
    # PROFILES
    # oxy = ET.ProcessingInstruction("oxygen", pidic["oxygen"])
    # print >> ofpobj, ET.tostring(dec)
    # print >> ofpobj, ET.tostring(oxy)
    
    #oxystr = ET.tostring(oxy)
    
    tree = ET.ElementTree(root)
    # tree.write(ofpobj)
    # write real UNICODE in etree and not character entities 
    tree.write(ofpobj, encoding="utf-8")
    xmlstr = ofpobj.getvalue()
    ofpobj.close()
    xmlstr = fixMixedContent(xmlstr)
    # I had to resort to this crude method for inserting this processing instruction
    # giving the option "encoding" in "tree.write" above inserts an XML declaration at
    # the start of the file, we cannot therefore insert the processing instruction
    # with etree means between the XML declaration and the root element
    
    # PROFILE
    # xmlstr = xmlstr.replace("<TEI", oxystr + "\n" + "<TEI")
    if os.path.isfile(ofp):
	    ofp = ofp[:-len('.xml')]+"DUPLICATE.xml"
    
    ofpobj = file(ofp, "w")
    ofpobj.write(xmlstr)
    ofpobj.close()
    

def getHeadWord(fh, bd):
    global hwcount, nohwcount
    # some body entries are enclosed in "<p>" tags
    bd = bd.replace("<p>", "")
    bd = bd.replace("</p>", "")
    bd = bd.strip(string.whitespace)
    hw = ''
    for hwnum, hwdopen in enumerate(headworddelimsopenlist):
        # print hwdopen
        if (hw == '') and (bd.startswith(hwdopen)):
            hwposa = len(hwdopen)
            hwposb = bd.find(headworddelimscloselist[hwnum], hwposa)
            # print "---", hwdopen
            hw = bd[hwposa:hwposb]
            hw = hw.strip(",.:;")
            # print "===", hw
            hwcount += 1
            # break
        # else:
    if (hw == ''):
        # no headword immediately after body tag
        # 33 cases - either do something in program or fix files by hand
        hw = "XXXXX"
        printCF(fh, 1, "XXXXX")
        nohwcount += 1
    hw = convertHtmlFormatsInHead(hw)
    return hw

def convertHtmlFormatsInHead(w):
    for h in htmlformatsdic.keys():
        w = w.replace(h, htmlformatsdic[h])
    return w

def convertHtmlFormats(repf, bdic):
    # for analysis
    # global bqcount
    for k in bdic.keys():
        for h in htmlformatsdic.keys():
            bdic[k] = bdic[k].replace(h, htmlformatsdic[h])
            # for analysis
            # bqcount += bdic[k].count("bq.")
    return bdic

def convertWikiFormats(repf, bdic):
    for k in bdic.keys():

        # the following does not work, I don't know why yet
        # for w in wikiformatslist:
        #     pat = rewikiformatsdic[w][0]
        #     # repl = rewikiformatsdic[w][1] + r"\\1" + rewikiformatsdic[w][2]
        #     repl = rewikiformatsdic[w][3]
        #     bdic[k] = re.sub(pat, repl, bdic[k])
        #     bdic[k] = re.sub(rewikiformatsdic[w][0], rewikiformatsdic[w][3], bdic[k])
        #     print pat, repl

        # bdic[k] = re.sub(r"\*\*(.+?)\*\*", '<hi rend="bold">\\1</hi>', bdic[k])
        # bdic[k] = re.sub(r"\*(.+?)\*", '<hi rend="bold">\\1</hi>', bdic[k])
        # bdic[k] = re.sub(r"_(.+?)_", '<hi rend="italic">\\1</hi>', bdic[k])

        bdic[k] = re.sub(r"\*\*(.+?)\*\*", '@@ohi rend=@@qbold@@q@@c\\1@@o/hi@@c', bdic[k])
        bdic[k] = re.sub(r"\*(.+?)\*", '@@ohi rend=@@qbold@@q@@c\\1@@o/hi@@c', bdic[k])
        bdic[k] = re.sub(r"_(.+?)_", '@@ohi rend=@@qitalic@@q@@c\\1@@o/hi@@c', bdic[k])
    return bdic

def convertHrefLinks(repf, bdic):
    for k in bdic.keys():
        bdic[k] = re.sub(r"""<a href="\.\./\.\./profile/.+?/(.+?).html">(.+?)</a>""", '@@oref cRef=@@q\\1@@q@@c\\2@@o/ref@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@q@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@u\\3@@q@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)_(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@u\\3@@u\\4@@q@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)_(.+?)_(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@u\\3@@u\\4@@u\\5@@q@@c', bdic[k])
    
    return bdic
    

def processTags(repf, hdic, bd, xmldic):
    taglist = hdic["TAGS"].split(",")
    for tag in taglist:
        tag = tag.strip()
        tag = tag.strip('"')
        tag = tag.strip()
        tagterm = ET.SubElement(xmldic["keywords"], "term")
        tagterm.text = tag
        xmldic["keywords"].set("scheme", "MT")
        tagterm.set("subtype", "tag")

def processPrimaryCategory(repf, hdic, bd, xmldic):
    tag = hdic["PRIMARY CATEGORY"]
    tag = tag.strip()
    tagterm = ET.SubElement(xmldic["keywords"], "term")
    tagterm.text = tag
    xmldic["keywords"].set("scheme", "MT")
    tagterm.set("subtype", "category")
    
def processBaseName(repf, hdic, bd, xmldic):
    tag = hdic["BASENAME"]
    tag = tag.strip()
    tagterm = ET.SubElement(xmldic["keywords"], "term")
    xmldic["keywords"].set("scheme", "MT")
    tagterm.text = tag
    tagterm.set("subtype", "basename")

def processEatsStub(repf, hdic, bd, xmldic):
    tagterm = ET.SubElement(xmldic["keywordsEats"], "term")
    xmldic["keywordsEats"].set("scheme", "EATS")
    tagterm.set("key", "nNNNNNNN")

def processConversionDate(repf, hdic, bd, xmldic):
    # tag = time.strftime("%Y%m%d%H%M", time.localtime())
    # tag = time.strftime("%Y%m%d", time.localtime())
    tag = time.strftime("%d/%m/%Y", time.localtime())
    xmldic["change1date"].text = tag

def processConvertedBody(repf, hdic, bdic, xmldic):
    for bodytype in bodyheaderslist:
        if bdic.has_key(bodytype):
            # oxy = ET.ProcessingInstruction("oxygen", pidic["oxygen"])
            # print >> ofpobj, ET.tostring(dec)
            comm = ET.Comment(bodytype)
            xmldic["bodydiv"].append(comm)
            parslist = re.split("\n\n+", bdic[bodytype])
            for par in parslist:
                par = par.strip()
                if par != "":
                    parel = ET.SubElement(xmldic["bodydiv"], "p")
                    # parel.text = par
                    parel.text = par.decode("utf8")

def convertAmericanToEuropeanDate(ds):
    dlist = ds.split()
    elist = dlist[0].split("/")
    ndate = "/".join([elist[1], elist[0], elist[2]])
    return ndate

#CORRESPONDENCE
def processCorresp(repf, hdic, bd, outfilepath):
    global correspcount
    correspcount += 1
    xmlskeldic = buildXMLSkeleton()
    writeXMLFile(repf, outfilepath, xmlskeldic["root"])
    
# PROFILE
#~ def processProfile(repf, hdic, bd):
    #~ global profcount
    #~ profcount += 1
    #~ xmlskeldic = buildXMLSkeleton()
       
    #~ headword = getHeadWord(repf, bd)
    #~ filingTitle= hdic["TITLE"].decode("utf8")
    #~ filingTitleSortkey = hdic["BASENAME"]
    
    #~ xmlskeldic["title"].text = headword.decode("utf8")w
    #~ xmlskeldic["filingTitle"].set("type", "file")
    #~ xmlskeldic["filingTitleTerm"].text = filingTitle
    #~ xmlskeldic["filingTitleTerm"].set("sortKey", filingTitleSortkey)
    #~ xmlskeldic["bodyhead"].text = headword.decode("utf8")
    #~ # xmlskeldic["respdate"].text = hdic["DATE"]
    #~ xmlskeldic["respdate"].text = convertAmericanToEuropeanDate(hdic["DATE"])
    #~ xmlskeldic["name"].text = hdic["AUTHOR"]
    #~ if hdic.has_key("TAGS"):
        #~ processTags(repf, hdic, bd, xmlskeldic)
    #~ processPrimaryCategory(repf, hdic, bd, xmlskeldic)
    #~ processBaseName(repf, hdic, bd, xmlskeldic)
    #~ processEatsStub(repf, hdic, bd, xmlskeldic)
    #~ processConversionDate(repf, hdic, bd, xmlskeldic)
    #~ bodydic = getBodyParts(repf, bd)
    #~ bodydic = convertHtmlFormats(repf, bodydic)   
    #~ bodydic = convertHrefLinks(repf, bodydic)
    #~ bodydic = convertWikiFormats(repf, bodydic)
    #~ processConvertedBody(repf, hdic, bodydic, xmlskeldic)
    #~ # print "-" * 50
    #~ # print bd
    
    #~ if not hdic.has_key("BASENAME"):
        #~ basename = "CCHPROVIDED"
    #~ else:
        #~ basename = hdic["BASENAME"]

    #~ if (hdic.has_key("PRIMARY CATEGORY")) and (hdic["PRIMARY CATEGORY"] in profileprimcatlist):
        #~ outdir = hdic["PRIMARY CATEGORY"].lower()
    #~ else:
        #~ outdir = ""
 
    #~ # in case basename is duplicated (i. e. it is in basenameslist)
    #~ # generate unique basename by adding current date and time
    #~ if basename in basenameslist:
        #~ basename += "-" + time.strftime("%Y%m%d%H%M", time.localtime())
    #~ xmlskeldic["root"].set("xml:id", basename)
    #~ basenameslist.append(basename)
    #~ outfilepath = os.path.join(outpath, outdir, basename + ".xml")
    #~ writeXMLFile(repf, outfilepath, xmlskeldic["root"])
    #~ return basenameslist

if __name__ == '__main__':
    checkDirs()
    # CORRESPONDENCE
    cleanupDirs()
    # PROFILE 
    # makeCatDirs()
    repf = getRepfileObject(logpath)
    # get file object to read MoveableType file
    mtfobj = file(mtfile, "r")
    mtcont = mtfobj.read()
    mtfobj.close()
    l = mtcont.split(mtentrysep)
    entrylist = getListOfEntries(mtcont)
    print len(entrylist)
    for entrynum, entry in enumerate(entrylist):
        head, body = getHeadAndBody(entry)
        headdic = getHeadDict(head)
        if (headdic.has_key("PRIMARY CATEGORY")) and (headdic["PRIMARY CATEGORY"] in correspprimcatlist):
            printCF(repf, 1, "processing entry #%d" % (entrynum
                                                       , ))
            
	    # CORRESPONDENCE
	    full_filename = makeFileDir(headdic["TITLE"])
	    basenameswrittenlist = processCorresp(repf, headdic, body, full_filename)
	    
	    # PROFILE
	    # basenameswrittenlist = processProfile(repf, headdic, body)
            # TEST for "<small>"
            # print "SMALL":, body.find("<small>")
    

    printHeadKeyStats(repf)
    
    
    
    repf.close()
    # for analysis
    # print "BQCOUNT:", bqcount
    print "--== FINISHED ==--"
