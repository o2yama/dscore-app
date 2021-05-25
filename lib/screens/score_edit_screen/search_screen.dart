import 'dart:io';

import 'package:dscore_app/data/score_datas.dart';
import 'package:dscore_app/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../score_list_screen/score_model.dart';

final TextEditingController searchController = TextEditingController();

class SearchScreen extends StatefulWidget {
  SearchScreen(this.event, {this.order});
  final String event;
  final int? order;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Consumer<ScoreModel>(builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    //戻るボタン
                    Container(
                      height: height * 0.1,
                      child: _backButton(context, widget.event),
                    ),
                    //検索バー
                    Container(
                      height: height * 0.1,
                      child: _searchBar(context),
                    ),
                    Container(
                      height: height * 0.05,
                      child: _searchChip(context, widget.event),
                    ),
                    //検索結果
                    Container(
                      height: height * 0.75,
                      child: _searchResults(context, widget.event),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  //戻るボタン
  Widget _backButton(BuildContext context, String event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  //検索バー
  Widget _searchBar(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: TextField(
        controller: searchController,
        cursorColor: Theme.of(context).primaryColor,
        autofocus: true,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            child: Icon(Icons.clear),
            onTap: () => scoreModel.deleteSearchBarText(searchController),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          hintText: '検索',
        ),
        onChanged: (text) {
          scoreModel.search(text, widget.event);
        },
      ),
    );
  }

  Widget _searchChip(BuildContext context, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: [
          _techChip(event),
          // _techChips(scoreModel.techItem[0], event),
          // _techChips(scoreModel.techItem[1], event),
          // _techChips(scoreModel.techItem[2], event),
        ],
      ),
    );
  }

  Widget _techChip(String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    if (event == '床') {
      _techFXChips(scoreModel.techFXItem[0], event);
      _techFXChips(scoreModel.techFXItem[1], event);
      _techFXChips(scoreModel.techFXItem[2], event);
    }
    return Container();
  }

  Widget _techFXChips(String techFXItem, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$techFXItem'),
        selected: scoreModel.selected,
        onSelected: (selected) {
          scoreModel.techChoice(event, techFXItem);
        },
      ),
    );
  }

  Widget _techPHChips(String techPHItem, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$techPHItem'),
        selected: scoreModel.selected,
        onSelected: (selected) {
          scoreModel.techChoice(event, techPHItem);
        },
      ),
    );
  }

  Widget _techSRChips(String techItem, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$techItem'),
        selected: scoreModel.selected,
        onSelected: (selected) {
          scoreModel.techChoice(event, techItem);
        },
      ),
    );
  }

  //検索結果
  Widget _searchResults(BuildContext context, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Consumer<ScoreModel>(builder: (context, model, child) {
      return ListView(
        children: scoreModel.searchResult
            .map((score) => resultTile(
                context, score, scoreModel.searchResult.indexOf(score)))
            .toList(),
      );
    });
  }

  Widget resultTile(BuildContext context, String techName, int index) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(
              '$techName',
              style: TextStyle(fontSize: Utilities().isMobile() ? 14 : 18.0),
            ),
            trailing: Container(
              width: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 8),
                      Expanded(
                        child: Text('難度', style: TextStyle(fontSize: 10)),
                      ),
                      Expanded(
                        child: Text(
                            '${scoreOfDifficulty[scoreModel.difficulty[techName]]}'),
                      ),
                    ],
                  ),
                  SizedBox(width: 24),
                  Column(
                    children: [
                      SizedBox(height: 8),
                      Expanded(
                        child: Text('グループ', style: TextStyle(fontSize: 10)),
                      ),
                      Expanded(
                        child:
                            Text('${groupDisplay[scoreModel.group[techName]]}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () async {
              await _onResultTileTapped(context, techName, widget.order);
              Navigator.pop(context);
            },
          ),
        ),
        scoreModel.searchResult.length - 1 == index
            ? SizedBox(height: 300)
            : Container(),
      ],
    );
  }

  Future<void> _onResultTileTapped(
      BuildContext context, String techName, int? order) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    try {
      scoreModel.onTechSelected(techName, order);
      scoreModel.calculateScore(widget.event);
    } catch (e) {
      print(e);
      await showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text('$e'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            : AlertDialog(
                title: Text('$e'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
      );
    }
  }
}
