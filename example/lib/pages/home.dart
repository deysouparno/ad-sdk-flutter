import 'package:adsdk_example/components/appopen_ad_component.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Test Ads",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          InterstitialAdComponent(),
          SizedBox(height: 16),
          AppOpenAdComponent(),
          SizedBox(height: 16),
          RewardedAdComponent(),
        ],
      ),
    );
  }
}
