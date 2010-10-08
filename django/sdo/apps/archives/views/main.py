# Create your views here.
from django.template import RequestContext, Context, loader
from django.http import Http404, HttpResponseRedirect, HttpResponse

from archives.models import Document


def index (request):
    return HttpResponseRedirect('admin')

def dates (request):
    docs = Document.objects.all()
    template = loader.get_template('dates.xml')
    context = Context({'docs': docs})
    return HttpResponse(template.render(context), mimetype='text/xml') 
