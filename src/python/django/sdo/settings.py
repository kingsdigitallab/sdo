# Django settings for sdo project.

DEBUG = True
TEMPLATE_DEBUG = DEBUG

ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
)

MANAGERS = ADMINS

DATABASE_ENGINE = 'mysql'           # 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
DATABASE_NAME = 'sdodb'             # Or path to database file if using sqlite3.
DATABASE_USER = 'sdoadmin'             # Not used with sqlite3.
DATABASE_PASSWORD = 'sdoadmin'         # Not used with sqlite3.
DATABASE_HOST = ''             # Set to empty string for localhost. Not used with sqlite3.
DATABASE_PORT = ''             # Set to empty string for default. Not used with sqlite3.

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'America/Chicago'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en-us'

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True

# Absolute path to the directory that holds media.
# Example: "/home/media/media.lawrence.com/"
MEDIA_ROOT = ''

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash if there is a path component (optional in other cases).
# Examples: "http://media.lawrence.com", "http://example.com/media/"
MEDIA_URL = ''

# URL prefix for admin media -- CSS, JavaScript and images. Make sure to use a
# trailing slash.
# Examples: "http://foo.com/media/", "/media/".
ADMIN_MEDIA_PREFIX = '/media/'

# Make this unique, and don't share it with anybody.
SECRET_KEY = 'rv4so!%$d5p8cl*trc2)j@907@&6d_=v#+^#zt(k-%m9puchc!'

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.load_template_source',
    'django.template.loaders.app_directories.load_template_source',
#     'django.template.loaders.eggs.load_template_source',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
)

ROOT_URLCONF = 'sdo.urls'

TEMPLATE_DIRS = (
    # Put strings here, like "/home/html/django_templates" or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    '/home/tamara/cchsvn/schenker/trunk/src/python/django/sdo/templates'
)

FIXTURE_DIRS = (
   '/home/tamara/cchsvn/schenker/trunk/src/python/django/sdo/fixtures'
)

AUTHENTICATION_BACKENDS = (
    'sdo.backends.LDAPBackend',
    'django.contrib.auth.backends.ModelBackend',
)

# LDAP configuration
# see auth/backends.py for explanation about the properties
LDAP_DEBUG = True

LDAP_SERVER_URI = 'ldap://jacana.cch.kcl.ac.uk'
LDAP_SEARCHDN = 'dc=cch,dc=kcl,dc=ac,dc=uk'
LDAP_SEARCH_FILTER = 'uid=%s'
LDAP_UPDATE_FIELDS = True
LDAP_FIRST_NAME = 'givenName'
LDAP_LAST_NAME = 'sn'

# Optional Settings
LDAP_FULL_NAME = None
LDAP_GID = 'memberUid'
LDAP_SU_GIDS = None
LDAP_STAFF_GIDS = ['cn=schenker,dc=cch,dc=kcl,dc=ac,dc=uk']
LDAP_ACTIVE_FIELD = None
LDAP_ACTIVE = None
LDAP_EMAIL = None
LDAP_DEFAULT_EMAIL_SUFFIX = None
LDAP_OPTIONS = None

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.admin',
    'django.contrib.databrowse',
    'django.contrib.admindocs',
    'sdo.archives',
)
