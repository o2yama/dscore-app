import 'package:dscore_app/calculation_screen.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '床',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculationScreen()),
                );
              }),
        ],
      ),
      body: Column(),
    );
  }
}
