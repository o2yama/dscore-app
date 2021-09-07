import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/ad.dart';
import 'package:dscore_app/common/loading_screen.dart';
import 'package:dscore_app/screens/score_edit_screen/score_edit_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/total_score_list_screen/total_score_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ScoreListScreen extends StatelessWidget {
  const ScoreListScreen({Key? key, required this.event}) : super(key: key);
  final String event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ScoreModel>(
        builder: (context, model, child) {
          final height = MediaQuery.of(context).size.height;
          return Container(
            color: Theme.of(context).backgroundColor,
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.1,
                          child: _backButton(context, event),
                        ),
                        SizedBox(
                          height: height * 0.1,
                          child: _eventNameDisplay(context),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: RefreshIndicator(
                            onRefresh: () async => model.getScores(event),
                            child: _scoreList(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Ad(),
                  model.isLoading ? LoadingScreen() : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _backButton(BuildContext context, String event) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Platform.isIOS
          ? Row(children: [
              Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                '6種目',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ])
          : Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
            ),
    );
  }

  Widget _eventNameDisplay(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Row(children: [
      SizedBox(width: width * 0.15),
      Text(
        '$event',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
      Expanded(child: Container()),
      IconButton(
          icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
          onPressed: () {
            scoreModel
              ..selectEvent(event)
              ..resetScore();
            Navigator.push<Object>(
              context,
              MaterialPageRoute(
                builder: (context) => ScoreEditScreen(event: event),
              ),
            );
          }),
      SizedBox(width: width * 0.1),
    ]);
  }

  Widget _scoreList(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    switch (event) {
      case '床':
        return ListView(
          children: scoreModel.fxScoreList
              .map((score) => _scoreTile(context, score.techs, score.total,
                  score.isFavorite, score.scoreId))
              .toList(),
        );
      case 'あん馬':
        return ListView(
          children: scoreModel.phScoreList
              .map((score) => _scoreTile(context, score.techs, score.total,
                  score.isFavorite, score.scoreId))
              .toList(),
        );
      case '吊り輪':
        return ListView(
          children: scoreModel.srScoreList
              .map((score) => _scoreTile(context, score.techs, score.total,
                  score.isFavorite, score.scoreId))
              .toList(),
        );
      case '平行棒':
        return ListView(
          children: scoreModel.pbScoreList
              .map((score) => _scoreTile(context, score.techs, score.total,
                  score.isFavorite, score.scoreId))
              .toList(),
        );
      case '鉄棒':
        return ListView(
          children: scoreModel.hbScoreList
              .map((score) => _scoreTile(context, score.techs, score.total,
                  score.isFavorite, score.scoreId))
              .toList(),
        );
      default:
        return ListView();
    }
  }

  Widget _scoreTile(BuildContext context, List<String> techs, num total,
      bool isFavorite, String scoreId) {
    final width = MediaQuery.of(context).size.width;
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return InkWell(
      onTap: () async {
        await scoreModel.getScore(scoreId, event);
        await Navigator.push<Object>(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ScoreEditScreen(event: event, scoreId: scoreId)),
        );
      },
      child: Slidable(
        actionExtentRatio: 0.2,
        actionPane: const SlidableScrollActionPane(),
        actions: [
          IconSlideAction(
            caption: '複製',
            color: Colors.blue,
            icon: CupertinoIcons.plus_square_fill_on_square_fill,
            onTap: () => _onCopyButtonPressed(context, scoreId),
          ),
        ],
        secondaryActions: [
          IconSlideAction(
            caption: '削除',
            color: Colors.red,
            icon: Icons.remove,
            onTap: () async {
              await _onDeleteButtonPressed(context, scoreId);
            },
          ),
        ],
        child: Row(children: [
          Expanded(
            child: _favoriteButton(context, isFavorite, scoreId),
          ),
          Expanded(
            flex: 9,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: width * 0.05),
                    Text(
                      '$total',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(width: width * 0.05),
                    _techsListView(context, techs),
                    SizedBox(width: width * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  ///選択した演技を複製する
  Future<void> _onCopyButtonPressed(
      BuildContext context, String scoreId) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    final totalScoreListModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
    await scoreModel.getScore(scoreId, event);
    await scoreModel.setScore(event);
    await scoreModel.getScores(event);
    await totalScoreListModel.getFavoriteScores();
    await showOkAlertDialog(
      context: context,
      title: '複製が完了しました。',
    );
  }

  Future<void> _onDeleteButtonPressed(
      BuildContext context, String scoreId) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    await showDialog<Dialog>(
      context: context,
      builder: (context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: const Text('この演技を削除してもよろしいですか？'),
              content: const Text('削除した演技は元には戻りません。'),
              actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () {
                      scoreModel.deletePerformance(event, scoreId);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  )
                ])
          : AlertDialog(
              title: const Text('この演技を削除してもよろしいですか？'),
              content: const Text('削除した演技は元には戻りません。'),
              actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () =>
                        scoreModel.deletePerformance(event, scoreId),
                    child: const Text('OK'),
                  )
                ]),
    );
  }

  Widget _favoriteButton(
      BuildContext context, bool isFavorite, String scoreId) {
    final totalScoreListModel =
        Provider.of<TotalScoreListModel>(context, listen: false);
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return IconButton(
        icon: Icon(
          Icons.star,
          size: 30,
          color: isFavorite ? Theme.of(context).primaryColor : Colors.white,
        ),
        onPressed: () async {
          await scoreModel.onFavoriteButtonTapped(event, isFavorite, scoreId);
          await totalScoreListModel.getFavoriteScores();
        });
  }

  //演技の内容が見れるところ
  Widget _techsListView(BuildContext context, List<String> techs) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView(
        children: techs
            .map((tech) => Card(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child: Text('$tech')),
                      ]),
                ))
            .toList(),
      ),
    );
  }
}
