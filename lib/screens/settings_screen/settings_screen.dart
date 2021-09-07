import 'dart:io';
import 'package:dscore_app/screens/edit_user_info_screen/edit_email/edit_email_screen.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_model.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/theme_color/theme_color_screen.dart';
import 'package:dscore_app/screens/usage/usage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/utilities.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    _backButton(context),
                    const SizedBox(height: 24),
                    _settingsListView(context),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: Utilities().isMobile() ? 70 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(children: [
          Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
            size: Utilities().isMobile() ? 20 : 30,
          ),
          const SizedBox(width: 24),
          Text(
            '設定',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: Utilities().isMobile() ? 18 : 24,
            ),
          )
        ]),
      ),
    );
  }

  Widget _settingsListView(BuildContext context) {
    final loginModel = Provider.of<LoginModel>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.8,
      child: ListView(children: [
        _settingTile(context, 'テーマカラー', Icons.color_lens,
            screen: ThemeColorScreen()),
        _settingTile(context, '使い方', Icons.info, screen: UsageScreen()),
        _settingTile(context, 'プライバシー・ポリシー', Icons.privacy_tip),
        _settingTile(context, '技追加の申請', Icons.playlist_add_rounded),
        _settingTile(context, 'お問い合わせ', Icons.send),
        // loginModel.currentUser != null
        //     ? _settingTile(
        //         context, 'パスワード', EditPasswordScreen(), Icons.vpn_key)
        //     : Container(),
        loginModel.currentUser != null
            ? _settingTile(context, 'メールアドレス', Icons.mail,
                screen: EditEmailScreen())
            : Container(),
        loginModel.currentUser == null
            ? _settingTile(context, 'ログイン', Icons.login, screen: LoginScreen())
            : _settingTile(context, 'ログアウト', Icons.logout),
        Container(height: Utilities().isMobile() ? 200 : 300),
      ]),
    );
  }

  Widget _settingTile(BuildContext context, String title, IconData icon,
      {Widget? screen}) {
    final loginModel = Provider.of<LoginModel>(context, listen: false);
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return InkWell(
      onTap: () {
        if (title == 'ログアウト') {
          showDialog<Dialog>(
              context: context,
              builder: (context) {
                return Platform.isIOS
                    ? CupertinoAlertDialog(
                        title: const Text('ログアウトしてもよろしいですか？'),
                        content: const Text('メールアドレスとパスワードを入力すると再度ログインできます。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () async {
                              scoreModel.resetScores();
                              await loginModel.signOut();
                              await Navigator.pushAndRemoveUntil<Object>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  (_) => false);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )
                    : AlertDialog(
                        title: const Text('ログアウトしてもよろしいですか？'),
                        content: const Text('メールアドレスとパスワードを入力すると再度ログインできます。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () async {
                              scoreModel.resetScores();
                              await loginModel.signOut();
                              await Navigator.pushAndRemoveUntil<Object>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  (_) => false);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
              });
        } else {
          if (title == 'ログイン') {
            Navigator.push<Object>(
                context,
                MaterialPageRoute(
                  builder: (_) => screen!,
                  fullscreenDialog: true,
                ));
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
            child: Row(children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 24),
              Text(
                '$title',
                style: TextStyle(fontSize: Utilities().isMobile() ? 18 : 24),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
