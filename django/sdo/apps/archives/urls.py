from django.conf.urls.defaults import *

urlpatterns = patterns(
    'archives.views.main',
    (r'^$', 'index'),
    (r'^dates/$', 'dates'),
    (r'^document/(?P<id>\d+)$', 'document')
)

urlpatterns += patterns(
    'archives.views.admin',
    (r'^admin/export/xsd/(?P<schema_type>[\w\-\w]+)/$', 'xsd'),
    (r'^admin/report/container/(?P<byContentType>\w+)/$', 'container'),
    (r'^admin/report/repository/$', 'repository'),
    (r'^admin/report/collection/$', 'collection'),
)
