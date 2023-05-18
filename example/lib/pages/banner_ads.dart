import 'package:adsdk_example/components/banner_ad_component.dart';
import 'package:flutter/material.dart';

class BannerAds extends StatelessWidget {
  const BannerAds({super.key});

  static const routeName = '/banner';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Banner Ads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: const BannerAdComponent(),
    );
  }
}
