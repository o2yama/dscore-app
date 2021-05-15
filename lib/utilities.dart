import 'package:flutter/cupertino.dart';

class Utilities {
  bool isMobile() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return data.size.shortestSide < 600 ? true : false;
  }
}
