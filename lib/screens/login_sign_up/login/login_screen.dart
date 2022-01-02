import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_screen.dart';
import 'package:dscore_app/common/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/utilities.dart';
import 'login_model.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Consumer(builder: (context, ref, child) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            _backButton(context),
                            const SizedBox(height: 24),
                            _description(context),
                            const SizedBox(height: 24),
                            _emailController(context, ref),
                            const SizedBox(height: 24),
                            _passwordController(context, ref),
                            const SizedBox(height: 50),
                            _loginButton(context, ref),
                            const SizedBox(height: 30),
                            _toSignUpScreenButton(context),
                            const SizedBox(height: 300),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const LoadingView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: Utilities.isMobile() ? 0 : 18),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil<Object>(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (_) => false);
          },
          child: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _description(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('ログイン', style: Theme.of(context).textTheme.headline5),
      const SizedBox(height: 24),
      SizedBox(
        height: 150,
        child: Image.asset('images/splash_image.JPG'),
      ),
      const SizedBox(height: 24),
      const Text('ログインして、Dスコアを管理しましょう！'),
    ]);
  }

  Widget _emailController(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: emailController,
      cursorColor: Theme.of(context).primaryColor,
      autofocus: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        prefixIcon: Icon(Icons.mail),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        hintText: 'メールアドレス',
      ),
      onChanged: ref.read(loginModelProvider).onEmailEdited,
    );
  }

  Widget _passwordController(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: passwordController,
      cursorColor: Theme.of(context).primaryColor,
      autofocus: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        prefixIcon: Icon(Icons.vpn_key_sharp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        hintText: 'パスワード',
      ),
      onChanged: ref.read(loginModelProvider).onPasswordEdited,
    );
  }

  Widget _loginButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async => _onLoginButtonPressed(context, ref),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: Text(
        'ログイン',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
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

    loadingStateModel.startLoading();

    if (!Validator().validEmail(loginModel.email)) {
      showValidMessage(context, 'メールアドレスをご確認ください。');
    } else if (!Validator().validPassword(loginModel.password)) {
      showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
    } else {
      try {
        await loginModel.logIn(loginModel.email, loginModel.password);
        await showOkAlertDialog(
          barrierDismissible: true,
          context: context,
          title: 'ログインできました。',
          message: 'Dスコアを登録しましょう！',
        );
        Navigator.pushAndRemoveUntil<Object>(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (_) => false);
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
      onPressed: () => Navigator.pushAndRemoveUntil<Object>(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
          (_) => false),
      child: const Text(
        'ユーザー登録がまだの方はこちら',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
