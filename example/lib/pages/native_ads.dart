import 'package:adsdk_example/components/native_ad_component.dart';
import 'package:flutter/material.dart';

class NativeAds extends StatefulWidget {
  const NativeAds({super.key});

  static const routeName = '/native';

  @override
  State<NativeAds> createState() => _NativeAdsState();
}

class _NativeAdsState extends State<NativeAds> {
  bool isDarkMode = false;

  toggleMode() => setState(() => isDarkMode = !isDarkMode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Native Ads",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: toggleMode,
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox.expand(
          child: NativeAdComponent(
            key: ValueKey(isDarkMode),
            isDarkMode: isDarkMode,
          ),
        ),
      ),
    );
  }
}
