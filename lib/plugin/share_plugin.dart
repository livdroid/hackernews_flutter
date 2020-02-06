import 'package:flutter/services.dart';
import 'package:share/share.dart';

class SharePluginImpl implements SharePlugin {
  @override
  Future<void> share(url) async {
    try {
      await Share.share(url);
    } on PlatformException {
      throw SharePlateformException();
    } on FormatException {
      throw ShareFormatException();
    }
  }
}

class ShareFormatException {}

class SharePlateformException {}

abstract class SharePlugin {
  factory SharePlugin() => SharePluginImpl();
  Future<void> share(String url);
}