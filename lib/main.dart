import 'package:dscore_app/screens/calculation_screen_model.dart';
import 'package:dscore_app/screens/event_screen_model.dart';
import 'package:dscore_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventScreenModel>(
          create: (context) => EventScreenModel(),
        ),
        ChangeNotifierProvider<CalculationScreenModel>(
          create: (context) => CalculationScreenModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
