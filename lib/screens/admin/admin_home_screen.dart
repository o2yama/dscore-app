import 'package:dscore_app/consts/event.dart';
import 'package:dscore_app/screens/admin/event_tech_list_screen.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _backButton(context),
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          children: [
            Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            const SizedBox(width: 24),
            Text(
              '設定',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _settingTile(BuildContext context, Event event) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push<Object>(
            context,
            MaterialPageRoute(
              builder: (_) => EventTechListScreen(event: event),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(event.name, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
