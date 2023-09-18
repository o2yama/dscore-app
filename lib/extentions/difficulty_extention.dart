import 'package:dscore_app/consts/difficulty.dart';

extension DifficultyEx on Difficulty {
  int get point {
    switch (this) {
      case Difficulty.A:
        return 1;
      case Difficulty.B:
        return 2;
      case Difficulty.C:
        return 3;
      case Difficulty.D:
        return 4;
      case Difficulty.E:
        return 5;
      case Difficulty.F:
        return 6;
      case Difficulty.G:
        return 7;
      case Difficulty.H:
        return 8;
      case Difficulty.I:
        return 9;
    }
  }

  static String getLabel(int point) {
    switch (point) {
      case 1:
        return 'A';
      case 2:
        return 'B';
      case 3:
        return 'C';
      case 4:
        return 'D';
      case 5:
        return 'E';
      case 6:
        return 'F';
      case 7:
        return 'G';
      case 8:
        return 'H';
      case 9:
        return 'I';
      default:
        return '';
    }
  }
}
