import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/consts/event.dart';
import 'package:dscore_app/extentions/difficulty_extention.dart';
import 'package:dscore_app/extentions/int_extension.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
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
      child: CustomScaffold(
        context: context,
        body: Consumer(
          builder: (context, ref, child) {
            return Column(
              children: [
                _backButton(context, event),
                _searchBar(context, ref),
                _searchChips(context, event, ref),
                _searchResults(context, event, ref),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context, Event event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          '技検索',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }

  Widget _searchBar(BuildContext context, WidgetRef ref) {
    final searchModel = ref.watch(searchModelProvider);

    return Padding(
      padding: const EdgeInsets.all(15),
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
    );
  }

  Widget _searchChips(BuildContext context, Event event, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: ref
              .watch(editPerformanceModelProvider)
              .suggestionWordsOf(event)
              .map(
                (chipsText) => _techChip(context, chipsText, event, ref),
              )
              .toList()),
    );
  }

  Widget _techChip(
    BuildContext context,
    String searchText,
    Event event,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
        backgroundColor: Colors.white,
        elevation: 4,
        label: Text(searchText),
        selected: false,
        onSelected: (selected) {
          FocusManager.instance.primaryFocus?.unfocus();
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
        ? _requestLink
        : Expanded(
            child: ListView(
              children: searchModel.searchResult
                  .map(
                    (score) => _techTile(context, score, ref),
                  )
                  .toList()
                ..add(_requestLink)
                ..add(const SizedBox(height: 300)),
            ),
          );
  }

  Widget get _requestLink {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        height: 50,
        child: TextButton(
          onPressed: () => launchUrl(
            Uri.parse(
                'https://docs.google.com/forms/d/1skhzHLRlNjMVCXZ3HjLQlMHxyZswp6v_enIj_bR4hwY/edit'),
          ),
          child: const Text('登録したい技がない場合はこちら'),
        ),
      ),
    );
  }

  Widget _techTile(BuildContext context, String techName, WidgetRef ref) {
    final scoreEditModel = ref.watch(editPerformanceModelProvider);
    final group = scoreEditModel.allGroupDataOf(event)[techName];
    final difficulty = scoreEditModel.allDifficultyDataOf(event)[techName];

    return Card(
      child: ListTile(
        title: Text(
          techName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '${DifficultyEx.getLabel(difficulty!)} / ${group!.techGroupLabel}',
        ),
        onTap: () async => _onTechSelected(context, techName, ref),
      ),
    );
  }

  Future<void> _onTechSelected(
    BuildContext context,
    String techName,
    WidgetRef ref,
  ) async {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final searchModel = ref.watch(searchModelProvider);

    final validateText = searchModel.validTech(
      event,
      editPerformanceModel.decidedTechList,
      techName,
    );

    if (validateText != null) {
      await showOkAlertDialog(
        context: context,
        title: validateText,
      );
    } else {
      searchModel.setTech(
        editPerformanceModel.decidedTechList,
        techName,
        order,
      );
    }
    Navigator.pop(context);
  }
}
