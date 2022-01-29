import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_dialog/ok_cancel_dialog.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/edit_performance_screen/components/cv_menu.dart';
import 'package:dscore_app/screens/edit_performance_screen/components/group_count.dart';
import 'package:dscore_app/screens/edit_performance_screen/components/tech_tile.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_mode.dart';
import 'package:dscore_app/screens/search_screen/search_model.dart';
import 'package:dscore_app/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPerformanceScreen extends ConsumerWidget {
  const EditPerformanceScreen({Key? key, required this.event, this.scoreId})
      : super(key: key);
  final Event event;
  final String? scoreId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      context: context,
      body: Column(
        children: [
          const BannerAdWidget(),
          _header(context, event, ref),
          _totalScore(context, ref),
          _scoreDetails(context, ref),
          _utils(context, ref),
          _techList(context, ref),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, Event event, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _onBackButtonPressed(context, ref),
            child: Platform.isIOS
                ? Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '${Convertor.eventName[event]}スコア一覧',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.clear, color: Theme.of(context).primaryColor),
          ),
          TextButton(
            onPressed: () => _onStoreButtonPressed(context, ref),
            child: Text(
              scoreId == null ? '保存' : '更新',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalScore(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final difficultyOfGroup4 = editPerformanceModel.difficultyGroup4(
      editPerformanceModel.decidedTechList,
      event,
    );

    return SizedBox(
      height: 110,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const VerticalDivider(color: Colors.black54),
            GroupCount(
              group: 'Ⅰ',
              count: editPerformanceModel.countGroup1(event),
            ),
            const VerticalDivider(color: Colors.black54),
            GroupCount(
              group: 'Ⅱ',
              count: editPerformanceModel.countGroup2(event),
            ),
            const VerticalDivider(color: Colors.black54),
            GroupCount(
              group: 'Ⅲ',
              count: editPerformanceModel.countGroup3(event),
            ),
            const VerticalDivider(color: Colors.black54),
            event == Event.fx
                ? const SizedBox()
                : Text(
                    difficultyOfGroup4 == 0
                        ? 'Ⅳ : -'
                        : 'Ⅳ : ${Convertor.difficulty[difficultyOfGroup4]}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
            const VerticalDivider(color: Colors.black54),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${editPerformanceModel.calcTotalScore(event)}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(${editPerformanceModel.decidedTechList.length}技)',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreDetails(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('難度点'),
            Text(
              '${editPerformanceModel.calculateDifficulty(event)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          ],
        ),
        Column(
          children: [
            const Text('要求点'),
            Text(
              '${editPerformanceModel.calculateEGR(event)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          ],
        ),
        event == Event.fx || event == Event.hb
            ? Column(
                children: const [
                  Text('組み合わせ'),
                  CvMenu(),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _utils(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          editPerformanceModel.decidedTechList.length == 10
              ? const SizedBox()
              : TextButton(
                  onPressed: () {
                    searchController.clear();
                    ref.watch(searchModelProvider).searchResult.clear();
                    Navigator.push<Object>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(event: event),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Theme.of(context).primaryColor),
                      Text(
                        '技の追加',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ),
          Row(
            children: [
              Text(
                '高校生ルール',
                style: TextStyle(
                  color: editPerformanceModel.isUnder16
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
              Switch(
                activeColor: Theme.of(context).primaryColor,
                value: editPerformanceModel.isUnder16,
                onChanged: (bool isUnder16) =>
                    editPerformanceModel.setRule(event, isUnder16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _techList(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ReorderableListView(
          onReorder: (int oldIndex, int newIndex) =>
              editPerformanceModel.onReOrder(oldIndex, newIndex, event),
          children: editPerformanceModel.decidedTechList
              .map(
                (tech) => TechTile(
                  key: Key(
                    editPerformanceModel.decidedTechList
                        .indexOf(tech)
                        .toString(),
                  ),
                  techName: tech,
                  order: editPerformanceModel.decidedTechList.indexOf(tech) + 1,
                  event: event,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _onBackButtonPressed(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    if (editPerformanceModel.isEdited) {
      showDialog<Dialog>(
        context: context,
        builder: (context) => OkCancelDialog(
          onOk: () {
            editPerformanceModel.noEdited();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
          title: '保存せずに戻ってもよろしいですか？',
          content: const Text('変更した内容は破棄されます。'),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onStoreButtonPressed(
      BuildContext context, WidgetRef ref) async {
    final loadingStateModel = ref.watch(loadingStateProvider.notifier);
    final performanceListModel = ref.watch(performanceListModelProvider);
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    if (_validCountOfGroup(ref)) {
      await showOkAlertDialog(
        context: context,
        title: '同一グループが6つ以上登録されています。',
        message: 'この演技は保存できません。',
      );
    } else {
      loadingStateModel.startLoading();

      editPerformanceModel.noEdited();
      scoreId == null
          ? await editPerformanceModel.setPerformance(
              event,
              performanceListModel.performanceList(event).isEmpty,
            )
          : await editPerformanceModel.updatePerformance(event, scoreId!);
      await performanceListModel.getPerformances(event);
      await ref.watch(homeModelProvider).getFavoritePerformances();

      loadingStateModel.endLoading();
      await showOkAlertDialog(
        context: context,
        title: '保存しました。',
      );

      Navigator.pop(context);
    }
  }

  //グループが５つを超えた場合の処理
  bool _validCountOfGroup(WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final countGroup1 = editPerformanceModel.countGroup1(event);
    final countGroup2 = editPerformanceModel.countGroup2(event);
    final countGroup3 = editPerformanceModel.countGroup3(event);

    return countGroup1 > 5 || countGroup2 > 5 || countGroup3 > 5;
  }
}
