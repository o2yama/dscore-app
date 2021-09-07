import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/loading_screen.dart';
import 'package:dscore_app/common/score_data.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_screen.dart';
import 'package:dscore_app/screens/score_edit_screen/search_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/total_score_list_screen/total_score_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../common/utilities.dart';

class ScoreEditScreen extends StatelessWidget {
  const ScoreEditScreen({required this.event, this.scoreId});
  final String event;
  final String? scoreId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScoreModel>(builder: (context, model, child) {
        final height = MediaQuery.of(context).size.height;
        return Container(
          color: Theme.of(context).backgroundColor,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.1,
                        child: _functionButtons(context, event),
                      ),
                      SizedBox(
                        height: height * 0.1,
                        child: _totalScoreDisplay(context),
                      ),
                      SizedBox(
                        height: height * 0.1,
                        child: _detailScores(context),
                      ),
                      SizedBox(
                          height: 40, child: _under16SwitchButton(context)),
                      SizedBox(
                        height: height * 0.7,
                        child: _techListView(context),
                      ),
                    ],
                  ),
                ),
                model.isLoading ? LoadingScreen() : Container(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _functionButtons(BuildContext context, String event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => _onBackButtonPressed(context),
          child: Platform.isIOS
              ? Row(children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    '$eventスコア一覧',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ])
              : Icon(Icons.clear, color: Theme.of(context).primaryColor),
        ),
        Container(),
        TextButton(
          onPressed: () => _onStoreButtonPressed(context),
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

  void _onBackButtonPressed(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    if (scoreModel.isEdited) {
      showDialog<Dialog>(
          context: context,
          builder: (context) => Platform.isIOS
              ? CupertinoAlertDialog(
                  title: const Text('保存せずに戻ってもよろしいですか？'),
                  content: const Text('変更した内容は破棄されます。'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        scoreModel.noEdited();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    )
                  ],
                )
              : AlertDialog(
                  title: const Text('保存せずに戻ってもよろしいですか？'),
                  content: const Text('計算した内容は破棄されます。'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    )
                  ],
                ));
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onStoreButtonPressed(BuildContext context) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    final totalScoreListModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
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
        scoreModel.noEdited();
        scoreId == null
            ? await scoreModel.setScore(event)
            : await scoreModel.updateScore(event, scoreId!);
        await scoreModel.getScores(event);
        await totalScoreListModel.getFavoriteScores();
        await showOkAlertDialog(
          context: context,
          title: '保存しました。',
        );
        Navigator.pop(context);
      }
    }
  }

  Widget _totalScoreDisplay(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    final difficultyOfGroup4 = scoreModel.difficultyOfGroup4;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Container(
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
          ),
          const VerticalDivider(color: Colors.black54),
          Expanded(
            child: Container(
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
          ),
          const VerticalDivider(color: Colors.black54),
          Expanded(
            child: Container(
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
          ),
          const VerticalDivider(color: Colors.black54),
          event != '床'
              ? Expanded(
                  child: Container(
                    child: Text(
                      scoreModel.difficultyOfGroup4 == 0
                          ? 'Ⅳ : ／'
                          : 'Ⅳ : ${difficultyDisplay[difficultyOfGroup4]}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
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

  Widget _detailScores(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
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
            event == '床' || event == '鉄棒'
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
            event == '床' || event == '鉄棒'
                ? Expanded(
                    child: Center(child: _cvSelectMenu(context)),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget _cvSelectMenu(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
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

  Widget _under16SwitchButton(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
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

  Widget _techListView(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
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
                              builder: (context) => SignUpScreen(),
                              fullscreenDialog: true,
                            ));
                      } else {
                        searchController.clear();
                        scoreModel.searchResult.clear();
                        scoreModel.selectEvent(event);
                        Navigator.push<Object>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(event),
                              fullscreenDialog: true,
                            ));
                      }
                    },
                    child: Container(
                      child: Icon(Icons.add,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            )
          : ReorderableListView(
              onReorder: (int oldIndex, int newIndex) =>
                  scoreModel.onReOrder(oldIndex, newIndex, event),
              children: scoreModel.decidedTechList
                  .map((tech) => _techTile(context, tech,
                      scoreModel.decidedTechList.indexOf(tech) + 1))
                  .toList(),
            ),
    );
  }

  Widget _techTile(BuildContext context, String techName, int order) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
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
                actionExtentRatio: 0.2,
                actionPane: const SlidableScrollActionPane(),
                secondaryActions: [
                  IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.remove,
                    onTap: () {
                      scoreModel.deleteTech(order - 1, event);
                    },
                  ),
                ],
                child: Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '$techName',
                            style: TextStyle(
                              fontSize: Utilities().isMobile() ? 15.0 : 18.0,
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
                                  '${difficultyDisplay[difficulty]}',
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
                                child: Text('${groupDisplay[group]}'),
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
                                SearchScreen(event, order: order),
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
                            builder: (context) => SearchScreen(event),
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
