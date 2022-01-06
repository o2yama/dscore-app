import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/search_screen/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final TextEditingController searchController = TextEditingController();

class SearchScreen extends StatelessWidget {
  const SearchScreen({required this.event, Key? key, this.order})
      : super(key: key);
  final Event event;
  final int? order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Container(
          height: Utilities.screenHeight(context),
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Consumer(
              builder: (context, ref, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _backButton(context, event),
                      _searchBar(context, ref),
                      _searchChips(context, event, ref),
                      _searchResults(context, event, ref),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context, Event event) {
    return SizedBox(
      height: Utilities.screenHeight(context) * 0.1,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ]),
    );
  }

  Widget _searchBar(BuildContext context, WidgetRef ref) {
    final searchModel = ref.watch(searchModelProvider);

    return SizedBox(
      height: Utilities.screenHeight(context) * 0.1,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: TextField(
          controller: searchController,
          cursorColor: Theme.of(context).primaryColor,
          autofocus: true,
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () => searchModel.deleteSearchBarText(searchController),
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
          onChanged: (text) => searchModel.search(text, event),
        ),
      ),
    );
  }

  Widget _searchChips(BuildContext context, Event event, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: ref
                .watch(editPerformanceModelProvider)
                .searchChipWords
                .map(
                  (chipsText) => _techChip(
                    context,
                    chipsText,
                    event,
                    ref,
                  ),
                )
                .toList()),
      ),
    );
  }

  Widget _techChip(
    BuildContext context,
    String searchText,
    Event event,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        backgroundColor: Colors.grey[200],
        elevation: 5,
        label: Text(searchText),
        selected: false,
        onSelected: (selected) {
          FocusScope.of(context).requestFocus(FocusNode());
          ref.watch(searchModelProvider).onTechChipSelected(event, searchText);
        },
      ),
    );
  }

  Widget _searchResults(
    BuildContext context,
    Event event,
    WidgetRef ref,
  ) {
    final searchModel = ref.watch(searchModelProvider);

    return searchModel.searchResult.isEmpty
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
              children: searchModel.searchResult
                  .map(
                    (score) => resultTile(
                      context,
                      score,
                      searchModel.searchResult.indexOf(score),
                      ref,
                    ),
                  )
                  .toList(),
            ),
          );
  }

  Widget resultTile(
    BuildContext context,
    String techName,
    int index,
    WidgetRef ref,
  ) {
    final scoreEditModel = ref.watch(editPerformanceModelProvider);
    final group = scoreEditModel.group[techName];
    final difficulty = scoreEditModel.difficulty[techName];

    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(
              techName,
              style: TextStyle(
                fontSize: Utilities.isMobile() ? 14.0 : 18.0,
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
                          Convertor.difficulty[difficulty].toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      const Expanded(
                        child: Text(
                          'グループ',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Expanded(
                        child: Text(Convertor.group[group].toString()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () async =>
                _onResultTileTapped(context, techName, order, ref),
          ),
        ),
        ref.watch(searchModelProvider).searchResult.length - 1 == index
            ? Column(
                children: [
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 300),
                ],
              )
            : Container(),
      ],
    );
  }

  Future<void> _onResultTileTapped(
    BuildContext context,
    String techName,
    int? order,
    WidgetRef ref,
  ) async {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final searchModel = ref.watch(searchModelProvider);

    if (searchModel.isSameTechSelected(
        editPerformanceModel.decidedTechList, techName)) {
      await showOkAlertDialog(
        context: context,
        title: 'すでに同じ技が登録されています。',
      );
    } else {
      searchModel.setTech(
        editPerformanceModel.decidedTechList,
        techName,
        order,
      );
      editPerformanceModel
        ..calculateNumberOfGroup(event)
        ..calculateScore(event);
    }
    Navigator.pop(context);
  }
}
