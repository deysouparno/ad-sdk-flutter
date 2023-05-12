import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/models/ad_store.dart';
import 'package:adsdk_example/utils/app_toast.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

class InterstitialAdComponent extends StatefulWidget {
  const InterstitialAdComponent({super.key});

  @override
  State<InterstitialAdComponent> createState() =>
      _InterstitialAdComponentState();
}

class _InterstitialAdComponentState extends State<InterstitialAdComponent> {
  final Map<String, AdStore?> ads = {};

  void setAdLoaded(String adName, AdStore? adStore) {
    if (adStore != null) {
      AppToast.showToast(context, "$adName Loaded");
    }
    setState(() => ads[adName] = adStore);
  }

  void loadInterstitialAd(String adName) {
    AppToast.showToast(context, "Loading $adName");

    AdSdk.loadAd(
      adName: adName,
      adSdkInterstitialAdListener: AdSdkInterstitialAdListener(
        onAdFailedToLoad: (errors) {
          AppToast.showToast(context, errors.first);
        },
        onAdmobAdLoaded: (ad) {
          setAdLoaded(
            adName,
            AdStore(ad: ad, adProvider: AdProvider.admob),
          );
        },
        onAdmanagerAdLoaded: (ad) {
          setAdLoaded(
            adName,
            AdStore(ad: ad, adProvider: AdProvider.admanager),
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

  void showInterstitialAd(String adName) {
    switch (ads[adName]?.adProvider) {
      case AdProvider.admob:
        ads[adName]?.ad.show();
        break;
      case AdProvider.admanager:
        ads[adName]?.ad.show();
        break;
      case AdProvider.applovin:
        AppLovinMAX.showInterstitial(ads[adName]?.ad.adUnitId);
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
                  title: Text(adName),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
