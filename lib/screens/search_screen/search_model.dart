import 'package:dscore_app/data/fx.dart';
import 'package:dscore_app/data/hb.dart';
import 'package:dscore_app/data/pb.dart';
import 'package:dscore_app/data/ph.dart';
import 'package:dscore_app/data/sr.dart';
import 'package:dscore_app/repository/performance_repository.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/search_screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchModelProvider = ChangeNotifierProvider(
  (ref) => SearchModel()..init(),
);

class SearchModel extends ChangeNotifier {
  late final PerformanceRepository performanceRepository;
  List<String> searchResult = [];
  String vtTechName = '';

  init() => performanceRepository = PerformanceRepository();

  //技検索
  void search(String inputText, Event event) {
    if (inputText.isEmpty) {
      searchResult.clear();
    } else {
      searchResult.clear(); //addしているため毎回クリアする必要がある
      final inputCharacters = <String>[];
      inputText.characters.forEach(inputCharacters.add);
      if (event == Event.fx) {
        searchResult = searchLogic(fxSearchWords, inputCharacters);
      }
      if (event == Event.ph) {
        searchResult = searchLogic(phSearchWords, inputCharacters);
      }
      if (event == Event.sr) {
        searchResult = searchLogic(srSearchWords, inputCharacters);
      }
      if (event == Event.pb) {
        searchResult = searchLogic(pbSearchWords, inputCharacters);
      }
      if (event == Event.hb) {
        searchResult = searchLogic(hbSearchWords, inputCharacters);
      }
    }
    notifyListeners();
  }

  List<String> searchLogic(
      Map<String, String> searchWords, List<String> characters) {
    final techsContainingFirstChar = <String>[];
    final techsToRemove = <String>[];

    for (var i = 0; i < characters.length; i++) {
      //0番目の文字を含むものをitemsに追加
      if (i == 0) {
        for (final word in searchWords.keys) {
          if (searchWords[word]!.contains(characters[0])) {
            techsContainingFirstChar.add(word);
          }
        }
      } else {
        //2番目以降の文字を含んでいないものをremoveListに追加
        for (final techs in techsContainingFirstChar) {
          if (!searchWords[techs]!.contains(characters[i])) {
            techsToRemove.add(techs);
          }
        }
      }
    }
    //removeListの要素をitemsから削除
    techsToRemove.forEach(techsContainingFirstChar.remove);
    return techsContainingFirstChar;
  }

  void onTechChipSelected(Event event, String searchText) {
    searchController.text = searchController.text + searchText;
    search(searchController.text, event);
    notifyListeners();
  }

  void deleteSearchBarText(TextEditingController controller) {
    controller.clear();
    searchResult.clear();
    notifyListeners();
  }

  bool isSameTechSelected(List<String> techList, String techName) {
    var isExist = false;
    for (final tech in techList) {
      if (techName == tech) {
        isExist = true;
      }
    }
    return isExist;
  }

  void setTech(List techList, String techName, int? order) {
    if (order != null) {
      techList[order - 1] = techName;
    } else {
      techList.add(techName);
    }
    notifyListeners();
  }
}
