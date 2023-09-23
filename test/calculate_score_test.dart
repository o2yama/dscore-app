import 'package:dscore_app/consts/event.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data.dart';

void main() {
  final editPerformanceModel = EditPerformanceModel();

  group('fx calc test', () {
    test('fxA', () {
      editPerformanceModel.decidedTechList = fxA;
      editPerformanceModel.cv = 0.1;

      expect(editPerformanceModel.calculateDifficulty(Event.fx), 3.4);
      expect(editPerformanceModel.calculateEGR(Event.fx), 1.5);
      expect(editPerformanceModel.calcTotalScore(Event.fx), 5.0);
    });

    test('fxB', () {
      editPerformanceModel.decidedTechList = fxB;
      editPerformanceModel.cv = 0.1;

      expect(editPerformanceModel.calculateDifficulty(Event.fx), 3.1);
      expect(editPerformanceModel.calculateEGR(Event.fx), 2.0);
      expect(editPerformanceModel.calcTotalScore(Event.fx), 5.2);
    });
  });

  group('hb calc test', () {
    test('hbA', () {
      editPerformanceModel.decidedTechList = hbA;
      editPerformanceModel.cv = 0.1;

      expect(editPerformanceModel.calculateDifficulty(Event.hb), 3.0);
      expect(editPerformanceModel.calculateEGR(Event.hb), 1.8);
      expect(editPerformanceModel.calcTotalScore(Event.hb), 4.9);
    });

    test('hbB', () {
      editPerformanceModel.decidedTechList = hbB;
      editPerformanceModel.cv = 0.4;

      expect(editPerformanceModel.calculateDifficulty(Event.hb), 4.5);
      expect(editPerformanceModel.calculateEGR(Event.hb), 2.0);
      expect(editPerformanceModel.calcTotalScore(Event.hb), 6.9);
    });
  });

  group('other calc test', () {
    test('calc phA', () {
      editPerformanceModel.decidedTechList = phA;
      editPerformanceModel.isUnder16 = false;
      editPerformanceModel.cv = 0;

      final difficulty = editPerformanceModel.calculateDifficulty(Event.ph);
      final egr = editPerformanceModel.calculateEGR(Event.ph);
      final total = editPerformanceModel.calcTotalScore(Event.ph);

      expect(difficulty, 2.1);
      expect(egr, 2.0);
      expect(total, 4.1);
    });

    test('calc phB', () {
      editPerformanceModel.decidedTechList = phB;
      editPerformanceModel.isUnder16 = false;
      editPerformanceModel.cv = 0;

      final difficulty = editPerformanceModel.calculateDifficulty(Event.ph);
      final egr = editPerformanceModel.calculateEGR(Event.ph);
      final total = editPerformanceModel.calcTotalScore(Event.ph);

      expect(difficulty, 3.8);
      expect(egr, 2.0);
      expect(total, 5.8);
    });

    test('calc pbA', () {
      editPerformanceModel.decidedTechList = pbA;
      editPerformanceModel.isUnder16 = true;
      editPerformanceModel.cv = 0;

      final difficulty = editPerformanceModel.calculateDifficulty(Event.pb);
      final egr = editPerformanceModel.calculateEGR(Event.pb);
      final total = editPerformanceModel.calcTotalScore(Event.pb);

      expect(difficulty, 3.0);
      expect(egr, 1.6);
      expect(total, 4.6);
    });

    test('calc pbB', () {
      editPerformanceModel.decidedTechList = pbB;
      editPerformanceModel.isUnder16 = false;
      editPerformanceModel.cv = 0;

      final difficulty = editPerformanceModel.calculateDifficulty(Event.pb);
      final egr = editPerformanceModel.calculateEGR(Event.pb);
      final total = editPerformanceModel.calcTotalScore(Event.pb);

      expect(difficulty, 3.5);
      expect(egr, 2.0);
      expect(total, 5.5);
    });
  });
}
