import 'dart:io';

import 'package:dscore_app/screens/home_screen.dart';
import 'package:dscore_app/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../ad_state.dart';
import '../event_screen/event_screen_model.dart';
import 'calculation_screen_model.dart';

class CalculationScreen extends StatefulWidget {
  CalculationScreen(this.event);
  final String event;
  final List<String> order = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  @override
  _CalculationScreenState createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
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
      body: SafeArea(
        child: Consumer<CalculationScreenModel>(
          builder: (context, model, child) {
            final height = MediaQuery.of(context).size.height - 50;
            return SingleChildScrollView(
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
                      child: _dScore(),
                    ),
                    //スコアの詳細
                    Container(
                      height: height * 0.1,
                      child: _detailsScore(),
                    ),
                    //技名の表示
                    Container(
                      height: height * 0.7,
                      child: ListView(
                        children: [
                          _techniqueDisplay(context, widget.order[0]),
                          _techniqueDisplay(context, widget.order[1]),
                          _techniqueDisplay(context, widget.order[2]),
                          _techniqueDisplay(context, widget.order[3]),
                          _techniqueDisplay(context, widget.order[4]),
                          _techniqueDisplay(context, widget.order[5]),
                          _techniqueDisplay(context, widget.order[6]),
                          _techniqueDisplay(context, widget.order[7]),
                          _techniqueDisplay(context, widget.order[8]),
                          _techniqueLastDisplay(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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

  //Dスコアの表示
  Widget _dScore() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
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

  //スコアの詳細
  _detailsScore() {
    if (widget.event == '床' || widget.event == '鉄棒') {
      return _combination();
    } else {
      return _noCombination();
    }
  }

//技名の表示
  Widget _techniqueDisplay(BuildContext context, String order) {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Center(
                child: Text(
                  order,
                  style: TextStyle(
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.only(bottom: 3.0),
              child: ListTile(
                title: Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(widget.event)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //終末技の表示
  Widget _techniqueLastDisplay(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 20.0,
              padding: EdgeInsets.only(left: 10.0),
              child: Center(
                child: Text(
                  '終末技',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.only(bottom: 3.0),
              child: ListTile(
                title: Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalculationScreen(widget.event)),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  //試合などの名前をつける入力フォーム
  Future<void> _dScoreName(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<EventScreenModel>(builder: (context, model, child) {
            return AlertDialog(
              title: Text('保存しました'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
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

  //組み合わせあり
  Widget _combination() {
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
            Expanded(
              child: Center(
                child: Text(
                  '組み合わせ',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
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
                  '３.1',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '2.0',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '2.0',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

// 組み合わせなし
  Widget _noCombination() {
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
                  '３.1',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '2.0',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
