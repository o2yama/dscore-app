import 'dart:io';
import 'package:dscore_app/common/ad_state.dart';
import 'package:dscore_app/screens/score_list_screen/score_list_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/settings_screen/settings_screen.dart';
import 'package:dscore_app/screens/total_score_list_screen/total_score_list_model.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../common/utilities.dart';
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
          request: const AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    final totalScreenModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
    Future(() async {
      //イントロを見たか確認
      if (!introModel.isIntroWatched) {
        await introModel.checkIsIntroWatched();
      }

      //currentUserがnullならユーザーデータ取得
      if (introModel.currentUser == null && !introModel.isFetchedUserData) {
        await introModel.getCurrentUserData();
      } else {
        if (introModel.isIntroWatched && !totalScreenModel.isFetchedScore) {
          await totalScreenModel.getFavoriteScores();
        }
      }

      //プッシュ通知の許可ダイアログ
      if (totalScreenModel.settings == null) {
        await totalScreenModel.requestNotificationPermission();
      }

      //トータルが20点超えたら、レビュー用のダイアログ
      await totalScreenModel.getIsAppReviewDialogShowed();
      if (!totalScreenModel.isAppReviewDialogShowed &&
          totalScreenModel.totalScore >= 20) {
        await totalScreenModel.showAppReviewDialog();
        await totalScreenModel.setAppReviewDialogShowed();
      }

      totalScreenModel.changeLoaded();
      introModel.changeLoaded();
    });
    return Consumer<TotalScoreListModel>(
        builder: (context, totalScoreListModel, child) {
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
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            _ad(context),
                            RefreshIndicator(
                              onRefresh: () async {
                                await introModel.getCurrentUserData();
                                await totalScoreListModel.getFavoriteScores();
                                totalScoreListModel.changeLoaded();
                              },
                              child: Column(
                                children: [
                                  _settingButtons(context),
                                  _eventsListView(context)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              (!model.isIntroWatched) ? IntroScreen() : Container(),
              (model.isLoading || totalScoreListModel.isLoading)
                  ? Container(
                      color: Colors.grey.withOpacity(0.6),
                      child: Center(
                        child: Platform.isIOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator(),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      );
    });
  }

  Widget _ad(BuildContext context) {
    return banner == null
        ? Container()
        : SizedBox(
            height: 50,
            child: AdWidget(ad: banner!),
          );
  }

  Widget _settingButtons(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 50; //広告の分の50px
    return SizedBox(
      height: height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.push<Object>(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _eventsListView(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 50;
    return SizedBox(
      height: height * 0.9,
      child: ListView(
        children: [
          _eventCard(context, event[0], eventEng[0]),
          _eventCard(context, event[1], eventEng[1]),
          _eventCard(context, event[2], eventEng[2]),
          _eventCard(context, event[3], eventEng[3]),
          _eventCard(context, event[4], eventEng[4]),
          _eventCard(context, event[5], eventEng[5]),
          _totalScore(),
          Container(height: 100),
        ],
      ),
    );
  }

  Widget _eventCard(BuildContext context, String event, String eventEng) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width - 50;
    return Consumer<TotalScoreListModel>(builder: (context, model, child) {
      return SizedBox(
        height: 130,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () async {
              scoreModel.selectEvent(event);
              if (event == '跳馬') {
                await scoreModel.getVTScore();
                await Navigator.push<Object>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VTScoreSelectScreen()));
              } else {
                await scoreModel.getScores(event);
                await Navigator.push<Object>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScoreListScreen(event: event),
                    ));
              }
            },
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, top: 20),
                          child: Text(
                            '$event',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            '$eventEng',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: event == '床'
                        ? model.favoriteFx == null
                            ? Text('0.0',
                                style: Theme.of(context).textTheme.headline6)
                            : Text('${model.favoriteFxScore}',
                                style: Theme.of(context).textTheme.headline6)
                        : event == 'あん馬'
                            ? model.favoritePh == null
                                ? Text('0.0',
                                    style:
                                        Theme.of(context).textTheme.headline6)
                                : Text(
                                    '${model.favoritePhScore}',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )
                            : event == '吊り輪'
                                ? model.favoriteSr == null
                                    ? Text('0.0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6)
                                    : Text(
                                        '${model.favoriteSrScore}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )
                                : event == '跳馬'
                                    ? model.vt == null
                                        ? Text('0.0',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6)
                                        : Text(
                                            '${model.vt!.score}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          )
                                    : event == '平行棒'
                                        ? model.favoritePb == null
                                            ? Text('0.0',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6)
                                            : Text(
                                                '${model.favoritePbScore}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              )
                                        : event == '鉄棒'
                                            ? model.favoriteHb == null
                                                ? Text('0.0',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6)
                                                : Text(
                                                    '${model.favoriteHbScore}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5,
                                                  )
                                            : const Text('0.0'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: width * 0.4,
                    child: _techsList(event, context),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      );
    });
  }

  //  6種目の合計
  Widget _totalScore() {
    final totalScoreListModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 160),
                child: const Text(
                  '合計',
                  style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Text(
                '${totalScoreListModel.totalScore}',
                style: TextStyle(
                  fontSize: Utilities().isMobile() ? 30 : 50,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        Divider(color: Theme.of(context).primaryColor),
      ],
    );
  }

  //技のリスト表示
  Widget _techsList(String event, BuildContext context) {
    final totalScoreListModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
    if (event == '床') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: totalScoreListModel.favoriteFx == null
              ? Container()
              : ListView(
                  children: totalScoreListModel.favoriteFx!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text('$tech')),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      );
    }
    if (event == 'あん馬') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: totalScoreListModel.favoritePh == null
              ? Container()
              : ListView(
                  children: totalScoreListModel.favoritePh!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text('$tech')),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      );
    }
    if (event == '吊り輪') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: totalScoreListModel.favoriteSr == null
              ? Container()
              : ListView(
                  children: totalScoreListModel.favoriteSr!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text('$tech')),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      );
    }
    if (event == '跳馬') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: totalScoreListModel.vt == null
                ? Container()
                : Center(child: Text('${totalScoreListModel.vt!.techName}'))),
      );
    }
    if (event == '平行棒') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: totalScoreListModel.favoritePb == null
              ? Container()
              : ListView(
                  children: totalScoreListModel.favoritePb!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text('$tech')),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      );
    }
    if (event == '鉄棒') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: totalScoreListModel.favoriteHb == null
              ? Container()
              : ListView(
                  children: totalScoreListModel.favoriteHb!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text('$tech')),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      );
    } else {
      return Container();
    }
  }
}
