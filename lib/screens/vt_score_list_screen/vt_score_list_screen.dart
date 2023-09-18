import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_scaffold/custom_scaffold.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_state.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/vt_score_list_screen/vt_score_model.dart';
import 'package:dscore_app/screens/vt_score_list_screen/widget/vt_tech_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VTScoreSelectScreen extends ConsumerWidget {
  const VTScoreSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      context: context,
      body: Column(
        children: [
          const BannerAdWidget(),
          _backButton(context, ref),
          Expanded(child: _dScoreDisplay(context, ref)),
          const Expanded(
            flex: 3,
            child: VTTechListView(),
          ),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: Row(
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
      ),
    );
  }

  Future<void> _onStoreButtonPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    ref.watch(loadingStateProvider.notifier).startLoading();

    await ref.watch(vtScoreModelProvider).setVTScore();
    await ref.watch(homeModelProvider).getFavoritePerformances();

    ref.watch(loadingStateProvider.notifier).endLoading();
    if (context.mounted) {
      await showOkAlertDialog(context: context, title: '保存しました').then(
        (_) => Navigator.pop(context),
      );
    }
  }

  Widget _dScoreDisplay(BuildContext context, WidgetRef ref) {
    final vtScoreModel = ref.watch(vtScoreModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          vtScoreModel.techName,
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          '${vtScoreModel.difficulty}',
          style: const TextStyle(fontSize: 40),
        ),
      ],
    );
  }
}
