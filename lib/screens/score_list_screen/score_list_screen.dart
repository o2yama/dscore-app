import 'dart:io';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/vt_score.dart';
import 'package:dscore_app/screens/score_list_screen/score_edit_screen/score_edit_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/score_list_screen/vt_score_list_screen/vt_score_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../ad_state.dart';

class ScoreListScreen extends StatefulWidget {
  ScoreListScreen(this.event);
  final String event;

  @override
  _ScoreListScreenState createState() => _ScoreListScreenState();
}

class _ScoreListScreenState extends State<ScoreListScreen> {
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
      body: Consumer<ScoreModel>(
        builder: (context, model, child) {
          Future(() async {
            if (widget.event == '床') {
              if (model.fxScoreList == null) await model.getFXScores();
            }
            if (widget.event == 'あん馬') {
              if (model.phScoreList == null) await model.getPHScores();
            }
          });
          final height = MediaQuery.of(context).size.height - 50;
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        banner == null
                            ? Container(height: 50)
                            : Container(
                                height: 50,
                                child: AdWidget(ad: banner!),
                              ),
                        Container(
                          height: height * 0.1,
                          child: _backButton(context, widget.event),
                        ),
                        Container(
                          height: height * 0.1,
                          child: _eventDisplay(context),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await model.getFXScores();
                            },
                            child: _scoreList(context),
                          ),
                        ),
                      ],
                    ),
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

  Widget _eventDisplay(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 50;
    final height = MediaQuery.of(context).size.height - 50;
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
                if (widget.event == '跳馬') {
                  //todo: データの取得
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VTScoreListScreen(widget.event)),
                  );
                } else {
                  //todo: データの取得
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScoreEditScreen(widget.event)),
                  );
                }
              }),
          SizedBox(width: width * 0.1),
        ],
      ),
    );
  }

  Widget _scoreList(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    if (widget.event == '床') {
      Future(() async => scoreModel.fxScoreList == null
          ? await scoreModel.getFXScores()
          : false);
      return scoreModel.fxScoreList == null
          ? Container()
          : ListView(
              children: scoreModel.fxScoreList!
                  .map((score) => _scoreTile(context, score))
                  .toList(),
            );
    }
    if (widget.event == 'あん馬') {
      Future(() async => scoreModel.phScoreList == null
          ? await scoreModel.getPHScores()
          : false);
      return scoreModel.phScoreList == null
          ? Container()
          : ListView(
              children: scoreModel.phScoreList!
                  .map((score) => _scoreTile(context, score))
                  .toList(),
            );
    }
    if (widget.event == '吊り輪') {
      Future(() async => scoreModel.srScoreList == null
          ? await scoreModel.getSRScores()
          : false);
      return scoreModel.srScoreList == null
          ? Container()
          : ListView(
              children: scoreModel.srScoreList!
                  .map((score) => _scoreTile(context, score))
                  .toList(),
            );
    }
    if (widget.event == '跳馬') {
      Future(() async => scoreModel.srScoreList == null
          ? await scoreModel.getSRScores()
          : false);
      return scoreModel.vtScoreList == null
          ? Container()
          : ListView(
              children: scoreModel.vtScoreList!
                  .map((score) => _vtScoreTile(context, score))
                  .toList(),
            );
    }
    if (widget.event == '平行棒') {
      Future(() async => scoreModel.pbScoreList == null
          ? await scoreModel.getPBScores()
          : false);
      return scoreModel.pbScoreList == null
          ? Container()
          : ListView(
              children: scoreModel.pbScoreList!
                  .map((score) => _scoreTile(context, score))
                  .toList(),
            );
    }
    if (widget.event == '鉄棒') {
      Future(() async => scoreModel.hbScoreList == null
          ? await scoreModel.getHBScores()
          : false);
      return scoreModel.hbScoreList == null
          ? Container()
          : ListView(
              children: scoreModel.hbScoreList!
                  .map((score) => _scoreTile(context, score))
                  .toList(),
            );
    } else {
      return Center(child: Text('データの取得に失敗しました。'));
    }
  }

  Widget _scoreTile(BuildContext context, Score score) {
    final width = MediaQuery.of(context).size.width - 50;
    final height = MediaQuery.of(context).size.height - 50;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScoreEditScreen(widget.event)),
        );
      },
      child: Row(
        children: [
          Expanded(child: _favoriteButton(context)),
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
                      '${score.total}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Expanded(child: Container()),
                    Container(
                      height: height * 0.07,
                      width: width * 0.4,
                      child: _techsDisplay(context, score.techs),
                    ),
                    SizedBox(width: width * 0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vtScoreTile(BuildContext context, VTScore vtScore) {
    final width = MediaQuery.of(context).size.width - 50;
    final height = MediaQuery.of(context).size.height - 50;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VTScoreListScreen(widget.event)),
        );
      },
      child: Row(
        children: [
          Expanded(child: _favoriteButton(context)),
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
                      '${vtScore.score}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Expanded(child: Container()),
                    Container(
                        height: height * 0.07,
                        width: width * 0.4,
                        child: Text('${vtScore.techName}')),
                    SizedBox(width: width * 0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteButton(BuildContext context) {
    return Consumer<ScoreModel>(
      builder: (context, model, child) {
        return IconButton(
            icon: Icon(
              Icons.star,
              size: 30,
              color: model.isFavorite
                  ? Theme.of(context).primaryColor
                  : Colors.white,
            ),
            onPressed: () {
              model.onFavoriteButtonTapped();
            });
      },
    );
  }

  Widget _techsList(BuildContext context, List<String> techs) {
    return Container(
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
                    Text('$tech'),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _techsDisplay(BuildContext context, List<String> scoreList) {
    if (widget.event == '跳馬') {
      return _vtTech();
    } else {
      return _techsListDisplay(context, scoreList);
    }
  }

  Widget _vtTech() {
    return Center(
      child: Text(
        'アカピアン',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _techsListDisplay(BuildContext context, List<String> scoreList) {
    return _techsList(context, scoreList);
  }
}