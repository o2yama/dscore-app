import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_dialog/ok_cancel_dialog.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_screen.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_mode.dart';
import 'package:dscore_app/screens/search_screen/search_model.dart';
import 'package:dscore_app/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../common/utilities.dart';

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
          _under16Switch(context, ref),
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
          Container(),
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
          onCancel: () {
            Navigator.pop(context);
          },
          title: '保存せずに戻ってもよろしいですか？',
          content: '変更した内容は破棄されます。',
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onStoreButtonPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final loadingStateModel = ref.watch(loadingStateProvider.notifier);
    final performanceListModel = ref.watch(performanceListModelProvider);
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    if (editPerformanceModel.currentUser == null) {
      await showOkAlertDialog(
        context: context,
        title: 'ログインしてください。',
      );
    } else {
      if (editPerformanceModel.numberOfGroup1 > 5 ||
          editPerformanceModel.numberOfGroup2 > 5 ||
          editPerformanceModel.numberOfGroup3 > 5) {
        await showOkAlertDialog(
          context: context,
          title: '同一グループが6つ以上登録されています。',
          message: 'この演技は保存できません。',
        );
      } else {
        loadingStateModel.startLoading();

        editPerformanceModel.noEdited();
        scoreId == null
            ? await editPerformanceModel.setScore(
                event,
                performanceListModel.scoreList(event).isEmpty,
              )
            : await editPerformanceModel.updateScore(event, scoreId!);
        await performanceListModel.getScores(event);
        await ref.watch(homeModelProvider).getFavoriteScores();

        loadingStateModel.endLoading();
        await showOkAlertDialog(
          context: context,
          title: '保存しました。',
        );

        Navigator.pop(context);
      }
    }
  }

  Widget _totalScore(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final difficultyOfGroup4 = editPerformanceModel.difficultyOfGroup4;

    return SizedBox(
      height: 100,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const VerticalDivider(color: Colors.black54),
            Text(
              'Ⅰ : ${editPerformanceModel.numberOfGroup1}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: editPerformanceModel.numberOfGroup1 > 5
                    ? Colors.redAccent
                    : Colors.grey,
              ),
            ),
            const VerticalDivider(color: Colors.black54),
            Text(
              'Ⅱ : ${editPerformanceModel.numberOfGroup2}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: editPerformanceModel.numberOfGroup2 > 5
                    ? Colors.redAccent
                    : Colors.grey,
              ),
            ),
            const VerticalDivider(color: Colors.black54),
            Text(
              'Ⅲ : ${editPerformanceModel.numberOfGroup3}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: editPerformanceModel.numberOfGroup3 > 5
                    ? Colors.redAccent
                    : Colors.grey,
              ),
            ),
            const VerticalDivider(color: Colors.black54),
            event != Event.fx
                ? Text(
                    editPerformanceModel.difficultyOfGroup4 == 0
                        ? 'Ⅳ : -'
                        : 'Ⅳ : ${Convertor.difficulty[difficultyOfGroup4]}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : Container(),
            const VerticalDivider(color: Colors.black54),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                '${editPerformanceModel.totalScore}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
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
              '${editPerformanceModel.difficultyPoint}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          ],
        ),
        Column(
          children: [
            const Text('要求点'),
            Text(
              '${editPerformanceModel.egr}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          ],
        ),
        event == Event.fx || event == Event.hb
            ? Column(
                children: [
                  const Text('組み合わせ'),
                  _cvSelectMenu(context, editPerformanceModel),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _cvSelectMenu(
    BuildContext context,
    EditPerformanceModel editPerformanceModel,
  ) {
    final cvs = [0.0, 0.1, 0.2, 0.3, 0.4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 32),
        Text(
          '${editPerformanceModel.cv}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        const SizedBox(width: 16),
        PopupMenuButton(
          itemBuilder: (context) => cvs
              .map(
                (cv) => PopupMenuItem<Widget>(
                  height: 32,
                  child: SizedBox(
                    child: TextButton(
                      onPressed: () {
                        editPerformanceModel
                          ..onCVSelected(cv)
                          ..calculateScore(event);
                        Navigator.pop(context);
                      },
                      child: Text(
                        '$cv',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          child: const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }

  Widget _under16Switch(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '高校生ルール',
          style: TextStyle(
            color: editPerformanceModel.isUnder16 ? Colors.black : Colors.grey,
          ),
        ),
        Switch(
          activeColor: Theme.of(context).primaryColor,
          value: editPerformanceModel.isUnder16,
          onChanged: (bool isUnder16) =>
              editPerformanceModel.setRule(event, isUnder16),
        )
      ],
    );
  }

  Widget _techList(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);

    return editPerformanceModel.totalScore == 0
        ? IconButton(
            onPressed: () {
              if (editPerformanceModel.currentUser == null) {
                Navigator.push<Object>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                    fullscreenDialog: true,
                  ),
                );
              } else {
                searchController.clear();
                ref.watch(searchModelProvider).searchResult.clear();
                editPerformanceModel.selectEvent(event);
                Navigator.push<Object>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(event: event),
                    fullscreenDialog: true,
                  ),
                );
              }
            },
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
          )
        : Expanded(
            child: ReorderableListView(
              onReorder: (int oldIndex, int newIndex) =>
                  editPerformanceModel.onReOrder(oldIndex, newIndex, event),
              children: editPerformanceModel.decidedTechList
                  .map((tech) => _techTile(
                        context,
                        tech,
                        editPerformanceModel.decidedTechList.indexOf(tech) + 1,
                        ref,
                      ))
                  .toList(),
            ),
          );
  }

  Widget _techTile(
    BuildContext context,
    String techName,
    int order,
    WidgetRef ref,
  ) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final group = editPerformanceModel.group[techName];
    final difficulty = editPerformanceModel.difficulty[techName];

    return Column(
      key: Key(
        editPerformanceModel.decidedTechList.indexOf(techName).toString(),
      ),
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(order.toString()),
            ),
            Expanded(
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      label: '削除',
                      backgroundColor: Colors.red,
                      icon: Icons.remove,
                      onPressed: (BuildContext context) {
                        editPerformanceModel.deleteTech(order - 1, event);
                      },
                    ),
                  ],
                ),
                child: Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            techName,
                            style: TextStyle(
                              fontSize: Utilities.isMobile() ? 15.0 : 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 110,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 8),
                              const Expanded(
                                child:
                                    Text('難度', style: TextStyle(fontSize: 10)),
                              ),
                              Expanded(
                                child: Text(
                                  Convertor.difficulty[difficulty].toString(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Column(
                            children: [
                              const SizedBox(height: 8),
                              const Expanded(
                                child: Text('グループ',
                                    style: TextStyle(fontSize: 10)),
                              ),
                              Expanded(
                                child: Text(Convertor.group[group].toString()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      searchController.clear();
                      ref.watch(searchModelProvider).searchResult.clear();
                      editPerformanceModel.selectEvent(event);
                      Navigator.push<Object>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchScreen(order: order, event: event),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        editPerformanceModel.decidedTechList.length == order &&
                editPerformanceModel.decidedTechList.length < 10
            ? IconButton(
                padding: const EdgeInsets.only(top: 40, bottom: 200),
                icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
                onPressed: () {
                  searchController.clear();
                  ref.watch(searchModelProvider).searchResult.clear();
                  editPerformanceModel.selectEvent(event);
                  Navigator.push<Object>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(event: event),
                      fullscreenDialog: true,
                    ),
                  );
                },
              )
            : editPerformanceModel.decidedTechList.length == order &&
                    editPerformanceModel.decidedTechList.length == 10
                ? const SizedBox(height: 200)
                : Container(),
      ],
    );
  }
}
