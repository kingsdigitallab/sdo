#!/bin/sh

###################################
# Generate CSV files from profiles.

python generate-csv-from-profiles.py place /sdo/dev/website/webapp/xml/content/profiles/place/

python generate-csv-from-profiles.py organization /sdo/dev/website/webapp/xml/content/profiles/organization/


##################################
# Import entities from CSV files.

python create_entities_from_csv.py person person.csv /sdo/dev/website/webapp/xml/content/profiles/person/

# Any composer not found in EATS will be output on the command line.
python create_entities_from_csv.py composition composition.csv /sdo/dev/website/webapp/xml/content/profiles/

# Any author/editor (it's always Schenker) not found in EATS will be
# output on the command line.
python create_entities_from_csv.py work work.csv /sdo/dev/website/webapp/xml/content/profiles/work/

python create_entities_from_csv.py term term.csv /sdo/dev/website/webapp/xml/content/profiles/

python create_entities_from_csv.py place place.csv /sdo/dev/website/webapp/xml/content/profiles/place/

python create_entities_from_csv.py organization organization.csv /sdo/dev/website/webapp/xml/content/profiles/organization/


