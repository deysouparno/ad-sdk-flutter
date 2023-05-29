import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/utils/app_toast.dart';
import 'package:flutter/material.dart';

class RewardedAdComponent extends StatefulWidget {
  const RewardedAdComponent({super.key});

  @override
  State<RewardedAdComponent> createState() => _RewardedAdComponentState();
}

class _RewardedAdComponentState extends State<RewardedAdComponent> {
  final Map<String, AdSdkAd?> ads = {};

  void setAdLoaded(String adName, AdSdkAd? adSdkAd) {
    if (adSdkAd != null) {
      AppToast.showToast(context, "$adName Loaded");
    }
    setState(() => ads[adName] = adSdkAd);
  }

  void loadRewardedAd(String adName) {
    AppToast.showToast(context, "Loading $adName");

    AdSdk.loadAd(
      adName: adName,
      onAdFailedToLoad: (errors) {
        AppToast.showToast(context, errors.first);
      },
      onAdLoaded: (ad) {
        setAdLoaded(adName, ad);
      },
    );
  }

  void showRewardedAd(String adName) {
    ads[adName]?.show(
      onAdDismissedFullScreenContent: (ad) {},
      onAdShowedFullScreenContent: (ad) {},
      onUserEarnedReward: (amount, type) {},
    );
    setAdLoaded(adName, null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      title: Text(
                          "Ad Provider: ${ads[adName]?.adProvider.key ?? "Not Loaded"}"),
                      subtitle: Text(adName),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
