import 'package:adsdk/adsdk.dart';
import 'package:flutter/material.dart';

class BannerAdComponent extends StatelessWidget {
  const BannerAdComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Banner Ads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        AdSdk.createBannerAd("admob_banner"),
        const SizedBox(height: 16),
        AdSdk.createBannerAd("admanager_banner"),
        const SizedBox(height: 16),
        AdSdk.createBannerAd("applovin_banner"),
      ],
    );
  }
}
