import 'package:flutter/cupertino.dart';

class Utilities {
  static bool isMobile() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var isMobile = true;
    if (data.size.shortestSide < 600) {
      isMobile = true;
    } else {
      isMobile = false;
    }
    return isMobile;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
