import 'package:dscore_app/intro_model.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/calculation_screen/calculation_screen_model.dart';
import 'package:dscore_app/screens/event_screen/event_screen_model.dart';
import 'package:dscore_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> multiProviders = [
  ...independentModels,
  ...viewModels,
];

List<SingleChildWidget> independentModels = [
  Provider<UserRepository>(create: (_) => UserRepository()),
];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<EventScreenModel>(
    create: (context) => EventScreenModel(),
  ),
  ChangeNotifierProvider<CalculationScreenModel>(
    create: (context) => CalculationScreenModel(),
  ),
  ChangeNotifierProvider<IntroModel>(
    create: (context) => IntroModel(
      userRepository: Provider.of<UserRepository>(context, listen: false),
    ),
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: multiProviders,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(),
          buttonColor: Theme.of(context).primaryColor,
          textTheme: ButtonTextTheme.primary,
          focusColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
