import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../intro_model.dart';
import 'event_screen/event_screen.dart';
import 'intro_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> event = ['床', 'あん馬', '吊り輪', '跳馬', '平行棒', '鉄棒'];
  final List<String> eventEng = ['FX', 'PH', 'SR', 'VT', 'PB', 'HB'];
  @override
  Widget build(BuildContext context) {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    return FutureBuilder(
        future: introModel.checkIsIntroWatched(),
        builder: (context, snapshot) {
          return !(introModel.isIntroWatched)
              ? IntroScreen()
              : Scaffold(
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          // 広告
                          _advertising(),
                          //設定ボタンと使い方ボタン
                          _settingButton(context),
                          //６種目のカード
                          _eventCard(context, event[0], eventEng[0]),
                          _eventCard(context, event[1], eventEng[1]),
                          _eventCard(context, event[2], eventEng[2]),
                          _eventCard(context, event[3], eventEng[3]),
                          _eventCard(context, event[4], eventEng[4]),
                          _eventCard(context, event[5], eventEng[5]),
                          //  6種目の合計
                          _totalScore(),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }

  //設定ボタンと使い方ボタン
  _settingButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
            Icons.miscellaneous_services,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  //６種目のカード
  _eventCard(BuildContext context, String event, String eventEng) {
    return SizedBox(
      height: 90,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventScreen(event)),
            );
          },
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    '$event',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '5.5',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //  6種目の合計
  _totalScore() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 160.0),
                child: Text(
                  '合計',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Text(
                '5.5',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        Divider(color: Colors.black)
      ],
    );
  }

  _advertising() {
    return Container(
      height: 100,
      child: Center(
        child: Text(
          '広告',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
