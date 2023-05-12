import 'package:adsdk/adsdk.dart';
import 'package:adsdk_example/components/appopen_ad_component.dart';
import 'package:adsdk_example/components/banner_ad_component.dart';
import 'package:adsdk_example/components/interstitial_ad_component.dart';
import 'package:adsdk_example/components/rewarded_ad_component.dart';
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
          "Test Ads",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                InterstitialAdComponent(),
                SizedBox(height: 16),
                AppOpenAdComponent(),
                SizedBox(height: 16),
                RewardedAdComponent(),
                SizedBox(height: 16),
              ],
            ),
          ),
          const BannerAdComponent(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
