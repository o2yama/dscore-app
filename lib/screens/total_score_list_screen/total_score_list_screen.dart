import 'dart:io';
import 'package:dscore_app/screens/score_list_screen/score_list_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/score_list_screen/vt_score_list_screen/vt_score_list_screen.dart';
import 'package:dscore_app/screens/theme_color/theme_color_screen.dart';
import 'package:dscore_app/screens/total_score_list_screen/total_score_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../ad_state.dart';
import '../intro/intro_model.dart';
import '../intro/intro_screen.dart';

final List<String> event = ['床', 'あん馬', '吊り輪', '跳馬', '平行棒', '鉄棒'];
final List<String> eventEng = ['FX', 'PH', 'SR', 'VT', 'PB', 'HB'];

class TotalScoreListScreen extends StatefulWidget {
  @override
  _TotalScoreListScreenState createState() => _TotalScoreListScreenState();
}

class _TotalScoreListScreenState extends State<TotalScoreListScreen> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    Future(() async {
      if (introModel.currentUser == null)
        await introModel.checkIsIntroWatched();
    });
    return Consumer<IntroModel>(
      builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // 広告
                          ad(context),
                          //設定ボタンと使い方ボタン
                          _settingButton(context),
                          //６種目のカード
                          _eventCard(context, event[0], eventEng[0]),
                          _eventCard(context, event[1], eventEng[1]),
                          _eventCard(context, event[2], eventEng[2]),
                          _eventCard(context, event[3], eventEng[3]),
                          _eventCard(context, event[4], eventEng[4]),
                          _eventCard(context, event[5], eventEng[5]),
                          //  6種目の合計
                          _totalScore(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            (!model.isIntroWatched) ? IntroScreen() : Container(),
            (model.isLoading)
                ? Container(
                    color: Colors.grey.withOpacity(0.6),
                    child: Center(
                      child: Platform.isIOS
                          ? CupertinoActivityIndicator()
                          : CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  //広告
  ad(BuildContext context) {
    return banner == null
        ? Container(height: 50)
        : Container(
            height: 50,
            child: AdWidget(ad: banner!),
          );
  }

  Widget _settingButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
            Icons.color_lens,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThemeColorScreen()),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _eventCard(BuildContext context, String event, String eventEng) {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer<TotalScoreListModel>(builder: (context, model, child) {
      Future(() async {
        if (introModel.currentUser != null) await model.getVTScores();
      });
      return model.vtScore == null
          ? SizedBox(
              height: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 15.0, top: 10.0),
                              child: Text(
                                '$event',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                '$eventEng',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    scoreModel.selectEvent(event);
                    if (event == '跳馬') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VTScoreSelectScreen(event)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoreListScreen(event)),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Text(
                                  '$event',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  '$eventEng',
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 30.0),
                          child: event == '跳馬'
                              ? Text(
                                  '${model.vtScore!.score}',
                                  style: Theme.of(context).textTheme.headline5,
                                )
                              : Text('5.5'),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: height * 0.07,
                          width: width * 0.4,
                          child: _techsList(
                              event,
                              context,
                              '前方ダブル',
                              'two',
                              'three',
                              'four',
                              'five',
                              'six',
                              'seven',
                              'eight',
                              'nine',
                              'finish'),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
    });
  }

  //  6種目の合計
  Widget _totalScore() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 160.0),
                child: Text(
                  '合計',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Text(
                '30.4',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        Divider(color: Colors.black)
      ],
    );
  }

  Widget _techsList(
    String event,
    BuildContext context,
    String one,
    String? two,
    String? three,
    String? four,
    String? five,
    String? six,
    String? seven,
    String? eight,
    String? nine,
    String? finish,
  ) {
    final totalScoreListModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
    List<String> _techs = [
      '1. $one',
      '2. $two',
      '3. $three',
      '4. $four',
      '5. $five',
      '6. $six',
      '7. $seven',
      '8. $eight',
      '9. $nine',
      '10. $finish',
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: event == '跳馬'
          ? Center(child: Text('${totalScoreListModel.vtScore!.techName}'))
          : ListView(
              children: _techs
                  .map(
                    (tech) => Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('$tech'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}