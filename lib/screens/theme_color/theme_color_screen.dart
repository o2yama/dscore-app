import 'package:dscore_app/screens/theme_color/theme_color_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../ad_state.dart';
import '../../utilities.dart';

class ThemeColorScreen extends StatefulWidget {
  @override
  _ThemeColorScreenState createState() => _ThemeColorScreenState();
}

class _ThemeColorScreenState extends State<ThemeColorScreen> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeColorModel>(builder: (context, model, child) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _ad(context),
                  _backButton(context),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView(
                            children: themes.keys
                                .map(
                                  (color) => _colorTile(context, color),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _ad(BuildContext context) {
    return banner == null
        ? Container(height: 50)
        : Container(
            height: 50,
            child: AdWidget(ad: banner!),
          );
  }

  Widget _backButton(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: Utilities().isMobile() ? 50 : 80,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            SizedBox(width: 8),
            Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
              size: Utilities().isMobile() ? 20 : 30,
            ),
            SizedBox(width: 24),
            Text(
              'テーマカラー',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: Utilities().isMobile() ? 16 : 24,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _colorTile(BuildContext context, String color) {
    final themeColorModel =
        Provider.of<ThemeColorModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 2.0,
      ),
      child: InkWell(
        onTap: () async {
          await themeColorModel.setThemeColor(color);
          await themeColorModel.getThemeColor();
        },
        child: Card(
          shadowColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: themes[color],
                  size: Utilities().isMobile() ? 20 : 30,
                ),
                SizedBox(width: 16),
                Text(
                  '$color',
                  style: TextStyle(
                    color: themes[color],
                    fontSize: Utilities().isMobile() ? 16 : 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
