import 'package:dscore_app/repository/score_repository.dart';
import 'package:flutter/material.dart';

class ScoreEditModel extends ChangeNotifier {
  ScoreEditModel({required this.scoreRepository});
  ScoreRepository scoreRepository;
}
