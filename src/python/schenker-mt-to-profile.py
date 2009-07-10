#!/usr/bin/env python

# extract MoveableType profile information and write to TEI XML file

import sys
import string
import re
import time
import os, os.path

# MoveableType data file
mtfile = "/projects/cch/schenker/data/movable-type/schenker_documents_online.txt"

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

hfreqdic = {}

def insertIntoHeadFreqDict(k):
    if hfreqdic.has_key(k):
        hfreqdic[k] += 1
    else:
        hfreqdic[k] = 1

def printHeadKeyStats():
    print "-" * 50
    for k in hfreqdic.keys():
        print k, hfreqdic[k]

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

def processProfile(hdic, bd):
    print hdic["PRIMARY CATEGORY"]

if __name__ == '__main__':
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
        # print headdic
        if (headdic.has_key("PRIMARY CATEGORY")) and (headdic["PRIMARY CATEGORY"] in profileprimcatlist):
            processProfile(headdic, body)
    
    # printHeadKeyStats()
    print "--== FINISHED ==--"
