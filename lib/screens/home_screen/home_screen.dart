import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_mode.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_screen.dart';
import 'package:dscore_app/screens/settings_screen/settings_screen.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_list_screen.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/utilities.dart';
import '../intro/intro_model.dart';
import '../intro/intro_screen.dart';

enum Event { fx, ph, sr, vt, pb, hb }

final List<String> event = ['床', 'あん馬', '吊り輪', '跳馬', '平行棒', '鉄棒'];
final List<String> eventEng = ['FX', 'PH', 'SR', 'VT', 'PB', 'HB'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final loadingStateModel = ref.watch(loadingStateProvider.notifier);
        final introModel = ref.watch(introModelProvider);
        final homeModel = ref.watch(homeModelProvider);

        return FutureBuilder(
          future: Future(() async {
            loadingStateModel.startLoading();

            //イントロを見たか確認
            if (!introModel.isIntroWatched) {
              await introModel.checkIsIntroWatched();
            }

            //currentUserがnullならユーザーデータ取得
            if (introModel.currentUser == null &&
                !introModel.isFetchedUserData) {
              await introModel.getCurrentUserData();
            } else {
              if (introModel.isIntroWatched && !homeModel.isFetchedScore) {
                await homeModel.getFavoriteScores();
              }
            }

            //プッシュ通知の許可ダイアログ
            if (homeModel.settings == null) {
              await homeModel.requestNotificationPermission();
            }

            //トータルが20点超えたら、レビュー用のダイアログ
            await homeModel.getIsAppReviewDialogShowed();
            if (!homeModel.isAppReviewDialogShowed &&
                homeModel.totalScore >= 20) {
              await homeModel.showAppReviewDialog();
              await homeModel.setAppReviewDialogShowed();
            }

            loadingStateModel.endLoading();
          }),
          builder: (context, snapshot) {
            return Scaffold(
              body: Container(
                color: Theme.of(context).backgroundColor,
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              RefreshIndicator(
                                onRefresh: () async {
                                  loadingStateModel.startLoading();
                                  await introModel.getCurrentUserData();
                                  await homeModel.getFavoriteScores();
                                  loadingStateModel.endLoading();
                                },
                                child: Column(
                                  children: [
                                    _settingButtons(context),
                                    _eventsListView(
                                      context,
                                      homeModel,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const BannerAdWidget(),
                      (!introModel.isIntroWatched)
                          ? const IntroScreen()
                          : Container(),
                      const LoadingView(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _settingButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
        icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.push<Object>(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
              fullscreenDialog: true,
            ),
          );
        },
      )
    ]);
  }

  Widget _eventsListView(BuildContext context, HomeModel homeModel) {
    return SizedBox(
      height: Utilities.screenHeight(context) * 0.9,
      child: ListView(children: [
        _eventCard(context, Event.fx),
        _eventCard(context, Event.ph),
        _eventCard(context, Event.sr),
        _eventCard(context, Event.vt),
        _eventCard(context, Event.pb),
        _eventCard(context, Event.hb),
        _totalScore(homeModel),
        Container(height: 100),
      ]),
    );
  }

  Widget _eventCard(BuildContext context, Event event) {
    return Consumer(
      builder: (context, ref, child) {
        final scoreModel = ref.watch(performanceListModelProvider);
        final homeModel = ref.watch(homeModelProvider);

        return SizedBox(
          height: 130,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () async {
                ref.watch(editPerformanceModelProvider).selectEvent(event);
                if (event == Event.vt) {
                  await ref.watch(vtScoreModelProvider).getVTScore();
                  await Navigator.push<Object>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VTScoreSelectScreen(),
                    ),
                  );
                } else {
                  ref.watch(loadingStateProvider.notifier).startLoading();
                  await scoreModel.getScores(event);
                  ref.watch(loadingStateProvider.notifier).endLoading();
                  await Navigator.push<Object>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PerformanceListScreen(event: event),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Column(children: [
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, top: 20),
                          child: Text(
                            Convertor.eventName[event]!,
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
                            Convertor.eventNameEn[event]!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: _scoreDisplay(context, homeModel, event),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: Utilities.screenWidth(context) * 0.4,
                      child: _techsList(event, context, homeModel),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _scoreDisplay(
    BuildContext context,
    HomeModel homeModel,
    Event event,
  ) {
    switch (event) {
      case Event.fx:
        return homeModel.favoriteFx == null
            ? Text('0.0', style: Theme.of(context).textTheme.headline6)
            : Text('${homeModel.favoriteFxScore}',
                style: Theme.of(context).textTheme.headline6);
      case Event.ph:
        return homeModel.favoritePh == null
            ? Text('0.0', style: Theme.of(context).textTheme.headline6)
            : Text('${homeModel.favoritePhScore}',
                style: Theme.of(context).textTheme.headline6);
      case Event.sr:
        return homeModel.favoriteSr == null
            ? Text('0.0', style: Theme.of(context).textTheme.headline6)
            : Text('${homeModel.favoriteSrScore}',
                style: Theme.of(context).textTheme.headline6);
      case Event.vt:
        return homeModel.vt == null
            ? Text('0.0', style: Theme.of(context).textTheme.headline6)
            : Text('${vtTech[homeModel.vt!.techName]}',
                style: Theme.of(context).textTheme.headline6);
      case Event.pb:
        return homeModel.favoritePb == null
            ? Text('0.0', style: Theme.of(context).textTheme.headline6)
            : Text('${homeModel.favoritePbScore}',
                style: Theme.of(context).textTheme.headline6);
      case Event.hb:
        return homeModel.favoriteHb == null
            ? Text('0.0', style: Theme.of(context).textTheme.headline6)
            : Text('${homeModel.favoriteHbScore}',
                style: Theme.of(context).textTheme.headline6);
    }
  }

  //  6種目の合計
  Widget _totalScore(HomeModel homeModel) {
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
                homeModel.totalScore.toString(),
                style: TextStyle(
                  fontSize: Utilities.isMobile() ? 30 : 50,
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
  Widget _techsList(
    Event event,
    BuildContext context,
    HomeModel homeModel,
  ) {
    switch (event) {
      case Event.fx:
        return _customListView(
          homeModel.favoriteFx == null
              ? Container()
              : ListView(
                  children: homeModel.favoriteFx!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text(tech)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
      case Event.ph:
        return _customListView(
          homeModel.favoritePh == null
              ? Container()
              : ListView(
                  children: homeModel.favoritePh!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text(tech)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
      case Event.sr:
        return _customListView(
          homeModel.favoriteSr == null
              ? Container()
              : ListView(
                  children: homeModel.favoriteSr!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text(tech)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
      case Event.vt:
        return _customListView(
          homeModel.vt == null
              ? Container()
              : Center(child: Text(homeModel.vt!.techName)),
        );
      case Event.pb:
        return _customListView(
          homeModel.favoritePb == null
              ? Container()
              : ListView(
                  children: homeModel.favoritePb!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text(tech)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
      case Event.hb:
        return _customListView(
          homeModel.favoriteHb == null
              ? Container()
              : ListView(
                  children: homeModel.favoriteHb!.techs
                      .map(
                        (tech) => Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(child: Text(tech)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
    }
  }

  Widget _customListView(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}
