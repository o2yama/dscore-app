import 'dart:io';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/screens/score_edit_screen/score_edit_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_list_model.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_list_screen.dart';
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
      body: Consumer<ScoreListModel>(
        builder: (context, model, child) {
          final height = MediaQuery.of(context).size.height - 50;
          return SafeArea(
            child: SingleChildScrollView(
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
                      child: ListView(
                        children: model.fxScoreList
                            .map((score) => _scoreTile(context, score))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
              icon: Icon(Icons.add, color: Colors.grey),
              onPressed: () {
                //todo:ScoreEditPageへ（値を何も渡さないで）
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

  Future<void> onEditButtonPressed() async {}

  Widget _scoreTile(BuildContext context, Score score) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
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

  Widget _favoriteButton(BuildContext context) {
    return Consumer<ScoreListModel>(
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
              //TODO: お気に入りを入れ替える
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
