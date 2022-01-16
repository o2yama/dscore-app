import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_screen.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_model.dart';
import 'package:dscore_app/common/validator.dart';

final _passwordController = TextEditingController();

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Consumer(
                builder: (context, ref, child) {
                  return Stack(
                    children: [
                      Image.asset('images/splash.png'),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              _title(context),
                              const SizedBox(height: 24),
                              _emailTextField(context, ref),
                              const SizedBox(height: 24),
                              _passwordTextField(context, ref),
                              SizedBox(
                                height: Utilities.screenHeight(context) * 0.3,
                              ),
                              _resisterButton(context, ref),
                              const SizedBox(height: 10),
                              _toLoginScreenButton(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const LoadingView(),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'ユーザー登録',
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          hintText: 'メールアドレス',
        ),
      ),
    );
  }

  Widget _passwordTextField(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
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
      ),
    );
  }

  Widget _resisterButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _onResisterButtonPressed(context, ref),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: const Text(
        '登録',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _onResisterButtonPressed(
      BuildContext context, WidgetRef ref) async {
    final signUpModel = ref.watch(signUpModelProvider);
    final loadingStateModel = ref.watch(loadingStateProvider.notifier);

    if (!Validator().validEmail(emailController.text)) {
      showValidMessage(context, '登録できないメールアドレスです。');
    } else if (!Validator().validPassword(_passwordController.text)) {
      showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
    } else {
      try {
        loadingStateModel.startLoading();
        await signUpModel.signUpWithEmailAndPassword(
          emailController.text,
          _passwordController.text,
        );
        await showOkAlertDialog(
          context: context,
          title: '登録が完了しました。',
          message: 'Dスコアを登録しましょう！',
        );
        emailController.clear();
        _passwordController.clear();
        Navigator.pushAndRemoveUntil<Object>(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (_) => false,
        );
      } on Exception catch (e) {
        await showOkAlertDialog(
          context: context,
          title: '登録に失敗しました。',
          message: e.toString(),
        );
      } finally {
        loadingStateModel.endLoading();
      }
    }
  }

  Widget _toLoginScreenButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _passwordController.clear();
        Navigator.pushAndRemoveUntil<Object>(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (_) => false,
        );
      },
      child: const Text(
        'ユーザー登録済みの方はこちら',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
