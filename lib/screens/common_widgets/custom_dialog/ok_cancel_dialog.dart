import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OkCancelDialog extends StatelessWidget {
  const OkCancelDialog({
    Key? key,
    required this.onOk,
    required this.onCancel,
    required this.title,
    this.content,
  }) : super(key: key);

  final VoidCallback onOk;
  final VoidCallback onCancel;
  final String title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(title),
            content: Text(content ?? ''),
            actions: [
              TextButton(
                onPressed: onCancel,
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: onOk,
                child: const Text('OK'),
              )
            ],
          )
        : AlertDialog(
            title: Text(title),
            content: Text(content ?? ''),
            actions: [
              TextButton(
                onPressed: onCancel,
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: onOk,
                child: const Text('OK'),
              )
            ],
          );
  }
}
