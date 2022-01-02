import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_tech_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/utilities.dart';

class VTScoreSelectScreen extends StatelessWidget {
  const VTScoreSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final height = Utilities.screenHeight(context);
          return Container(
            color: Theme.of(context).backgroundColor,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.1,
                        child: _backButton(context, ref),
                      ),
                      SizedBox(
                        height: height * 0.2,
                        child: _dScoreDisplay(context, ref),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: height * 0.5,
                        child: const VTTechListView(),
                      ),
                    ],
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

  Widget _backButton(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Platform.isIOS
              ? Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      '6種目一覧',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              : Icon(
                  Icons.clear,
                  color: Theme.of(context).primaryColor,
                ),
        ),
        TextButton(
          onPressed: () => _onStoreButtonPressed(context, ref),
          child: Text(
            '保存',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Future<void> _onStoreButtonPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    ref.watch(loadingStateProvider.notifier).startLoading();

    await ref.watch(scoreModelProvider).setVTScore();
    await ref.watch(homeModelProvider).getFavoriteScores();

    ref.watch(loadingStateProvider.notifier).endLoading();
    await showOkAlertDialog(context: context, title: '保存しました');

    Navigator.pop(context);
  }

  Widget _dScoreDisplay(BuildContext context, WidgetRef ref) {
    final width = Utilities.screenWidth(context);
    final scoreModel = ref.watch(scoreModelProvider);
    return Row(
      children: [
        Container(
          width: width * 0.5,
          margin: const EdgeInsets.only(left: 40),
          child: Text(
            scoreModel.vtTechName,
            style: TextStyle(
              fontSize: Utilities.isMobile() ? 24 : 30,
            ),
          ),
        ),
        SizedBox(width: width * 0.1),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Text(
            '${scoreModel.totalScore}',
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ],
    );
  }
}
