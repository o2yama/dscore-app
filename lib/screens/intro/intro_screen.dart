import 'dart:io';
import 'package:dscore_app/common/att.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
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

  List<Slide> _sliders(BuildContext context) {
    return [
      Slide(
        backgroundImage: 'images/tutorial_1.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: Colors.black,
      ),
      Slide(
        backgroundImage: 'images/tutorial_2.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      Slide(
        backgroundImage: 'images/tutorial_3.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      Slide(
        backgroundImage: 'images/tutorial_4.png',
        backgroundBlendMode: BlendMode.screen,
        backgroundImageFit: BoxFit.contain,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    ];
  }

  Future<void> finishIntro(BuildContext context) async {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    if (Platform.isIOS) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'このアプリでは広告を表示しています。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  SizedBox(height: 12),
                  Divider(color: Colors.black54),
                  Text(
                    'お客様により適した広告表示のために、次の画面で「許可」することをお勧めします。',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Divider(color: Colors.black54),
                  SizedBox(height: 12),
                  Image.asset('images/att_dialog.png'),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      final isAttPermitted =
                          await ATT.instance.requestPermission();
                      print(isAttPermitted);
                      introModel.finishIntro();
                      Navigator.pop(context);
                    },
                    child: Text('次へ'),
                  ),
                ],
              ),
            );
          });
    } else if (Platform.isAndroid) {
      introModel.finishIntro();
    }
  }
}
