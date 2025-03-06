import 'package:flutter/material.dart';

void debugLongPrint(Object? object) async {
  int defaultPrintLength = 1020;
  if (object == null || object.toString().length <= defaultPrintLength) {
    debugPrint(object.toString());
  } else {
    String log = object.toString();
    int start = 0;
    int endIndex = defaultPrintLength;
    int logLength = log.length;
    int tmpLogLength = log.length;
    while (endIndex < logLength) {
      debugPrint(log.substring(start, endIndex));
      endIndex += defaultPrintLength;
      start += defaultPrintLength;
      tmpLogLength -= defaultPrintLength;
    }
    if (tmpLogLength > 0) {
      debugPrint(log.substring(start, logLength));
    }
  }
}
