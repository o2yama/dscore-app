import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/services.dart';

class ATT {
  ATT._();
  static final ATT instance = ATT._();

  Future<bool> requestPermission() async {
    var result = false;

    if (Platform.isIOS) {
      final trackingStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      print('trackingStatus:$trackingStatus');

      try {
        if (trackingStatus == TrackingStatus.notDetermined) {
          final status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          print('requestTrackingAuthorization:$status');

          if (status == TrackingStatus.authorized) {
            result = true;
          }
        } else if (trackingStatus == TrackingStatus.authorized) {
          result = true;
        } else if (trackingStatus == TrackingStatus.notSupported) {
          result = true;
        }
      } on PlatformException {
        print('PlatformException was thrown');
      }
    } else {
      result = true;
    }

    final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
    print('[AppTrackingTransparency]IDFA:$idfa');
    print('[AppTrackingTransparency]result:$result');

    return result;
  }
}
