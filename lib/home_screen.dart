import 'package:dscore_app/event_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> event = ['床', 'あん馬', '吊り輪', '跳馬', '平行棒', '鉄棒'];
  final List<String> eventEng = ['FX', 'PH', 'SR', 'VT', 'PB', 'HB'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('6種目'),
      ),
      body: Column(
        children: [
          _eventTile(context, event[0], eventEng[0]),
          _eventTile(context, event[1], eventEng[1]),
          _eventTile(context, event[2], eventEng[2]),
          _eventTile(context, event[3], eventEng[3]),
          _eventTile(context, event[4], eventEng[4]),
          _eventTile(context, event[5], eventEng[5]),
        ],
      ),
    );
  }

  _eventTile(BuildContext context, String event, String eventEng) {
    return ListTile(
      title: Text(
        '$event',
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(
        '$eventEng',
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventScreen()),
        );
      },
    );
  }
}
