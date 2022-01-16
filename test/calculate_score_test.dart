import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final editPerformanceModel = EditPerformanceModel();

  final phPerformanceA = [
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

  group('calculation test', () {
    test('calculate egr PhA', () {
      editPerformanceModel.decidedTechList = phPerformanceA;
      final egr = editPerformanceModel.calculateEGR(
          editPerformanceModel.decidedTechList, false, Event.ph);
      expect(egr, 2.0);
    });
  });
}
