import 'package:dscore_app/consts/event.dart';
import 'package:dscore_app/extentions/difficulty_extention.dart';
import 'package:dscore_app/extentions/int_extension.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/search_screen/search_model.dart';
import 'package:dscore_app/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TechTile extends ConsumerWidget {
  const TechTile({
    required Key key,
    required this.techName,
    required this.order,
    required this.event,
  }) : super(key: key);

  final String techName;
  final int order;
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editPerformanceModel = ref.watch(editPerformanceModelProvider);
    final group = editPerformanceModel.allGroupDataOf(event)[techName];
    final difficulty =
        editPerformanceModel.allDifficultyDataOf(event)[techName];

    return Slidable(
      key: Key(
          editPerformanceModel.decidedTechList.indexOf(techName).toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            label: '削除',
            backgroundColor: Colors.red,
            icon: Icons.remove,
            onPressed: (BuildContext context) {
              editPerformanceModel.deleteTech(order - 1, event);
            },
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  techName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          trailing: Text(
            '${DifficultyEx.getLabel(difficulty!)} / ${group!.techGroupLabel}',
          ),
          onTap: () {
            searchController.clear();
            ref.watch(searchModelProvider).searchResult.clear();
            Navigator.push<Object>(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(order: order, event: event),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
