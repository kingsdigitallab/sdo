package uk.ac.kcl.cch.eats.oxygen;

import javax.swing.*;

/**
 * Created by IntelliJ IDEA.
 * User: Elliott Hall
 * Date: 28-Jul-2008
 * Time: 12:32:45
 * To change this template use File | Settings | File Templates.
 */
public class EatException extends Exception{
    EatException (String message) {
        super(message);
    }

    EatException (String message, Exception exception) {
        super(message + " \n\nFull error:\n    " + exception.getMessage());
    }

    public String display () {
        // Handle an exception by displaying the error message in a
        // dialog.
        return "Cannot proceed due to the following error: \n"
            + this.getMessage();

    }
}
