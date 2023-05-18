// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';

class AdSdkAd {
  dynamic ad;

  String adName;
  String adUnitId;

  AdProvider adProvider;
  AdUnitType adUnitType;

  AdSdkAd({
    required this.ad,
    required this.adName,
    required this.adUnitId,
    required this.adProvider,
    required this.adUnitType,
  });

  AdSdkAd copyWith({
    dynamic ad,
    String? adName,
    String? adUnitId,
    AdProvider? adProvider,
    AdUnitType? adUnitType,
  }) {
    return AdSdkAd(
      ad: ad ?? this.ad,
      adName: adName ?? this.adName,
      adUnitId: adUnitId ?? this.adUnitId,
      adProvider: adProvider ?? this.adProvider,
      adUnitType: adUnitType ?? this.adUnitType,
    );
  }

  void show({
    required Function(AdSdkAd ad) onAdDismissedFullScreenContent,
    required Function(AdSdkAd ad) onAdShowedFullScreenContent,
    Function(num amount, String type)? onUserEarnedReward,
  }) {
    if (adProvider == AdProvider.admob || adProvider == AdProvider.admanager) {
      if (adUnitType == AdUnitType.appOpen) {
        (ad as AppOpenAd).fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (_) =>
              onAdDismissedFullScreenContent(this),
          onAdShowedFullScreenContent: (_) => onAdShowedFullScreenContent(this),
        );
        (ad as AppOpenAd).show();
      } else if (adUnitType == AdUnitType.interstitial) {
        if (adProvider == AdProvider.admob) {
          (ad as InterstitialAd).fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) =>
                onAdDismissedFullScreenContent(this),
            onAdShowedFullScreenContent: (_) =>
                onAdShowedFullScreenContent(this),
          );
          (ad as InterstitialAd).show();
        } else {
          (ad as AdManagerInterstitialAd).fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) =>
                onAdDismissedFullScreenContent(this),
            onAdShowedFullScreenContent: (_) =>
                onAdShowedFullScreenContent(this),
          );
          (ad as AdManagerInterstitialAd).show();
        }
      } else if (adUnitType == AdUnitType.rewarded) {
        (ad as RewardedAd).fullScreenContentCallback =
            FullScreenContentCallback(
          onAdDismissedFullScreenContent: (_) =>
              onAdDismissedFullScreenContent(this),
          onAdShowedFullScreenContent: (_) => onAdShowedFullScreenContent(this),
        );
        (ad as RewardedAd).show(onUserEarnedReward: (ad, reward) {
          if (onUserEarnedReward != null) {
            onUserEarnedReward(reward.amount, reward.type);
          }
        });
      }
    } else if (adProvider == AdProvider.applovin) {
      if (adUnitType == AdUnitType.appOpen) {
        AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
          onAdLoadedCallback: (_) => null,
          onAdLoadFailedCallback: (_, __) => null,
          onAdDisplayedCallback: (_) => onAdShowedFullScreenContent(this),
          onAdDisplayFailedCallback: (ad, error) {},
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (_) => onAdDismissedFullScreenContent(this),
        ));
        AppLovinMAX.showAppOpenAd(adUnitId);
      } else if (adUnitType == AdUnitType.interstitial) {
        AppLovinMAX.setInterstitialListener(InterstitialListener(
          onAdLoadedCallback: (_) => null,
          onAdLoadFailedCallback: (_, __) => null,
          onAdDisplayedCallback: (_) => onAdShowedFullScreenContent(this),
          onAdDisplayFailedCallback: (ad, error) {},
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (_) => onAdDismissedFullScreenContent(this),
        ));
        AppLovinMAX.showInterstitial(adUnitId);
      } else if (adUnitType == AdUnitType.rewarded) {
        AppLovinMAX.setRewardedAdListener(RewardedAdListener(
          onAdLoadedCallback: (_) => null,
          onAdLoadFailedCallback: (_, __) => null,
          onAdDisplayedCallback: (_) => onAdShowedFullScreenContent(this),
          onAdDisplayFailedCallback: (ad, error) {},
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (_) => onAdDismissedFullScreenContent(this),
          onAdReceivedRewardCallback: (ad, reward) {
            if (onUserEarnedReward != null) {
              onUserEarnedReward(reward.amount, reward.label);
            }
          },
        ));
        AppLovinMAX.showRewardedAd(adUnitId);
      }
    }
  }
}
