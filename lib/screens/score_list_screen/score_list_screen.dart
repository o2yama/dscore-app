import 'dart:io';
import 'package:dscore_app/screens/score_edit_screen/score_edit_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ScoreListScreen extends StatefulWidget {
  ScoreListScreen(this.event);
  final String event;

  @override
  _ScoreListScreenState createState() => _ScoreListScreenState();
}

class _ScoreListScreenState extends State<ScoreListScreen> {
  @override
  void initState() {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    scoreModel.isFinishedGettingScores = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Consumer<ScoreModel>(
        builder: (context, model, child) {
          Future(() async {
            if ((!model.isFinishedGettingScores)) {
              await model.getScores(widget.event);
            }
          });
          final height = MediaQuery.of(context).size.height;
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height * 0.1,
                        child: _backButton(context, widget.event),
                      ),
                      Container(
                        height: height * 0.1,
                        child: _eventNameDisplay(context),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await model.getScores(widget.event);
                          },
                          child: _scoreList(context),
                        ),
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
                                : CircularProgressIndicator()),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _backButton(BuildContext context, String event) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Platform.isIOS
          ? Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  '6種目一覧',
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
    );
  }

  Widget _eventNameDisplay(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Container(
      height: height * 0.1,
      child: Row(
        children: [
          SizedBox(width: width * 0.1),
          Text(
            '${widget.event}',
            style: Theme.of(context).textTheme.headline4,
          ),
          Expanded(child: Container()),
          IconButton(
              icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
              onPressed: () {
                scoreModel.selectEvent(widget.event);
                scoreModel.resetScore();
                scoreModel.startEdit();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScoreEditScreen(widget.event)),
                );
              }),
          SizedBox(width: width * 0.1),
        ],
      ),
    );
  }

  Widget _scoreList(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return widget.event == '床'
        ? ListView(
            children: scoreModel.fxScoreList
                .map((score) => _scoreTile(context, score.techs, score.total,
                    score.isFavorite, score.scoreId))
                .toList(),
          )
        : widget.event == 'あん馬'
            ? ListView(
                children: scoreModel.phScoreList
                    .map((score) => _scoreTile(context, score.techs,
                        score.total, score.isFavorite, score.scoreId))
                    .toList(),
              )
            : widget.event == '吊り輪'
                ? ListView(
                    children: scoreModel.srScoreList
                        .map((score) => _scoreTile(context, score.techs,
                            score.total, score.isFavorite, score.scoreId))
                        .toList(),
                  )
                : widget.event == '平行棒'
                    ? ListView(
                        children: scoreModel.pbScoreList
                            .map((score) => _scoreTile(context, score.techs,
                                score.total, score.isFavorite, score.scoreId))
                            .toList(),
                      )
                    : widget.event == '鉄棒'
                        ? ListView(
                            children: scoreModel.hbScoreList
                                .map((score) => _scoreTile(
                                    context,
                                    score.techs,
                                    score.total,
                                    score.isFavorite,
                                    score.scoreId))
                                .toList(),
                          )
                        : ListView();
  }

  Widget _scoreTile(BuildContext context, List<String> techs, num total,
      bool isFavorite, String scoreId) {
    final width = MediaQuery.of(context).size.width;
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return InkWell(
      onTap: () async {
        await scoreModel.getScore(scoreId, widget.event);
        scoreModel.startEdit();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ScoreEditScreen(widget.event, scoreId: scoreId)),
        );
      },
      child: Slidable(
        actionExtentRatio: 0.2,
        actionPane: SlidableScrollActionPane(),
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
        child: Row(
          children: [
            Expanded(child: _favoriteButton(context, isFavorite, scoreId)),
            Expanded(
              flex: 8,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: width * 0.1),
                      Text(
                        '$total',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Expanded(child: Container()),
                      _techsListView(context, techs),
                      SizedBox(width: width * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteButtonPressed(
      BuildContext context, String scoreId) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    await showDialog(
      context: context,
      builder: (context) => Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text('この演技を削除してもよろしいですか？'),
              content: Text('削除した演技は元には戻りません。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () {
                    scoreModel.deletePerformance(widget.event, scoreId);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            )
          : AlertDialog(
              title: Text('この演技を削除してもよろしいですか？'),
              content: Text('削除した演技は元には戻りません。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () {
                    scoreModel.deletePerformance(widget.event, scoreId);
                  },
                  child: Text('OK'),
                )
              ],
            ),
    );
  }

  Widget _favoriteButton(
      BuildContext context, bool isFavorite, String scoreId) {
    return Consumer<ScoreModel>(
      builder: (context, model, child) {
        return IconButton(
            icon: Icon(
              Icons.star,
              size: 30,
              color: isFavorite ? Theme.of(context).primaryColor : Colors.white,
            ),
            onPressed: () async {
              await model.onFavoriteButtonTapped(
                  widget.event, isFavorite, scoreId);
            });
      },
    );
  }

  //演技の内容が見れるところ
  Widget _techsListView(BuildContext context, List<String> techs) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView(
        children: techs
            .map(
              (tech) => Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(child: Text('$tech')),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
