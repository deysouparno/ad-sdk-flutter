import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdLoadListener {
  void onAdLoaded({required AppOpenAd appOpenAd}) {}

  void onApplovinAdLoaded({required MaxAd appOpenAdMax}) {}

  void onAdFailedToLoad({required List<String> loadAdError}) {}

  void onAdFailedToShow({required AdError adError}) {}

  void onAdClosed() {}
}
