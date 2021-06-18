import 'package:flutter/cupertino.dart';

class Utilities {
  bool isMobile() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    var isMobile = true;
    if (data.size.shortestSide < 600) {
      isMobile = true;
    } else {
      isMobile = false;
    }
    return isMobile;
  }
}
