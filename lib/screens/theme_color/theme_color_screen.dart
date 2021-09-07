import 'dart:io';
import 'package:dscore_app/screens/theme_color/theme_color_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/utilities.dart';

class ThemeColorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeColorModel>(builder: (context, model, child) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  _backButton(context),
                  _exampleCardWidget(context),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView(
                      children: themes.keys
                          .map((color) => _colorTile(context, color))
                          .toList(),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: Utilities().isMobile() ? 70 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Platform.isIOS
            ? Row(children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColor,
                  size: Utilities().isMobile() ? 20 : 30,
                ),
                const SizedBox(width: 24),
                Text(
                  'テーマカラー',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Utilities().isMobile() ? 18 : 24,
                  ),
                ),
              ])
            : Row(children: [
                Icon(
                  Icons.clear,
                  color: Theme.of(context).primaryColor,
                  size: Utilities().isMobile() ? 20 : 30,
                ),
                const SizedBox(width: 24),
                Text(
                  'テーマカラー',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Utilities().isMobile() ? 18 : 24,
                  ),
                ),
              ]),
      ),
    );
  }

  Widget _exampleCardWidget(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        Text(
          'イメージ',
          style: TextStyle(fontSize: Utilities().isMobile() ? 18 : 24),
        ),
        SizedBox(
          height: 130,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.1),
                  Text(
                    '5.2',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 130,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _colorTile(BuildContext context, String color) {
    final themeColorModel =
        Provider.of<ThemeColorModel>(context, listen: false);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: InkWell(
          onTap: () async {
            await themeColorModel.setThemeColor(color);
            await themeColorModel.getThemeColor();
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: themes[color],
                  size: Utilities().isMobile() ? 20 : 30,
                ),
                const SizedBox(width: 16),
                Text(
                  '$color',
                  style: TextStyle(
                    color: themes[color],
                    fontSize: Utilities().isMobile() ? 18 : 24,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
      if (color == 'ブラック') const SizedBox(height: 250),
    ]);
  }
}
