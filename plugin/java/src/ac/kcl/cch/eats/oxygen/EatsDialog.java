package uk.ac.kcl.cch.eats.oxygen;

import org.nzetc.eats.client.EATSEntity;

import javax.swing.*;
import java.awt.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.util.Vector;
import java.lang.reflect.Array;

/**
 * Created by IntelliJ IDEA.
 * User: Elliott Hall
 * Date: 21-Jul-2008
 * Time: 13:08:29
 * To change this template use File | Settings | File Templates.
 */
public class EatsDialog extends JDialog implements ActionListener {

    private JTextField selectedTextField;
    private DefaultListModel listModel;
    private JList list;
    private String value;
    private JComboBox typeList;
    private EatsLookup eats;
    private String message;
    private String[] types = {"Person", "Organization", "Dog", "Rabbit", "Pig"};
    private Frame parentFrame;
    Vector<EatEntity> results = null;

    /**
     * Constructor for the ConversionDialog object
     *
     * @param parentFrame The parent frame of this dialog.
     * @param dialogName  The dialog name.
     */
    public EatsDialog(Frame parentFrame, String dialogName) throws EatException {
        super(parentFrame, dialogName);
        this.parentFrame = parentFrame;
        initPanel();
        eats = new EatsLookup();

    }

    private void initPanel() throws EatException {
        JPanel content = new JPanel();
        content.setLayout(new BorderLayout());
        content.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        try {
            JPanel searchPanel = new JPanel();
            searchPanel.setLayout(new BoxLayout(searchPanel, BoxLayout.PAGE_AXIS));
            JPanel resultPanel = new JPanel();

            //Search text and results
            listModel = new DefaultListModel();
            list = new JList(listModel);            
            list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
            list.setSelectedIndex(0);
            //list.addListSelectionListener(this);
            list.setVisibleRowCount(5);
            JScrollPane listScrollPane = new JScrollPane(list);
            //FlowLayout centerFlowLayout = new FlowLayout(FlowLayout.CENTER);
            selectedTextField = new JTextField();
            JLabel label = new JLabel("You searched for:");
            searchPanel.add(label);
            searchPanel.add(selectedTextField);
            resultPanel.add(listScrollPane);
            typeList = new TypeBox(types);
           /* typeList.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    try{
                        doLookup();
                    }catch(Exception ex){
                       //throw new Exception(ex);
                    }
                }
            }
            );
            selectedTextField.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    try{
                        doLookup();
                    }catch(Exception ex){

                    }
                }
            }
            );*/

            //petList.addActionListener(this);
            searchPanel.add(typeList);

            //Buttons on the bottom
            JButton cancelButton = new JButton("Cancel");
            cancelButton.addActionListener(this);
            JButton setButton = new JButton("Copy to Clipboard");
            setButton.setActionCommand("Use");
            setButton.addActionListener(this);
            JButton searchButton = new JButton("Search");
            searchButton.setActionCommand("Search");
            searchButton.addActionListener(this);
            getRootPane().setDefaultButton(setButton);

            JPanel buttonPane = new JPanel();
            buttonPane.setLayout(new BoxLayout(buttonPane, BoxLayout.LINE_AXIS));
            buttonPane.setBorder(BorderFactory.createEmptyBorder(0, 10, 10, 10));
            buttonPane.add(Box.createHorizontalGlue());
            buttonPane.add(cancelButton);
            buttonPane.add(Box.createRigidArea(new Dimension(10, 0)));
            buttonPane.add(searchButton);
            buttonPane.add(Box.createRigidArea(new Dimension(10, 0)));
            buttonPane.add(setButton);
            content.add(searchPanel, BorderLayout.PAGE_START);
            content.add(resultPanel, BorderLayout.CENTER);
            content.add(buttonPane, BorderLayout.PAGE_END);

            // content.add(resultPanel,1);
            this.getContentPane().add(content, BorderLayout.CENTER);
            pack();
            Rectangle parentBounds = this.getParent().getBounds();
            setLocation((int) (parentBounds.getCenterX() - this.getSize().getWidth()), (int) (parentBounds.getCenterY() - this.getSize().getHeight()));
        } catch (Exception e) {
            throw new EatException("Failed to init dialog:", e);
        }
    }

    private void showError(JPanel parent, Exception e) {
        JOptionPane.showMessageDialog(this.parentFrame, "Error", e.getMessage(), JOptionPane.ERROR_MESSAGE);
    }

    public void doLookup() throws EatException {
        String search = selectedTextField.getText();
//
        //Vector results = null;
        try {
            if (typeList.getSelectedItem() != null) {
                eats.setEntity_type((String) typeList.getSelectedItem());
            }            
            listModel.clear();
            this.results = eats.search(search);
            populateList(results);
            //}
            //listModel.clear();
            //listModel.addElement(results.size());

        } catch (Exception e) {
            message = "Failed to retrieve search results from EATS server for search " + search;
            throw new EatException(message, e);
        } finally {
            setVisible(true);
        }
    }


    private void populateList(Vector<EatEntity> results) throws Exception {
        listModel.clear();
        if (results != null) {
            if (results.size() > 0) {
                for (int x = 0; x < results.size(); x++) {
                    EatEntity eat = (EatEntity) results.get(x);
                    String[] names = eat.get_authoritative_names();
                    if (names!=null){
                        listModel.addElement(join("|",names));
                    } else {
                       throw new EatException("Null value in names", new Exception());
                    }
                }
               list.setSelectedIndex(0); 
            } else {
                listModel.addElement("Name not Found");
                if (message != null) {
                    listModel.addElement(message);
                }
            }
        } else {
            listModel.addElement("Error");
            throw new EatException("Error in populate List", new Exception());
        }

    }

    public static String join( String token, String[] strings )
        {
            StringBuffer sb = new StringBuffer();

            for( int x = 0; x < ( strings.length - 1 ); x++ )
            {
                sb.append( strings[x] );
                sb.append( token );
            }
            sb.append( strings[ strings.length - 1 ] );

            return( sb.toString() );
        }

    public void actionPerformed(ActionEvent e) {
        if ("Use".equals(e.getActionCommand())) {
            if (list.getSelectedValue() != null) {
                value = (String) list.getSelectedValue();
                toClipboard();
            }
            setVisible(false);
        } else if ("Search".equals(e.getActionCommand())) {
            try {
                doLookup();                
            } catch (EatException e1) {
                EatError.showError(parentFrame,e1.getMessage());
            }
        }else{
            setVisible(false);
        }
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public void setSelectedText(String value) {
        this.selectedTextField.setText(value);
    }

    /**
     * Copies the value to the clipboard as a formatted tag
     */
    public void toClipboard() {

        try {
            EatEntity selected=(EatEntity) results.get(typeList.getSelectedIndex());
            String type=selected.get_entity_types()[0];
            if (type!=null){
                type=type.toLowerCase();
            } else{
                throw new EatException("No Type for Entity, cannot make tag",new Exception());
            }
            String [] names=selected.get_authoritative_names();

//            copy("<tei:persName key=\""+selected.get_key()+"\">" + join("|",names) + "</tei:persName>");
            copy("<tei:persName key=\""+selected.get_key()+"\">" + this.selectedTextField.getText() + "</tei:persName>");
        } catch (EatException e) {
            EatError.showError(parentFrame,e.getMessage());
        }

    }

    /**
     * Transfers the currently selected text to the system clipboard. Does
     * nothing for null argument.
     *
     * @param str The string to be transfered.
     */
    public void copy(String str) {
        if (str != null) {
            Clipboard clipboard = getToolkit().getSystemClipboard();
            StringSelection contents = new StringSelection(str);
            clipboard.setContents(contents, null);
        }
    }
}
