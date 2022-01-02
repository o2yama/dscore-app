import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FixedExtentScrollController vtController =
    FixedExtentScrollController(initialItem: 14); //アカピアンスタート

class VTTechListView extends StatelessWidget {
  const VTTechListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Consumer(
        builder: (context, ref, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ListWheelScrollView.useDelegate(
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: 1.3,
                squeeze: 2,
                controller: vtController,
                itemExtent: 100,
                perspective: 0.001,
                childDelegate: ListWheelChildListDelegate(
                  children: vtTech.keys
                      .map((techName) => _vtTile(context, techName))
                      .toList(),
                ),
                overAndUnderCenterOpacity: 0.4,
                onSelectedItemChanged: (index) =>
                    ref.watch(scoreModelProvider).onVTTechSelected(index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _vtTile(BuildContext context, String techName) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text('${vtTech[techName]}'),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                techName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
