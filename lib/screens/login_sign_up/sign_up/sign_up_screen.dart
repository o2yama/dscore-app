import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/login_sign_up/login/login_screen.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_model.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/common/validator.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
                            _resisterButton(context, ref),
                            const SizedBox(height: 30),
                            _toLoginScreenButton(context),
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
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(width: Utilities.isMobile() ? 0 : 18),
      TextButton(
        onPressed: () => Navigator.pushAndRemoveUntil<Object>(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (_) => false),
        child: Icon(
          Icons.clear,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ]);
  }

  Widget _description(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('ユーザー登録', style: Theme.of(context).textTheme.headline5),
      const SizedBox(height: 24),
      SizedBox(
        height: 150,
        child: Image.asset('images/splash_image.JPG'),
      ),
      const SizedBox(height: 24),
      const Text('演技の保存にはユーザー登録が必要です。')
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
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        hintText: 'メールアドレス',
      ),
      onChanged: ref.read(signUpModelProvider).onEmailEdited,
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
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintText: 'パスワード',
      ),
      onChanged: ref.read(signUpModelProvider).onPasswordEdited,
    );
  }

  Widget _resisterButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _onResisterButtonPressed(context, ref),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: Text(
        '登録',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
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

    loadingStateModel.startLoading();

    if (!Validator().validEmail(signUpModel.email)) {
      showValidMessage(context, '登録できないメールアドレスです。');
    } else if (!Validator().validPassword(signUpModel.password)) {
      showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
    } else {
      try {
        await signUpModel.signUpWithEmailAndPassword();
        await showOkAlertDialog(
          context: context,
          title: '登録が完了しました。',
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
      onPressed: () => Navigator.pushAndRemoveUntil<Object>(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (_) => false),
      child: const Text(
        'ユーザー登録済みの方はこちら',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
