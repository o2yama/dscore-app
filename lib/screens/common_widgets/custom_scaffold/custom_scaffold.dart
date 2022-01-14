import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends Scaffold {
  const CustomScaffold({
    Key? key,
    required this.context,
    Widget? body,
  }) : super(key: key, body: body);

  final BuildContext context;

  @override
  Widget? get body => Scaffold(
        body: Container(
          height: Utilities.screenHeight(context),
          color: Theme.of(context).backgroundColor,
          child: Stack(
            children: [
              GestureDetector(
                onTap: FocusManager.instance.primaryFocus?.unfocus,
                child: SafeArea(
                  child: super.body!,
                ),
              ),
              const LoadingView(),
            ],
          ),
        ),
      );
}
