import 'dart:io';
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          Text(
            '$event',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.5),
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
        ],
      ),
    );
  }

  Widget _scoreTile(BuildContext context, num score) {
    return Row(
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
                  Text(
                    '$score',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                  _dropDownComponentsList('前方ダブル', 'two', 'three', 'four',
                      'five', 'six', 'seven', 'eight', 'nine', 'finish')
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _favoriteButton(BuildContext context) {
    return Consumer<EventScreenModel>(
      builder: (context, model, child) {
        return IconButton(
            icon: Icon(
              Icons.star,
              size: 40,
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

  Widget _dropDownComponentsList(
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
    List<DropdownMenuItem> _techs = [
      _dropDownItem('1.$one'),
      _dropDownItem('2.$two'),
      _dropDownItem('3.$three'),
      _dropDownItem('4.$four'),
      _dropDownItem('5.$five'),
      _dropDownItem('6.$six'),
      _dropDownItem('7.$seven'),
      _dropDownItem('8.$eight'),
      _dropDownItem('9.$nine'),
      _dropDownItem('終末 $finish'),
    ];

    return DropdownButton(
      items: _techs,
      elevation: 0,
      underline: Container(),
    );
  }

  DropdownMenuItem _dropDownItem(String tech) {
    return DropdownMenuItem(
      child: Text(tech),
    );
  }
}
