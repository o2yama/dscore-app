import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  AdState(this.initialization);
  Future<InitializationStatus> initialization;

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-4715063571730383/8443324315'
      : 'ca-app-pub-4715063571730383/7108123549';

  AdListener get adListener => _adListener;
  final AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to load: ${ad.adUnitId}, $error.'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAppEvent: (ad, name, data) =>
        print('App event: ${ad.adUnitId}, $name, $data'),
    onApplicationExit: (ad) => print('App Exit: ${ad.adUnitId}.'),
    onNativeAdClicked: (nativeAd) =>
        print('Native ad clicked: ${nativeAd.adUnitId}'),
    onNativeAdImpression: (nativeAd) =>
        print('Native ad impression: ${nativeAd.adUnitId}'),
    onRewardedAdUserEarnedReward: (ad, reward) => print(
        'User rewarded: ${ad.adUnitId}, ${reward.amount} ${reward.type}.'),
  );
}
