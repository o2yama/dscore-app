import 'package:dscore_app/common/att.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/consts/event.dart';
import 'package:dscore_app/data/vt/vt.dart';
import 'package:dscore_app/extentions/event_extension.dart';
import 'package:dscore_app/repository/prefs_repository.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_mode.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_screen.dart';
import 'package:dscore_app/screens/settings_screen/settings_screen.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_list_screen.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const BannerAdWidget(),
              _settingButtons(context),
              _eventsList(context),
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
          onPressed: () => Navigator.push<Widget>(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
              fullscreenDialog: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _eventsList(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeModel = ref.watch(homeModelProvider);

        return FutureBuilder(
          future: Future(() async {
            if (!homeModel.isFetched) {
              ref.watch(loadingStateProvider.notifier).startLoading();
              await homeModel.getUserData();
              await homeModel.getFavoritePerformances();

              final isPermitted = await ATT.requestPermission();
              await PrefsRepository().setAttPermission(isPermitted).then(
                (_) async {
                  //トータルが20点超えたら、レビュー用のダイアログ
                  await homeModel.getIsAppReviewDialogShowed().then(
                    (result) async {
                      if (!result && homeModel.totalScore >= 20) {
                        await homeModel.showAppReviewDialog();
                      }
                    },
                  );
                },
              );

              homeModel.doneFetch();

              ref.watch(loadingStateProvider.notifier).endLoading();
            }
          }),
          builder: (context, snapshot) {
            return Column(
              children: Event.values
                  .map(
                    (event) => _eventCard(context, event, ref),
                  )
                  .toList()
                ..add(_totalScore(context, ref))
                ..add(Container(height: 150)),
            );
          },
        );
      },
    );
  }

  Widget _eventCard(BuildContext context, Event event, WidgetRef ref) {
    return SizedBox(
      height: 150,
      child: Card(
        child: InkWell(
          onTap: () async {
            if (event == Event.vt) {
              await ref.watch(vtScoreModelProvider).getVTScore();
              if (context.mounted) {
                Navigator.push<Object>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VTScoreSelectScreen(),
                  ),
                );
              }
            } else {
              ref.watch(loadingStateProvider.notifier).startLoading();
              await ref
                  .watch(performanceListModelProvider)
                  .getPerformances(event);
              ref.watch(loadingStateProvider.notifier).endLoading();
              if (context.mounted) {
                Navigator.push<Object>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerformanceListScreen(event: event),
                  ),
                );
              }
            }
          },
          child: Row(
            children: [
              _cardHeader(context, event, ref),
              Expanded(child: _techsList(event, context, ref)),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardHeader(BuildContext context, Event event, WidgetRef ref) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            event.enName,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            event.name,
            style: const TextStyle(fontSize: 16),
          ),
          _score(context, event, ref),
        ],
      ),
    );
  }

  Widget _score(BuildContext context, Event event, WidgetRef ref) {
    final homeModel = ref.watch(homeModelProvider);

    switch (event) {
      case Event.fx:
        return Text(
          '${homeModel.favoriteFxScore}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
      case Event.ph:
        return Text(
          '${homeModel.favoritePhScore}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
      case Event.sr:
        return Text(
          '${homeModel.favoriteSrScore}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
      case Event.vt:
        return Text(
          homeModel.vt == null
              ? '0.0'
              : vtTechs[homeModel.vt!.techName].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
      case Event.pb:
        return Text(
          '${homeModel.favoritePbScore}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
      case Event.hb:
        return Text(
          '${homeModel.favoriteHbScore}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        );
    }
  }

  //  6種目の合計
  Widget _totalScore(BuildContext context, WidgetRef ref) {
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
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                ),
              ),
              Text(
                ref.watch(homeModelProvider).totalScore.toString(),
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
  Widget _techsList(Event event, BuildContext context, WidgetRef ref) {
    final homeModel = ref.watch(homeModelProvider);

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
          borderRadius: BorderRadius.circular(8),
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
