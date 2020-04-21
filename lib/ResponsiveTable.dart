import 'dart:async';

import 'package:flutter/services.dart';

class ResponsiveTable {
  static const MethodChannel _channel = const MethodChannel('responsive_table');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
