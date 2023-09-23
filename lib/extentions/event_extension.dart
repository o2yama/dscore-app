import 'package:dscore_app/consts/event.dart';

extension EventEx on Event {
  String get name {
    switch (this) {
      case Event.fx:
        return '床';
      case Event.ph:
        return 'あん馬';
      case Event.sr:
        return '吊り輪';
      case Event.vt:
        return '跳馬';
      case Event.pb:
        return '平行棒';
      case Event.hb:
        return '鉄棒';
    }
  }

  String get enName {
    switch (this) {
      case Event.fx:
        return 'FX';
      case Event.ph:
        return 'PH';
      case Event.sr:
        return 'SR';
      case Event.vt:
        return 'VT';
      case Event.pb:
        return 'PB';
      case Event.hb:
        return 'HB';
    }
  }
}
