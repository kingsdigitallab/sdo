from django.forms import *
from django.forms.extras.widgets import SelectDateWidget
from sdo.archives.models import *
from django.utils.safestring import mark_safe


class DocumentForm(forms.ModelForm):
   coverage_start = forms.DateField(label="Coverage Start Date",widget=SelectDateWidget(years=range(1880,1970)),help_text=u"Enter the start date for material covered in this document.")
   coverage_end = forms.DateField(label="Coverage End Date", required=False, widget=SelectDateWidget(required=False, years=range(1880,1970)),help_text=u"For documents covering more than one day, indicate the end date for material covered.")
   
     
   class Meta:
        model = Document;