import 'package:adsdk/adsdk.dart';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text("admob_native"),
                AdSdkNativeAdWidget(
                  adName: "admob_native",
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),
                const Text("admanager_native"),
                AdSdkNativeAdWidget(
                  adName: "admanager_native",
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ));
  }
}
