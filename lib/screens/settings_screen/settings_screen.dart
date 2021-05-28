import 'dart:io';
import 'package:dscore_app/screens/edit_user_info_screen/edit_email/edit_email_screen.dart';
import 'package:dscore_app/screens/edit_user_info_screen/edit_password/edit_password_screen.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_model.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/theme_color/theme_color_screen.dart';
import 'package:dscore_app/screens/usage/usage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../ad_state.dart';
import '../../utilities.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _ad(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _backButton(context),
                      SizedBox(height: 24),
                      _settingsListView(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      height: Utilities().isMobile() ? 70 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          children: [
            Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
              size: Utilities().isMobile() ? 20 : 30,
            ),
            SizedBox(width: 24),
            Text(
              '設定',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: Utilities().isMobile() ? 18 : 24,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _settingsListView(BuildContext context) {
    final loginModel = Provider.of<LoginModel>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.6,
      child: ListView(
        children: [
          _settingTile(context, 'テーマカラー', ThemeColorScreen(), Icons.color_lens),
          _settingTile(context, '使い方', UsageScreen(), Icons.info),
          loginModel.currentUser != null
              ? _settingTile(context, 'メール変更', EditEmailScreen(), Icons.mail)
              : Container(),
          loginModel.currentUser != null
              ? _settingTile(
                  context, 'パスワード変更', EditPasswordScreen(), Icons.vpn_key)
              : Container(),
          loginModel.currentUser == null
              ? _settingTile(context, 'ログイン', LoginScreen(), Icons.login)
              : _settingTile(context, 'ログアウト', Container(), Icons.logout),
        ],
      ),
    );
  }

  Widget _settingTile(
      BuildContext context, String setting, Widget screen, IconData icon) {
    final loginModel = Provider.of<LoginModel>(context, listen: false);
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    return InkWell(
      onTap: () {
        if (setting == 'ログアウト') {
          showDialog(
              context: context,
              builder: (context) {
                return Platform.isIOS
                    ? CupertinoAlertDialog(
                        title: Text('ログアウトしてもよろしいですか？'),
                        content: Text('メールアドレスとパスワードを入力すると再度ログインできます。'),
                        actions: [
                          TextButton(
                            child: Text('キャンセル'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () async {
                              scoreModel.resetScores();
                              await loginModel.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  (_) => false);
                            },
                          ),
                        ],
                      )
                    : AlertDialog();
              });
        } else {
          if (setting == 'ログイン') {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => screen,
                  fullscreenDialog: true,
                ));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 24),
                Text(
                  '$setting',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
