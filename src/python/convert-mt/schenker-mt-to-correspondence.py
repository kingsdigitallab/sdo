#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# extract MoveableType correspondence information and write to TEI XML file

# TODO:


# PROBLEMS:

# DONE:
# - separate records
# - group files into subfolders. 
#   For example, given the TITLE: OJ 11/42, [1] : 10-11-92, 
#   a file should be created with the name OJ-11-42_1.xml. 
#   It should be saved into this folder tree: OJ/11/42 
# - Information appearing in the BODY should be placed into a <tei:transcription> block.
# - Information appearing in the EXTENDED BODY should be placed into a <tei:translation> block. 
# - If possible, each paragraph (to be detected by parsing the control characters) should be placed into a <tei:p> block. 
# - Inline Markup
#    * text surrounded by underscores, with <em>, or with <i> should be converted to <hi rend="italic">
#    * text surrounded by asterisks, or with <strong> should be converted to <hi rend="bold"> 
# - Numbered markers appear in the body of the transcription and the translation, e.g. [1], [2], etc. 
#   The note appears in the EXCERPT: section, usually under a human created label FOOTNOTES: -
#   Markers in the Transcription and Translation should be converted to <tei:note> and 
#   <tei:ptr elements respectively, and given an xml:id (or corresp) attribute with the value r0001-fnN 
#  (where N is the value of the current note marker. The actual note (again, appearing in the excerpt section) should be placed into the body of the note in the transcription. 
# - The entire record should be placed within an sdo:recordCollection element, with namespace declarations
# - An indication of the source type, and the unique shelfmark. For the moment, give each shelfmark as TEST-SHELFMARK1 
# - A placeholder for handnotes (w/the indicated instructional XML comment) 
# - Statements of Responsibility
# - the various copyright statements sprinkled throughout the record should be collated into an XML Comment at the beginning of the record
# - collate the dcterms:license, dcterms:provenance and dcterms:rightsHolder 
# - A revisionDesc note

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
#mtfile = "/home/rviglianti/Projects/schenker/data/movable-type/schenker_documents_online.txt"
outpath = "/tmp/correspondence"
# TL
mtfile = "/home/tamara/cchsvn/schenker/trunk/data/movable-type/schenker_documents_online.txt"
# outpath = "/tmp/profiles"
logpath = "/tmp/logs"
# GB
# mtfile = "/projects/cch/schenker/data/movable-type/schenker_documents_online.txt"
# outpath = "/xi/schenker/profiles"
# logpath = "/xi/schenker/logs"

# declarations at beginning of XML file
pidic = { "xml" : 'version="1.0"',
	  "xml-stylesheet" : 'href="../../../css/sdo_oxygen.css" type="text/css"',
        }

# CORRESPONDENCE - TBA
schemalocation = "../../../schema/schenker.xsd"

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
                  '<strong>'  : '<tei:hi rend="bold">',
                  '</strong>' : '</tei:hi>',
                  '<b>'       : '<tei:hi rend="bold">',
                  '</b>'      : '</tei:hi>',
                  '<em>'      : '<tei:hi rend="italic">',
                  '</em>'     : '</tei:hi>',
                  '<i>'       : '<tei:hi rend="italic">',
                  '</i>'      : '</tei:hi>'
                  }
                  
htmlformatsdic = {
                  'bq.'       : '@@o!-- bq. --@@c',
                  '<small>'   : '',
                  '</small>'  : '',
                  # '<small>'   : '@@o!-- small --@@c',
                  # '</small>'  : '@@o!-- /small --@@c',
                  '<strong>'  : '@@otei:hi rend=@@qbold@@q@@c',
                  '</strong>' : '@@o/tei:hi@@c',
                  '<b>'       : '@@otei:hi rend=@@qbold@@q@@c',
                  '</b>'      : '@@o/tei:hi@@c',
                  '<em>'      : '@@otei:hi rend=@@qitalic@@q@@c',
                  '</em>'     : '@@o/tei:hi@@c',
                  '<i>'       : '@@otei:hi rend=@@qitalic@@q@@c',
                  '</i>'      : '@@o/tei:hi@@c',
                  '<u>'       : '@@otei:hi rend=@@qitalic@@q@@c',
                  '</u>'      : '@@o/tei:hi@@c'
                  }
                  
wikiformatsdic = {
                  '**' : ['<tei:hi rend="bold">', '</tei:hi>'],
                  '*'  : ['<tei:hi rend="bold">', '</tei:hi>'],
                  '_'  : ['<tei:hi rend="italic">', '</tei:hi>']
                  }

rewikiformatsdic = {
                  '**' : [r'\*\*(.+?)\*\*', r'<tei:hi rend="bold">', '</tei:hi>', '<tei:hi rend="bold">\\1</tei:hi>'],
                  '*'  : [r'\*(.+?)\*', r'<tei:hi rend="bold">', '</tei:hi>', '<tei:hi rend="bold">\\1</tei:hi>'],
                  '_'  : [r'_', r'<tei:hi rend="italic">', '</tei:hi>', '<tei:hi rend="italic">\\1</tei:hi>']
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
		# if the following groups still have , or [ or ] after punctuation being stripped out, throw into basket.
		g3 = ""
		g4 = ""
		g5 = ""
		if title_m.group(3) : g3 = string.strip(string.strip(title_m.group(3)), string.punctuation) 
		if title_m.group(4) : g4 = string.strip(string.strip(title_m.group(4)), string.punctuation)
		if title_m.group(5) : g5 = string.strip(string.strip(title_m.group(5)), string.punctuation)
		
		if g3.find(",") != -1 or g3.find("[")  != -1 or g3.find("]") != -1:
			secondlevel_dir = "basket"
		elif g4 != None and ( g4.find(",") != -1 or g4.find("[") != -1 or g4.find("]") != -1 ):
			secondlevel_dir = "basket"
		elif g5 != None and ( g5.find(",") != -1 or g5.find("[") != -1 or g5.find("]") != -1 ):
			secondlevel_dir = "basket"
			
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
				elif i == 1 or i == 2:
					if titleescaped_m.group(i+1).find("[") != -1: 
						filename = string.join([filename, string.strip(string.strip(g), string.punctuation)], "_")
					else: filename = string.join([filename, string.strip(string.strip(g), string.punctuation)], "-")
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
    
    #root and namespaces
    skeldic["root"] = ET.Element("sdo:recordCollection")
    skeldic["root"].set("xmlns:sdo", "http://www.cch.kcl.ac.uk/schenker")
    skeldic["root"].set("xmlns:tei", "http://www.tei-c.org/ns/1.0")
    skeldic["root"].set("xmlns:dc", "http://purl.org/dc/elements/1.1/")
    skeldic["root"].set("xmlns:dcterms", "http://purl.org/dc/terms/")
    skeldic["root"].set("xmlns:marcrel", "http://www.loc.gov/loc.terms/relators/")
    skeldic["root"].set("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
    skeldic["root"].set("xsi:schemaLocation", "http://www.cch.kcl.ac.uk/schenker "+schemalocation)

    skeldic["collectionDesc"] = ET.SubElement(skeldic["root"], "sdo:collectionDesc")
    # An indication of the source type, and the unique shelfmark
    skeldic["source"] = ET.SubElement(skeldic["collectionDesc"], "sdo:source")
    skeldic["source"].append(ET.Comment("MovableType Shelfmark:" + headdic["TITLE"]))
    skeldic["correspondence"] = ET.SubElement(skeldic["source"], "sdo:correspondence")
    skeldic["correspondence"].set("shelfmark", "TEST-SHELFMARK1")
    
    # A placeholder for handnotes
    skeldic["handNotes"] = ET.SubElement(skeldic["collectionDesc"], "tei:handNotes")
    skeldic["handNote"] = ET.SubElement(skeldic["handNotes"], "tei:handNote")
    comm_handNote = "Please populate at least one handNote.  Remember to include an xml:id attribute and the scope of the work"
    skeldic["handNote"].append( ET.Comment(comm_handNote))
    
    # Statements of Responsibility
    comm_respStmt = "Add additional or remove unnecessary statements of responsiblity as needed below"
    skeldic["collectionDesc"].append( ET.Comment(comm_respStmt))
    skeldic["respStmt1"] = ET.SubElement(skeldic["collectionDesc"], "tei:respStmt")
    skeldic["respStmt1"].set("xml:id", "IB")
    skeldic["persName"] = ET.SubElement(skeldic["respStmt1"], "tei:persName")
    skeldic["persName"].text = "Ian Bent"
    comm_persName = "Add additional or remove unnecessary specific responsibility notes."
    skeldic["respStmt1"].append( ET.Comment(comm_persName))
    skeldic["resp1"] = ET.SubElement(skeldic["respStmt1"], "tei:resp")
    skeldic["resp1"].text= "Transcription"
    skeldic["resp2"] = ET.SubElement(skeldic["respStmt1"], "tei:resp")
    skeldic["resp2"].text = "XML Encoding"
    skeldic["resp3"] = ET.SubElement(skeldic["respStmt1"], "tei:resp")
    skeldic["resp3"].text = "Translation"
    
    skeldic["respStmt2"] = ET.SubElement(skeldic["collectionDesc"], "tei:respStmt")
    skeldic["respStmt2"].set("xml:id", "BOT")
    skeldic["name"] = ET.SubElement(skeldic["respStmt2"], "tei:name")
    skeldic["name"].text = "Automated Script"
    skeldic["name"] = ET.SubElement(skeldic["respStmt2"], "tei:resp")
    skeldic["name"].text = "Conversion from MovableType syntax to TEI"
    
    # Revision Desc. Note
    comm_revisionDesc = "Add additional change elements below to note major changes to the document"
    skeldic["collectionDesc"].append( ET.Comment(comm_revisionDesc))
    skeldic["revisionDesc"] = ET.SubElement(skeldic["collectionDesc"], "tei:revisionDesc")
    skeldic["change"] = ET.SubElement(skeldic["revisionDesc"], "tei:change")
    skeldic["change"].set("when", time.strftime("%Y-%m-%d", time.localtime()) )
    skeldic["change"].set("who", "#BOT")
    skeldic["change"].text = "Template Generated"

    # Sections
    skeldic["record"] = ET.SubElement(skeldic["root"], "sdo:record")
    skeldic["record"].set("ID", "r0001")
    skeldic["itemDesc"] = ET.SubElement(skeldic["record"], "sdo:itemDesc")
    skeldic["transcription"] = ET.SubElement(skeldic["record"], "tei:transcription")
    skeldic["translation"] = ET.SubElement(skeldic["record"], "tei:translation")
    
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
    stylesheet = ET.ProcessingInstruction("xml-stylesheet", pidic["xml-stylesheet"])
    print >> ofpobj, ET.tostring(dec)
    print >> ofpobj, ET.tostring(stylesheet)
    
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
    
    ofplist = ofp.split("/")
    # generate the right number of "../" after "correspondence/". Needs +2 compensate for first element of list "" and filename 
    levels = ''.join( ["../" for dummy in xrange(len(ofplist)-(ofplist.index("correspondence")+2))] )
    xmlstr = xmlstr.replace('"http://www.cch.kcl.ac.uk/schenker ', '"http://www.cch.kcl.ac.uk/schenker '+ levels)
    xmlstr = xmlstr.replace('href="', 'href="'+ levels)
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

        bdic[k] = re.sub(r"\*\*(.+?)\*\*", '@@otei:hi rend=@@qbold@@q@@c\\1@@o/tei:hi@@c', bdic[k])
        bdic[k] = re.sub(r"\*(.+?)\*", '@@otei:hi rend=@@qbold@@q@@c\\1@@o/tei:hi@@c', bdic[k])
        bdic[k] = re.sub(r"_(.+?)_", '@@otei:hi rend=@@qitalic@@q@@c\\1@@o/tei:hi@@c', bdic[k])
    return bdic

def convertHrefLinks(repf, bdic):
    for k in bdic.keys():
        bdic[k] = re.sub(r"""<a href="\.\./\.\./profile/.+?/(.+?).html">(.+?)</a>""", '@@oref cRef=@@q\\1@@q@@c\\2@@o/ref@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@q@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@u\\3@@q@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)_(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@u\\3@@u\\4@@q@@c', bdic[k])
        bdic[k] = re.sub(r"""cRef=@@q(.+?)_(.+?)_(.+?)_(.+?)_(.+?)@@q@@c""", 'cRef=@@q\\1@@u\\2@@u\\3@@u\\4@@u\\5@@q@@c', bdic[k])
    
    return bdic
    
# CORRESPONDENCE
def createTopComments(repf, bdic):
    
    #dictionary to return
    topcomments = {}
    
    # get copyright info
    copyright_b = re.findall(r"""(©.+)""", bdic["BODY:"])
    copyright_eb = re.findall(r"""(©.+)""", bdic["EXTENDED BODY:"])
    copyright_ex = re.findall(r"""(©.+)""", bdic["EXCERPT:"])
    copyright = copyright_b+copyright_eb+copyright_ex
    
    # escape "--" characters
    bdic["EXCERPT:"] = re.sub(r"""--""", ' - -', bdic["EXCERPT:"])    
    
    # get dcterms elements
    dcterms_license = re.findall(r"""<dcterms:license>.+?</dcterms:license>""", bdic["EXCERPT:"])
    dcterms_provenance = re.findall(r"""<dcterms:provenance>.+?</dcterms:provenance>""", bdic["EXCERPT:"])
    dcterms_rightsHolder = re.findall(r"""<dcterms:rightsHolder>.+?</dcterms:rightsHolder>""", bdic["EXCERPT:"])
    #replace angle brackets
    
    dcterms = dcterms_license+dcterms_provenance+dcterms_rightsHolder
    
    #write results to dictionary
    topcomments["copyright"] = copyright
    topcomments["dcterms"] = dcterms
        
    # get rid of copyright info in body and ext. body	
    bdic["BODY:"] = re.sub(r"""(©.+)""", '', bdic["BODY:"])
    bdic["EXTENDED BODY:"] = re.sub(r"""(©.+)""", '', bdic["EXTENDED BODY:"])
    
    #return
    return topcomments, bdic
    

# The various dc elements can at times contain mixed content owing to their source in the MT records.
# This method strips the mixed content so that a greater number of files will validate.

def stripDCMixedContent(toBeStripped):
    toBeStripped = re.sub(r"""(?:@@otei:hi.*?@@c)""", '', toBeStripped)
    toBeStripped = re.sub(r"""(?:@@o/tei:hi@@c)""", '', toBeStripped)

    return toBeStripped

# CORRESPONDENCE
def createItemDescription(repf, hdic, bdic):
	
	# escape "--" characters
	bdic["EXCERPT:"] = re.sub(r"""--""", ' - -', bdic["EXCERPT:"])    
	
	itemDescElements = {}

        # Include a comment with the MovableType tags, if they have been tracked 
        if hdic.has_key("TAGS"):
	    itemDescElements["COMM_tags"] = "MT Tags: " + hdic["TAGS"] 
	
	# title
	# With current source, the warning never appears. There is always a match (2009-11-05)
	dc_title = re.search(r"""<dc:title>(.*?)</dc:title>""", bdic["EXCERPT:"])
	if dc_title == None:
		dc_title = re.search(r"""^(.*?)\n""", bdic["BODY:"])
	if dc_title != None:
		dc_title = dc_title.group(1)
	else:
		dc_title = "@@o!-- Enter title here --@@c"

        dc_title = stripDCMixedContent(dc_title)
		
	itemDescElements["dc:title"] = dc_title.decode("utf8")
	
	# date of creation
	# With current source, hdic["DATE"] always returns the value (2009-11-05)
	dc_created = hdic["DATE"]
	if dc_created == "":
		dc_created = re.search(r"""<dcterms:created>(.*?)</dcterms:created>""", bdic["EXCERPT:"])
		if dc_created != None:
			dc_created = dc_created.group(1)
		else:
			dc_created = "@@o!-- Enter date of creation here --@@c"
	
	itemDescElements["COMM_created"] = "Date Created: " + dc_created.decode("utf8")
	
	# date authored
	# With current source, several missing (2009-11-05)
	dc_datesub = re.search(r"""<dcterms:dateSubmitted>(.*?)</dcterms:dateSubmitted>""", bdic["EXCERPT:"])
	if dc_datesub != None:
		dc_datesub = dc_datesub.group(1)
	else:
		dc_datesub = "@@o!-- Enter date of submission here --@@c"
		
	itemDescElements["dcterms:dateSubmitted"] = dc_datesub.decode("utf8")
	
	# description
	# With current source, several missing (63) (2009-11-05)
	dc_desc = re.search(r"""(?s)SUMMARY.*?\n(.*?)(©|-{4,})""", bdic["EXCERPT:"])
	if dc_desc != None:
		dc_desc = dc_desc.group(1)
	else:
		dc_desc = ""

        dc_desc = stripDCMixedContent(dc_desc)		
	itemDescElements["dc:description"] = dc_desc.decode("utf8")
	
	# subjects
	# With current source, several missing (2009-11-05)
	dc_subjects = re.search(r"""<dc:subject>(.*?)</dc:subject>""", bdic["EXCERPT:"])
	if dc_subjects != None:
		dc_subjects = dc_subjects.group(1)
	else:
		dc_subjects = "@@o!-- Enter subjects here --@@c"
		
	itemDescElements["dc:subject"] = dc_subjects.decode("utf8")
	
	# sender
	sender = re.search(r"""(?:@@otei:hi.*?@@c)?([Ss]ender( address)?:?)(?:@@o/tei:hi@@c)?(.*?)\n""", bdic["EXCERPT:"])
	if sender != None:
		if sender.group(3) != None:
			sender = sender.group(3)
	else:
		sender = ""
		
	itemDescElements["marcrel:correspondent"] = sender.decode("utf8")
	
	# recipient
	recipient = re.search(r"""(?:@@otei:hi.*?@@c)?([Rr]ecipient( address)?:?)(?:@@o/tei:hi@@c)?(.*?)\n""", bdic["EXCERPT:"])
	if recipient != None:
		if recipient.group(3) != None:
			recipient = recipient.group(3)
	else:
		recipient = ""
		
	itemDescElements["marcrel:recipient"] = recipient.decode("utf8")
	
	return itemDescElements
		
	
    
# CORRESPONDENCE
def convertFootnotes(repf, bdic):
    # Find footnotes
    footnotes = re.findall(r"""fn(\d+)\.?(.+?)\n""", bdic["EXCERPT:"])
    for fn in footnotes:
	bdic["BODY:"] = re.sub(re.compile('\['+fn[0]+'\]'), '@@otei:note xml:id=@@qr0001-fn'+fn[0]+'@@q@@c'+fn[1]+'@@o/tei:note@@c', bdic["BODY:"])
	bdic["EXTENDED BODY:"] = re.sub(re.compile('\['+fn[0]+'\]'), '@@otei:ptr target=@@q#r0001-fn'+fn[0]+'@@q/@@c', bdic["EXTENDED BODY:"])	
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

def processConvertedBody(repf, hdic, bdic, tc, ide, xmldic):

    # 1. Assign the parts to their elements
	
    for bodytype in bodyheaderslist:
        if bdic.has_key(bodytype):
            # oxy = ET.ProcessingInstruction("oxygen", pidic["oxygen"])
            # print >> ofpobj, ET.tostring(dec)
	    if bodytype == "BODY:":
		comm = ET.Comment(bodytype)
		xmldic["transcription"].append(comm)
	        parslist = re.split("\n\n+", bdic[bodytype])
	        for par in parslist:
		    par = par.strip()
		    if par != "":
		        parel = ET.SubElement(xmldic["transcription"], "tei:p")
		        # parel.text = par
		        parel.text = par.decode("utf8")
	    elif bodytype == "EXTENDED BODY:":
		comm = ET.Comment(bodytype)
		xmldic["translation"].append(comm)
	        parslist = re.split("\n\n+", bdic[bodytype])
	        for par in parslist:
		    par = par.strip()
		    if par != "":
		        parel = ET.SubElement(xmldic["translation"], "tei:p")
		        # parel.text = par
		        parel.text = par.decode("utf8")
	    
    # 2. Further XML addition and processing
    
    # Add dcterms in comment first elemetn in sdo:record
    dcterms_comm = '\n'+'\n'.join(tc["dcterms"])+'\n'
    dcterms_comm = dcterms_comm.replace("<", "@@o")
    dcterms_comm = dcterms_comm.replace(">", "@@c")
    xmldic["record"].insert(0, ET.Comment(dcterms_comm.decode("utf8")))
    
    # Add copyright info in comment before first elemetn in sdo:record
    copyright_comm = '\n'+'\n'.join(tc["copyright"])+'\n'
    xmldic["record"].insert(0, ET.Comment(copyright_comm.decode("utf8")))
    
    # Add Item Description Elements
    for key in ide:
	    if key.startswith("COMM") :
		    xmldic["itemDesc"].append(ET.Comment(ide[key])) 
  
    xmldic["dctitle"] = ET.SubElement(xmldic["itemDesc"],"dc:title")
    xmldic["dctitle"].text = ide["dc:title"] 
    xmldic["dcdatesubmit"] = ET.SubElement(xmldic["itemDesc"],"dcterms:dateSubmitted")
    xmldic["dcdatesubmit"].text = ide["dcterms:dateSubmitted"]
    xmldic["dcdesc"] = ET.SubElement(xmldic["itemDesc"],"dc:description")
    xmldic["dcdesc"].text = ide["dc:description"]
    xmldic["dcsubject"] = ET.SubElement(xmldic["itemDesc"],"dc:subject")
    xmldic["dcsubject"].text = ide["dc:subject"]
    # Add marcrel elements in Item Description
    xmldic["itemDesc"].append(ET.Comment("Add the EATS key attribute value to indicate the sender of the letter")) 
    xmldic["mr_correspondent"] = ET.SubElement(xmldic["itemDesc"], "marcrel:correspondent")
    xmldic["mr_correspondent"].set("key", "EATS_nNNNNNN")
    xmldic["mr_correspondent"].text = ide["marcrel:correspondent"] 
    xmldic["itemDesc"].append(ET.Comment("Add the key attribute to indicate the recipient of the letter")) 
    xmldic["mr_recipient"] = ET.SubElement(xmldic["itemDesc"], "marcrel:recipient")
    xmldic["mr_recipient"].set("key", "EATS_nNNNNNN")
    xmldic["mr_recipient"].text = ide["marcrel:recipient"] 


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
    
    # conversion functions
    bodydic = getBodyParts(repf, bd)
    bodydic = convertHtmlFormats(repf, bodydic)   
    bodydic = convertHrefLinks(repf, bodydic)
    bodydic = convertWikiFormats(repf, bodydic)
    bodydic = convertFootnotes(repf, bodydic)
    topComments, bodydic = createTopComments(repf, bodydic)
    itemDescElements = createItemDescription(repf, hdic, bodydic)
    
    
    # split the processed record
    processConvertedBody(repf, hdic, bodydic, topComments, itemDescElements, xmlskeldic)
    
    # write out
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
            if headdic.has_key("TITLE"):
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
