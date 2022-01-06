import 'dart:io';
import 'package:dscore_app/common/utilities.dart';
import 'package:flutter/material.dart';

class UsageScreen extends StatelessWidget {
  const UsageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _backButton(context),
                _usageImages(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: Utilities.isMobile() ? 70 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Platform.isIOS
            ? Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                    size: Utilities.isMobile() ? 20 : 30,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '使い方',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Utilities.isMobile() ? 18 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            : Row(
                children: [
                  Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                    size: Utilities.isMobile() ? 20 : 30,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '使い方',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Utilities.isMobile() ? 18 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _usageImages() {
    return Expanded(
      child: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.all(Utilities.isMobile() ? 8 : 32),
            child: Image.asset('images/tutorial_2.png'),
          ),
          Padding(
            padding: EdgeInsets.all(Utilities.isMobile() ? 8 : 32),
            child: Image.asset('images/tutorial_3.png'),
          ),
          Padding(
            padding: EdgeInsets.all(Utilities.isMobile() ? 8 : 32),
            child: Image.asset('images/tutorial_4.png'),
          ),
        ],
      ),
    );
  }
}
