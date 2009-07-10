#!/usr/bin/env python

# extract MoveableType profile information and write to TEI XML file

import sys
import string
import re
import time
import os, os.path
from xml.etree import ElementTree as ET

#####################################
# GLOBAL CONSTANTS
#####################################

# MoveableType data file
mtfile = "/projects/cch/schenker/data/movable-type/schenker_documents_online.txt"
outpath = "/projects/cch/schenker/data/profiles"
logpath = "/projects/cch/schenker/src/python/logs"

# declarations at beginning of XML file
pidic = {
         "xml" : 'version="1.0"',
         "oxygen" : 'RNGSchema="../../../../schema/tei/xmod_web.rnc" type="compact"'
        }

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

# categories, after "PRIMARY CATEGORY:", that determine if an entry is a profile
profileprimcatlist = [
                      "Company",
                      "Work",
                      "Title",
                      "Person",
                      "Place",
                      "Organization",
                      "Institution"
                      ]

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


def insertIntoHeadFreqDict(k):
    if hfreqdic.has_key(k):
        hfreqdic[k] += 1
    else:
        hfreqdic[k] = 1

def printHeadKeyStats(fh):
    printCF(fh, 1, "-" * 50)
    for k in hfreqdic.keys():
        printCF(fh, 1, "%20s : %d" % (k, hfreqdic[k]))

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
    # build a tree structure
    root = ET.Element("TEI")
    root.set("xmlns", "http://www.tei-c.org/ns/1.0")
    root.set("xml:id", "p1_1_1_2")
    root.set("xmlns:xmt", "http://www.cch.kcl.ac.uk/xmod/tei/1.0")
    
    pi = ET.ProcessingInstruction("oxygen", "xxx")
    # root.append(pi)
    print ET.tostring(pi)

    
    teiHeader = ET.SubElement(root, "teiHeader")
    fileDesc = ET.SubElement(teiHeader, "fileDesc")
    titleStmt = ET.SubElement(teiHeader, "titleStmt")
    title = ET.SubElement(titleStmt, "title")
    respStmt = ET.SubElement(titleStmt, "respStmt")
    resp = ET.SubElement(respStmt, "resp")
    respdate = ET.SubElement(resp, "date")
    name = ET.SubElement(respStmt, "name")
    publicationStmt = ET.SubElement(teiHeader, "publicationStmt")
    publisher = ET.SubElement(publicationStmt, "publisher")
    address = ET.SubElement(publicationStmt, "address")
    addrLine1 = ET.SubElement(address, "addrLine")
    addrLine2 = ET.SubElement(address, "addrLine")
    notesStmt = ET.SubElement(teiHeader, "notesStmt")
    note1 = ET.SubElement(notesStmt, "note")
    note2 = ET.SubElement(notesStmt, "note")
    sourceDesc = ET.SubElement(teiHeader, "sourceDesc")
    psource = ET.SubElement(sourceDesc, "p")
    encodingDesc = ET.SubElement(teiHeader, "encodingDesc")
    pencoding = ET.SubElement(encodingDesc, "p")
    revisionDesc = ET.SubElement(teiHeader, "revisionDesc")
    change1 = ET.SubElement(revisionDesc, "change")
    change1date = ET.SubElement(change1, "date")
    change1desc = ET.SubElement(change1, "desc")

    # CONSTANTS
    resp.text = 'published in Movable Type'
    publisher.text = 'Schenker Documents Online in association with the Centre for Computing in the Humanities'
    addrLine1.text = 'http://www.schenkerdocumentsonline.org'
    addrLine2.text = 'http://www.kcl.ac.uk/cch/'
    psource.text = 'No source: created in electronic format.'
    pencoding.text = 'Encoding according to the CCH TEI Guidelines'
    change1desc.text = 'Automatic Conversion from Movable Type'
    
    text = ET.SubElement(root, "text")
    body = ET.SubElement(text, "body")
    head = ET.SubElement(body, "head")
    div  = ET.SubElement(body, "div")
    
    # title = ET.SubElement(head, "title")
    # title.text = "Page Title"
    
    # body = ET.SubElement(root, "body")
    # body.set("bgcolor", "#ffffff")
    
    # body.text = "Hello, World!"
    
    # wrap it in an ElementTree instance, and save as XML
    # tree = ET.ElementTree(root)
    # tree.write(logpath + "/" + "page.xhtml")
    return root

def writeXMLFile(repf, ofp, root):
    printCF(repf, 1, "writing to file '%s'" % (ofp, ))

    ofpobj = file(ofp, "w")

    # write declarations
    dec = ET.ProcessingInstruction("xml", pidic["xml"])
    oxy = ET.ProcessingInstruction("oxygen", pidic["oxygen"])
    print >> ofpobj, ET.tostring(dec)
    print >> ofpobj, ET.tostring(oxy)
    
    tree = ET.ElementTree(root)
    tree.write(ofpobj)

def processProfile(repf, hdic, bd):
    xmlroot = buildXMLSkeleton()
    if not hdic.has_key("BASENAME"):
        basename = "CCHPROVIDED"
    else:
        basename = hdic["BASENAME"]
    # in case basename is duplicated (i. e. it is in basenameslist)
    # generate unique basename by adding current date and time
    if basename in basenameslist:
        basename += "-" + time.strftime("%Y%m%d%H%M", time.localtime())
    basenameslist.append(basename)
    outfilepath = os.path.join(outpath, basename + ".xml")
    writeXMLFile(repf, outfilepath, xmlroot)
    # print hdic["PRIMARY CATEGORY"]

if __name__ == '__main__':
    checkDirs()
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
        if (headdic.has_key("PRIMARY CATEGORY")) and (headdic["PRIMARY CATEGORY"] in profileprimcatlist):
            printCF(repf, 1, "processing entry #%d" % (entrynum
                                                       , ))
            processProfile(repf, headdic, body)
    
    printHeadKeyStats(repf)
    
    
    repf.close()
    print "--== FINISHED ==--"
