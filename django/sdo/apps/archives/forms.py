from archives.models import Document
from django import forms
from django.forms.extras.widgets import SelectDateWidget

class DocumentForm(forms.ModelForm):
    coverage_start = forms.DateField(label="Start Date",widget=SelectDateWidget(years=range(1879,1991)),help_text=u"Enter the start date for material covered in this document.")
    coverage_end = forms.DateField(label="End Date", widget=SelectDateWidget(years=range(1879,1991)),help_text=u"For documents covering more than one day indicate the end date for material covered.")
     
    class Meta:
        model = Document;
