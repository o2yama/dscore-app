import 'package:flutter_test/flutter_test.dart';

void main() {
  // final editPerformanceModel = EditPerformanceModel();

  final phTechList = [
    'バックセアー',
    'Cセアー',
    'ロス',
    'Cトンフェイ',
    '縦向き旋回',
    'シュテクリB',
    'フクガ',
    '旋回',
    '倒立2回ひねり下り',
  ];

  group('スコア計算のテスト', () {
    test('length of performance', () {
      expect(phTechList.length, 9);
    });

    // test('calculate egr', () {
    //   final egr = editPerformanceModel.calculateEGR(phTechList, Event.ph);
    //   expect(egr, 2.0);
    // });
  });
}
