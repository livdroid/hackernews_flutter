import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherPluginImpl implements URLLauncherPlugin {
  @override
  Future<void> launchUrl(url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } on PlatformException {
      throw URLLauncherPlateformException();
    }
  }
}

class URLLauncherPlateformException {}

abstract class URLLauncherPlugin {
  factory URLLauncherPlugin() => URLLauncherPluginImpl();

  void launchUrl(String url);
}
