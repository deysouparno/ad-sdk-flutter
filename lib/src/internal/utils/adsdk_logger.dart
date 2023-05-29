import 'package:adsdk/src/internal/constants/constants.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:flutter/foundation.dart';

abstract class AdSdkLogger {
  static String info(String message) {
    debugPrint("\x1B[34m[${AdSdkConstants.tag} - INFO]: $message");
    return message;
  }

  static String error(String message) {
    debugPrint("\x1B[31m[${AdSdkConstants.tag} - INFO]: $message");
    return message;
  }
  
  static void adLoadedLog({
    required String adName,
    required AdProvider adProvider,
  }) {
    info("Ad Loaded - (AdName: $adName, AdProvider: ${adProvider.key})");
  }
}
