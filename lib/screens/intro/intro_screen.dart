import 'dart:io';
import 'package:dscore_app/screens/intro/intro_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  final List<PageViewModel> introViews = [
    PageViewModel(
      title: '使いやすい！',
      body: '最高のアプリだ！',
    ),
    PageViewModel(
      title: '使いやすい！',
      body: '最高のアプリだ！',
    ),
    PageViewModel(
      title: '使いやすい！',
      body: '最高のアプリだ！',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IntroModel>(
        builder: (context, model, child) {
          return SafeArea(
            child: Stack(
              children: [
                IntroductionScreen(
                  pages: introViews,
                  onDone: () async {
                    try {
                      await model.signIn();
                      await model.finishIntro();
                      // await model.checkIsIntroWatched();
                    } catch (e) {
                      print(e);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('失敗'),
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
                  },
                  onSkip: () async {
                    try {
                      await model.finishIntro();
                      await model.signIn();
                      // await model.checkIsIntroWatched();
                    } catch (e) {
                      print(e);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('失敗'),
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
                  },
                  showSkipButton: true,
                  skip: const Text('スキップ'),
                  next: const Text('次へ'),
                  done: const Text("アプリへ",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  dotsDecorator: DotsDecorator(
                    size: const Size.square(10.0),
                    activeSize: const Size(20.0, 10.0),
                    activeColor: Theme.of(context).primaryColor,
                    color: Colors.black26,
                    spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
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
}
