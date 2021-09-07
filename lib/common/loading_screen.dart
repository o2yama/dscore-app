import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      color: Colors.grey.withOpacity(0.6),
      child: Center(
        child: Platform.isIOS
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black.withOpacity(0.1),
                ),
                height: 100,
                width: 100,
                child: const CupertinoActivityIndicator(radius: 20),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
