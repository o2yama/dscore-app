import 'package:dscore_app/screens/common_widgets/custom_dialog/ok_cancel_dialog.dart';
import 'package:dscore_app/screens/edit_user_info_screen/edit_email/edit_email_screen.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_model.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/theme_color/theme_color_screen.dart';
import 'package:dscore_app/screens/usage/usage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/utilities.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return Column(
                        children: [
                          _backButton(context),
                          const SizedBox(height: 24),
                          _settingsListView(context, ref),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: Utilities.isMobile() ? 70 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(children: [
          Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
            size: Utilities.isMobile() ? 20 : 30,
          ),
          const SizedBox(width: 24),
          Text(
            '設定',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: Utilities.isMobile() ? 18 : 24,
            ),
          )
        ]),
      ),
    );
  }

  Widget _settingsListView(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: Utilities.screenHeight(context) * 0.8,
      child: ListView(
        children: [
          _settingTile(
            context,
            'テーマカラー',
            Icons.color_lens,
            ref,
            screen: ThemeColorScreen(),
          ),
          _settingTile(
            context,
            '使い方',
            Icons.info,
            ref,
            screen: UsageScreen(),
          ),
          _settingTile(context, 'プライバシー・ポリシー', Icons.privacy_tip, ref),
          _settingTile(context, '技追加の申請', Icons.playlist_add_rounded, ref),
          _settingTile(context, 'お問い合わせ', Icons.send, ref),
          // loginModel.currentUser != null
          //     ? _settingTile(
          //         context, 'パスワード', EditPasswordScreen(), Icons.vpn_key)
          //     : Container(),
          ref.read(loginModelProvider).currentUser != null
              ? _settingTile(
                  context,
                  'メールアドレス',
                  Icons.mail,
                  ref,
                  screen: EditEmailScreen(),
                )
              : Container(),
          ref.read(loginModelProvider).currentUser == null
              ? _settingTile(
                  context,
                  'ログイン',
                  Icons.login,
                  ref,
                  screen: const LoginScreen(),
                )
              : _settingTile(
                  context,
                  'ログアウト',
                  Icons.logout,
                  ref,
                ),
          Container(height: Utilities.isMobile() ? 200 : 300),
        ],
      ),
    );
  }

  Widget _settingTile(
    BuildContext context,
    String title,
    IconData icon,
    WidgetRef ref, {
    Widget? screen,
  }) {
    return InkWell(
      onTap: () {
        if (title == 'ログアウト') {
          showDialog<Dialog>(
            context: context,
            builder: (context) {
              return OkCancelDialog(
                onOk: () async {
                  ref.watch(scoreModelProvider).resetScores();
                  await ref.watch(loginModelProvider).signOut();
                  await Navigator.pushAndRemoveUntil<Object>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (_) => false);
                },
                onCancel: () => Navigator.pop(context),
                title: 'ログアウトしてもよろしいですか？',
                content: 'メールアドレスとパスワードを入力すると再度ログインできます。',
              );
            },
          );
        } else {
          if (title == 'ログイン') {
            Navigator.push<Object>(
              context,
              MaterialPageRoute(
                builder: (_) => screen!,
                fullscreenDialog: true,
              ),
            );
          } else {
            if (title == 'プライバシー・ポリシー') {
              launch(
                'https://dscore-app-a72cf.firebaseapp.com/',
                forceSafariVC: true,
                forceWebView: true,
              );
            } else {
              if (title == 'お問い合わせ') {
                launch(
                  'https://docs.google.com/forms/d/1HjKY8j_RqIJ1qRgqfxbIwqsNmAhclGNUdf6CofqQKIQ/edit',
                  forceSafariVC: true,
                  forceWebView: true,
                );
              } else {
                if (title == '技追加の申請') {
                  launch(
                    'https://docs.google.com/forms/d/1skhzHLRlNjMVCXZ3HjLQlMHxyZswp6v_enIj_bR4hwY/edit',
                    forceSafariVC: true,
                    forceWebView: true,
                  );
                } else {
                  Navigator.push<Object>(
                      context, MaterialPageRoute(builder: (_) => screen!));
                }
              }
            }
          }
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 24),
                Text(
                  title,
                  style: TextStyle(fontSize: Utilities.isMobile() ? 18 : 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
