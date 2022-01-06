import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/theme_color/theme_color_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(
      const ProviderScope(child: MyApp()),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _themeColorModel = ref.watch(themeModelProvider);

        Future(() async => _themeColorModel.getThemeColor());
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: _themeColorModel.themeColor,
            backgroundColor: _themeColorModel.themeColor.withOpacity(0.1),
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            buttonTheme: ButtonThemeData(
              shape: const RoundedRectangleBorder(),
              buttonColor: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.primary,
              focusColor: Colors.white,
              hoverColor: Theme.of(context).primaryColor,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
