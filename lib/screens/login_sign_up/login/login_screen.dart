import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_model.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_screen.dart';
import 'package:dscore_app/common/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailController = TextEditingController();
final _passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: Utilities.screenWidth(context),
            height: Utilities.screenHeight(context),
            child: Image.asset('images/background.png', fit: BoxFit.fill),
          ),
          Center(
            child: SizedBox(
              width: Utilities.isMobile() ? 200 : 300,
              height: Utilities.isMobile() ? 200 : 300,
              child: Image.asset('images/logo.png'),
            ),
          ),
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return Column(
                        children: [
                          const SizedBox(height: 24),
                          _title(context),
                          _emailTextField(context, ref),
                          _passwordTextField(context, ref),
                          SizedBox(
                            height: Utilities.screenHeight(context) * 0.3,
                          ),
                          _loginButton(context, ref),
                          const SizedBox(height: 24),
                          _toSignUpScreenButton(context),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const LoadingView(),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ログイン',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _emailTextField(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: TextField(
        controller: emailController,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          hintText: 'メールアドレス',
        ),
      ),
    );
  }

  Widget _passwordTextField(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: _passwordController,
      cursorColor: Theme.of(context).primaryColor,
      autofocus: true,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintText: 'パスワード',
      ),
    );
  }

  Widget _loginButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async => _onLoginButtonPressed(context, ref),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: const Text(
        'ログイン',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          fontSize: 18,
        ),
      ),
    );
  }

  Future<void> _onLoginButtonPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final loginModel = ref.watch(loginModelProvider);
    final loadingStateModel = ref.watch(loadingStateProvider.notifier);
    final homeModel = ref.watch(homeModelProvider);

    if (!Validator().validEmail(emailController.text)) {
      showValidMessage(context, 'メールアドレスをご確認ください。');
    } else if (!Validator().validPassword(_passwordController.text)) {
      showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
    } else {
      try {
        loadingStateModel.startLoading();
        await loginModel.logIn(
          emailController.text,
          _passwordController.text,
        );

        await homeModel.getUserData();
        await homeModel.getFavoritePerformances();

        loadingStateModel.endLoading();
        emailController.clear();
        _passwordController.clear();

        if (context.mounted) {
          await showOkAlertDialog(
            barrierDismissible: true,
            context: context,
            title: 'ログインできました。',
            message: 'Dスコアを登録しましょう！',
          ).then((value) {
            Navigator.pushAndRemoveUntil<Object>(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (_) => false,
            );
          });
        }
      } on Exception catch (e) {
        await showOkAlertDialog(
          barrierDismissible: true,
          context: context,
          title: 'ログインに失敗しました',
          message: e.toString(),
        );
      } finally {
        loadingStateModel.endLoading();
      }
    }
  }

  Widget _toSignUpScreenButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _passwordController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
      child: const Text(
        'ユーザー登録がまだの方はこちら',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
