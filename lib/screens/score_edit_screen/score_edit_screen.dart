import 'dart:io';
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
  ScoreEditScreen(this.event, {this.scoreId});
  final String event;
  final String? scoreId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Consumer<ScoreModel>(builder: (context, model, child) {
        final height = MediaQuery.of(context).size.height;
        return SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Container(
                      height: height * 0.1,
                      child: _backButton(context, event),
                    ),
                    Container(
                      height: height * 0.1,
                      child: _totalScoreDisplay(context),
                    ),
                    Container(
                      height: height * 0.1,
                      child: _detailsScore(context),
                    ),
                    Container(
                      height: height * 0.7,
                      child: _techListView(context),
                    ),
                  ],
                ),
              ),
              model.isLoading
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
          ),
        );
      }),
    );
  }

  Widget _backButton(BuildContext context, String event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          child: Platform.isIOS
              ? Row(
                  children: [
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
                  ],
                )
              : Icon(
                  Icons.clear,
                  color: Theme.of(context).primaryColor,
                ),
          onPressed: () {
            _onBackButtonPressed(context);
          },
        ),
        TextButton(
          child: Text(
            scoreId == null ? '保存' : '更新',
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 15.0),
          ),
          onPressed: () {
            _onStoreButtonPressed(context);
          },
        ),
      ],
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    if (scoreModel.isEdited) {
      showDialog(
          context: context,
          builder: (context) => Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('保存せずに戻ってもよろしいですか？'),
                  content: Text('変更した内容は破棄されます。'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    )
                  ],
                )
              : AlertDialog(
                  title: Text('保存せずに戻ってもよろしいですか？'),
                  content: Text('計算した内容は破棄されます。'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    )
                  ],
                ));
    } else {
      Navigator.pop(context);
    }
  }

  //保存ボタン押された時の処理
  Future<void> _onStoreButtonPressed(BuildContext context) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    final totalScoreListModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
    if (scoreModel.currentUser == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text('ログインしてください。'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      )
                    ],
                  )
                : AlertDialog(
                    title: Text('ログインしてください。'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      )
                    ],
                  );
          });
    } else {
      if (scoreModel.numberOfGroup1 > 5 ||
          scoreModel.numberOfGroup2 > 5 ||
          scoreModel.numberOfGroup3 > 5) {
        showDialog(
            context: context,
            builder: (context) {
              return Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text('同一グループが6つ以上登録されています。'),
                      content: Text('この演技は保存できません。'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        )
                      ],
                    )
                  : AlertDialog(
                      title: Text('同一グループが6つ以上登録されています。'),
                      content: Text('この演技は保存できません。'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        )
                      ],
                    );
            });
      } else {
        scoreId == null
            ? await scoreModel.setScore(event)
            : await scoreModel.updateScore(event, scoreId!);
        scoreModel.doneEdit();
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text('保存しました'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            scoreModel.getScores(event);
                            totalScoreListModel.getFavoriteScores();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('0K'),
                        ),
                      ],
                    )
                  : AlertDialog(
                      title: Text('保存しました'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await scoreModel.getScores(event);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            '0K',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    );
            });
      }
    }
  }

  Widget _totalScoreDisplay(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
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
          VerticalDivider(color: Colors.black54),
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
          VerticalDivider(color: Colors.black54),
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
          VerticalDivider(color: Colors.black54),
          event != '床'
              ? Expanded(
                  child: Container(
                    child: Text(
                      scoreModel.difficultyOfGroup4 == 0
                          ? 'Ⅳ : ／'
                          : 'Ⅳ : ${scoreOfDifficulty[scoreModel.difficultyOfGroup4]}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              : Container(),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 15.0),
              child: FittedBox(
                child: Text(
                  '${scoreModel.totalScore}',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _detailsScore(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '難度点',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '要求点',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            event == '床' || event == '鉄棒'
                ? Expanded(
                    child: Center(
                      child: Text(
                        '組み合わせ',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '${scoreModel.difficultyPoint}',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '${scoreModel.egr}',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            event == '床' || event == '鉄棒'
                ? Expanded(
                    child: Center(
                      child: _cvSelectMenu(context),
                    ),
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
        SizedBox(width: 32),
        Text('${scoreModel.cv}', textAlign: TextAlign.center),
        SizedBox(width: 16),
        PopupMenuButton(
          child: Icon(Icons.arrow_drop_down),
          itemBuilder: (context) => cvs
              .map(
                (cv) => PopupMenuItem(
                  child: Container(
                    width: 100,
                    height: 50,
                    child: TextButton(
                      child: Text('$cv'),
                      onPressed: () {
                        scoreModel.onCVSelected(cv);
                        scoreModel.calculateScore(event);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              )
              .toList(),
        ),
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
                Container(
                  height: 50,
                  width: 100,
                  child: InkWell(
                    child: Container(
                      child: Icon(Icons.add,
                          color: Theme.of(context).primaryColor),
                    ),
                    onTap: () {
                      if (scoreModel.currentUser == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                              fullscreenDialog: true,
                            ));
                      } else {
                        searchController.clear();
                        scoreModel.searchResult.clear();
                        scoreModel.selectEvent(event);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(event),
                              fullscreenDialog: true,
                            ));
                      }
                    },
                  ),
                ),
              ],
            )
          : ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                scoreModel.onReOrder(oldIndex, newIndex);
              },
              children: scoreModel.decidedTechList
                  .map((tech) => _techTile(context, tech,
                      scoreModel.decidedTechList.indexOf(tech) + 1))
                  .toList(),
            ),
    );
  }

  Widget _techTile(BuildContext context, String techName, int order) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Column(
      key: Key(scoreModel.decidedTechList.indexOf(techName).toString()),
      children: [
        Row(
          children: [
            SizedBox(width: 16),
            Text(
              '$order',
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Slidable(
                actionExtentRatio: 0.2,
                actionPane: SlidableScrollActionPane(),
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
                        SizedBox(width: 8),
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
                    trailing: Container(
                      width: 110,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 8),
                              Expanded(
                                child:
                                    Text('難度', style: TextStyle(fontSize: 10)),
                              ),
                              Expanded(
                                child: Text(
                                    '${scoreOfDifficulty[scoreModel.difficulty[techName]]}'),
                              ),
                            ],
                          ),
                          SizedBox(width: 24),
                          Column(
                            children: [
                              SizedBox(height: 8),
                              Expanded(
                                child: Text('グループ',
                                    style: TextStyle(fontSize: 10)),
                              ),
                              Expanded(
                                child: Text(
                                    '${groupDisplay[scoreModel.group[techName]]}'),
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
                      Navigator.push(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(event),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                  SizedBox(height: 200),
                ],
              )
            : scoreModel.decidedTechList.length == order &&
                    scoreModel.decidedTechList.length == 10
                ? SizedBox(height: 200)
                : Container(),
      ],
    );
  }
}
