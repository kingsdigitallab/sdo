"""Create entities in EATS based on the information in a CSV file."""

import csv
import os
import sys

from eatsml.dispatcher import Dispatcher


# CSV file format properties.
DELIMITER = ','
QUOTE_CHAR = '"'

# EATS server details.
SERVER_URL = 'http://localhost:8000/'
USERNAME = 'jamie'
PASSWORD = 'password'


def main ():
    dispatcher = Dispatcher(SERVER_URL, USERNAME, PASSWORD)
    dispatcher.login()
    eats_data = get_eats_data(dispatcher)
    csv_reader = csv.reader(open(sys.argv[2], 'b'), delimiter=DELIMITER,
                            quotechar=QUOTE_CHAR)
    entity_type = sys.argv[1]
    profile_dir = sys.argv[3]
    for entry in csv_reader:
        process_entry(dispatcher, eats_data, entity_type, entry, profile_dir)

def get_eats_data (dispatcher):
    """Return a dictionary of EATS data to be used in the creation of
    all entities."""
    doc = dispatcher.get_base_document()
    eats_data = {}
    eats_data['authority'] = doc.get_default_authority()
    eats_data['entity_types'] = {}
    for entity_type in doc.get_entity_types():
        eats_data['entity_types'][unicode(entity_type)] = entity_type
    eats_data['name_type'] = doc.get_name_types()[0]
    eats_data['name_part_types'] = {}
    for name_part_type in doc.get_name_part_types():
        eats_data['name_part_types'][name_part_type.text] = name_part_type
    eats_data['languages'] = {}
    for language in doc.get_languages():
        eats_data['languages'][language.name] = language
    eats_data['scripts'] = {}
    for script in doc.get_scripts():
        eats_data['scripts'][script.name] = script
    return eats_data

def process_entry (dispatcher, eats_data, entity_type, entry, profile_dir):
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
        entity_Type=eats_data['entity_types'][entity_type], is_preferred=True)
    add_names(entity, entry, eats_data, authority_record, entity_type)
    message = 'Created new entity "%s" from CSV authority list.' % entry[2]
    url = dispatcher.import_document(doc, message.encode('utf-8'))
    rename_profile(dispatcher, profile_dir, entry[-1], url)

def add_names (entity, entry, eats_data, authority_record, entity_type):
    count = 1
    # The first name is the preferred one.
    add_name(entity, entry[2], authority_record, eats_data, True, entity_type,
             count)
    count = count + 1
    for name in entry[3:-1]:
        name = name.strip()
        if name:
            add_name(entity, name, authority_record, eats_data, False,
                     entity_type, count)
            count = count + 1

def add_name (entity, name, authority_record, eats_data, is_preferred,
              entity_type, count):
    name_type = eats_data['name_type']
    language = eats_data['languages']['German']
    script = eats_data['scripts']['Latin']
    display_form = name
    name_parts = {}
    if entity_type == 'person':
        parts = name.split()
        if len(parts) > 1:
            name_parts['given'] = parts[:-1].join(' ')
            name_parts['family'] = parts[-1]
            display_form = ''
    assertion_id = 'new_name_assertion_%d' % count
    name = entity.create_name(
        assertion_id, authority_record=authority_record, name_type=name_type,
        is_preferred=is_preferred)
    name.display_form = display_form
    name.language = language
    name.script = script
    for name_part_type, name_part in name_parts.items():
        name.create_name_part(eats_data['name_part_types'][name_part_type],
                              name_part)

def rename_profile(dispatcher, profile_dir, profile, url):
    """Rename the profile file to the key specified by the import at url."""
    eatsml = dispatcher.get_processed_import(url)
    entity = eatsml.get_entities()[0]
    key = entity.get_default_authority_records()[0].system_id
    old_file = os.path.join(profile_dir, '%s.xml' % profile)
    new_file = os.path.join(profile_dir, '%s.xml' % key)
    os.rename(old_file, new_file)


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print 'This script takes three arguments:\n  * the entity type; and\n  * the CSV file; and\n  * the path to the directory containing the profiles for the specified entity type.'
        sys.exit()
    main()
