import 'package:adsdk/adsdk.dart';
import 'package:flutter/material.dart';

class BannerAdComponent extends StatelessWidget {
  const BannerAdComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text("admob_banner"),
            AdSdkBannerAdWidget(adName: "admob_banner"),
            SizedBox(height: 16),
            Text("admanager_banner"),
            AdSdkBannerAdWidget(adName: "admanager_banner"),
            SizedBox(height: 16),
            Text("applovin_banner"),
            AdSdkBannerAdWidget(adName: "applovin_banner"),
          ],
        ),
      ),
    );
  }
}
