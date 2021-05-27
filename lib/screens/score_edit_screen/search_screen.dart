import 'dart:io';

import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/data/hb.dart';
import 'package:dscore_app/data/pb.dart';
import 'package:dscore_app/data/ph.dart';
import 'package:dscore_app/data/score_datas.dart';
import 'package:dscore_app/data/sr.dart';
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
                      height: height * 0.1,
                      child: _searchChip(context, widget.event),
                    ),
                    //検索結果
                    Container(
                      height: height * 0.7,
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
    return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
            child: event == '床'
                ? _fxChips(event)
                : event == 'あん馬'
                    ? _phChips(event)
                    : event == '吊り輪'
                        ? _srChips(event)
                        : event == '平行棒'
                            ? _pbChips(event)
                            : event == '鉄棒'
                                ? _hbChips(event)
                                : Container()));
  }

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

  Widget _fxChips(String event) {
    return Wrap(
      children: [
        _techFXChips(fxSearchText[0], event),
        _techFXChips(fxSearchText[1], event),
        _techFXChips(fxSearchText[2], event),
        _techFXChips(fxSearchText[3], event),
        _techFXChips(fxSearchText[4], event),
        _techFXChips(fxSearchText[5], event),
        _techFXChips(fxSearchText[6], event),
        _techFXChips(fxSearchText[7], event),
        _techFXChips(fxSearchText[8], event),
        _techFXChips(fxSearchText[9], event),
      ],
    );
  }

  Widget _phChips(String event) {
    return Wrap(
      children: [
        _techPHChips(phSearchText[0], event),
        _techPHChips(phSearchText[1], event),
        _techPHChips(phSearchText[2], event),
        _techPHChips(phSearchText[3], event),
        _techPHChips(phSearchText[4], event),
        _techPHChips(phSearchText[5], event),
        _techPHChips(phSearchText[6], event),
        _techPHChips(phSearchText[7], event),
        _techPHChips(phSearchText[8], event),
      ],
    );
  }

  Widget _srChips(String event) {
    return Wrap(
      children: [
        _techSRChips(srSearchText[0], event),
        _techSRChips(srSearchText[1], event),
        _techSRChips(srSearchText[2], event),
        _techSRChips(srSearchText[3], event),
        _techSRChips(srSearchText[4], event),
        _techSRChips(srSearchText[5], event),
        _techSRChips(srSearchText[6], event),
        _techSRChips(srSearchText[7], event),
      ],
    );
  }

  Widget _pbChips(String event) {
    return Wrap(
      children: [
        _techPBChips(pbSearchText[0], event),
        _techPBChips(pbSearchText[1], event),
        _techPBChips(pbSearchText[2], event),
        _techPBChips(pbSearchText[3], event),
        _techPBChips(pbSearchText[4], event),
        _techPBChips(pbSearchText[5], event),
        _techPBChips(pbSearchText[6], event),
        _techPBChips(pbSearchText[7], event),
      ],
    );
  }

  Widget _hbChips(String event) {
    return Wrap(
      children: [
        _techHBChips(hbSearchText[0], event),
        _techHBChips(hbSearchText[1], event),
        _techHBChips(hbSearchText[2], event),
        _techHBChips(hbSearchText[3], event),
        _techHBChips(hbSearchText[4], event),
        _techHBChips(hbSearchText[5], event),
        _techHBChips(hbSearchText[6], event),
        _techHBChips(hbSearchText[7], event),
      ],
    );
  }

  Widget _techFXChips(String fxSearchText, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$fxSearchText'),
        selected: false,
        onSelected: (selected) {
          scoreModel.techFXSelected(event, fxSearchText);
          // scoreModel.search(text, widget.event);
        },
      ),
    );
  }

  Widget _techPHChips(String phSearchText, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$phSearchText'),
        selected: false,
        onSelected: (selected) {
          scoreModel.techPHSelected(event, phSearchText);
        },
      ),
    );
  }

  Widget _techSRChips(String srSearchText, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$srSearchText'),
        selected: false,
        onSelected: (selected) {
          scoreModel.techSRSelected(event, srSearchText);
        },
      ),
    );
  }

  Widget _techPBChips(String pbSearchText, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$pbSearchText'),
        selected: false,
        onSelected: (selected) {
          scoreModel.techPBSelected(event, pbSearchText);
        },
      ),
    );
  }

  Widget _techHBChips(String hbSearchText, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text('$hbSearchText'),
        selected: false,
        onSelected: (selected) {
          scoreModel.techHBSelected(event, hbSearchText);
        },
      ),
    );
  }
}
