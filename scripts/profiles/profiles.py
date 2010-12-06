'''
Created on Dec 06, 2010

@author: jvieira jose.m.vieira@kcl.ac.uk

Creates an XML file with a mapping between the entity key and the entity name.
'''
import logging
import sys
import os

from lxml import etree

# xpath expression to select the title from the XML document
TITLE_XPATH = 'normalize-space(string(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@*)]))'

#
def main():
    # reads input arguments
    # the profile name
    profile_name = sys.argv[1]

    # the profile directory
    profile_dir_path = sys.argv[2]

    # checks the profile directory exists
    if not os.path.isdir(profile_dir_path):
        print 'directory not found %s' % profile_dir_path
        sys.exit(1)

    # creates the mapping XML
    root = etree.Element('entities')
    root.set('type', profile_name)

    # for each file in the directory
    for f in os.listdir(profile_dir_path):
        # gets the filename and the extension of the current file
        (filename, ext) = os.path.splitext(os.path.basename(f))

        # checks it's an XML file
        if ext == '.xml':
            # parses the XML file
            xml = etree.parse(os.path.join(profile_dir_path, f))

            # checks if the parse succeeded
            if xml is not None:
                # gets the title
                title = xml.xpath(TITLE_XPATH, namespaces = {'tei': 'http://www.tei-c.org/ns/1.0'})

                # checks the title
                if title:
                    # adds and entity to the mapping XML
                    entity = etree.SubElement(root, 'entity')
                    # adds the id as an attribute
                    entity.set('id', filename)
                    # adds the title to the entity
                    entity.text = title.strip()

    # creates a new file
    xml_file = open(profile_name + '.xml', 'w')
    
    # writes the mapping XML into the file
    xml_file.write(etree.tostring(root, encoding = 'utf-8', pretty_print = True))
    
    xml_file.close()

#
if __name__ == '__main__':
    if len(sys.argv) != 3:
        print 'This script takes two arguments: profile name and profile directory'
        sys.exit(1)

    main()
