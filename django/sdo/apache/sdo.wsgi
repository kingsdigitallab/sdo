# This is a completely generic apache-wsgi configuration file (no
# project-specific constants here).
# If you place this file under [MY_DJANGO_SITE]/apache/django.wsgi, it
# will automatically enable the [MY_DJANGO_SITE] project

import os.path, sys

import django.core.handlers.wsgi

project_path = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
project_parent_path = os.path.abspath(os.path.join(project_path, '..'))
apps_path = os.path.join(project_path, 'apps')
module_name = os.path.basename(project_path)

sys.path.append(project_parent_path)
sys.path.append(project_path)
sys.path.append(apps_path)

os.environ['DJANGO_SETTINGS_MODULE'] = '%s.settings' % module_name
application = django.core.handlers.wsgi.WSGIHandler()
