#!/usr/bin/env python

"""Create EATS entities for each of the XML profile files in the
specified directories."""

import glob
from os.path import abspath, join
import sys

from lxml import etree


from eatsml.dispatcher import Dispatcher


SERVER_URL = 'http://localhost/sdo/eats/'
USERNAME = 'jamie'
PASSWORD = ''

TEI_NAMESPACE = 'http://www.tei-c.org/ns/1.0'
NSMAP = {'tei': TEI_NAMESPACE}

GET_PROFILE_NAME = etree.XPath('tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type="file"]/tei:term', namespace=NSMAP)


def main ():
    dispatcher = Dispatcher(SERVER_URL, USERNAME, PASSWORD)
    dispatcher.login()
    eats_data = get_eats_data(dispatcher)
    dirs = sys.argv[1:]
    for directory in dirs:
        filename_pattern = abspath(join(directory, '*.xml'))
        for filename in glob.glob(filename_pattern):
            process_profile(dispatcher, filename, eats_data, directory)

def get_eats_data (dispatcher):
    """Return a dictionary of EATS data to be used in the creation of
    all entities."""
    doc = dispatcher.get_base_document()
    eats_data = {}
    eats_data['authority'] = doc.get_default_authority()
    eats_data['name_type'] = doc.get_name_types()[0]
    eats_data['entity_types'] = {}
    for entity_type in doc.get_entity_types():
        eats_data['entity_types'][unicode(entity_type)] = entity_type
    return eats_data
    
def process_profile (dispatcher, filename, eats_data, entity_type):
    """Create an EATS entity from the information in the profile at
    `filename`."""
    profile = etree.parse(filename)
    profile_data = {}
    name = GET_PROFILE_NAME(profile)[0]
    doc = dispatcher.get_base_document_copy()
    authority_record = doc.create_authority_record(
        id='new_authority_record', authority=eats_data['authority'])
    authority_record.set_auto_create_data()
    entity = doc.create_entity(id='new_entity')
    entity.create_existence(
        id='new_existence_assertion', authority_record=authority_record,
        is_preferred=True)
    entity.create_entity_type(
        id='new_entity_type_assertion', authority_record=authority_record,
        entity_type=profile_data['entity_type'], is_preferred=True)
    name = entity.create_name(
        'new_name_assertion', authority_record=authority_record,
        name_type=eats_data['name_type'], is_preferred=True)
    name.display_form = profile_data['display_form']
    for name_part_type in ('terms_of_address', 'given_name', 'family_name'):
        if eats_data[name_part_type]:
            name.create_name_part(eats_data[name_part_type],
                                  profile_data[name_part_type])
    message_name = profile_data['display_form']
    if not message_name:
        message_name = ' '.join([profile_data['given_name'],
                                 profile_data['family_name']]).strip()
    message = 'Created new entity "%s" from lookup.' % message_name
    url = dispatcher.import_document(doc, message)
    eatsml = dispatcher.get_processed_import(url)
    entity = eatsml.get_entities()[0]

    

if __name__ == '__main__':
    main()
