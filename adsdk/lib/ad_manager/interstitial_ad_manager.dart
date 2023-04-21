import 'dart:async';
import 'dart:developer';
import 'package:adsdk/ad_provider/interstitial_ad_provider/interstitial_app_lovin_ad_provider.dart';
import 'package:adsdk/ad_provider/interstitial_ad_provider/interstitial_ad_mob_ad_provider.dart';
import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/interstitial_ad_load_listener.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  int _adRequestsCompleted = 0;
  final List<String> _adUnitsProvider = [];
  final List<String> _adUnits = [];
  late Timer _timer;
  final List<String> _adFailureReasonList = [];
  bool _isAdLoaded = false;

  void loadInterstitialAd(
      {required String adName,
      required String fallBackId,
      required List<String> primaryAdUnitIds,
      required List<String> secondaryAdUnitIds,
      required String primaryAdUnitProvider,
      required String secondaryAdUnitProvider,
      required int timeout,
      required InterstitialAdLoadListener interstitialAdLoadListener}) {
    for (String adUnit in primaryAdUnitIds) {
      _adUnits.add(adUnit);
      _adUnitsProvider.add(primaryAdUnitProvider);
    }

    for (String adUnit in secondaryAdUnitIds) {
      _adUnits.add(adUnit);
      _adUnitsProvider.add(secondaryAdUnitProvider);
    }

    _adUnits.add(fallBackId);
    _adUnitsProvider.add(AdProvider.ADMOB.name.toLowerCase());

    _requestAd(
        adName: adName,
        adUnit: _adUnits[_adRequestsCompleted],
        adProvider: _adUnitsProvider[_adRequestsCompleted],
        interstitialAdLoadListener: interstitialAdLoadListener);
  }

  Future<void> _requestAd(
      {required String adName,
      required String adUnit,
      required String adProvider,
      required InterstitialAdLoadListener interstitialAdLoadListener}) async {
    final completer = Completer<bool>();

    InterstitialAdMobAdProvider().loadInterstitialAd(
        adUnit: adUnit,
        adProvider: adProvider,
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          log('InterstitialAd Loaded');
          interstitialAdLoadListener.onAdLoaded(interstitialAd: ad);
          completer.complete(true);
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (adError) {
          String error = "$adName ==== $adUnit ==== ${adError}";
          _adFailureReasonList.add(error);
          _adRequestsCompleted += 1;
          if (_adRequestsCompleted < _adUnits.length) {
            _requestAd(
                adName: adName,
                adUnit: _adUnits[_adRequestsCompleted],
                interstitialAdLoadListener: interstitialAdLoadListener,
                adProvider: adProvider);
          } else {
            interstitialAdLoadListener.onAdFailedToLoad(
                adErrors: _adFailureReasonList);
          }
          completer.complete(false);
        });

    InterstitialAppLovinAdProvider().loadInterstitialAd(
        adUnit: adUnit,
        adProvider: adProvider,
        onAdLoaded: (maxAd) {
          if (!_isAdLoaded) {
            interstitialAdLoadListener.onApplovinAdLoaded(
                maxInterstitialAd: maxAd);
            _isAdLoaded = true;
          }
        },
        onAdFailedToLoad: (maxError) {
          String error = "$adName ==== $adUnit ==== $maxError";
          _adFailureReasonList.add(error);
          _adRequestsCompleted += 1;
          if (_adRequestsCompleted < _adUnits.length) {
            _requestAd(
                adName: adName,
                adUnit: _adUnits[_adRequestsCompleted],
                interstitialAdLoadListener: interstitialAdLoadListener,
                adProvider: adProvider);
          } else {
            interstitialAdLoadListener.onAdFailedToLoad(
                adErrors: _adFailureReasonList);
          }
        });
  }

  Future<bool> showInterstitialAd() async {
    return true;
  }
}
