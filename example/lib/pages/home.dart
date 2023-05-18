import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/components/appopen_ad_component.dart';
import 'package:adsdk_example/components/interstitial_ad_component.dart';
import 'package:adsdk_example/components/rewarded_ad_component.dart';
import 'package:adsdk_example/pages/banner_ads.dart';
import 'package:adsdk_example/pages/native_ads.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AdSdk.setAppOpenLifecycleReactor("appopen_bg_to_fg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Test Ads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, BannerAds.routeName),
                  child: const Text("Banner Ads"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, NativeAds.routeName),
                  child: const Text("Native Ads"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const InterstitialAdComponent(),
          const SizedBox(height: 16),
          const AppOpenAdComponent(),
          const SizedBox(height: 16),
          const RewardedAdComponent(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
