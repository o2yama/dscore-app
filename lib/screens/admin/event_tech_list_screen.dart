import 'package:dscore_app/consts/event.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';

class EventTechListScreen extends StatelessWidget {
  const EventTechListScreen({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      body: Container(),
    );
  }
}
