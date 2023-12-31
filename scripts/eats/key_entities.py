#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Key marked up names in the XML files passed in on the commandline."""

import glob
import re
import sys

from lxml import etree

from eatsml.dispatcher import Dispatcher


SERVER_URL = 'http://sdo-data.cch.kcl.ac.uk/eats/'
USERNAME = 'cchguest'
PASSWORD = 'guestcch'
HTTP_USERNAME = ''
HTTP_PASSWORD = ''

TEI_NAMESPACE = 'http://www.tei-c.org/ns/1.0'
NSMAP = {'tei': TEI_NAMESPACE}

GET_COMMENTS = etree.XPath('descendant::comment()[1] | following-sibling::node()[1][self::comment()]')
GET_PEOPLE = etree.XPath('//tei:persName[not(@key)]', namespaces=NSMAP)
GET_ORGANISATIONS = etree.XPath('//tei:orgName[not(@key)]', namespaces=NSMAP)
GET_PLACES = etree.XPath('//tei:placeName[not(@key)]', namespaces=NSMAP)
GET_TITLES = etree.XPath('//tei:rs[@type="title"][not(@key)]', namespaces=NSMAP)
GET_WORKS = etree.XPath('//tei:rs[@type="work"][not(@key)]', namespaces=NSMAP)
GET_TERMS = etree.XPath('//tei:rs[@type="musical-term"][not(@key)]',
                        namespaces=NSMAP)
GET_COMPOSITIONS = etree.XPath('//tei:rs[@type="musical-composition"][not(@key)]',
                               namespaces=NSMAP)

NAME = re.compile(r'^(\[D\S+\s+(?P<name1>[^\]]*)\])|(profile:\s+(?P<name2>.*))$')

KEY_CACHE = {}

def main ():
    dispatcher = Dispatcher(SERVER_URL, USERNAME, PASSWORD, HTTP_USERNAME, HTTP_PASSWORD)
    dispatcher.login()
    filenames = []
    for arg in sys.argv[1:]:
        filenames.extend(glob.glob(arg))
    for filename in filenames:
        process_file(filename, dispatcher)

def process_file (filename, dispatcher):
    tree = etree.parse(filename)
    people = GET_PEOPLE(tree)
    organisations = GET_ORGANISATIONS(tree)
    places = GET_PLACES(tree)
    titles = GET_TITLES(tree)
    works = GET_WORKS(tree)
    terms = GET_TERMS(tree)
    compositions = GET_COMPOSITIONS(tree)
    entities = people + organisations + places + titles + works + terms + \
        compositions
    needs_save = False
    for entity in entities:
        try:
            modified = key_element(dispatcher, entity)
            if modified:
                needs_save = True
        except Exception:
            # If the element cannot be keyed, for whatever reason,
            # just move on to the next element.
            pass
    # Save the processed file.
    if needs_save:
        fh = open(filename, 'w')
        tree.write(fh, encoding='utf-8', pretty_print=True,
                   xml_declaration=True)
        fh.close()

def key_element (dispatcher, element):
    """Find and add the key for the entity marked up in element."""
    modified = False
    # Extract the name to look up from the immediately following
    # comment, not from the content of the element.
    comments = GET_COMMENTS(element)
    # If there is no comment, or more on than one, don't bother even
    # trying to find a matching entity.
    if len(comments) == 1:
        name = get_name(comments[0].text)
        modified = set_key(dispatcher, element, name)
    elif element.get('n'):
        name = element.get('n')
        modified = set_key(dispatcher, element, name)
        if modified:
            del element.attrib['n']
    return modified

def set_key (dispatcher, element, name):
    """Set key, looking it up in the cache or in EATS. Return boolean
    of whether the element has been modified."""
    modified = False
    if name is None:
        key = None
    elif name in KEY_CACHE:
        key = KEY_CACHE[name]
    else:
        key = get_key_from_lookup(dispatcher, name)
        KEY_CACHE[name] = key
    if key is not None:
        element.set('key', key)
        modified = True
    return modified    

def get_key_from_lookup (dispatcher, name):
    """Return the key for the entity with name, or None if there is
    some problem."""
    key = None
    eatsml = dispatcher.look_up_name(name)
    matches = eatsml.get_entities()
    # If there are multiple matches, we're not in a position to chosee
    # among them, and if there are no matches there's no key at all.
    if len(matches) == 1:
        keys = [record.system_id for record in
                matches[0].get_default_authority_records()]
        # A single entity may have multiple authority records
        # associated with it, which we cannot choose among.
        if len(keys) == 1:
            key = keys[0]
    return key

def get_name (comment):
    """Return the entity name from the comment string.

    >>> get_name(' profile: Heinrich Schenker ')
    u'Heinrich Schenker'
    >>> get_name('Heinrich Schenker')
    >>> get_name('[DIn]')
    >>> get_name('[DPe Schenker, Wilhelm]')
    u'Schenker, Wilhelm'
    >>> get_name('[DPl Kiev]')
    u'Kiev'
    >>> get_name(' profile: Café Vindobona ')
    u'Café Vindobona'
    
    """
    name = None
    match = NAME.search(comment.strip().decode('utf-8'))
    if match is not None:
        name = match.group('name1')
        if name is None:
            name = match.group('name2')
    return name


if __name__ == '__main__':
    import doctest
    doctest.testmod()
    main()
