import 'dart:io';
import 'package:dscore_app/screens/intro/intro_model.dart';
import 'package:dscore_app/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IntroModel>(
        builder: (context, model, child) {
          return SafeArea(
            child: Stack(
              children: [
                IntroSlider(
                  slides: _sliders(context),
                  renderNextBtn: Text(
                    "次へ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Utilities().isMobile() ? 14 : 20,
                    ),
                  ),
                  renderDoneBtn: Text(
                    "アプリへ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Utilities().isMobile() ? 14 : 20,
                    ),
                  ),
                  renderSkipBtn: Text(
                    "スッキプ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Utilities().isMobile() ? 14 : 20,
                    ),
                  ),
                  onDonePress: () async {
                    finishIntro(context);
                  },
                  onSkipPress: () async {
                    finishIntro(context);
                  },
                ),
                model.isLoading
                    ? Container(
                        color: Colors.grey.withOpacity(0.7),
                        child: Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> finishIntro(BuildContext context) async {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    if (Platform.isIOS) {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('このアプリの使用に関して、下記の内容に同意していただく必要があります。'),
              content: Text('このアプリは広告の成果改善や問題の診断、分析機能などの目的のため、'
                  'パフォーマンスデータや広告データなどを収集する場合がございます。'),
              actions: [
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        introModel.finishIntro();
                        Navigator.pop(context);
                      },
                      child: Text('同意する',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(color: Colors.black, height: 1),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('同意しない'),
                    ),
                  ],
                )
              ],
            );
          });
    } else {
      introModel.finishIntro();
    }
  }

  List<Slide> _sliders(BuildContext context) {
    final backgroundColor = Colors.white;
    return [
      Slide(
        backgroundImage: 'images/tutorial_1.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: backgroundColor,
      ),
      Slide(
        backgroundImage: 'images/tutorial_2.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: backgroundColor,
      ),
      Slide(
        backgroundImage: 'images/tutorial_3.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: backgroundColor,
      ),
      Slide(
        backgroundImage: 'images/tutorial_4.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: backgroundColor,
      ),
    ];
  }
}
