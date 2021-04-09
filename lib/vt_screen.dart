import 'package:flutter/material.dart';

import 'event_screen.dart';

class VtScreen extends StatelessWidget {
  VtScreen(this.event);

  final String event;

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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            //Dスコアの表示
            _dScore(),
            // 跳馬の技名検索
            _vtSearch(),
          ],
        ),
      ),
    );
  }

  //試合などの名前をつける入力フォーム
  Future<void> _dScoreName(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存名を入力してください'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: '全日本インカレ',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => EventScreen(event)),
                  );
                },
                child: Text('保存する'),
              ),
            ],
          );
        });
  }

  //Dスコアの表示
  Widget _dScore() {
    return Container(
      padding: EdgeInsets.only(top: 50.0, bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dスコア',
            style: TextStyle(fontSize: 40.0),
          ),
          Text(
            '5.4',
            style: TextStyle(fontSize: 40.0),
          )
        ],
      ),
    );
  }

  Widget _vtSearch() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '技名',
            style: TextStyle(fontSize: 40.0),
          ),
          Text(
            '5.4',
            style: TextStyle(fontSize: 40.0),
          )
        ],
      ),
    );
  }
}
