import 'dart:io';
import 'package:dscore_app/common/att.dart';
import 'package:dscore_app/common/loading_screen.dart';
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
      backgroundColor: Colors.grey[200],
      body: Consumer<IntroModel>(
        builder: (context, model, child) {
          return SafeArea(
            child: Stack(
              children: [
                IntroSlider(
                  slides: _sliders(context),
                  renderNextBtn: Text(
                    '次へ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Utilities().isMobile() ? 14 : 20,
                    ),
                  ),
                  renderDoneBtn: Text(
                    'アプリへ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Utilities().isMobile() ? 14 : 20,
                    ),
                  ),
                  renderSkipBtn: Text(
                    'スキップ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Utilities().isMobile() ? 14 : 20,
                    ),
                  ),
                  onDonePress: () async {
                    await finishIntro(context);
                  },
                  onSkipPress: () async {
                    await finishIntro(context);
                  },
                ),
                model.isLoading ? LoadingScreen() : Container(),
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
        widthImage: MediaQuery.of(context).size.width * 0.8,
        heightImage: MediaQuery.of(context).size.height * 0.8,
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
      await showDialog<Dialog>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'このアプリでは広告を表示しています。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                children: [
                  const SizedBox(height: 12),
                  const Divider(color: Colors.black54),
                  const Text(
                    '次の画面で「許可」を選択すると、お客様により適した広告が表示されます。',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const Divider(color: Colors.black54),
                  const SizedBox(height: 12),
                  Image.asset('images/att_dialog.png'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      await ATT.instance.requestPermission();
                      await introModel.finishIntro();
                      Navigator.pop(context);
                    },
                    child: const Text('次へ'),
                  ),
                ],
              ),
            );
          });
    } else if (Platform.isAndroid) {
      await introModel.finishIntro();
    }
  }
}
