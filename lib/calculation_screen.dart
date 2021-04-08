import 'package:dscore_app/home_screen.dart';
import 'package:flutter/material.dart';

class CalculationScreen extends StatelessWidget {
  CalculationScreen(this.event);
  final String event;

  // final items = List<String>.generate(10, (i) => "Item $i");
  final List<String> order = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '終末技'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            //Dスコアの表示
            _dScore(),
            //組み合わせ加点の表示
            _combinationScore(),
            // 要求点の表示
            _requestScore(),
            //技名の表示
            _techniqueDisplay(order[0]),
            _techniqueDisplay(order[1]),
            _techniqueDisplay(order[2]),
            _techniqueDisplay(order[3]),
            _techniqueDisplay(order[4]),
            _techniqueDisplay(order[5]),
            _techniqueDisplay(order[6]),
            _techniqueDisplay(order[7]),
            _techniqueDisplay(order[8]),
            _techniqueDisplay(order[9]),
          ],
        ),
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
          Text(
            '5.4',
            style: TextStyle(fontSize: 40.0),
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
        Text(
          '0.2',
          style: TextStyle(fontSize: 30.0),
        ),
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
          Text(
            '2.0',
            style: TextStyle(fontSize: 30.0),
          )
        ],
      ),
    );
  }

//技名の表示
  Widget _techniqueDisplay(String order) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 3.0),
            child: Text(
              order,
              style: TextStyle(fontSize: 28.0),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: 3.0),
            child: ListTile(
              title: Text(
                '+',
                style: TextStyle(fontSize: 28.0),
              ),
              onTap: () {
                //  TODO
              },
            ),
          ),
        )
      ],
    );
    // return Row(
    //   children: [
    //     Expanded(
    //       flex: 1,
    //       child: ListView.builder(
    //         shrinkWrap: true,
    //         physics: NeverScrollableScrollPhysics(),
    //         itemCount: 10,
    //         itemBuilder: (context, index) {
    //           return ListTile(
    //             title: Text(
    //               '${index + 1}',
    //               style: TextStyle(fontSize: 25.0),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //     Expanded(
    //       flex: 5,
    //       child: ListView.builder(
    //         shrinkWrap: true,
    //         physics: NeverScrollableScrollPhysics(),
    //         itemCount: 10,
    //         itemBuilder: (context, index) {
    //           return ListTile(
    //             title: Center(
    //               child: Text(
    //                 '+',
    //                 style: TextStyle(fontSize: 25.0),
    //               ),
    //             ),
    //             onTap: () {
    //               // TODO
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
