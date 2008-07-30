package uk.ac.kcl.cch.eats.oxygen;

import java.net.URLEncoder;
import javax.xml.xpath.*;
import org.w3c.dom.*;


public class EatEntity {

    private Element element;
    private String server_url;
    private String usage_url;
    private String key = null;
    private String[] names = null;
    private String[] dates = null;
    private String[] entity_types = null;
    private String[] entity_relationships = null;
    private String edit_link = null;
    private static XPathFactory xpath_factory = XPathFactory.newInstance();
    private static XPath xpath = xpath_factory.newXPath();

    public EatEntity(Element node, String server_url, String usage_url){
        this.element = node;
        this.server_url = server_url;
        this.usage_url = usage_url;
    }

    public String get_key () throws EatException {
        // Return a string of the preferred authority's record id.
        if (this.key == null) {
            XPathExpression get_key;
            try {
                get_key = xpath.compile("authority_records/authority_record/id");
                this.key = get_key.evaluate(this.element);
            }
            catch (Exception exception) {
                String message = "Failed to get key from search result XML.";
                throw new EatException(message, exception);
            }
        }
        return this.key;
    }

    public String[] get_authoritative_names () throws EatException {
        // Return a list of the authoritative names.
        if (this.names == null) {
            XPathExpression get_authoritative_names;
            try {
                get_authoritative_names = xpath.compile("names/name[@type='authorised']/display_form");
                NodeList name_nodes = (NodeList) get_authoritative_names.evaluate(this.element,
                                                                                  XPathConstants.NODESET);
                this.names = get_array_from_nodelist(name_nodes);
            }
            catch (Exception exception) {
                String message = "Failed to get authoritative names from search result XML.";
                throw new EatException(message, exception);
            }
        }
        return this.names;
    }

    public String[] get_dates () throws EatException {
        // Return a list of the existence dates.
        if (this.dates == null) {
            XPathExpression get_dates;
            try {
                get_dates = xpath.compile("dates/date");
                NodeList date_nodes = (NodeList) get_dates.evaluate(this.element,
                                                                    XPathConstants.NODESET);
                this.dates = get_array_from_nodelist(date_nodes);
            }
            catch (Exception exception) {
                String message = "Failed to get dates from search result XML.";
                throw new EatException(message, exception);
            }
        }
        return this.dates;
    }

    public String[] get_entity_types () throws EatException {
        // Return a list of the entity types.
        if (this.entity_types == null) {
            XPathExpression get_entity_types;
            try {
                get_entity_types = xpath.compile("entity_types/entity_type");
                NodeList entity_type_nodes = (NodeList) get_entity_types.evaluate(this.element,
                                                                                  XPathConstants.NODESET);
                this.entity_types = get_array_from_nodelist(entity_type_nodes);
            }
            catch (Exception exception) {
                String message = "Failed to get entity type from search result XML.";
                throw new EatException(message, exception);
            }
        }
        return this.entity_types;
    }

    public String[] get_relationships () throws EatException {
        // Return a list of entity relationships.
        if (this.entity_relationships == null) {
            XPathExpression get_relationships;
            try {
                get_relationships = xpath.compile("relationships/relationship");
                NodeList relationship_nodes = (NodeList) get_relationships.evaluate(this.element,
                                                                                    XPathConstants.NODESET);
                this.entity_relationships = new String[relationship_nodes.getLength()];
                for (int count=0; count < relationship_nodes.getLength(); count++) {
                    Node node = relationship_nodes.item(count);
                    String entity = xpath.compile("entity").evaluate(node);
                    if ("".equals(entity)) {
                        entity = "This entity";
                    }
                    String relationship_type = xpath.compile("type").evaluate(node);
                    String related_entity = xpath.compile("related_entity").evaluate(node);
                    if ("".equals(related_entity)) {
                        related_entity = "this entity";
                    }
                    this.entity_relationships[count] = entity + " " + relationship_type + " " + related_entity;
                }
            }
            catch (Exception exception) {
                String message = "Failed to get entity relationships from search result XML.";
                throw new EatException(message, exception);
            }
        }
        return this.entity_relationships;
    }

    public String get_edit_URL () throws EatException {
        // Return a string of the edit URL.
        if (this.edit_link == null) {
            XPathExpression get_edit_link;
            try {
                get_edit_link = xpath.compile("eats_url");
                this.edit_link = this.server_url + get_edit_link.evaluate(this.element);
            }
            catch (Exception exception) {
                String message = "Failed to get edit URL from search result XML.";
                throw new EatException(message, exception);
            }
        }
        return this.edit_link;
    }

    public String get_usage_URL () throws EatException {
        // Return a string of the usage URL.
        String url = "";
        try {
            String key = this.get_key();
            url = this.usage_url + URLEncoder.encode(key, "UTF-8");
        }
        catch (Exception exception) {
            String message = "Failed to get context URL from search result XML.";
            throw new EatException(message, exception);
        }
        return url;
    }

    public String[] get_nonauthoritative_names () throws EatException {
        // Return a list of the non-authoritative names.
        XPathExpression get_nonauthoritative_names;
        String[] names = {};
        try {
            get_nonauthoritative_names = xpath.compile("names/name[not(@type='authorised')]/display_form");
            NodeList name_nodes = (NodeList) get_nonauthoritative_names.evaluate(this.element,
                                                                                 XPathConstants.NODESET);
            names = get_array_from_nodelist(name_nodes);
        }
        catch (Exception exception) {
            String message = "Failed to get non-authoritative names from search result XML.";
            throw new EatException(message, exception);
        }
        return names;
    }

    public String[] get_notes (String note_type) throws EatException {
        // Return a list of the notes of type note_type.
        XPathExpression get_notes;
        String[] notes = {};
        try {
            get_notes = xpath.compile("notes/" + note_type);
            NodeList note_nodes = (NodeList) get_notes.evaluate(this.element,
                                                                XPathConstants.NODESET);
            notes = get_array_from_nodelist(note_nodes);
        }
        catch (Exception exception) {
            String message = "Failed to get notes from search result XML.";
            throw new EatException(message, exception);
        }
        return notes;
    }

    private String[] get_array_from_nodelist (NodeList nodes) {
        String[] array = {};
        for (int count=0; count < nodes.getLength(); count++) {
            if (count == array.length) {
                String[] temp = new String[array.length + 1];
                for (int i=0; i < array.length; i++) {
                    temp[i] = array[i];
                }
                array = temp;
            }
            Node node = nodes.item(count);
            array[count] = node.getTextContent();
        }
        return array;
    }

    public String toString(){
          return key;
    }

}