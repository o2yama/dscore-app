import 'dart:io';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/score_list_screen/vt_score_list_screen/vt_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../ad_state.dart';
import '../../total_score_list_screen.dart';

class VTScoreListScreen extends StatefulWidget {
  VTScoreListScreen(this.event);
  final String event;

  @override
  _VTScoreListScreenState createState() => _VTScoreListScreenState();
}

class _VTScoreListScreenState extends State<VTScoreListScreen> {
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
        return SafeArea(
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
                  height: height * 0.2,
                  child: _dScore(),
                ),
                // 跳馬の技名検索
                Container(
                  height: height * 0.2,
                  child: _vtSearch(),
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
  _backButton(BuildContext context, String event) {
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
        ),
        TextButton(
          child: Text(
            '保存',
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 15.0),
          ),
          onPressed: () {
            //試合などの名前をつける入力フォーム
            _dScoreName(context);
          },
        ),
      ],
    );
  }

  //試合などの名前をつける入力フォーム
  Future<void> _dScoreName(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<ScoreModel>(builder: (context, model, child) {
            return AlertDialog(
              title: Text('保存しました'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TotalScoreListScreen()),
                        (_) => false);
                  },
                  child: Text(
                    '0K',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  //Dスコアの表示
  Widget _dScore() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(right: 15.0),
            child: Text(
              '5.4',
              style: TextStyle(fontSize: 40.0),
            ),
          )
        ],
      ),
    );
  }

  // 跳馬の技名検索
  Widget _vtSearch() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '技名',
            style: TextStyle(fontSize: 40.0),
          ),
          VtDropDown(),
        ],
      ),
    );
  }
}
