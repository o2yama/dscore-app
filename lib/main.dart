import 'package:dscore_app/ad_state.dart';
import 'package:dscore_app/screens/intro/intro_model.dart';
import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/calculation_screen/calculation_screen_model.dart';
import 'package:dscore_app/screens/event_screen/event_screen_model.dart';
import 'package:dscore_app/screens/home_screen.dart';
import 'package:dscore_app/screens/theme_color/theme_color_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  ChangeNotifierProvider<ThemeColorModel>(
    create: (context) => ThemeColorModel(),
  ),
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
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MultiProvider(
        providers: multiProviders,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeColorModel>(builder: (context, model, child) {
      Future(() async => model.getThemeColor());
      return MaterialApp(
        theme: ThemeData(
          primaryColor: model.themeColor,
          backgroundColor: Colors.grey[200],
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 3,
            margin: EdgeInsets.all(12),
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(),
            buttonColor: Theme.of(context).primaryColor,
            textTheme: ButtonTextTheme.primary,
            focusColor: Colors.white,
            hoverColor: Theme.of(context).primaryColor,
          ),
        ),
        home: HomeScreen(),
      );
    });
  }
}
