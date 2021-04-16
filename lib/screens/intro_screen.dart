import 'package:dscore_app/intro_model.dart';
import 'package:dscore_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  final List<PageViewModel> introViews = [
    PageViewModel(
      title: '使いやすい！',
      image: Image.asset('images/events_list.PNG'),
      body: '最高のアプリだ！',
    ),
    PageViewModel(
      title: '使いやすい！',
      image: Image.asset('images/scores.PNG'),
      body: '最高のアプリだ！',
    ),
    PageViewModel(
      title: '使いやすい！',
      image: Image.asset('images/calc_view.PNG'),
      body: '最高のアプリだ！',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IntroModel>(builder: (context, model, child) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : IntroductionScreen(
                pages: introViews,
                onDone: () async {
                  await model.finishIntro();
                  await model.signIn();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()),
                    (_) => false,
                  );
                },
                onSkip: () async {
                  await model.finishIntro();
                  await model.signIn();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()),
                    (_) => false,
                  );
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
              );
      }),
    );
  }
}
