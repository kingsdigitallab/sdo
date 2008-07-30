package uk.ac.kcl.cch.eats.oxygen;


import org.w3c.dom.NodeList;

import javax.swing.*;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathConstants;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

/**
 * Created by IntelliJ IDEA.
 * User: Elliott Hall
 * Date: 22-Jul-2008
 * Time: 11:46:25
 * To change this template use File | Settings | File Templates.
 */
public class TypeBox extends JComboBox implements ActionListener {
    String selectedType;
    //private String[] types = { "Person", "Organization", "Dog", "Rabbit", "Pig" };

    public TypeBox(String[] types) {
        super(types);    //To change body of overridden methods use File | Settings | File Templates.
        this.setSelectedIndex(0);
        this.addActionListener(this);
    }

    public void actionPerformed(ActionEvent e) {
        this.getSelectedItem();      

    }    

}
