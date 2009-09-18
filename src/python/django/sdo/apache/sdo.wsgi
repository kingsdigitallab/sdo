import os, sys
sys.path.append('/home/tamara/cchsvn/schenker/trunk/src/python/django')
sys.path.append('/home/tamara/cchsvn/schenker/trunk/src/python/django/sdo')
os.environ['DJANGO_SETTINGS_MODULE'] = 'sdo.settings'
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

