import 'dart:io';
import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/domain/performance.dart';
import 'package:dscore_app/domain/performance_with_cv.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_dialog/ok_cancel_dialog.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_screen.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PerformanceListScreen extends ConsumerWidget {
  const PerformanceListScreen({Key? key, required this.event})
      : super(key: key);
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      context: context,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const BannerAdWidget(),
              _backButton(context, event, ref),
              _scoreList(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context, Event event, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Platform.isIOS
              ? Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      '6??????',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              : Icon(
                  Icons.clear,
                  color: Theme.of(context).primaryColor,
                ),
        ),
        Text(
          Convertor.eventName[event]!,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
          onPressed: () {
            ref.watch(editPerformanceModelProvider).resetScore();
            Navigator.push<Object>(
              context,
              MaterialPageRoute(
                builder: (context) => EditPerformanceScreen(event: event),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _scoreList(BuildContext context, WidgetRef ref) {
    final performanceListModel = ref.watch(performanceListModelProvider);

    switch (event) {
      case Event.fx:
        return Column(
          children: performanceListModel.fxPerformanceList
              .map(
                (score) => _scoreTile(context, ref, scoreWithCV: score),
              )
              .toList(),
        );
      case Event.ph:
        return Column(
          children: performanceListModel.phPerformanceList
              .map(
                (score) => _scoreTile(context, ref, score: score),
              )
              .toList(),
        );
      case Event.sr:
        return Column(
          children: performanceListModel.srPerformanceList
              .map(
                (score) => _scoreTile(context, ref, score: score),
              )
              .toList(),
        );
      case Event.pb:
        return Column(
          children: performanceListModel.pbPerformanceList
              .map(
                (score) => _scoreTile(context, ref, score: score),
              )
              .toList(),
        );
      case Event.hb:
        return Column(
          children: performanceListModel.hbPerformanceList
              .map(
                (score) => _scoreTile(
                  context,
                  ref,
                  scoreWithCV: score,
                ),
              )
              .toList(),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _scoreTile(
    BuildContext context,
    WidgetRef ref, {
    Performance? score,
    PerformanceWithCV? scoreWithCV,
  }) {
    return Row(
      children: [
        Expanded(
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  label: '??????',
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade300,
                  icon: CupertinoIcons.plus_square_fill_on_square_fill,
                  onPressed: (context) => _onCopyButtonPressed(
                    context,
                    score == null ? scoreWithCV!.scoreId : score.scoreId,
                    ref,
                  ),
                ),
                SlidableAction(
                  label: '??????',
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red.shade300,
                  icon: Icons.remove,
                  onPressed: (context) => _onDeleteButtonPressed(
                    context,
                    score == null ? scoreWithCV!.scoreId : score.scoreId,
                    ref,
                  ),
                ),
              ],
            ),
            child: SizedBox(
              height: 150,
              child: Card(
                child: InkWell(
                  onTap: () async {
                    ref.watch(loadingStateProvider.notifier).startLoading();

                    await ref
                        .watch(editPerformanceModelProvider)
                        .getPerformanceData(
                          score == null ? scoreWithCV!.scoreId : score.scoreId,
                          event,
                        );

                    ref.watch(loadingStateProvider.notifier).endLoading();
                    await Navigator.push<Object>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPerformanceScreen(
                          event: event,
                          scoreId: score == null
                              ? scoreWithCV!.scoreId
                              : score.scoreId,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          '${score == null ? scoreWithCV!.total : score.total}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(width: 16),
                        _techsListView(
                          context,
                          score == null ? scoreWithCV!.techs : score.techs,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            _star(
                              context,
                              score == null
                                  ? scoreWithCV!.isFavorite
                                  : score.isFavorite,
                              score == null
                                  ? scoreWithCV!.scoreId
                                  : score.scoreId,
                              ref,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //?????????????????????
  Future<void> _onCopyButtonPressed(
    BuildContext context,
    String scoreId,
    WidgetRef ref,
  ) async {
    final performanceListModel = ref.watch(performanceListModelProvider);
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    ref.watch(loadingStateProvider.notifier).startLoading();

    await editPerformanceModel.getPerformanceData(scoreId, event);
    await editPerformanceModel.setPerformance(
      event,
      performanceListModel.performanceList(event).isEmpty,
    );

    await performanceListModel.getPerformances(event);
    await ref.watch(homeModelProvider).getFavoritePerformances();

    ref.watch(loadingStateProvider.notifier).endLoading();
  }

  Future<void> _onDeleteButtonPressed(
    BuildContext context,
    String scoreId,
    WidgetRef ref,
  ) async {
    await showDialog<Dialog>(
      context: context,
      builder: (context) => OkCancelDialog(
        onOk: () async {
          await ref
              .watch(performanceListModelProvider)
              .deletePerformance(event, scoreId);
          await ref.watch(homeModelProvider).getFavoritePerformances();
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
        title: '??????????????????????????????????????????????????????',
        content: const Text('????????????????????????????????????????????????'),
      ),
    );
  }

  Widget _star(
    BuildContext context,
    bool isFavorite,
    String scoreId,
    WidgetRef ref,
  ) {
    return InkWell(
      onTap: () async {
        ref.watch(loadingStateProvider.notifier).startLoading();

        await ref
            .watch(performanceListModelProvider)
            .onStarTapped(event, isFavorite, scoreId);
        await ref.watch(performanceListModelProvider).getPerformances(event);
        await ref.watch(homeModelProvider).getFavoritePerformances();

        ref.watch(loadingStateProvider.notifier).endLoading();
      },
      child: Icon(
        Icons.star,
        color: isFavorite ? Colors.orangeAccent : Colors.grey,
      ),
    );
  }

  //????????????????????????????????????
  Widget _techsListView(BuildContext context, List<String> techs) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView(
          children: techs
              .map(
                (tech) => Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(tech, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
