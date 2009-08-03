from django.conf.urls.defaults import *
from django.contrib import admin
from django.contrib.auth.views import login, logout
from sdo.archives.views import  index
from sdo.archives.admin_views import xsd, container, repository, collection

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()


urlpatterns = patterns('',
    # Example:
   (r'^$', index),
    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
     # (r'^admin/doc/', include('django.contrib.admindocs.urls')),
     (r'^admin/export/xsd/(?P<schema_type>[\w\-\w]+)/$', xsd),
     (r'^admin/report/container/(?P<byContentType>\w+)/$', container),
     (r'^admin/report/repository/$', repository),
     (r'^admin/report/collection/$', collection),


    # Uncomment the next line to enable the admin:
     (r'^admin/(.*)', admin.site.root),
   
)



