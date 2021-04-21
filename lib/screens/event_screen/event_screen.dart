import 'dart:io';

import 'package:dscore_app/screens/calculation_screen/calculation_screen.dart';
import 'package:dscore_app/screens/event_screen/event_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatelessWidget {
  EventScreen(this.event);
  final String event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventScreenModel>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ad(context),
                  _backButton(context, event),
                  _eventDisplay(context),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView(
                      children: [
                        _scoreTile(context, 5.5),
                        _scoreTile(context, 5.8),
                        _scoreTile(context, 6.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget ad(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Center(child: Text('広告')),
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
            '$event',
            style: Theme.of(context).textTheme.headline4,
          ),
          Expanded(child: Container()),
          TextButton(
            onPressed: () {
              //todo: チェックボタン表示
            },
            child: Text(
              '編集',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: width * 0.1),
        ],
      ),
    );
  }

  Widget _scoreTile(BuildContext context, num score) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalculationScreen(event)),
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
                      '$score',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Expanded(child: Container()),
                    Container(
                      height: height * 0.07,
                      width: width * 0.4,
                      child: _techsList(
                          context,
                          '前方ダブル',
                          'two',
                          'three',
                          'four',
                          'five',
                          'six',
                          'seven',
                          'eight',
                          'nine',
                          'finish'),
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
    return Consumer<EventScreenModel>(
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

  Widget _techsList(
    BuildContext context,
    String one,
    String? two,
    String? three,
    String? four,
    String? five,
    String? six,
    String? seven,
    String? eight,
    String? nine,
    String? finish,
  ) {
    List<String> _techs = [
      '1. $one',
      '2. $two',
      '3. $three',
      '4. $four',
      '5. $five',
      '6. $six',
      '7. $seven',
      '8. $eight',
      '9. $nine',
      '10. $finish',
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView(
        children: _techs
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
}
