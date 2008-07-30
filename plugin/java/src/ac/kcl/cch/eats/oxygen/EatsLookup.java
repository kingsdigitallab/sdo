package uk.ac.kcl.cch.eats.oxygen;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;

import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import java.util.Vector;
import java.net.URLEncoder;

/**
 * Created by IntelliJ IDEA.
 * User: Elliott Hall
 * Date: 22-Jul-2008
 * Time: 13:01:54
 * To change this template use File | Settings | File Templates.
 */
public class EatsLookup {
    private String server_url = "http://137.73.122.119/eats/";
    private String username = "test";
    private String password = "test";
    private String usage_url="";
    private String entity_type;
    private int default_language_index, default_script_index;

    private static XPathFactory xpath_factory = XPathFactory.newInstance();
    private static XPath xpath = xpath_factory.newXPath();

    public EatsLookup() {

    }

    public Vector<EatEntity> search(String name) throws EatException {
    //    public Vector search(String name) throws EatException {
        try {
            // Return a Vector containing the search results (EatEntity objects).
            String escaped_name = URLEncoder.encode(name, "UTF-8");            
            String lookup_url = this.server_url + "lookup/?name=" + escaped_name;
            DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder domBuilder = domFactory.newDocumentBuilder();
            Document root = domBuilder.parse(lookup_url);
            XPathExpression get_entities = xpath.compile("/results/entity");
            NodeList entity_nodes = (NodeList) get_entities.evaluate(root,
                    XPathConstants.NODESET);    
            Vector<EatEntity> search_results = new Vector<EatEntity>();
            //Vector search_results = new Vector();
            for (int count = 0; count < entity_nodes.getLength(); count++) {
                Element node = (Element) entity_nodes.item(count);
                EatEntity search_result = new EatEntity(node, this.server_url,this.usage_url);
                search_results.add(search_result);
            }            
            return search_results;
        } catch (Exception e) {
            throw new EatException("Error during search for " + name, e);
        }
         //return null;        
    }

    public String getEntity_type() {
        return entity_type;
    }

    public void setEntity_type(String entity_type) {
        this.entity_type = entity_type;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getServer_url() {
        return server_url;
    }

    public void setServer_url(String server_url) {
        this.server_url = server_url;
    }

    public String getUsage_url() {
        return usage_url;
    }

    public void setUsage_url(String usage_url) {
        this.usage_url = usage_url;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
