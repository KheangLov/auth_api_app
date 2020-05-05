package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.ileaf.tinder_card.TinderCardPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    TinderCardPlugin.registerWith(registry.registrarFor("com.ileaf.tinder_card.TinderCardPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
