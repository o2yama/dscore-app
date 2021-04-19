import 'dart:io';
import 'package:dscore_app/screens/theme_color/theme_color_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeColorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeColorModel>(builder: (context, model, child) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              ad(context),
              backButton(context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: ListView(
                        children: themes.keys
                            .map(
                              (color) => colorTile(context, color),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget ad(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Center(child: Text('広告')),
    );
  }

  Widget backButton(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: Theme.of(context).backgroundColor,
      width: width,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Platform.isIOS
                ? Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
          SizedBox(width: width * 0.1),
          Text(
            'テーマカラー',
            style: TextStyle(color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }

  Widget colorTile(BuildContext context, String color) {
    final themeColorModel =
        Provider.of<ThemeColorModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 2.0,
      ),
      child: InkWell(
        onTap: () async {
          //todo:modelのtheme変更
          await themeColorModel.setThemeColor(color);
          await themeColorModel.getThemeColor();
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline_outlined, color: themes[color]),
                SizedBox(width: 8),
                Text('$color', style: TextStyle(color: themes[color])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
