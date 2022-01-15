import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CvMenu extends ConsumerWidget {
  const CvMenu({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final cvs = [0.0, 0.1, 0.2, 0.3, 0.4];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 32),
        Text(
          '${editPerformanceModel.cv}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        const SizedBox(width: 16),
        PopupMenuButton(
          itemBuilder: (context) => cvs
              .map(
                (cv) => PopupMenuItem<Widget>(
                  height: 32,
                  child: SizedBox(
                    child: TextButton(
                      onPressed: () {
                        editPerformanceModel.onCVSelected(cv);
                        Navigator.pop(context);
                      },
                      child: Text(
                        '$cv',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          child: const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}
