import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdSdkConfiguration {
  bool isTestMode;
  AdRequest adRequest;
  AdManagerAdRequest adManagerAdRequest;
  List<String> applovinTestDevices;
  List<String> googleAdsTestDevices;

  AdSdkConfiguration({
    this.isTestMode = false,
    this.adRequest = const AdRequest(),
    this.adManagerAdRequest = const AdManagerAdRequest(),
    this.applovinTestDevices = const [],
    this.googleAdsTestDevices = const [],
  });
}
