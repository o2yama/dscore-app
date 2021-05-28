import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities.dart';
import '../edit_email/edit_email_model.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          _backButton(context),
                          SizedBox(height: 24),
                          SizedBox(height: 24),
                          SizedBox(height: 24),
                          SizedBox(height: 50),
                          SizedBox(height: 30),
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
                        'パスワード変更',
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
}
