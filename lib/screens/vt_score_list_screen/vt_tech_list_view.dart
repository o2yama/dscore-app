import 'package:dscore_app/data/vt.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FixedExtentScrollController vtController = FixedExtentScrollController();

class VTTechListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer<ScoreModel>(
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ListWheelScrollView.useDelegate(
                physics: FixedExtentScrollPhysics(),
                diameterRatio: 1.3,
                squeeze: 2.0,
                controller: vtController,
                itemExtent: 100,
                perspective: 0.001,
                childDelegate: ListWheelChildListDelegate(
                  children: vtTech.keys
                      .map((techName) => _vtTile(context, techName))
                      .toList(),
                ),
                overAndUnderCenterOpacity: 0.4,
                onSelectedItemChanged: (index) {
                  model.onVTTechSelected(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _vtTile(BuildContext context, String techName) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text('${vtTech[techName]}'),
            SizedBox(width: 16),
            Flexible(child: Text('$techName')),
          ],
        ),
      ),
    );
  }
}
