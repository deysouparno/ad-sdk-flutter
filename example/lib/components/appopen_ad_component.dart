import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/models/ad_store.dart';
import 'package:adsdk_example/utils/app_toast.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

class AppOpenAdComponent extends StatefulWidget {
  const AppOpenAdComponent({super.key});

  @override
  State<AppOpenAdComponent> createState() => _AppOpenAdComponentState();
}

class _AppOpenAdComponentState extends State<AppOpenAdComponent> {
  final Map<String, AdStore?> ads = {};

  void setAdLoaded(String adName, AdStore? adStore) {
    if (adStore != null) {
      AppToast.showToast(context, "$adName Loaded");
    }
    setState(() => ads[adName] = adStore);
  }

  void loadAppOpenAd(String adName) {
    AppToast.showToast(context, "Loading $adName");

    AdSdk.loadAd(
      adName: adName,
      adSdkAppOpenAdListener: AdSdkAppOpenAdListener(
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

  void showAppOpenAd(String adName) {
    switch (ads[adName]?.adProvider) {
      case AdProvider.admob:
        ads[adName]?.ad.show();
        break;
      case AdProvider.admanager:
        ads[adName]?.ad.show();
        break;
      case AdProvider.applovin:
        AppLovinMAX.showAppOpenAd(ads[adName]?.ad.adUnitId);
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
          "AppOpen Ads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ["admob_appopen", "admanager_appopen", "applovin_appopen"]
              .map(
                (adName) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ElevatedButton(
                    onPressed: () {
                      if (ads[adName] == null) {
                        loadAppOpenAd(adName);
                      } else {
                        showAppOpenAd(adName);
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
