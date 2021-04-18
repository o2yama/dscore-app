import 'package:dscore_app/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'combination_drop_down.dart';
import '../event_screen/event_screen.dart';
import '../event_screen/event_screen_model.dart';
import 'calculation_screen_model.dart';

class CalculationScreen extends StatelessWidget {
  CalculationScreen(this.event);
  final String event;
  final List<String> order = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event,
        ),
        actions: [
          TextButton(
            child: Text(
              '保存',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            onPressed: () {
              //試合などの名前をつける入力フォーム
              _dScoreName(context);
            },
          ),
        ],
      ),
      body: Consumer<CalculationScreenModel>(
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    //Dスコアの表示
                    _dScore(),
                    //組み合わせ加点の表示
                    _combinationScore(),
                    // 要求点の表示
                    _requestScore(),
                    //技名の表示
                    _techniqueDisplay(context, order[0]),
                    _techniqueDisplay(context, order[1]),
                    _techniqueDisplay(context, order[2]),
                    _techniqueDisplay(context, order[3]),
                    _techniqueDisplay(context, order[4]),
                    _techniqueDisplay(context, order[5]),
                    _techniqueDisplay(context, order[6]),
                    _techniqueDisplay(context, order[7]),
                    _techniqueDisplay(context, order[8]),
                    _techniqueLastDisplay(context),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //Dスコアの表示
  Widget _dScore() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dスコア',
            style: TextStyle(fontSize: 40.0),
          ),
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

  //組み合わせ加点の表示
  Widget _combinationScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '組み合わせ加点',
          style: TextStyle(fontSize: 25.0),
        ),
        CombinationDropDown(),
      ],
    );
  }

  // 要求点の表示
  Widget _requestScore() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '要求点',
            style: TextStyle(fontSize: 25.0),
          ),
          Container(
            padding: EdgeInsets.only(right: 25.0),
            child: Text(
              '2.0',
              style: TextStyle(fontSize: 30.0),
            ),
          )
        ],
      ),
    );
  }

//技名の表示
  Widget _techniqueDisplay(BuildContext context, String order) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(bottom: 3.0),
                child: Center(
                  child: Text(
                    order,
                    style: TextStyle(fontSize: 28.0),
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
                      style: TextStyle(fontSize: 28.0),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(event)),
                    );
                  },
                ),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.black,
          height: 1,
        )
      ],
    );
  }

  //終末技の表示
  Widget _techniqueLastDisplay(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(bottom: 3.0),
                child: Center(
                  child: Text(
                    '終末技',
                    style: TextStyle(fontSize: 14.0),
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
                      style: TextStyle(fontSize: 28.0),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalculationScreen(event)),
                    );
                  },
                ),
              ),
            )
          ],
        ),
        Divider(
          color: Colors.black,
          height: 1,
        )
      ],
    );
  }

  //試合などの名前をつける入力フォーム
  Future<void> _dScoreName(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<EventScreenModel>(builder: (context, model, child) {
            return AlertDialog(
              title: Text('保存名を入力してください'),
              content: TextField(
                onChanged: (text) {},
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '全日本インカレ',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventScreen(
                                  event,
                                )),
                        (_) => false);
                  },
                  child: Text('保存する'),
                ),
              ],
            );
          });
        });
  }
}
