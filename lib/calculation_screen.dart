import 'package:dscore_app/event_screen.dart';
import 'package:flutter/material.dart';

class CalculationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '床',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventScreen()),
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Dスコアの表示
            _dScore(),
            //組み合わせ加点の表示
            _combinationScore(),
            // 要求点の表示
            _requestScore(),
          ],
        ),
      ),
    );
  }

  //Dスコアの表示
  Widget _dScore() {
    return Row(
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
    );
  }

  //組み合わせ加点の表示
  Widget _combinationScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '組み合わせ加点',
          style: TextStyle(fontSize: 30.0),
        ),
        Text(
          '0.2',
          style: TextStyle(fontSize: 30.0),
        ),
      ],
    );
  }

  // 要求点の表示
  Widget _requestScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '要求点',
          style: TextStyle(fontSize: 30.0),
        ),
        Text(
          '2.0',
          style: TextStyle(fontSize: 30.0),
        )
      ],
    );
  }
}
