import 'package:flutter/foundation.dart';

/// printing on debug
void printd(Object? content) {
  if (kDebugMode) {
    if (content is String) {
      debugPrint(content, wrapWidth: null);
    } else {
      print(content);
    }
  }
}