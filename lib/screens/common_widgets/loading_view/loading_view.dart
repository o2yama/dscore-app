import 'dart:io';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingView extends ConsumerWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(loadingStateProvider);

    return loadingState
        ? Container(
            width: Utilities.screenWidth(context),
            height: Utilities.screenHeight(context),
            color: Colors.grey.withOpacity(0.6),
            child: Center(
              child: Platform.isIOS
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      height: 100,
                      width: 100,
                      child: const CupertinoActivityIndicator(radius: 20),
                    )
                  : const CircularProgressIndicator(),
            ),
          )
        : const SizedBox();
  }
}
