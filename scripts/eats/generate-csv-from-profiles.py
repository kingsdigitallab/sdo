#!/usr/bin/env python

"""Create a CSV file from the profile files in a directory."""

import csv
import glob
import os.path
import re
import sys

from lxml import etree

# CSV file format properties.
DELIMITER = ','
QUOTE_CHAR = '"'

TEI_NAMESPACE = 'http://www.tei-c.org/ns/1.0'
NSMAP = {'tei': TEI_NAMESPACE}

GET_PROFILE_NAME = etree.XPath('/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type="file"]/tei:term', namespaces=NSMAP)

MULTIPLE_WHITESPACE = re.compile(r'\s+')

def main (profile_type, directory):
    csv_filename = '%s.csv' % profile_type
    writer = csv.writer(open(csv_filename, 'wb'), delimiter=DELIMITER,
                        quotechar=QUOTE_CHAR, quoting=csv.QUOTE_ALL)
    writer.writerow(['Name', 'Profile'])
    filename_pattern = os.path.abspath(os.path.join(directory, '*.xml'))
    for filename in glob.glob(filename_pattern):
        process_profile(writer, filename)

def process_profile (writer, filename):
    profile = etree.parse(filename)
    name = GET_PROFILE_NAME(profile)[0].text
    name = MULTIPLE_WHITESPACE.sub(' ', name).encode('utf-8')
    writer.writerow([name, os.path.splitext(os.path.basename(filename))[0]])


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print 'This script takes two arguments: the type of profile and the profile directory'
        sys.exit(2)
    profile_type = sys.argv[1]
    directory = sys.argv[2]
    main(profile_type, directory)
