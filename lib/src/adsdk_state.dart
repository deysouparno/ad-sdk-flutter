import 'package:adsdk/src/internal/models/ad_sdk_configuration.dart';
import 'package:adsdk/src/internal/models/api_response.dart';

abstract class AdSdkState {
  static late AdSdkConfiguration adSdkConfig;
  static final Map<String, AdSdkAdConfig> ads = {};
  static bool showingAd = false;
}
