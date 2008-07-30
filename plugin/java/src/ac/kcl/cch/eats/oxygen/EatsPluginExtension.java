package uk.ac.kcl.cch.eats.oxygen;

import ro.sync.exml.plugin.selection.SelectionPluginContext;
import ro.sync.exml.plugin.selection.SelectionPluginExtension;
import ro.sync.exml.plugin.selection.SelectionPluginResult;
import ro.sync.exml.plugin.selection.SelectionPluginResultImpl;
import org.nzetc.eats.client.NameLookup;

import javax.swing.*;
import java.awt.*;


/**
 * Created by IntelliJ IDEA.
 * User: Elliott Hall
 * Date: 21-Jul-2008
 * Time: 10:50:47
 * To change this template use File | Settings | File Templates.
 */


public class EatsPluginExtension implements SelectionPluginExtension {

    private static NameLookup name_lookup;
    public static final String OPTION_PREFIX = "options.lookupname.";
    private EatsDialog EatsDialog;

    public SelectionPluginResult process(SelectionPluginContext selectionPluginContext) {
        String name = selectionPluginContext.getSelection();
        //String result = name_lookup.lookup_name(entity_type, name);
        //JOptionPane.showMessageDialog(selectionPluginContext.getFrame(), "Error", "ERROR", JOptionPane.ERROR_MESSAGE);
        try {
            if (EatsDialog == null) {
                EatsDialog =
                        new EatsDialog(
                                selectionPluginContext.getFrame(),
                                EatsPlugin.getInstance().getDescriptor().getName());
            }

            //Initial search on a name from selected text
            EatsDialog.setSelectedText(name);
            EatsDialog.doLookup();
        } catch (EatException e) {
            JOptionPane.showMessageDialog(selectionPluginContext.getFrame(), e.getMessage(), "ERROR", JOptionPane.ERROR_MESSAGE);
        }  catch (Exception e) {
            JOptionPane.showMessageDialog(selectionPluginContext.getFrame(), e.getMessage(), "ERROR", JOptionPane.ERROR_MESSAGE);
        }
        //return new SelectionPluginResultImpl(EatsDialog.getValue());
        return null;
    }

}
