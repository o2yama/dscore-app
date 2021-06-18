import 'dart:io';
import 'package:dscore_app/screens/edit_user_info_screen/edit_password/edit_password_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/utilities.dart';
import '../edit_email/edit_email_model.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();

class EditPasswordScreen extends StatelessWidget {
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
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          _backButton(context),
                          const SizedBox(height: 24),
                          const SizedBox(height: 24),
                          const SizedBox(height: 24),
                          const SizedBox(height: 50),
                          const SizedBox(height: 30),
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
            ),
          ),
        );
      }),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
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
                      const SizedBox(width: 24),
                      Text(
                        'パスワード変更',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Utilities().isMobile() ? 18 : 24,
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

  Widget _emailController(BuildContext context) {
    final editPasswordModel =
        Provider.of<EditPasswordModel>(context, listen: false);
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
      onChanged: editPasswordModel.onEmailFieldChanged,
    );
  }
}
