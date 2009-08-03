
from sdo.archives.models import Repository,Collection,Container,Document,Address, CollectionStatements, ContainerStatements
from django.contrib import admin

class AddressInline(admin.StackedInline):
    model = Address
    extra = 1

class DocumentInline(admin.TabularInline):
    model = Document
    extra = 4
    
class ContainerStatementInline(admin.TabularInline):
    model = ContainerStatements
    extra = 1

class CollectionStatementInline(admin.TabularInline):
    model = CollectionStatements
    extra = 1

class AddressAdmin(admin.ModelAdmin):

   search_fields = ['address1']

class RepositoryAdmin(admin.ModelAdmin):
    list_display = ('name','abbreviation','description')
    inlines = [AddressInline]
    save_on_top = True
    search_fields = ['name']

class ContainerAdmin(admin.ModelAdmin):
    list_display = ('__unicode__','collection','box','folder','series','description','documents_supplied','content_type')
    list_filter = ('content_type','documents_supplied')
    inlines = [ContainerStatementInline,DocumentInline]
    search_fields = ['collection__name','collection__abbreviation','box','folder','series','description']
    save_on_top = True
    
class CollectionAdmin(admin.ModelAdmin):
    list_display = ('name','abbreviation','description')
    inlines = [CollectionStatementInline]
    search_fields = ['name','abbreviation','description']

    save_on_top = True
    



admin.site.register(Collection,CollectionAdmin)
admin.site.register(Repository,RepositoryAdmin)
admin.site.register(Container,ContainerAdmin)

