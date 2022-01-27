import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/screens/account_info_screen/account_info_model.dart';
import 'package:dscore_app/screens/common_widgets/custom_dialog/ok_cancel_dialog.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_model.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_screen.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_screen.dart';
import 'package:dscore_app/screens/performance_list_screen/performance_list_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _formKey = GlobalKey<FormState>();

final passwordController = TextEditingController();

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      body: Consumer(
        builder: (context, ref, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _backButton(context),
                        const SizedBox(height: 30),
                        _prevEmailDisplay(context, ref),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          _logOutButton(context, ref),
                          const SizedBox(height: 8),
                          _deleteAccountButton(context, ref),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: Utilities.isMobile() ? 50 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Platform.isIOS
                ? Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 24),
                      Text(
                        'アカウント情報',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  )
                : const Icon(Icons.clear),
          ],
        ),
      ),
    );
  }

  Widget _prevEmailDisplay(BuildContext context, WidgetRef ref) {
    final accountInfoModel = ref.watch(accountInfoModelProvider);
    return Column(
      children: [
        const Text('メールアドレス'),
        const SizedBox(height: 16),
        Text(
          accountInfoModel.userRepository.appUser!.email,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  Widget _logOutButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        showDialog<Dialog>(
          context: context,
          builder: (context) {
            return OkCancelDialog(
              onOk: () async {
                ref.watch(performanceListModelProvider).resetScores();
                await ref.watch(loginModelProvider).signOut();
                await Navigator.pushAndRemoveUntil<Object>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (_) => false);
              },
              onCancel: () => Navigator.pop(context),
              title: 'ログアウトしてもよろしいですか？',
              content: const Text('メールアドレスとパスワードを入力すると再度ログインできます。'),
            );
          },
        );
      },
      child: const Text('ログアウト'),
    );
  }

  Widget _deleteAccountButton(BuildContext context, WidgetRef ref) {
    final _accountInfoModel = ref.watch(accountInfoModelProvider);

    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: FocusManager.instance.primaryFocus!.unfocus,
              child: Stack(
                children: [
                  AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () async {
                          ref
                              .watch(loadingStateProvider.notifier)
                              .startLoading();

                          try {
                            await _accountInfoModel.reAuthAndDeleteAccount(
                              passwordController.text,
                            );
                            passwordController.clear();
                            await showOkAlertDialog(
                              context: context,
                              title: 'アカウントの削除が完了しました。',
                              message: 'ご利用いただきありがとうございました。'
                                  '\nまた演技のスコアを計算したい！と思ったら、ぜひご利用ください。',
                              barrierDismissible: true,
                            ).then((_) {
                              ref
                                  .watch(loadingStateProvider.notifier)
                                  .endLoading();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                                (route) => false,
                              );
                            });
                          } on Exception catch (e) {
                            await showOkAlertDialog(
                              context: context,
                              title: 'アカウントの削除に失敗しました',
                              message: e.toString(),
                            );
                          } finally {
                            ref
                                .watch(loadingStateProvider.notifier)
                                .endLoading();
                          }
                        },
                        child: const Text(
                          '削除',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    title: const Text(
                      '本当にアカウントを削除してもよろしいですか？',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      height: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'アカウントを削除すると下記のデータが完全に削除されます。\n',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            '・今までに登録した演技のデータ\n・アカウント情報\n(メールアドレス/パスワード)\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            '完全に削除されると復元できなくなりますが、よろしいですか？',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              errorText: passwordController.text.isEmpty
                                  ? 'アカウントの削除を続ける場合は\nパスワードを入力してください。'
                                  : null,
                              filled: true,
                              fillColor: Colors.grey.shade200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const LoadingView(),
                ],
              ),
            );
          },
        );
      },
      child: const Text(
        'アカウント削除',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
