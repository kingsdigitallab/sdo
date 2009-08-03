from django.db import models

# Create your models here.
class Repository(models.Model):
    name = models.CharField(max_length=200, help_text=u"Enter the current name of the repository")
    abbreviation = models.CharField(max_length=6,blank=True, help_text=u"Add an abbreviation for this repository, e.g. NYPL")
    description = models.TextField(blank=True, help_text=u"As required, enter additional descriptive text about this repository")
     
    class Meta:
        verbose_name_plural = "Repositories"

    def __unicode__(self):
       phrase = self.name
       
       if self.abbreviation:
           phrase += " (" + self.abbreviation + ")"
              
       return  phrase
        
ADDRESS_TYPES = (
    ('1','Street Address'),
    ('2', 'Postal Address'),
 )

class Address(models.Model):
     address = models.ForeignKey(Repository)
     address_type = models.CharField(max_length=1,choices=ADDRESS_TYPES, help_text=u"Indicate the kind of address")
     address1 = models.CharField("Address Line 1", max_length=300, help_text=u"First line of the address")
     address2 = models.CharField("Address Line 2", max_length=300, blank=True, help_text=u"Additional address information as required")
     city = models.CharField(max_length=100, blank=True)
     province = models.CharField("Province/State", max_length=100, blank=True, help_text=u"Province, State, or other regional indicator")
     country = models.CharField(max_length=100, blank=True)
     postal_code = models.CharField("Postal/Zip Code", max_length=12, blank=True, help_text=u"Postal, ZIP or other mailing code")
     note = models.TextField(blank=True)
     
     class Meta:
         verbose_name_plural = "Addresses"
         
 
STATEMENT_TYPES = (
    ('1','Format'),
    ('2', 'Provenance'),
    ('3','Rights Holder'),
    ('4','License'),
    )

class Collection(models.Model):
    repository = models.ForeignKey(Repository)
    name = models.CharField("Name",max_length=200, help_text=u"The name by which this collection is currently known")
    abbreviation = models.CharField(max_length=6, help_text=u"The code used to refer to this collection in shelfmarks and other identifying information")
    description = models.TextField(blank=True, help_text=u"As required, other descriptive information about this collection")
       

    def __unicode__(self):
        phrase = self.name + " (" + self.abbreviation + ")";
        return phrase 

class CollectionStatements(models.Model):
    collection_id = models.ForeignKey(Collection)
    statement_type = models.CharField(max_length=1,choices=STATEMENT_TYPES,help_text=u"Indicate the kind of statement being made about this collection")
    description = models.CharField(max_length=400,help_text=u"Make a statement about the collection")
    
    def __unicode__(self):
         phrase = self.get_statement_type_display() + ": " + self.description
         return phrase
         
    class Meta:
         verbose_name_plural = "Collection Statements"
        

DELIMITER_TYPES = (
    ('1','Slash ( / )'),
    ('2','Dash ( - )'),
    )
    

CONTENT_TYPES = (
    ('1','Correspondence'),
    ('2','Diary'),
    ('3','Lessonbook'),
    ('4','Other'),
    )

class Container(models.Model):
    collection = models.ForeignKey(Collection,help_text=u"Select the collection to which this container belongs; click the green plus sign (+) to add a new repository to the archive")
    box = models.CharField(max_length=5, blank=True, help_text=u"As required, enter the box identifier for the container")    
    folder = models.CharField("Folder/File",max_length=5, blank=True, help_text=u"As required, enter the folder identifier for the container") 
    series = models.CharField(max_length=5, blank=True,help_text=u"As required, enter the series identifier for the container")
    description = models.TextField(blank=True, help_text=u"As required, other descriptive information about this container")
    documents_supplied = models.BooleanField("Document IDs supplied by SDO", blank=False, help_text=u"Indicate whether or not document-level IDs are supplied by the Schenker Documents Online project; leaving this unchecked indicates that document IDs are drawn from information maintained by the holding institution")
    content_type = models.CharField("Content Type",max_length=1, choices=CONTENT_TYPES, help_text=u"Indicate the kind of material included in this container.")
    delimiter = models.CharField("Shelfmark Symbol",max_length=1, choices=DELIMITER_TYPES, help_text=u"Indicate the symbol to be used when composing shelfmarks for this container")

     
    def __unicode__(self):
        phrase = self.collection.abbreviation + " " + self.box + " " + self.folder + " " 
        return phrase 

class ContainerStatements(models.Model):
    container_id = models.ForeignKey(Container)
    statement_type = models.CharField(max_length=1,choices=STATEMENT_TYPES, help_text=u"Indicate the kind of statement being made about this container")
    description = models.TextField(help_text=u"Make a statement about this container")    
    
    def __unicode__(self):
         phrase = self.get_statement_type_display() + ": " + self.description
         return phrase
    
    class Meta:
         verbose_name_plural = "Container Statements"
    

class Document(models.Model):
    container = models.ForeignKey(Container)
    unitid = models.CharField(max_length=10, help_text=u"Alpha-numeric text string that serves as a unique reference point or control number for the described material")    
    description = models.CharField(max_length=200,blank=True, help_text=u"As required, enter a brief descriptive note about this document")
    
    def __unicode__(self):
        phrase = self.container.collection.abbreviation + self.container.box + " " + self.container.folder +  " " + self.unitid
        return self.unitid
        

