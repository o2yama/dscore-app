import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/cupertino.dart';

class SearchModel extends ChangeNotifier {
  SearchModel({required this.scoreRepository});
  ScoreRepository scoreRepository;
}
