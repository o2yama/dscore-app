import 'dart:io';
import 'package:dscore_app/screens/login_sign_up/login/login_screen.dart';
import 'package:dscore_app/screens/login_sign_up/sign_up/sign_up_model.dart';
import 'package:dscore_app/screens/total_score_list_screen/total_score_list_screen.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/common/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class SignUpScreen extends StatelessWidget {
  void _showValidMessage(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SafeArea(
            child: Consumer<SignUpModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            _backButton(context),
                            SizedBox(height: 24),
                            _description(context),
                            SizedBox(height: 24),
                            _emailController(context),
                            SizedBox(height: 24),
                            _passwordController(context),
                            SizedBox(height: 50),
                            _resisterButton(context),
                            SizedBox(height: 30),
                            _toLoginScreenButton(context),
                            SizedBox(height: 300),
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
                                ? CupertinoActivityIndicator()
                                : CircularProgressIndicator(),
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
          child: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => TotalScoreListScreen()),
                (_) => false);
          },
        ),
      ],
    );
  }

  Widget _description(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('ユーザー登録', style: Theme.of(context).textTheme.headline5),
        SizedBox(height: 24),
        Container(
          height: 150,
          child: Image.asset('images/splash_image.JPG'),
        ),
        SizedBox(height: 24),
        Text('演技の保存にはユーザー登録が必要です。')
      ],
    );
  }

  Widget _emailController(BuildContext context) {
    final signInModel = Provider.of<SignUpModel>(context, listen: false);
    return TextField(
      controller: emailController,
      cursorColor: Theme.of(context).primaryColor,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        prefixIcon: Icon(Icons.mail),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        hintText: 'メールアドレス',
      ),
      onChanged: (text) {
        signInModel.onEmailEdited(text);
      },
    );
  }

  Widget _passwordController(BuildContext context) {
    final signInModel = Provider.of<SignUpModel>(context, listen: false);
    return TextField(
      controller: passwordController,
      cursorColor: Theme.of(context).primaryColor,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        prefixIcon: Icon(Icons.vpn_key_sharp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        hintText: 'パスワード',
      ),
      onChanged: (text) {
        signInModel.onPasswordEdited(text);
      },
    );
  }

  Widget _resisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _onResisterButtonPressed(context);
      },
      child: Text(
        '登録',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
    );
  }

  Future<void> _onResisterButtonPressed(BuildContext context) async {
    final signInModel = Provider.of<SignUpModel>(context, listen: false);
    if (!(Validator().validEmail(signInModel.email))) {
      _showValidMessage(context, '登録できないメールアドレスです。');
    } else {
      if (!(Validator().validPassword(signInModel.password))) {
        _showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
      } else {
        try {
          await signInModel.signUpWithEmailAndPassword();
          showDialog(
            context: context,
            builder: (context) => Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text('登録が完了しました。'),
                    content: Text('Dスコアを登録しましょう！'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          signInModel.sendEmailVerification();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TotalScoreListScreen()),
                              (_) => false);
                        },
                        child: Text('OK'),
                      )
                    ],
                  )
                : AlertDialog(
                    title: Text('登録が完了しました。'),
                    content: Text('Dスコアを登録しましょう！'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TotalScoreListScreen()),
                              (_) => false);
                        },
                        child: Text('OK'),
                      )
                    ],
                  ),
          );
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text('登録に失敗しました。'),
                    content: Column(
                      children: [
                        SizedBox(height: 8),
                        Text('すでに同じメールアドレスが登録されている可能性があります。'),
                        Text('メールアドレスとパスワードをご確認ください。'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      )
                    ],
                  )
                : AlertDialog(
                    title: Text('登録に失敗しました'),
                    content: Text('メールアドレスとパスワードをご確認ください。'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      )
                    ],
                  ),
          );
        }
      }
    }
  }

  Widget _toLoginScreenButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (_) => false);
      },
      child: Text(
        'ユーザー登録済みの方はこちら',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
