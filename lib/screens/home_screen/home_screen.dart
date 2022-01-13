import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_mode.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_screen.dart';
import 'package:dscore_app/screens/settings_screen/settings_screen.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_list_screen.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Event { fx, ph, sr, vt, pb, hb }

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeModel = ref.watch(homeModelProvider);

    if (homeModel.isFetchedScore) {
      Future(() async {
        ref.watch(loadingStateProvider.notifier).startLoading();

        await homeModel.getUserData();
        await homeModel.getFavoriteScores();

        //プッシュ通知の許可ダイアログ
        if (homeModel.settings == null) {
          await homeModel.requestNotificationPermission();
        }

        //トータルが20点超えたら、レビュー用のダイアログ
        await homeModel.getIsAppReviewDialogShowed();
        if (!homeModel.isAppReviewDialogShowed && homeModel.totalScore >= 20) {
          await homeModel.showAppReviewDialog();
          await homeModel.setAppReviewDialogShowed();
        }

        ref.watch(loadingStateProvider.notifier).endLoading();
      });
    }

    return CustomScaffold(
      context: context,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const BannerAdWidget(),
              _settingButtons(context),
              _eventsList(context, homeModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.push<Object>(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
              fullscreenDialog: true,
            ),
          ),
        )
      ],
    );
  }

  Widget _eventsList(BuildContext context, HomeModel homeModel) {
    return Column(
      children: [
        _eventCard(context, Event.fx),
        _eventCard(context, Event.ph),
        _eventCard(context, Event.sr),
        _eventCard(context, Event.vt),
        _eventCard(context, Event.pb),
        _eventCard(context, Event.hb),
        _totalScore(context, homeModel),
        Container(height: 100),
      ],
    );
  }

  Widget _eventCard(BuildContext context, Event event) {
    return Consumer(
      builder: (context, ref, child) {
        final performanceListModel = ref.watch(performanceListModelProvider);
        final homeModel = ref.watch(homeModelProvider);

        return SizedBox(
          height: 130,
          child: Card(
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
                  await performanceListModel.getPerformances(event);
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
                      child: _score(context, homeModel, event),
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

  Widget _score(BuildContext context, HomeModel homeModel, Event event) {
    switch (event) {
      case Event.fx:
        return Text(
          '${homeModel.favoriteFxScore}',
          style: Theme.of(context).textTheme.headline6,
        );
      case Event.ph:
        return Text(
          '${homeModel.favoritePhScore}',
          style: Theme.of(context).textTheme.headline6,
        );
      case Event.sr:
        return Text(
          '${homeModel.favoriteSrScore}',
          style: Theme.of(context).textTheme.headline6,
        );
      case Event.vt:
        return Text(
          homeModel.vt == null
              ? '0.0'
              : vtTech[homeModel.vt!.techName].toString(),
          style: Theme.of(context).textTheme.headline6,
        );
      case Event.pb:
        return Text('${homeModel.favoritePbScore}',
            style: Theme.of(context).textTheme.headline6);
      case Event.hb:
        return Text(
          '${homeModel.favoriteHbScore}',
          style: Theme.of(context).textTheme.headline6,
        );
    }
  }

  //  6種目の合計
  Widget _totalScore(BuildContext context, HomeModel homeModel) {
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
          context,
          homeModel.favoriteFx == null
              ? Container()
              : ListView(
                  children: homeModel.favoriteFx!.techs
                      .map((tech) => _techText(tech))
                      .toList(),
                ),
        );
      case Event.ph:
        return _customListView(
          context,
          homeModel.favoritePh == null
              ? Container()
              : ListView(
                  children: homeModel.favoritePh!.techs
                      .map((tech) => _techText(tech))
                      .toList(),
                ),
        );
      case Event.sr:
        return _customListView(
          context,
          homeModel.favoriteSr == null
              ? Container()
              : ListView(
                  children: homeModel.favoriteSr!.techs
                      .map((tech) => _techText(tech))
                      .toList(),
                ),
        );
      case Event.vt:
        return _customListView(
          context,
          homeModel.vt == null
              ? Container()
              : Center(child: Text(homeModel.vt!.techName)),
        );
      case Event.pb:
        return _customListView(
          context,
          homeModel.favoritePb == null
              ? Container()
              : ListView(
                  children: homeModel.favoritePb!.techs
                      .map((tech) => _techText(tech))
                      .toList(),
                ),
        );
      case Event.hb:
        return _customListView(
          context,
          homeModel.favoriteHb == null
              ? Container()
              : ListView(
                  children: homeModel.favoriteHb!.techs
                      .map((tech) => _techText(tech))
                      .toList(),
                ),
        );
    }
  }

  Widget _customListView(BuildContext context, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: child,
      ),
    );
  }

  Widget _techText(String tech) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(tech, overflow: TextOverflow.ellipsis),
    );
  }
}
