// ignore_for_file: library_prefixes

import 'dart:developer' as dartDev;
import 'package:flutter/foundation.dart';

import 'dart:io';

class Logger {
  final String name;
  bool showLog = true;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  Logger._internal(this.name) {
    init();
  }

  void init() {
    showLog = true;
  }

  void log(String msg) {
    if (Platform.environment['FLUTTER_TEST'] == 'true') {
      if (showLog) testDebug("$name - $msg");
    } else {
      if (showLog) dartDev.log("$name - $msg");
    }
  }

  void debug(String msg) {
    if (Platform.environment['FLUTTER_TEST'] == 'true') {
      if (showLog) testDebug("$name - $msg");
    } else {
      if (showLog) dartDev.log("$name - $msg");
    }
  }

  void error(String msg) {
    if (showLog) dartDev.log("$name - $msg");
  }

  void testDebug(String msg) {
    if (showLog) debugPrint("$name - $msg");
  }
}
