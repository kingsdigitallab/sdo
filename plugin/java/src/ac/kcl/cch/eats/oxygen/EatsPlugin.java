package uk.ac.kcl.cch.eats.oxygen;

/**
 * Created by IntelliJ IDEA.
 * User: Elliott Hall
 * Date: 21-Jul-2008
 * Time: 11:26:55
 * To change this template use File | Settings | File Templates.
 */

import ro.sync.exml.plugin.Plugin;
import ro.sync.exml.plugin.PluginDescriptor;

public class EatsPlugin extends Plugin {
    /**
     * Plugin instance.
     */
    private static EatsPlugin instance = null;

    /**
     * EatsPlugin constructor.
     * *
     *
     * @param descriptor Plugin descriptor object.
     */
    public EatsPlugin(PluginDescriptor descriptor) {
        super(descriptor);
        if (instance != null) {
            throw new IllegalStateException("Already instantiated !");
        }
        instance = this;
    }

    /**
   * @return The conversion plugin instance.
   */
  public static EatsPlugin getInstance() {
    return instance;
  }
}
