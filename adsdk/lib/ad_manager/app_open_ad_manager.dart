import 'dart:async';
import 'dart:developer';
import 'package:adsdk/ad_provider/app_open_ad_provider/app_open_ad_lovin_ad_provider.dart';
import 'package:adsdk/ad_provider/app_open_ad_provider/app_open_ad_mob_ad_provider.dart';
import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/app_open_interface/app_open_ad_load_listener.dart';
import 'package:applovin_max/src/ad_classes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager implements AppOpenAdLoadListener {
  final List<String> _adUnits = [];
  final List<String> _adUnitsProvider = [];
  int _adRequestsCompleted = 0;
  final List<String> _adFailureReasonList = [];
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  loadAppOpenAd({
    required String adName,
    required String fallBackId,
    required List<String> primaryAdUnitIds,
    required List<String> secondaryAdUnitIds,
    required String primaryAdUnitProvider,
    required String secondaryAdUnitProvider,
  }) {
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

    _requestAppOpenAd(
      adName: adName,
      adUnit: _adUnits[_adRequestsCompleted],
      adProvider: _adUnitsProvider[_adRequestsCompleted],
    );
  }

  Future<bool> _requestAppOpenAd({
    required String adName,
    required String adUnit,
    required String adProvider,
  }) async {
    final completer = Completer<bool>();

    AppOpenAdMobAdProvider().loadAppOpenAd(
        adUnit: adUnit,
        adProvider: adProvider,
        onAdLoaded: (ad) {
          if (!_isAdLoaded) {
            _appOpenAd = ad;
            onAdLoaded(appOpenAd: ad);
            log('AppOpenAd Loaded');
            _isAdLoaded = true;
            completer.complete(true);
          }
        },
        onAdFailedToLoad: (adError) {
          String error = "$adName ==== $adUnit ==== ${adError.toString()}";
          log('AppOpenAd failed to load: $error');
          _adFailureReasonList.add(error);
          _adRequestsCompleted += 1;
          if (_adRequestsCompleted < _adUnits.length) {
            _requestAppOpenAd(
              adName: adName,
              adUnit: _adUnits[_adRequestsCompleted],
              adProvider: adProvider,
            );
          } else {
            onAdFailedToLoad(loadAdError: _adFailureReasonList);
            completer.complete(false);
          }
        });

    AppOpenAppLovinAdProvider().loadAppOpenAd(
        adUnit: adUnit,
        adProvider: adProvider,
        onAdLoaded: (maxAd) {
          if (!_isAdLoaded) {
            log('AppOpenAd Loaded');
            onApplovinAdLoaded(appOpenAdMax: maxAd);
            _isAdLoaded = true;
            completer.complete(true);
          }
        },
        onAdFailedToLoad: (maxError) {
          String error = "$adName ==== $adUnit ==== $maxError";
          _adFailureReasonList.add(error);
          _adRequestsCompleted += 1;
          if (_adRequestsCompleted < _adUnits.length) {
            _requestAppOpenAd(
              adName: adName,
              adUnit: _adUnits[_adRequestsCompleted],
              adProvider: adProvider,
            );
          } else {
            onAdFailedToLoad(loadAdError: _adFailureReasonList);
            completer.complete(false);
          }
        });
    return completer.future;
  }

  @override
  void onAdClosed() {
    // TODO: implement onAdClosed
  }

  @override
  void onAdFailedToLoad({required List<String> loadAdError}) {
    // TODO: implement onAdFailedToLoad
  }

  @override
  void onAdFailedToShow({required AdError adError}) {
    // TODO: implement onAdFailedToShow
  }

  @override
  void onAdLoaded({required AppOpenAd appOpenAd}) {
    // TODO: implement onAdLoaded
  }

  @override
  void onApplovinAdLoaded({required MaxAd appOpenAdMax}) {
    // TODO: implement onApplovinAdLoaded
  }
}
