import 'package:adsdk/adsdk.dart';
import 'package:flutter/material.dart';

class NativeAdComponent extends StatelessWidget {
  const NativeAdComponent({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
