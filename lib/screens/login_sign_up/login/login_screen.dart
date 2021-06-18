import 'dart:io';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_screen.dart';
import 'package:dscore_app/screens/total_score_list_screen/total_score_list_screen.dart';
import 'package:dscore_app/common/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../common/utilities.dart';
import 'login_model.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  void _showValidMessage(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: '$message',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SafeArea(
            child: Consumer<LoginModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _backButton(context),
                            const SizedBox(height: 24),
                            _description(context),
                            const SizedBox(height: 24),
                            _emailController(context),
                            const SizedBox(height: 24),
                            _passwordController(context),
                            const SizedBox(height: 50),
                            _loginButton(context),
                            const SizedBox(height: 30),
                            _toSignUpScreenButton(context),
                            const SizedBox(height: 300),
                          ],
                        ),
                      ),
                    ),
                  ),
                  model.isLoading
                      ? Container(
                          color: Colors.grey.withOpacity(0.6),
                          child: Center(
                            child: Platform.isIOS
                                ? const CupertinoActivityIndicator()
                                : const CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: Utilities().isMobile() ? 0 : 18),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil<Object>(
                context,
                MaterialPageRoute(builder: (context) => TotalScoreListScreen()),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('ログイン', style: Theme.of(context).textTheme.headline5),
        const SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: Image.asset('images/splash_image.JPG'),
        ),
        const SizedBox(height: 24),
        const Text('ログインして、Dスコアを管理しましょう！'),
      ],
    );
  }

  Widget _emailController(BuildContext context) {
    final loginModel = Provider.of<LoginModel>(context, listen: false);
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
      onChanged: loginModel.onEmailEdited,
    );
  }

  Widget _passwordController(BuildContext context) {
    final loginModel = Provider.of<LoginModel>(context, listen: false);
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
      onChanged: loginModel.onPasswordEdited,
    );
  }

  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _onLoginButtonPressed(context);
      },
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

  Future<void> _onLoginButtonPressed(BuildContext context) async {
    final loginModel = Provider.of<LoginModel>(context, listen: false);
    if (!Validator().validEmail(loginModel.email)) {
      _showValidMessage(context, 'メールアドレスをご確認ください。');
    } else {
      if (!Validator().validPassword(loginModel.password)) {
        _showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
      } else {
        try {
          await loginModel.logIn(loginModel.email, loginModel.password);
          await showDialog<Dialog>(
            context: context,
            builder: (context) => Platform.isIOS
                ? CupertinoAlertDialog(
                    title: const Text('ログインできました。'),
                    content: const Text('Dスコアを登録しましょう！'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil<Object>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TotalScoreListScreen()),
                              (_) => false);
                        },
                        child: const Text('OK'),
                      )
                    ],
                  )
                : AlertDialog(
                    title: const Text('ログインできました。'),
                    content: const Text('Dスコアを登録しましょう！'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil<Object>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TotalScoreListScreen()),
                              (_) => false);
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ),
          );
        } on Exception catch (e) {
          print(e);
          await showDialog<Dialog>(
            context: context,
            builder: (context) => Platform.isIOS
                ? CupertinoAlertDialog(
                    title: const Text('ログインに失敗しました'),
                    content: const Text('メールアドレスとパスワードをご確認ください。'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      )
                    ],
                  )
                : AlertDialog(
                    title: const Text('ログインに失敗しました'),
                    content: const Text('メールアドレスとパスワードをご確認ください。'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ),
          );
        }
      }
    }
  }

  Widget _toSignUpScreenButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil<Object>(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
            (_) => false);
      },
      child:
          const Text('ユーザー登録がまだの方はこちら', style: TextStyle(color: Colors.blue)),
    );
  }
}
