import 'dart:io';
import 'package:dscore_app/screens/intro/intro_model.dart';
import 'package:dscore_app/common/utilities.dart';
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
                    "スキップ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Utilities().isMobile() ? 14 : 20,
                    ),
                  ),
                  onDonePress: () async {
                    model.finishIntro();
                  },
                  onSkipPress: () async {
                    model.finishIntro();
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
