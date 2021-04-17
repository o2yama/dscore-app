import 'package:dscore_app/screens/event_screen/event_screen_model.dart';
import 'package:dscore_app/screens/vt_screen/vt_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../calculation_screen/calculation_screen.dart';

class EventScreen extends StatelessWidget {
  EventScreen(this.event);
  final String event;

  final bool favorite = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (event != '跳馬') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculationScreen(event),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VtScreen(event),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<EventScreenModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Row(
                children: [
                  _favoriteButton(),
                  Text('試合名'),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  _favoriteButton() {
    return IconButton(
        icon: Icon(
          Icons.favorite,
          // favorite == true ? Icons.favorite : Icons.favorite_border,
          // color: favorite == true ? Colors.red : Colors.black38,
        ),
        onPressed: () {
          //TODO
        });
  }
}
