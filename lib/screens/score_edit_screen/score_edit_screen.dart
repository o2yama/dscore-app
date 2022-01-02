import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/screens/common_widgets/custom_dialog/ok_cancel_dialog.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_screen.dart';
import 'package:dscore_app/screens/score_edit_screen/search_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../common/utilities.dart';

class ScoreEditScreen extends StatelessWidget {
  const ScoreEditScreen({
    Key? key,
    required this.event,
    this.scoreId,
  }) : super(key: key);
  final Event event;
  final String? scoreId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final scoreModel = ref.watch(scoreModelProvider);

          return Container(
            color: Theme.of(context).backgroundColor,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: Utilities.screenHeight(context) * 0.1,
                          child: _header(context, event, ref),
                        ),
                        SizedBox(
                          height: Utilities.screenHeight(context) * 0.1,
                          child: _totalScoreDisplay(context, scoreModel),
                        ),
                        SizedBox(
                          height: Utilities.screenHeight(context) * 0.1,
                          child: _detailScores(context, scoreModel),
                        ),
                        SizedBox(
                          height: 40,
                          child: _under16SwitchButton(context, scoreModel),
                        ),
                        SizedBox(
                          height: Utilities.screenHeight(context) * 0.7,
                          child: _techListView(context, scoreModel),
                        ),
                      ],
                    ),
                  ),
                  const LoadingView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, Event event, WidgetRef ref) {
    return Row(
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
    );
  }

  void _onBackButtonPressed(BuildContext context, WidgetRef ref) {
    final scoreModel = ref.watch(scoreModelProvider);

    if (scoreModel.isEdited) {
      showDialog<Dialog>(
        context: context,
        builder: (context) => OkCancelDialog(
          onOk: () {
            scoreModel.noEdited();
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
    final scoreModel = ref.watch(scoreModelProvider);

    if (scoreModel.currentUser == null) {
      await showOkAlertDialog(
        context: context,
        title: 'ログインしてください。',
      );
    } else {
      if (scoreModel.numberOfGroup1 > 5 ||
          scoreModel.numberOfGroup2 > 5 ||
          scoreModel.numberOfGroup3 > 5) {
        await showOkAlertDialog(
          context: context,
          title: '同一グループが6つ以上登録されています。',
          message: 'この演技は保存できません。',
        );
      } else {
        loadingStateModel.startLoading();

        scoreModel.noEdited();
        scoreId == null
            ? await scoreModel.setScore(event)
            : await scoreModel.updateScore(event, scoreId!);
        await scoreModel.getScores(event);
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

  Widget _totalScoreDisplay(BuildContext context, ScoreModel scoreModel) {
    final difficultyOfGroup4 = scoreModel.difficultyOfGroup4;

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Ⅰ : ${scoreModel.numberOfGroup1}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: scoreModel.numberOfGroup1 > 5
                    ? Colors.redAccent
                    : Colors.grey,
              ),
            ),
          ),
          const VerticalDivider(color: Colors.black54),
          Expanded(
            child: Text(
              'Ⅱ : ${scoreModel.numberOfGroup2}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: scoreModel.numberOfGroup2 > 5
                    ? Colors.redAccent
                    : Colors.grey,
              ),
            ),
          ),
          const VerticalDivider(color: Colors.black54),
          Expanded(
            child: Text(
              'Ⅲ : ${scoreModel.numberOfGroup3}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: scoreModel.numberOfGroup3 > 5
                    ? Colors.redAccent
                    : Colors.grey,
              ),
            ),
          ),
          const VerticalDivider(color: Colors.black54),
          event != Event.fx
              ? Expanded(
                  child: Text(
                    scoreModel.difficultyOfGroup4 == 0
                        ? 'Ⅳ : ／'
                        : 'Ⅳ : ${Convertor.difficulty[difficultyOfGroup4]}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Container(),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(right: 15),
              child: FittedBox(
                child: Text(
                  '${scoreModel.totalScore}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _detailScores(BuildContext context, ScoreModel scoreModel) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  '難度点',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  '要求点',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            event == Event.fx || event == Event.hb
                ? const Expanded(
                    child: Center(
                      child: Text(
                        '組み合わせ',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '${scoreModel.difficultyPoint}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '${scoreModel.egr}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            event == Event.fx || event == Event.hb
                ? Expanded(
                    child: Center(
                      child: _cvSelectMenu(context, scoreModel),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget _cvSelectMenu(BuildContext context, ScoreModel scoreModel) {
    final cvs = [0.0, 0.1, 0.2, 0.3, 0.4];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 32),
        Text(
          '${scoreModel.cv}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                        scoreModel
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

  Widget _under16SwitchButton(BuildContext context, ScoreModel scoreModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '高校生ルール',
          style: TextStyle(
            color: scoreModel.isUnder16 ? Colors.black : Colors.grey,
          ),
        ),
        Switch(
          activeColor: Theme.of(context).primaryColor,
          value: scoreModel.isUnder16,
          onChanged: (bool isUnder16) => scoreModel.setRule(event, isUnder16),
        )
      ],
    );
  }

  Widget _techListView(BuildContext context, ScoreModel scoreModel) {
    return Container(
      child: scoreModel.totalScore == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: InkWell(
                    onTap: () {
                      if (scoreModel.currentUser == null) {
                        Navigator.push<Object>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      } else {
                        searchController.clear();
                        scoreModel.searchResult.clear();
                        scoreModel.selectEvent(event);
                        Navigator.push<Object>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(event: event),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                    },
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            )
          : ReorderableListView(
              onReorder: (int oldIndex, int newIndex) =>
                  scoreModel.onReOrder(oldIndex, newIndex, event),
              children: scoreModel.decidedTechList.map((tech) {
                return _techTile(
                  context,
                  tech,
                  scoreModel.decidedTechList.indexOf(tech) + 1,
                  scoreModel,
                );
              }).toList(),
            ),
    );
  }

  Widget _techTile(
    BuildContext context,
    String techName,
    int order,
    ScoreModel scoreModel,
  ) {
    final group = scoreModel.group[techName];
    final difficulty = scoreModel.difficulty[techName];
    return Column(
      key: Key(scoreModel.decidedTechList.indexOf(techName).toString()),
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Text('$order', textAlign: TextAlign.center),
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
                        scoreModel.deleteTech(order - 1, event);
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
                      scoreModel.searchResult.clear();
                      scoreModel.selectEvent(event);
                      Navigator.push<Object>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchScreen(order: order, event: event),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        scoreModel.decidedTechList.length == order &&
                scoreModel.decidedTechList.length < 10
            ? Column(
                children: [
                  IconButton(
                    icon:
                        Icon(Icons.add, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      searchController.clear();
                      scoreModel.searchResult.clear();
                      scoreModel.selectEvent(event);
                      Navigator.push<Object>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(event: event),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  const SizedBox(height: 200),
                ],
              )
            : scoreModel.decidedTechList.length == order &&
                    scoreModel.decidedTechList.length == 10
                ? const SizedBox(height: 200)
                : Container(),
      ],
    );
  }
}
