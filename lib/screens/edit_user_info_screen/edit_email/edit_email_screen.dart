import 'dart:io';
import 'package:dscore_app/screens/edit_user_info_screen/edit_email/edit_email_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../common/utilities.dart';
import '../../../common/validator.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController newEmailController = TextEditingController();
TextEditingController confirmationNewEmailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class EditEmailScreen extends StatelessWidget {
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
      body: Consumer<EditEmailModel>(builder: (context, model, child) {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: InkWell(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _backButton(context),
                            SizedBox(height: 30),
                            _prevEmailDisplay(context),
                            // SizedBox(height: 50),
                            // _newEmailController(context),
                            // SizedBox(height: 50),
                            // _confirmationNewEmailController(context),
                            // SizedBox(height: 50),
                            // _passwordController(context),
                            // SizedBox(height: 100),
                            // _changeButton(context),
                            SizedBox(height: 300),
                          ],
                        ),
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
            ),
          ),
        );
      }),
    );
  }

  Widget _backButton(BuildContext context) {
    return Container(
      height: Utilities().isMobile() ? 70 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: Utilities().isMobile() ? 8 : 16),
            Platform.isIOS
                ? Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 24),
                      Text(
                        'メールアドレス',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Utilities().isMobile() ? 18 : 24,
                        ),
                      )
                    ],
                  )
                : Icon(Icons.clear),
          ],
        ),
      ),
    );
  }

  Widget _prevEmailDisplay(BuildContext context) {
    final editEmailModel = Provider.of<EditEmailModel>(context, listen: false);
    return editEmailModel.currentUser != null
        ? Column(
            children: [
              Text('メールアドレス'),
              SizedBox(height: 16),
              Text(
                '${editEmailModel.currentUser!.email}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          )
        : Container();
  }

  Widget _newEmailController(BuildContext context) {
    final editEmailModel = Provider.of<EditEmailModel>(context, listen: false);
    return TextField(
      controller: newEmailController,
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
        hintText: '新しいメールアドレス',
      ),
      onChanged: (text) {
        editEmailModel.onNewEmailFieldChanged(text);
      },
    );
  }

  Widget _confirmationNewEmailController(BuildContext context) {
    final editEmailModel = Provider.of<EditEmailModel>(context, listen: false);
    return TextField(
      controller: confirmationNewEmailController,
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
        hintText: '確認用メールアドレス',
      ),
      onChanged: (text) {
        editEmailModel.onConfirmationNewEmailFieldChanged(text);
      },
    );
  }

  Widget _passwordController(BuildContext context) {
    final editEmailModel = Provider.of<EditEmailModel>(context, listen: false);
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
        editEmailModel.onPasswordFieldChanged(text);
      },
    );
  }

  Widget _changeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _onChangeButtonPressed(context);
      },
      child: Text(
        '変更',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: Utilities().isMobile() ? 18 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
    );
  }

  Future<void> _onChangeButtonPressed(BuildContext context) async {
    final editEmailModel = Provider.of<EditEmailModel>(context, listen: false);
    if (!(Validator().validEmail(editEmailModel.newEmail))) {
      _showValidMessage(context, '登録できないメールアドレスです。');
    } else {
      if (!(Validator().validPassword(editEmailModel.password))) {
        _showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
      } else {
        if (editEmailModel.currentUser!.email == editEmailModel.newEmail) {
          _showValidMessage(context, 'メールアドレスが変更されていません');
        } else {
          try {
            final result = await editEmailModel.updateEmail();
            if (result == 'done') {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Platform.isIOS
                        ? CupertinoAlertDialog(
                            title: Text('変更が完了しました！'),
                            content: Text('認証メールのリンクをタップしてください。'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await editEmailModel.updateEmailInDB();
                                  editEmailModel.resetController();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: Text('変更が完了しました！'),
                            content: Text('認証メールのリンクをタップしてください。'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await editEmailModel.updateEmailInDB();
                                  editEmailModel.resetController();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                  });
            } else {
              if (result == 'fail auth') {
                _showValidMessage(context, 'パスワードが間違っている可能性があります。');
              }
              if (result == 'different confirmationEmail') {
                _showValidMessage(context, '確認用メールアドレスが異なります。');
              }
            }
          } catch (e) {
            print(e.toString());
            if (e.toString() ==
                '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Platform.isIOS
                        ? CupertinoAlertDialog(
                            title: Text('変更に失敗しました。'),
                            content: Text('同じメールアドレスの人が登録されています。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: Text('変更に失敗しました。'),
                            content: Text('同じメールアドレスの人が登録されています。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Platform.isIOS
                        ? CupertinoAlertDialog(
                            title: Text('変更に失敗しました。'),
                            content: Text('メールアドレスとパスワードをご確認ください。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: Text('変更に失敗しました。'),
                            content: Text('メールアドレスとパスワードをご確認ください。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          );
                  });
            }
          }
        }
      }
    }
  }
}
