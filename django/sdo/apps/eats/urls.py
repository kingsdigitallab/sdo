from django.conf.urls.defaults import *

urlpatterns = patterns(
    'eats.views.main',
    (r'^$', 'index'),
    (r'^(?P<entity_id>\d+)/$', 'display_entity'),
    (r'^(?P<entity_id>\d+)/eatsml/full/', 'display_entity_full_eatsml'),
    (r'^(?P<entity_id>\d+)/eatsml/', 'display_entity_eatsml'),
    (r'^(?P<entity_id>\d+)/xtm/', 'display_entity_xtm'),
    (r'^(?P<entity_id>\d+)/eac/(?P<authority_record_id>\d+)/', 'display_entity_eac'),
    (r'^search/$', 'search'), # Human usable search
    (r'^lookup/$', 'lookup'), # Machine usable search, used by clients
    (r'^entities/types/$', 'entity_types'),
    (r'^entities/(?P<entity_type_id>\d+)/$', 'entities_by_type'),
    (r'^get_names/$', 'get_names'),
    (r'^get_primary_authority_records/$', 'get_primary_authority_records'),
)
urlpatterns += patterns(
    'eats.views.edit',
    (r'^edit/import/$', 'import_eatsml'), # Human usable import from EATSML
    (r'^edit/import/(?P<import_id>\d+)/$', 'display_import'),
    (r'^edit/import/(?P<import_id>\d+)/raw/$', 'display_import_raw'),
    (r'^edit/import/(?P<import_id>\d+)/processed/$', 'display_import_processed'),
    (r'^edit/export/eatsml/$', 'export_eatsml'),
    (r'^edit/export/eatsml/base/$', 'export_base_eatsml'),
    (r'^edit/export/eatsml/(?P<authority_id>\d+)/$', 'export_eatsml'),
    (r'^edit/export/xslt/$', 'export_xslt_list'),
    (r'^edit/export/xslt/(?P<xslt>[A-Za-z0-9_\-]+)/', 'export_xslt'),
    (r'^edit/create_entity/$', 'create_entity'),
    (r'^edit/create_date/(?P<assertion_id>\d+)/$', 'create_date'),
    (r'^edit/create_name/(?P<entity_id>\d+)/$', 'create_name'),
    (r'^edit/select_entity/$', 'select_entity'),
    (r'^edit/select_authority_record/$', 'select_authority_record'),
    (r'^edit/delete/entity/(?P<entity_id>\d+)/$', 'delete_entity'),
    (r'^edit/delete/(?P<model_name>[^/]+)/(?P<object_id>\d+)/$', 'delete_object'),
    (r'^edit/(?P<model_name>[^/]+)/(?P<object_id>\d+)/$', 'edit_model_object'),
    (r'^edit/update_name_search_forms/$', 'update_name_search_forms'),
)
