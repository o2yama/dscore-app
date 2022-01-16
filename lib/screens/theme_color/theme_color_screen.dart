import 'dart:io';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/theme_color/theme_color_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/utilities.dart';

class ThemeColorScreen extends ConsumerWidget {
  const ThemeColorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      context: context,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            const BannerAdWidget(),
            _backButton(context),
            const SizedBox(height: 24),
            Column(
              children: themes.keys
                  .map(
                    (color) => _colorTile(context, color, ref),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: Utilities.isMobile() ? 50 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Platform.isIOS
            ? Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                    size: Utilities.isMobile() ? 20 : 30,
                  ),
                  const SizedBox(width: 24),
                  Text(
                    'テーマカラー',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Utilities.isMobile() ? 18 : 24,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                    size: Utilities.isMobile() ? 20 : 30,
                  ),
                  const SizedBox(width: 24),
                  Text(
                    'テーマカラー',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Utilities.isMobile() ? 18 : 24,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _colorTile(BuildContext context, String color, WidgetRef ref) {
    final themeColorModel = ref.watch(themeModelProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Card(
            child: InkWell(
              onTap: () async {
                await themeColorModel.setThemeColor(color);
                await themeColorModel.getThemeColor();
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_outlined,
                      color: themes[color],
                      size: Utilities.isMobile() ? 20 : 30,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      color,
                      style: TextStyle(
                        color: themes[color],
                        fontSize: Utilities.isMobile() ? 18 : 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (color == 'ブラック') const SizedBox(height: 250),
      ],
    );
  }
}
