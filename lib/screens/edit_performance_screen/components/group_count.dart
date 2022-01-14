import 'package:flutter/material.dart';

class GroupCount extends StatelessWidget {
  const GroupCount({
    Key? key,
    required this.group,
    required this.count,
  }) : super(key: key);

  final String group;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$group : $count',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: count > 5 ? Colors.redAccent : Colors.grey,
      ),
    );
  }
}
