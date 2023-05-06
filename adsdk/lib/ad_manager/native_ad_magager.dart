import 'package:adsdk/ad_provider/native_ad_provider/native_ad_mob_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdManager {
  NativeAd? _nativeAd;

  int _adRequestsCompleted = 0;
  final List<String> _adUnitsProvider = [];
  final List<String> _adUnits = [];
  final List<String> _adFailureReasonList = [];

  loadAppOpenAd({
    required Function onAdLoaded,
    required Function onAdFailedToLoad,
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
    _requestNativeAd(
        adName: adName,
        adUnit: _adUnitsProvider[_adRequestsCompleted],
        adProvider: _adUnitsProvider[_adRequestsCompleted],
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad);
  }

  _requestNativeAd({
    required String adName,
    required String adUnit,
    required String adProvider,
    required Function onAdLoaded,
    required Function onAdFailedToLoad,
  }) async {
    NativeAdMobProvider().loadNativeAd(
        adUnit: adUnit,
        adProvider: adProvider,
        onAdLoaded: (ad) {
          _nativeAd = ad;
          onAdLoaded();
        },
        onAdFailedToLoad: (adError) {
          _adRequestsCompleted += 1;
          _nativeAd = null;
          if (_adRequestsCompleted < _adUnits.length) {
            _requestNativeAd(
                adName: adName,
                adUnit: _adUnitsProvider[_adRequestsCompleted],
                adProvider: _adUnitsProvider[_adRequestsCompleted],
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad);
          } else {
            onAdFailedToLoad();
          }
        });
  }
}
