# Create your views here.
from django.template import RequestContext
from django.http import Http404, HttpResponseRedirect

def index (request):
    return HttpResponseRedirect('admin')
