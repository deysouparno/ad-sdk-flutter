import 'dart:async';
import 'dart:developer';
import 'package:adsdk/data/enums/ad_provider.dart';
import 'package:adsdk/interfaces/app_open_ad_load_listener.dart';
import 'package:adsdk/utils/utils.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdLoader {
  final List<String> _adUnits = [];
  final List<String> _adUnitsProvider = [];
  int _adRequestsCompleted = 0;
  final List<String> _adFailureReasonList = [];
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  loadAppOpenAd(
      {required String adName,
      required String fallBackId,
      required List<String> primaryAdUnitIds,
      required List<String> secondaryAdUnitIds,
      required String primaryAdUnitProvider,
      required String secondaryAdUnitProvider,
      required AppOpenAdLoadListener appOpenAdLoadListener}) {
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
        appOpenAdLoadListener: appOpenAdLoadListener);
  }

  Future<bool> _requestAppOpenAd(
      {required String adName,
      required String adUnit,
      required AppOpenAdLoadListener appOpenAdLoadListener}) async {
    final completer = Completer<bool>();

    if (_adUnitsProvider[_adRequestsCompleted] ==
        AdProvider.ADMOB.name.toLowerCase()) {
      AppOpenAd.load(
        adUnitId: adUnit,
        orientation: AppOpenAd.orientationPortrait,
        request: Utils.getAdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            if (!_isAdLoaded) {
              _appOpenAd = ad;
              appOpenAdLoadListener.onAdLoaded(appOpenAd: ad);
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
                  appOpenAdLoadListener: appOpenAdLoadListener);
            } else {
              appOpenAdLoadListener.onAdFailedToLoad(
                  loadAdError: _adFailureReasonList);
            }
            completer.complete(false);
          },
        ),
      );
    } else if (_adUnitsProvider[_adRequestsCompleted] ==
        AdProvider.APPLOVIN.name.toLowerCase()) {
      Map? configuration = await AppLovinMAX.initialize(adUnit);
      if (configuration != null) {
        AppLovinMAX.loadAppOpenAd(adUnit);
        AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
            onAdLoadedCallback: (maxAd) {
              if (!_isAdLoaded) {
                log('AppOpenAd Loaded');
                appOpenAdLoadListener.onApplovinAdLoaded(appOpenAdMax: maxAd);
                _isAdLoaded = true;
              }
            },
            onAdLoadFailedCallback: (adUnit, maxError) {
              String error = "$adName ==== $adUnit ==== ${maxError.toString()}";
              _adFailureReasonList.add(error);
              _adRequestsCompleted += 1;
              if (_adRequestsCompleted < _adUnits.length) {
                _requestAppOpenAd(
                    adName: adName,
                    adUnit: _adUnits[_adRequestsCompleted],
                    appOpenAdLoadListener: appOpenAdLoadListener);
              } else {
                appOpenAdLoadListener.onAdFailedToLoad(
                    loadAdError: _adFailureReasonList);
              }
            },
            onAdDisplayedCallback: (maxAd) {},
            onAdDisplayFailedCallback: (maxAd, error) {},
            onAdClickedCallback: (maxAd) {},
            onAdHiddenCallback: (maxAd) {}));
      }
    }
    return completer.future;
  }
}
