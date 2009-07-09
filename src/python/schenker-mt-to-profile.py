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

if __name__ == '__main__':
    # get file object to read MoveableType file
    mtfobj = file(mtfile, "r")
    mtcont = mtfobj.read()
    mtfobj.close()
    mtlinelist = mtcont.split("\n")
    print len(mtlinelist)
    print mtcont.count("\n")
    for linenum, line in enumerate(mtlinelist):
        if line == mtentrysep1:
            lineaftersep = mtlinelist[linenum+1]
            if lineaftersep.startswith(mtentrysep2):
                print linenum, line, lineaftersep
    print "--== FINISHED ==--"
