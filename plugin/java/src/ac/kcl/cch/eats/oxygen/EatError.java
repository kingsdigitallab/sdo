package uk.ac.kcl.cch.eats.oxygen;

import javax.swing.*;
import java.awt.*;

/**
 * Created by IntelliJ IDEA.
 * User: Elliott Hall
 * Date: 29-Jul-2008
 * Time: 11:49:48
 * To change this template use File | Settings | File Templates.
 */
public class EatError {

    public static void showError(Frame parentFrame,String message){
        JOptionPane.showMessageDialog(parentFrame, message, "ERROR", JOptionPane.ERROR_MESSAGE);
    }
}
