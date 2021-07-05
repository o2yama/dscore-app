import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/score_data.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../score_list_screen/score_model.dart';

final TextEditingController searchController = TextEditingController();

class SearchScreen extends StatelessWidget {
  const SearchScreen(this.event, {this.order});
  final String event;
  final int? order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Consumer<ScoreModel>(builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _backButton(context, event),
                    _searchBar(context),
                    _searchChips(context, event),
                    _searchResults(context, event),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
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
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: TextField(
          controller: searchController,
          cursorColor: Theme.of(context).primaryColor,
          autofocus: true,
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () => scoreModel.deleteSearchBarText(searchController),
              child: Icon(
                Icons.clear,
                color: Theme.of(context).primaryColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: '技名を検索',
          ),
          onChanged: (text) {
            scoreModel.search(text, event);
          },
        ),
      ),
    );
  }

  Widget _searchChips(BuildContext context, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: scoreModel.searchChipWords
                .map((chipsText) => _techChip(context, chipsText, event))
                .toList()),
      ),
    );
  }

  Widget _techChip(BuildContext context, String searchText, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        backgroundColor: Colors.grey[200],
        elevation: 5,
        label: Text('$searchText'),
        selected: false,
        onSelected: (selected) {
          FocusScope.of(context).requestFocus(FocusNode());
          scoreModel.onTechChipSelected(event, searchText);
        },
      ),
    );
  }

  Widget _searchResults(BuildContext context, String event) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return Consumer<ScoreModel>(builder: (context, model, child) {
      return scoreModel.searchResult.isEmpty
          ? Column(
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: () => launch(
                      'https://docs.google.com/forms/d/1skhzHLRlNjMVCXZ3HjLQlMHxyZswp6v_enIj_bR4hwY/edit',
                      forceSafariVC: true,
                      forceWebView: true,
                    ),
                    child: const Text('登録したい技がない場合はこちら'),
                  ),
                ),
              ],
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                children: scoreModel.searchResult
                    .map((score) => resultTile(
                        context, score, scoreModel.searchResult.indexOf(score)))
                    .toList(),
              ),
            );
    });
  }

  Widget resultTile(BuildContext context, String techName, int index) {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    final group = scoreModel.group[techName];
    final difficulty = scoreModel.difficulty[techName];
    return Column(children: [
      Card(
        child: ListTile(
          title: Text(
            '$techName',
            style: TextStyle(
              fontSize: Utilities().isMobile() ? 14.0 : 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: SizedBox(
            width: 110,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      const Expanded(
                        child: Text('難度', style: TextStyle(fontSize: 10)),
                      ),
                      Expanded(
                        child: Text(
                          '${difficultyDisplay[difficulty]}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(children: [
                    const SizedBox(height: 8),
                    const Expanded(
                      child: Text(
                        'グループ',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    Expanded(
                      child: Text('${groupDisplay[group]}'),
                    ),
                  ]),
                ]),
          ),
          onTap: () async => _onResultTileTapped(context, techName, order),
        ),
      ),
      scoreModel.searchResult.length - 1 == index
          ? Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      launch(
                        'https://docs.google.com/forms/d/1skhzHLRlNjMVCXZ3HjLQlMHxyZswp6v_enIj_bR4hwY/edit',
                        forceSafariVC: true,
                        forceWebView: true,
                      );
                    },
                    child: const Text('登録したい技がない場合はこちら'),
                  ),
                ),
                const SizedBox(height: 300),
              ],
            )
          : Container(),
    ]);
  }

  Future<void> _onResultTileTapped(
      BuildContext context, String techName, int? order) async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    if (scoreModel.isSameTechSelected(techName)) {
      await showOkAlertDialog(
        context: context,
        title: 'すでに同じ技が登録されています。',
      );
    } else {
      scoreModel
        ..setTech(techName, order)
        ..calculateNumberOfGroup(event)
        ..calculateScore(event);
    }
    Navigator.pop(context);
  }
}
