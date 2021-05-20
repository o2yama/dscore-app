import 'dart:io';
import 'package:dscore_app/screens/intro/intro_model.dart';
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
                    ),
                  ),
                  renderDoneBtn: Text(
                    "アプリへ",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  renderSkipBtn: Text(
                    "スッキプ",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onDonePress: () async {
                    _resisterUser(context);
                  },
                  onSkipPress: () async {
                    _resisterUser(context);
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

  Future<void> _resisterUser(BuildContext context) async {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    try {
      introModel.finishIntro();
      introModel.signIn();
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('ユーザー登録に失敗しました'),
              content: Text('時間をおいて、通信環境の良い場所で再度お試しください。'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            );
          });
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
