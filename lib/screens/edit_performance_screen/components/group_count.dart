import 'package:flutter/material.dart';

class GroupCount extends StatelessWidget {
  const GroupCount({Key? key, required this.count}) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ⅰ : $count',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: count > 5 ? Colors.redAccent : Colors.grey,
      ),
    );
  }
}
