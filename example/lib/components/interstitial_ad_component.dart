import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/utils/app_toast.dart';
import 'package:flutter/material.dart';

class InterstitialAdComponent extends StatefulWidget {
  const InterstitialAdComponent({super.key});

  @override
  State<InterstitialAdComponent> createState() =>
      _InterstitialAdComponentState();
}

class _InterstitialAdComponentState extends State<InterstitialAdComponent> {
  final Map<String, AdSdkAd?> ads = {};

  void setAdLoaded(String adName, AdSdkAd? adSdkAd) {
    if (adSdkAd != null) {
      AppToast.showToast(context, "$adName Loaded");
    }
    setState(() => ads[adName] = adSdkAd);
  }

  void loadInterstitialAd(String adName) {
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

  void showInterstitialAd(String adName) {
    ads[adName]?.show(
      onAdDismissedFullScreenContent: (ad) {},
      onAdShowedFullScreenContent: (ad) {},
    );
    setAdLoaded(adName, null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Interstitial Ads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            "admob_interstitial",
            "admanager_interstitial",
            "applovin_interstitial"
          ]
              .map(
                (adName) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ElevatedButton(
                    onPressed: () {
                      if (ads[adName] == null) {
                        loadInterstitialAd(adName);
                      } else {
                        showInterstitialAd(adName);
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
