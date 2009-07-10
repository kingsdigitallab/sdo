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
            else:
                colonpos = line.find(":")
                # we want at least one character before the colon
                if colonpos > 1:
                    k = line[:colonpos]
                    v = line[colonpos+1:]
                    k = k.strip()
                    v = v.strip()
                    print k, v
                    hdic[k] = v
    return hdic

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
        print headdic
#    mtlinelist = mtcont.split("\n")
#    print len(mtlinelist)
#    print mtcont.count("\n")
#    for linenum, line in enumerate(mtlinelist):
#        if line == mtentrysep1:
#            lineaftersep = mtlinelist[linenum+1]
#            if lineaftersep.startswith(mtentrysep2):
#                print linenum, line, lineaftersep
    print "--== FINISHED ==--"
