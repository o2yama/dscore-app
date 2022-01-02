import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingStateProvider = StateNotifierProvider<LoadingState, bool>(
  (ref) => LoadingState(),
);

class LoadingState extends StateNotifier<bool> {
  LoadingState() : super(false);

  void startLoading() {
    state = true;
  }

  void endLoading() {
    state = false;
  }
}
