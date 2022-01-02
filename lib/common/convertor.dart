import 'package:dscore_app/screens/home_screen/home_screen.dart';

class Convertor {
  static const difficulty = {
    1: 'A',
    2: 'B',
    3: 'C',
    4: 'D',
    5: 'E',
    6: 'F',
    7: 'G',
    8: 'H',
    9: 'I',
  };

  static const group = {
    1: 'Ⅰ',
    2: 'Ⅱ',
    3: 'Ⅲ',
    4: 'Ⅳ',
  };

  static const eventName = {
    Event.fx: '床',
    Event.ph: 'あん馬',
    Event.sr: '吊り輪',
    Event.vt: '跳馬',
    Event.pb: '平行棒',
    Event.hb: '鉄棒',
  };

  static const eventNameEn = {
    Event.fx: 'FX',
    Event.ph: 'PH',
    Event.sr: 'SR',
    Event.vt: 'VT',
    Event.pb: 'PB',
    Event.hb: 'HB',
  };
}
