import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:applovin_max/applovin_max.dart';

abstract class InterstitialAdLoadListener {
  void onAdFailedToLoad({required List<String> adErrors}) {}

  void onAdLoaded({required InterstitialAd interstitialAd}) {}

  void onApplovinAdLoaded({required MaxAd maxInterstitialAd}) {}
}
