import 'dart:async';
import 'package:adsdk/ad_provider/rewarded_ad_provider/rewarded_ad_mob_ad_provider.dart';
import 'package:adsdk/ad_provider/rewarded_ad_provider/rewarded_app_lovin_ad_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  int _adRequestsCompleted = 0;
  final List<String> _adUnits = [];
  final List<String> _adUnitsProvider = [];
  final List<String> _adFailureReasonsList = [];
  bool _isAdLoaded = false;

  void loadRewardedAd({
    required Function onAdLoaded,
    required Function onAdFailedToLoad,
    required String adName,
    required String fallBackId,
    required List<String> primaryAdUnitIds,
    required List<String> secondaryAdUnitIds,
    required String primaryAdUnitProvider,
    required String secondaryAdUnitProvider,
  }) {
    Completer adCompleter = Completer();

    for (String adUnit in primaryAdUnitIds) {
      _adUnits.add(adUnit);
      _adUnitsProvider.add(primaryAdUnitProvider);
    }

    for (String adUnit in secondaryAdUnitIds) {
      _adUnits.add(adUnit);
      _adUnitsProvider.add(secondaryAdUnitProvider);
    }
    _adUnits.add(fallBackId);

    _requestRewardedAd(
        adName: adName,
        adUnit: _adUnitsProvider[_adRequestsCompleted],
        adProvider: _adUnitsProvider[_adRequestsCompleted],
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad);
  }

  _requestRewardedAd({
    required String adName,
    required String adUnit,
    required String adProvider,
    required Function onAdLoaded,
    required Function onAdFailedToLoad,
  }) async {
    final completer = Completer<bool>();

    RewardedAdMobAdProvider().loadRewardedAd(
        adUnit: adUnit,
        adProvider: adProvider,
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          completer.complete(null);
          onAdLoaded();
        },
        onAdFailedToLoad: (adError) {
          _adRequestsCompleted += 1;
          _rewardedAd = null;
          if (_adRequestsCompleted < _adUnits.length) {
            _requestRewardedAd(
                adName: adName,
                adUnit: _adUnitsProvider[_adRequestsCompleted],
                adProvider: _adUnitsProvider[_adRequestsCompleted],
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad);
          } else {
            completer.complete(null);
            onAdFailedToLoad();
          }
        });

    RewardedAppLovinAdProvider().loadRewardedAd(
        adUnit: adUnit,
        adProvider: adProvider,
        onAdLoaded: (maxAd) {
          completer.complete(null);
          onAdLoaded();
        },
        onAdFailedToLoad: (maxError) {
          String error = "$adName ==== $adUnit ==== $maxError";
          _adRequestsCompleted += 1;
          if (_adRequestsCompleted < _adUnits.length) {
            _requestRewardedAd(
                adName: adName,
                adUnit: _adUnits[_adRequestsCompleted],
                adProvider: adProvider,
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad);
          } else {
            onAdFailedToLoad();
          }
        });
  }

  Future<void> show(
      {required Function() onUserEarnedReward,
      required Function() onAdFailedToShowContent,
      required Function onAdDismissed}) async {
    if (_rewardedAd == null) {
      throw Exception('Unable to Show Ad');
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _rewardedAd = null;
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        onAdFailedToShowContent();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) =>
          onUserEarnedReward(),
    );
  }
}
