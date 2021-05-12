import 'dart:io';
import 'package:dscore_app/data/score_datas.dart';
import 'package:dscore_app/screens/score_edit_screen/search_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../ad_state.dart';

class ScoreEditScreen extends StatefulWidget {
  ScoreEditScreen(this.event, {this.scoreId});
  final String event;
  final String? scoreId;

  @override
  _ScoreEditScreenState createState() => _ScoreEditScreenState();
}

class _ScoreEditScreenState extends State<ScoreEditScreen> {
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
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScoreModel>(builder: (context, model, child) {
        final height = MediaQuery.of(context).size.height - 50;
        return SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  //広告
                  ad(context),
                  //戻るボタン
                  Container(
                    height: height * 0.1,
                    child: _backButton(context, widget.event),
                  ),
                  //Dスコアの表示
                  Container(
                    height: height * 0.1,
                    child: _totalScore(context),
                  ),
                  //スコアの詳細
                  Container(
                    height: height * 0.1,
                    child: _detailsScore(context),
                  ),
                  //技名の表示
                  Container(
                    height: height * 0.7,
                    child: _techListView(context),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  //広告
  Widget ad(BuildContext context) {
    return banner == null
        ? Container(height: 50)
        : Container(
            height: 50,
            child: AdWidget(ad: banner!),
          );
  }

  //戻るボタンと保存ボタン
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
            onBackButtonPressed(context);
          },
        ),
        TextButton(
          child: Text(
            widget.scoreId == null ? '保存' : '更新',
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 15.0),
          ),
          onPressed: () {
            onStoreButtonPressed(context);
          },
        ),
      ],
    );
  }

  void onBackButtonPressed(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    if (scoreModel.isEdited) {
      showDialog(
          context: context,
          builder: (context) => Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('保存せずに戻ってもよろしいですか？'),
                  content: Text('変更した内容は破棄されます。'),
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('キャンセル'),
                          ),
                        ),
                        VerticalDivider(
                          width: 2,
                          color: Colors.black54,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : AlertDialog(
                  title: Text('保存せずに戻ってもよろしいですか？'),
                  content: Text('計算した内容は破棄されます。'),
                  actions: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    )
                  ],
                ));
    } else {
      Navigator.pop(context);
    }
  }

  //保存ボタン押された時の処理
  Future<void> onStoreButtonPressed(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    widget.scoreId == null
        ? scoreModel.setScore(widget.event)
        : scoreModel.updateScore(widget.event, widget.scoreId!);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('保存しました'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await scoreModel.getScores(widget.event);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        '0K',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text('保存しました'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await scoreModel.getSRScores();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        '0K',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                );
        });
  }

  //Dスコアの表示
  Widget _totalScore(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(right: 15.0),
            child: FittedBox(
              child: Text(
                '${scoreModel.totalScore}',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  //スコアの詳細
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
            widget.event == '床' || widget.event == '鉄棒'
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
            widget.event == '床' || widget.event == '鉄棒'
                ? Expanded(
                    child: Center(
                      child: cvSelectMenu(context),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget cvSelectMenu(BuildContext context) {
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
                        scoreModel.calculateScore(widget.event);
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
                      searchController.clear();
                      scoreModel.searchResult.clear();
                      scoreModel.selectEvent(widget.event);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(widget.event),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: () async => await scoreModel.getScores(widget.event),
              child: ListView(
                children: scoreModel.decidedTechList
                    .map((tech) => _techTile(context, tech,
                        scoreModel.decidedTechList.indexOf(tech) + 1))
                    .toList(),
              ),
            ),
    );
  }

  Widget _techTile(BuildContext context, String techName, int order) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Column(
      children: [
        Card(
          child: Slidable(
            actionExtentRatio: 0.2,
            actionPane: SlidableScrollActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: '削除',
                color: Colors.red,
                icon: Icons.remove,
                onTap: () {
                  scoreModel.deleteTech(order - 1, widget.event);
                },
              ),
            ],
            child: ListTile(
              title: Row(
                children: [
                  Text('$order'),
                  SizedBox(width: 8),
                  Flexible(
                      child:
                          Text('$techName', style: TextStyle(fontSize: 14.0))),
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
                          child: Text('難度', style: TextStyle(fontSize: 10)),
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
                          child: Text('グループ', style: TextStyle(fontSize: 10)),
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
                scoreModel.selectEvent(widget.event);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchScreen(widget.event, order: order),
                      fullscreenDialog: true,
                    ));
              },
            ),
          ),
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
                      scoreModel.selectEvent(widget.event);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(widget.event),
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
