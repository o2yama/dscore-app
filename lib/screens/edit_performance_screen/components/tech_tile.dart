import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/screens/edit_performance_screen/edit_performance_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
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
    final group = editPerformanceModel.groupData(event)[techName];
    final difficulty = editPerformanceModel.difficultyData(event)[techName];

    return Slidable(
      key: Key(
        editPerformanceModel.decidedTechList.indexOf(techName).toString(),
      ),
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
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          trailing: SizedBox(
            width: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 8),
                    const Expanded(
                      child: Text('難度', style: TextStyle(fontSize: 10)),
                    ),
                    Expanded(
                      child: Text(
                        Convertor.difficulty[difficulty].toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    const SizedBox(height: 8),
                    const Expanded(
                      child: Text('グループ', style: TextStyle(fontSize: 10)),
                    ),
                    Expanded(
                      child: Text(Convertor.group[group].toString()),
                    ),
                  ],
                ),
              ],
            ),
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
