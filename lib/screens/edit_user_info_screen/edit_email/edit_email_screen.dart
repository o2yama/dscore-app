import 'dart:io';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/edit_user_info_screen/edit_email/edit_email_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/utilities.dart';
import '../../../common/validator.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController newEmailController = TextEditingController();
TextEditingController confirmationNewEmailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class EditEmailScreen extends StatelessWidget {
  const EditEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return Container(
            height: Utilities.screenHeight(context),
            color: Theme.of(context).backgroundColor,
            child: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _formKey,
                      child: GestureDetector(
                        onTap: () =>
                            FocusManager.instance.primaryFocus!.unfocus(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _backButton(context),
                              const SizedBox(height: 30),
                              _prevEmailDisplay(context, ref),
                              // SizedBox(height: 50),
                              // _newEmailController(context),
                              // SizedBox(height: 50),
                              // _confirmationNewEmailController(context),
                              // SizedBox(height: 50),
                              // _passwordController(context),
                              // SizedBox(height: 100),
                              // _changeButton(context),
                              const SizedBox(height: 300),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const LoadingView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      height: Utilities.isMobile() ? 70 : 90,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: Utilities.isMobile() ? 8 : 16),
            Platform.isIOS
                ? Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 24),
                      Text(
                        'メールアドレス',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Utilities.isMobile() ? 18 : 24,
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
    final editEmailModel = ref.watch(editEmailModelProvider);
    return editEmailModel.currentUser != null
        ? Column(
            children: [
              const Text('メールアドレス'),
              const SizedBox(height: 16),
              Text(
                editEmailModel.currentUser!.email,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          )
        : Container();
  }

  Widget _newEmailController(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: newEmailController,
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
        hintText: '新しいメールアドレス',
      ),
      onChanged: ref.watch(editEmailModelProvider).onNewEmailFieldChanged,
    );
  }

  Widget _confirmationNewEmailController(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: confirmationNewEmailController,
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
        hintText: '確認用メールアドレス',
      ),
      onChanged:
          ref.watch(editEmailModelProvider).onConfirmationNewEmailFieldChanged,
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
      onChanged: ref.watch(editEmailModelProvider).onPasswordFieldChanged,
    );
  }

  Widget _changeButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await _onChangeButtonPressed(context, ref);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: Text(
        '変更',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: Utilities.isMobile() ? 18 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _onChangeButtonPressed(
      BuildContext context, WidgetRef ref) async {
    final editEmailModel = ref.watch(editEmailModelProvider);

    if (!Validator().validEmail(editEmailModel.newEmail)) {
      showValidMessage(context, '登録できないメールアドレスです。');
    } else {
      if (!Validator().validPassword(editEmailModel.password)) {
        showValidMessage(context, 'パスワードは半角英数字6文字以上です。');
      } else {
        if (editEmailModel.currentUser!.email == editEmailModel.newEmail) {
          showValidMessage(context, 'メールアドレスが変更されていません');
        } else {
          try {
            final result = await editEmailModel.updateEmail();
            if (result == 'done') {
              await showDialog<Dialog>(
                  context: context,
                  builder: (context) {
                    return Platform.isIOS
                        ? CupertinoAlertDialog(
                            title: const Text('変更が完了しました！'),
                            content: const Text('認証メールのリンクをタップしてください。'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  // await editEmailModel.updateEmailInDB();
                                  editEmailModel.resetController();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: const Text('変更が完了しました！'),
                            content: const Text('認証メールのリンクをタップしてください。'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  // await editEmailModel.updateEmailInDB();
                                  editEmailModel.resetController();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                  });
            } else {
              if (result == 'fail auth') {
                showValidMessage(context, 'パスワードが間違っている可能性があります。');
              }
              if (result == 'different confirmationEmail') {
                showValidMessage(context, '確認用メールアドレスが異なります。');
              }
            }
          } on Exception catch (e) {
            if (e.toString() ==
                '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
              await showDialog<Dialog>(
                  context: context,
                  builder: (context) {
                    return Platform.isIOS
                        ? CupertinoAlertDialog(
                            title: const Text('変更に失敗しました。'),
                            content: const Text('同じメールアドレスの人が登録されています。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: const Text('変更に失敗しました。'),
                            content: const Text('同じメールアドレスの人が登録されています。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                  });
            } else {
              await showDialog<Dialog>(
                  context: context,
                  builder: (context) {
                    return Platform.isIOS
                        ? CupertinoAlertDialog(
                            title: const Text('変更に失敗しました。'),
                            content: const Text('メールアドレスとパスワードをご確認ください。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: const Text('変更に失敗しました。'),
                            content: const Text('メールアドレスとパスワードをご確認ください。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
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
