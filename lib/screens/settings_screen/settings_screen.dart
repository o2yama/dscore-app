import 'package:dscore_app/repository/user_repository.dart';
import 'package:dscore_app/screens/admin/admin_home_screen.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/account_info_screen/account_info_screen.dart';
import 'package:dscore_app/screens/theme_color/theme_color_screen.dart';
import 'package:dscore_app/screens/usage/usage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer(
          builder: (context, ref, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const BannerAdWidget(),
                  _backButton(context),
                  const SizedBox(height: 24),
                  _adminTile(context, ref),
                  const SizedBox(height: 24),
                  _settingTile(
                    context,
                    'テーマカラー',
                    Icons.color_lens,
                    ref,
                    nextScreen: const ThemeColorScreen(),
                  ),
                  _settingTile(
                    context,
                    '使い方',
                    Icons.info,
                    ref,
                    nextScreen: const UsageScreen(),
                  ),
                  _settingTile(
                    context,
                    'プライバシー・ポリシー',
                    Icons.privacy_tip,
                    ref,
                  ),
                  _settingTile(
                    context,
                    '技追加の申請',
                    Icons.playlist_add_rounded,
                    ref,
                  ),
                  _settingTile(context, 'お問い合わせ', Icons.send, ref),
                  // loginModel.currentUser != null
                  //     ? _settingTile(
                  //         context, 'パスワード', EditPasswordScreen(), Icons.vpn_key)
                  //     : Container(),
                  _settingTile(context, '2022年版新ルール', Icons.rule, ref),
                  _settingTile(
                    context,
                    'アカウント情報',
                    Icons.mail,
                    ref,
                    nextScreen: const AccountInfoScreen(),
                  ),
                ],
              ),
            );
          },
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

  Widget _adminTile(BuildContext context, WidgetRef ref) {
    if (UserRepository().appUser == null ||
        !UserRepository().appUser!.isAdmin) {
      return const SizedBox();
    }

    return _settingTile(
      context,
      '管理画面',
      Icons.admin_panel_settings,
      ref,
      nextScreen: const AdminHomeScreen(),
    );
  }

  Widget _settingTile(
    BuildContext context,
    String title,
    IconData icon,
    WidgetRef ref, {
    Widget? nextScreen,
  }) {
    return Card(
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'プライバシー・ポリシー':
              launchUrl(Uri.parse('https://dscore-app-a72cf.web.app'));
              break;
            case 'お問い合わせ':
              launchUrl(Uri.parse(
                  'https://docs.google.com/forms/d/1HjKY8j_RqIJ1qRgqfxbIwqsNmAhclGNUdf6CofqQKIQ/edit'));
              break;
            case '技追加の申請':
              launchUrl(Uri.parse(
                  'https://docs.google.com/forms/d/1skhzHLRlNjMVCXZ3HjLQlMHxyZswp6v_enIj_bR4hwY/edit'));
              break;
            case '2022年版新ルール':
              launchUrl(Uri.parse(
                  'https://www.jpn-gym.or.jp/artistic/wp-content/uploads/sites/2/2021/11/fe50cd796f5adc2c6bee264a726ff587.pdf'));
              break;
            default:
              Navigator.push<Object>(
                  context, MaterialPageRoute(builder: (_) => nextScreen!));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 24),
              Text(title, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
