import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/models/ad_store.dart';
import 'package:adsdk_example/utils/app_toast.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdComponent extends StatefulWidget {
  const RewardedAdComponent({super.key});

  @override
  State<RewardedAdComponent> createState() => _RewardedAdComponentState();
}

class _RewardedAdComponentState extends State<RewardedAdComponent> {
  final Map<String, AdStore?> ads = {};

  void setAdLoaded(String adName, AdStore? adStore) {
    if (adStore != null) {
      AppToast.showToast(context, "$adName Loaded");
    }
    setState(() => ads[adName] = adStore);
  }

  void loadRewardedAd(String adName) {
    AppToast.showToast(context, "Loading $adName");

    AdSdk.loadAd(
      adName: adName,
      adSdkRewardedAdListener: AdSdkRewardedAdListener(
        onAdFailedToLoad: (errors) {
          AppToast.showToast(context, errors.first);
        },
        onAdmobAdLoaded: (ad) {
          setAdLoaded(
            adName,
            AdStore(ad: ad, adProvider: AdProvider.admob),
          );
        },
        onApplovinAdLoaded: (ad) => {
          setAdLoaded(
            adName,
            AdStore(ad: ad, adProvider: AdProvider.applovin),
          )
        },
      ),
    );
  }

  void showRewardedAd(String adName) {
    switch (ads[adName]?.adProvider) {
      case AdProvider.admob:
        (ads[adName]?.ad as RewardedAd).show(
          onUserEarnedReward: (ad, reward) {},
        );
        break;
      case AdProvider.admanager:
        (ads[adName]?.ad as RewardedAd).show(
          onUserEarnedReward: (ad, reward) {},
        );
        break;
      case AdProvider.applovin:
        AppLovinMAX.showRewardedAd(ads[adName]?.ad.adUnitId);
        break;
      default:
    }
    setAdLoaded(adName, null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Rewarded Ads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              ["admob_rewarded", "admanager_rewarded", "applovin_rewarded"]
                  .map(
                    (adName) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ElevatedButton(
                        onPressed: () {
                          if (ads[adName] == null) {
                            loadRewardedAd(adName);
                          } else {
                            showRewardedAd(adName);
                          }
                        },
                        child: Text(ads[adName] != null ? "Show" : "Load"),
                      ),
                      title: Text(adName),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
