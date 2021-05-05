import 'package:dscore_app/data/score_datas.dart';
import 'package:dscore_app/data/vt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../score_model.dart';

final TextEditingController searchController = TextEditingController();

class SearchScreen extends StatelessWidget {
  SearchScreen(this.event);
  final String event;

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
                      child: _backButton(context, event),
                    ),
                    //検索バー
                    Container(
                      height: height * 0.1,
                      child: _searchBar(context),
                    ),
                    //検索結果
                    Container(
                      height: height * 0.75,
                      child: _searchResults(context, event),
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
  _backButton(BuildContext context, String event) {
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
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: searchController,
        cursorColor: Theme.of(context).primaryColor,
        autofocus: true,
        decoration: InputDecoration(
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
          scoreModel.search(text, event);
        },
      ),
    );
  }

  //検索結果
  Widget _searchResults(BuildContext context, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Consumer<ScoreModel>(builder: (context, model, child) {
      return event == '跳馬'
          ? ListView(
              children: scoreModel.searchResult
                  .map((vtScore) => vtResultTile(context, vtScore))
                  .toList(),
            )
          : ListView(
              children: scoreModel.searchResult
                  .map((score) => resultTile(context, score))
                  .toList(),
            );
    });
  }

  Widget resultTile(BuildContext context, String techName) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Card(
      child: ListTile(
        title: Text(
          '$techName',
          style: TextStyle(fontSize: 14.0),
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
                    child: Text('${groupDisplay[scoreModel.group[techName]]}'),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget vtResultTile(BuildContext context, String vtScore) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Card(
      child: ListTile(
        title: Text(
          '$vtScore',
          style: TextStyle(fontSize: 14.0),
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
                    child: Text('${vtTech[vtScore]}'),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
