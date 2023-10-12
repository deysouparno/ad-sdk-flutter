import 'package:adsdk/src/internal/models/ad_sdk_configuration.dart';
import 'package:adsdk/src/internal/models/api_response.dart';

class AdSdkState {
  static AdSdkConfiguration adSdkConfig = AdSdkConfiguration();
  static AdSdkApiResponse? apiResp;
  static final Map<String, AdSdkAdConfig> ads = {};
  static bool showingAd = false;
}
