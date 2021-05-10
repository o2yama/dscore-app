import 'dart:io';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_tech_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../ad_state.dart';

class VTScoreSelectScreen extends StatefulWidget {
  @override
  _VTScoreSelectScreenState createState() => _VTScoreSelectScreenState();
}

class _VTScoreSelectScreenState extends State<VTScoreSelectScreen> {
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
        return Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                ad(context),
                Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.1,
                            child: _backButton(context),
                          ),
                          Container(
                            height: height * 0.2,
                            child: _dScoreDisplay(),
                          ),
                          Container(
                            height: height * 0.5,
                            child: VTTechListView(),
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
              ],
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

  //戻るボタン
  Widget _backButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
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
                      'スコア一覧',
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
        ),
        TextButton(
          child: Text(
            '保存',
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

  Future<void> onStoreButtonPressed(context) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    await scoreModel.setVTScore();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<ScoreModel>(builder: (context, model, child) {
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text('保存しました'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          '0K',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  )
                : AlertDialog(
                    title: Text('保存しました'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          '0K',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  );
          });
        });
  }

  Widget _dScoreDisplay() {
    final width = MediaQuery.of(context).size.width;
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Row(
      children: [
        Container(
          width: width * 0.5,
          margin: EdgeInsets.only(left: 40),
          child: Text(
            '${scoreModel.vtTechName}',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        SizedBox(width: width * 0.1),
        Container(
          margin: EdgeInsets.only(right: 16),
          child: Text(
            '${scoreModel.totalScore}',
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ],
    );
  }
}
