"""Create entities in EATS based on the information in a CSV
file. Rename the associated profile page to match the new entity key,
and change its root xml:id."""

import csv
import os.path
import subprocess
import sys

from lxml import etree

from eatsml.dispatcher import Dispatcher


# CSV file format properties.
DELIMITER = ','
QUOTE_CHAR = '"'

# EATS server details.
SERVER_URL = 'http://localhost:8000/eats/'
USERNAME = 'jamie'
PASSWORD = 'password'

# XML namespace.
XML_NAMESPACE = 'http://www.w3.org/XML/1998/namespace'
XML = '{%s}' % XML_NAMESPACE


def main ():
    profile_dir = os.path.abspath(os.path.realpath(sys.argv[3]))
    if not os.path.isdir(profile_dir):
        print '%s does not exist.' % sys.argv[3]
        sys.exit(2)
    dispatcher = Dispatcher(SERVER_URL, USERNAME, PASSWORD)
    dispatcher.login()
    eats_data = get_eats_data(dispatcher)
    csv_reader = csv.reader(open(sys.argv[2], 'rb'), delimiter=DELIMITER,
                            quotechar=QUOTE_CHAR)
    entity_type = sys.argv[1]
    is_first_line = True
    for entry in csv_reader:
        if not is_first_line:
            # Because each CSV file (there is one per entity type) has
            # its own structure, extract all information from the
            # entry into variables first, to abstract away the
            # differences.
            names = get_names_from_entry(entry, entity_type)
            profile = get_profile_from_entry(entry, entity_type)
            process_entry(dispatcher, eats_data, entity_type, names,
                          profile, profile_dir)
        is_first_line = False

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

def get_names_from_entry (entry, entity_type):
    """Return a list of names for the entry. The entity type
    determines the structure of the CSV file."""
    names = []
    if entity_type in ('person', 'work'):
        names = entry[2:-1]
    elif entity_type == 'composition':
        names = entry[3:]
    return names

def get_profile_from_entry (entry, entity_type):
    """Return the profile name for the entry. The entity type
    determines the structure of the CSV file."""
    profile = ''
    if entity_type in ('person', 'work'):
        profile = entry[-1]
    return profile

def process_entry (dispatcher, eats_data, entity_type, names, profile,
                   profile_dir):
    """Process the entry, creating an entity and changing any
    associated profile."""
    import_url = create_entity(dispatcher, eats_data, entity_type, names)
    if profile:
        key = get_key(dispatcher, import_url)
        if key is not None:
            filename = rename_profile(profile_dir, profile, key)
            update_id(filename, key)

def create_entity (dispatcher, eats_data, entity_type, names):
    """Create an entity in EATS."""
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
        entity_type=eats_data['entity_types'][entity_type], is_preferred=True)
    add_names(entity, names, eats_data, authority_record, entity_type)
    message = 'Created new entity "%s" from CSV authority list.' \
        % names[0].decode('utf-8')
    url = dispatcher.import_document(doc, message.encode('utf-8'))
    return url
    
def add_names (entity, names, eats_data, authority_record, entity_type):
    """Add names to entity."""
    count = 1
    # The first name is the preferred one.
    is_preferred = True
    for name in names[1:]:
        name = name.strip()
        if name:
            add_name(entity, name, authority_record, eats_data, is_preferred,
                     entity_type, count)
            is_preferred = False
            count = count + 1

def add_name (entity, name, authority_record, eats_data, is_preferred,
              entity_type, count):
    """Add name to entity."""
    name = name.decode('utf-8')
    name_type = eats_data['name_type']
    language = eats_data['languages']['German']
    script = eats_data['scripts']['Latin']
    display_form = name
    name_parts = {}
    if entity_type == 'person':
        parts = name.split()
        if len(parts) > 1:
            name_parts['given'] = ' '.join(parts[:-1])
            name_parts['family'] = parts[-1]
            display_form = ''
    assertion_id = 'new_name_assertion_%d' % count
    name_obj = entity.create_name(
        assertion_id, authority_record=authority_record, name_type=name_type,
        is_preferred=is_preferred)
    name_obj.display_form = display_form
    name_obj.language = language
    name_obj.script = script
    for name_part_type, name_part in name_parts.items():
        try:
            name_obj.create_name_part(
                eats_data['name_part_types'][name_part_type], name_part)
        except Exception, e:
            print 'Failed creating name part "%s" in %s: %s' \
                % (name_part, name, e)

def get_key (dispatcher, url):
    """Return the key (authority record system id) for the new
    entity."""
    eatsml = dispatcher.get_processed_import(url)
    entity = eatsml.get_entities()[0]
    key = entity.get_default_authority_records()[0].system_id
    return key

def rename_profile (profile_dir, profile, key):
    """Rename the profile file to the key specified by the import at
    url. Return the new filename."""
    old_file = os.path.join(profile_dir, '%s.xml' % profile)
    new_file = os.path.join(profile_dir, '%s.xml' % key)
    args = ['svn', 'rename', old_file, new_file]
    try:
        subprocess.check_call(args)
    except Exception, e:
        print 'Failed to SVN rename %s to %s: %s' % (old_file, new_file, e)
        sys.exit(2)
    return new_file

def update_id (filename, xml_id):
    """Change the root xml:id in filename to xml_id."""
    tree = etree.parse(filename)
    tree.getroot().set(XML + 'id', xml_id)
    output = open(filename, 'w')
    tree.write(output, encoding='utf-8', pretty_print=True,
               xml_declaration=True)
    output.close()
    

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print 'This script takes three arguments:\n  * the entity type; and\n  * the CSV file; and\n  * the path to the directory containing the profiles for the specified entity type.'
        sys.exit(2)
    main()
